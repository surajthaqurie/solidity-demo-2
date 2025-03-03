// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;


contract lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }


    // Check player is already joined/entered
    function alreadyEntered() view private returns (bool) {
        for(uint i =0; i<players.length;i++){
            if(players[i] ==msg.sender){
                return  true;
            }
        }

        return  false;
    }

    //handle player join
    function enter() payable  public {
        require(msg.sender != manager,"Manger connot enter");
        require(alreadyEntered() == false,"Player already entered");
        require(msg.value >= 1 ether,"Minimum amout must be payed");
        players.push(payable (msg.sender));
    }

    function random() view  private returns (uint) {
        return uint(sha256(abi.encodePacked(block.prevrandao,block.number,players)));
    }
    

    function pickWinner() public {
        require(msg.sender == manager,"Only Manager can pick winner");
        uint index = random()%players.length; // winner index

        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance); //transfer

        players = new address payable [](0); // reset 
    }

    function getPlayer() view public returns (address payable [] memory){ 
        return players;
    }
   
}