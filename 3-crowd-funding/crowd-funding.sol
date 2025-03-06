// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

/*Requirement:
    - owner: raise the funding for the business with goal and time period
    - founder: to give funds min x amount
    - if the goal is achieve in this time period. (stops funds)
    - if the goal is not achieve then the fund is rollback to the funders
 */


 contract CrowdFunding{
    address public owner;
    mapping (address => uint) funders; // funders ["address" => "amount"]

    uint public goal;
    uint public minAmount;
    uint public noOfFunders;
    uint public fundsRaised;
    uint public timePeriod; // timestamp


    constructor(uint _goal, uint _timePeriod){
        goal =_goal;
        timePeriod = block.timestamp + _timePeriod;
        owner = msg.sender;
        minAmount = 1000 wei;
    }

    function Contribution() public payable {
        require(block.timestamp < timePeriod, "Funding time is over!");
        require(msg.value >= minAmount, "Minimum amount criteria not satisfy");

        if(funders[msg.sender]==0){
            noOfFunders++;
        }

        funders[msg.sender] += msg.value;
        fundsRaised += msg.value;


    }

    receive() external payable { 
        Contribution(); // Receive the rest of the ether sent to this contract
    }  

    //Refund
    function getRefund() public {
        require(block.timestamp > timePeriod,"Funding is still on");
        require(fundsRaised < goal, "Funding is successful");
        require(funders[msg.sender]>0,"Not a funder");

        payable (msg.sender).transfer(funders[msg.sender]);
        fundsRaised -= funders[msg.sender];
        funders[msg.sender] = 0;    
    }

    //Ower request for payment
    struct Request{
        string description;
        uint amount; 
        address payable receiver;
        uint noOfVoters;
        mapping (address => bool) votes;
        bool Completed;
    }

    mapping (uint => Request) public AllRequests;
    uint public numReq;

    modifier isOwner{
        require(msg.sender == owner, "Your are not the owner");
        _;
    }

    function createRequest(string memory _description, uint _amount, address payable _receiver) isOwner public{

        Request storage newRequest = AllRequests[numReq];
        numReq++;

        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.receiver = _receiver;
        newRequest.Completed =false;
        newRequest.noOfVoters = 0;
    }

    //voting
    function votingForRequest(uint reqNum) public {
        require(funders[msg.sender] > 0, "Not a founder");
        Request storage thisRequest = AllRequests[reqNum];

        require(thisRequest.votes[msg.sender] == false, "Already Voted");
        thisRequest.votes[msg.sender]= true;
        thisRequest.noOfVoters++;
    }

    //Payment
    function makePayment (uint reqNum) isOwner public {
        Request storage thisRequest = AllRequests[reqNum];
        require(thisRequest.Completed == false, "Request completed");
        
        require(thisRequest.noOfVoters >= noOfFunders/2, "Voting no in favour");
        thisRequest.Completed = true;
    }

 }