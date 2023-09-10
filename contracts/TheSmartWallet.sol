//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract Customer{
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function deposit() public payable{}
}

contract SmartWalletContract{

    address  payable public  owner;
    address payable  nextOwner;
    mapping(address => uint) public allowances;
    mapping(address => mapping(address=>bool)) nextOwnerGaudianVotedBool;
    mapping(address => bool) public gaurdian;
    mapping(address => bool) public isAllowedToSend;
    uint gaurdianResetCount;
    uint public constant confirmationsFromGaurdianForReset=3;

    constructor(){
        owner = payable(msg.sender);
    } 

    function transfer(address payable  _to,uint _amount,bytes memory payload) public returns(bytes memory){
      if(msg.sender != owner){
      require(isAllowedToSend[msg.sender],"user is not allowed to Send");
      require(allowances[msg.sender]>=_amount,"Insufficient amount available, aburting");
      allowances[msg.sender] -= _amount;
      }
      (bool success,bytes memory returnData)=_to.call{value:_amount}(payload);
      require(success);
      return returnData;
    }

    function setAllowances(address _for,uint _amount)public {
      require(msg.sender == owner,"you are not the owner aborting");
      allowances[_for]=_amount;
      if(_amount>0){
          isAllowedToSend[_for]=true;
      }
      else{
          isAllowedToSend[_for]=false;
      }
    }

    function proposeNewOwner(address payable _newOwner)public {
        require(gaurdian[msg.sender],"You are not the gaudian");
        require(nextOwnerGaudianVotedBool[_newOwner][msg.sender]==false,"Aborting");
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            gaurdianResetCount=0;
        }
        gaurdianResetCount++;
        if(gaurdianResetCount>=confirmationsFromGaurdianForReset){
            owner=nextOwner;
            nextOwner = payable(0);
        }
    }

    function setGaurdian(address _gaurdian,bool _isGaurdian) public {
        require(msg.sender==owner,"you are not the owner, aborting");
        gaurdian[_gaurdian]=_isGaurdian;
    }

    receive() external payable {}

}