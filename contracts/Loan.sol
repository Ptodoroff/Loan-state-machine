prgama solidity 0.8.15;


//@ notice all enum values are written in CAPS
contract Loan {
enum State {
                PENDING,                                //1st stage - investors investing the loan
                ACTIVE,                                 //2nd stage - loan is used by the borrower
                CLOSED                                  //3rd stage - loan is repaid
        }


State public state = State.PENDING;               // a variable that storest the current state of the enum
//@ notice parameters defining the loan

uint public amount;
uint public interest;
uint public end;
address payable public borrower;
address payable public lender;

constructor (uint _amount, uint _interest, uint _duration, address payable _borrower, address payable _lender) {
        amount = _amount;
        interest = _interest;
        end = block.timestamp + duration;
        borrower=_borrower;
        lender=_lender;

}

function fundLoan () external payable {
        require(amount == msg.value, "You should lend the amount, defined in the constructor");
        require(lender == msg.sender, "Callable only by the lender");  
        borrower.transfer(amount);                         //transfers the deposited funds to the borrower                                 

}

function repay () external payable {
        require(msg.value==amount + interest, "You should return the interest and the amount");
        require(msg.sender==borrower, "you are not the borrower");
        require(block.timestamp<=end, "You are late");
        borrower.transfer(msg.value); 
}


}