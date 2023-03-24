const AttendenceContract = artifacts.require("AttendenceContract");

module.exports = function (deployer) {
  deployer.deploy(AttendenceContract);
};