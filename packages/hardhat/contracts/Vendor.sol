pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  YourToken yourToken;

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() external payable {
    uint amountOfTokens = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amountOfTokens);
    BuyTokens(msg.sender, msg.value, amountOfTokens);
  }

  function withdraw() external onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function sellTokens(uint256 amount) external {
    bool transfered = yourToken.transferFrom(msg.sender, address(this), amount);
    require(transfered, "Failed to transfer");
    (bool sent,) = payable(msg.sender).call{value: amount/tokensPerEth}("");
    require(sent, "Failed to send Ether");
  }
}
