pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20{
  constructor(uint256 initialSupply) public ERC20("AgileFreaks", "AF") {
       _mint(msg.sender, initialSupply);
   }
}
