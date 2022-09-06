const Loan = artifacts.require('Loan.sol');
const {expectRevert, time, balance} = require("@openzeppelin/test-helpers"); 
const { assertion } = require("@openzeppelin/test-helpers/src/expectRevert");
const { web3 } = require("@openzeppelin/test-helpers/src/setup");
let loan;
 

contract ("Loan", (accounts) =>{
    let lender = accounts[1];
    let borrower= accounts[2];
    beforeEach(async () => {
        loan = await Loan.deployed ();
    })

it ("Callable only by the lender", async () =>{
    await expectRevert (loan.fundLoan({from:borrower, value:500}),"Callable only by the lender")
})
it ("Reverts if msg value is not the amount, defined in the construcotr ", async () =>{

  await expectRevert ( loan.fundLoan({from:lender, value:50}),"You should lend the amount, defined in the constructor")
})
it ("should send funds to the borrower", async () => {
    let before = await balance.current(borrower);
    await loan.fundLoan({from:lender, value:500})
    let after = await  balance.current(borrower);
    assert(after.sub(before).toNumber()==500)
    

})

})