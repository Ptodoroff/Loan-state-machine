pragma solidity 0.8.15;


//@ notice all enum values are written in CAPS
//@ notice enums works best if combined with a function that changes its state. In this particular case, this is the _transitionTo function
contract Loan {
enum State {
                PENDING,                                //1st stage - investors investing the loan
                ACTIVE,                                 //2nd stage - loan is used by the borrower
                CLOSED                                  //3rd stage - loan is repaid
        }


State public state = State.PENDING;               // a variable that storest the current state of the enum
//@ notice  under the hood, Solidity sees every variable in an enum as an integer. e.g. PENDING is 0, ACTIVE is 1 and so on. aka enum values are convertible to integers and inegers are converted to enum values
//@ notice   in this regard, I cannot simply access a variable in an enum by ots corresponding integer, because solidity will complain. Aka I cannot access PENDING by typing State.0. Instead I it happens like this:

/*
function foo (uint a){
        state = State(a)       state now equals State.PENDING
        //in other words, if I want to acess a variable in an enum the syntax is EnunNAME(int);
}

*/

//@ notice parameters defining the loan

uint public amount;
uint public interest;
uint public end;
address payable public borrower;
address payable public lender;

constructor (uint _amount, uint _interest, uint _duration, address payable _borrower, address payable _lender) {
        amount = _amount;
        interest = _interest;
        end = block.timestamp + _duration;
        borrower=_borrower;
        lender=_lender;

}

function fundLoan () external payable {
        require( msg.value ==amount, "You should lend the amount, defined in the constructor");
        require( msg.sender == lender, "Callable only by the lender");  
        _transitionTo(State.ACTIVE);                        //placed before the actual transfer, because if this function fails to execute, the funds wont be transferred to the borrower
        borrower.transfer(amount);                         //transfers the deposited funds to the borrower                                 

}

function repay () external payable {
        require(msg.value==amount + interest, "You should return the interest and the amount");
        require(msg.sender==borrower, "you are not the borrower");
        _transitionTo(State.CLOSED ); 
        borrower.transfer(msg.value); 
}

function _transitionTo (State to) private {                                                        // declared with _ because this is the ocnvention to followe when declaring priate functions. this fn will change the state of the enum after each of the other functions in the contract. The parameter represents the value of the State enum to which we want the state changed to 
        require( to != State.PENDING, "Cannot go back to pending state");                          // this check is here to make sure that the the state cannot go back to its initial state 
        require (to != state, "cannot transition to the initial state" );                          //checks to make sure that state wont change to the current state
        if ( to == State.ACTIVE) {
                require (state == State.PENDING, "Cannot transiotion to active state if the current state is NOT PENDING ");
                state=State.ACTIVE;
        }
                if ( to == State.CLOSED) {
                require (state == State.ACTIVE, "Cannot transiotion to closed state if the current state is NOT ACTIVE ");
                require(block.timestamp>=end, "Loan has not matured yet. ");
                state=State.CLOSED;
        }



}

}