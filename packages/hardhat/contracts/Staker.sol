pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  receive() external payable {
    this.stake{value: msg.value}();
  }

  mapping (address => uint256) public balances;

  uint public constant threshold = 1 ether;

  bool public openForWithdraw = false;

  uint256 public deadline = block.timestamp + 30 seconds;

  function stake() payable external onlyBeforeDeadline() {
    balances[msg.sender] += msg.value;
  }

  function execute() external onlyAfterDeadline notCompleted {
    if(address(this).balance > threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    } else {
      openForWithdraw = true;
    }
  }

  function withdraw(address withdrawAddress) external {
    require(openForWithdraw == true);
    payable(withdrawAddress).transfer(address(this).balance);
  }

  function timeLeft() external view returns (uint256) {
    if(deadline <= block.timestamp) {
      return 0;
    } else return deadline - block.timestamp;
  }

  modifier onlyAfterDeadline() {
    require(block.timestamp >= deadline, "Wait until deadline");
    _;
  }

  modifier onlyBeforeDeadline() {
    require(block.timestamp < deadline, "Time is up");
    _;
  }

  modifier notCompleted() {
    bool complete = exampleExternalContract.completed();
    require(complete == false);
    _;
  }
}
