//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.18;
contract willThrow{
   function afunction() public pure {
       require(false,"Error Message");
   }
}
contract ErrorHandling{
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes lowLevelData);
    function catchTheError() public {
        willThrow will = new willThrow();
        try will.afunction(){
        // code execute
        }
        catch Error(string memory reason){
          emit ErrorLogging(reason);
        }
        catch Panic(uint errorCode){
          emit ErrorLogCode(errorCode);
        }
        catch (bytes memory lowLevelData){
          emit ErrorLogBytes(lowLevelData);
        }
    }
}