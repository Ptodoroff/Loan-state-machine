const Loan = artifacts.require("Loan");


module.exports = function (deployer,_network,accounts) {
  deployer.deploy(Loan,500,500,5000,accounts[2],accounts[1]);
};
