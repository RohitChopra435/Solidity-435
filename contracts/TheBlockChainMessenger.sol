//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.18;
contract TheBlockChainMessenger{
    address public owner;
    string public message;
    uint public updateCnt;

    constructor(){
        owner=msg.sender;
    }
    
    function setAddress(string memory _myAddr) public {
      if(msg.sender == owner){
         message = _myAddr;
         updateCnt++;
      }
    }
}