// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract Lotter{
 address public manager;
 address payable[] public players;
 address payable public winner;

  constructor(){
      manager=msg.sender;
  }

  function participate() public payable{
      require(msg.value==1 ether,"Please pay 1 ether only");
      players.push(payable(msg.sender));
  }

  function getBalance() public view returns(uint){
      require(manager==msg.sender,"You are not the manager");
      return address(this).balance;
  }

  function random() internal view returns(uint){
      return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
  }

  function pickWinner() public{
      require(manager==msg.sender,"You are not the manager");
      require(players.length>=3,"Not Enough Palyers !");

      uint r=random();
      uint index = r%players.length;
      winner=players[index];
      winner.transfer(getBalance());
      players= new address payable[](0); //this will intiliaze the players array back to 0
  }

}
