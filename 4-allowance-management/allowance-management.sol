// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/*Requirement
    deposit money: any one
    owner: 
        - withdraw/transfer without asking anyone
        - give allowance without asking anyone
    non owner:
        - wait getting allowance
        - then also can do owner works
 */


 contract AllowanceManage is Ownable {
    receive() external payable { }  
   
    function checkBalance() public view returns(uint){
        return address(this).balance;
    }

    mapping (address => uint) public allowances;
    
    // address public owner;
    constructor() Ownable (msg.sender){
        //owner = msg.sender;
      }

    function addAllowance(address _to, uint _amt) public onlyOwner{
        // require(msg.sender == owner,"Not owner"); //check if sender is the owner. 
        allowances[_to] += _amt;  

    }

    function isOwner() internal view returns (bool){
        return owner() == msg.sender;
    }   
    
    modifier  ownerOrAllowed(uint _amt){
        require(isOwner() || allowances[msg.sender] >= _amt ,"Not allowed");
        _;
    }

    event MoneySent(string description, address to, uint amt);
    function withdrawMoney(string memory _description, address payable _to, uint _amt) ownerOrAllowed(_amt) public {
        require(address(this).balance >= _amt, "Not enough fund left");
        if(isOwner() ==false){
            allowances[msg.sender] -= _amt;
        }

        emit MoneySent (_description,_to,_amt);
        _to.transfer(_amt);

    }
 
      
    function renounceOwnership()public override view onlyOwner {
        revert("Can't renounce ownership");
    }

 }