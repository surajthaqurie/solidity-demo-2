// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;


/* Requirement:
    Auctioneer: manger
    Auction successful: Highest payable bid
    Auction End: Auctioneer (emergency- all transition are rollback)
    Bidding system: 
        - highest payable bid: min(currentBid, highestBidder + increment)
        - auctioneer not able bid
        - bid increment: (previous bid + current bid) / min 1 eth bid

    Auction time:
        - solidity not able to save time on element for safely reason.
        - start time (number of start block
        - end time (number of end block)
        - in 15 sec in ethereum generate 1 block
        - block.number current
 */

 contract Auction {
    address payable  public auctioneer;
    uint public stBlock;  // start time
    uint public etBlock; // end time

    enum AucState{
        Started,
        Running,
        Ended,
        Cancelled
    }

    AucState public auctionState;

    uint public highestPayableBid;
    uint public bidInc;

    address payable public highestBidder;

    mapping(address => uint) public bids;

    constructor(){
        auctioneer = payable (msg.sender);
        auctionState = AucState.Running;
        stBlock = block.number;
        etBlock = block.number + 240; // one hour
        bidInc = 1 ether;
    }


    // check not owner
    modifier notOwner(){
        require(msg.sender != auctioneer,"Only auctioneer can bid");
        _;
    }


    // Check owner
    modifier Owner(){
        require(msg.sender == auctioneer,"Owner can't bid");
        _;
    }


    // Check the auction is started
    modifier started(){
        require(block.number > stBlock);
    _;

    }
    
    // Check auction is ended
    modifier beforeEnded(){
        require(block.number < etBlock);
        _;
    }
    

    // Cancel Auction
    function cancelAuc() public Owner{
        auctionState = AucState.Cancelled;
    }

    // For testing end the auction
    function endAuc() public Owner{
        auctionState = AucState.Ended;
    }

    // Get minimum value 
    function min(uint a, uint b) pure  private  returns (uint){
        if (a <= b){
            return a;
        }else {
            return b;
        }
    }

    function bid() payable public notOwner started beforeEnded{
        require(auctionState == AucState.Running);
        require(msg.value >= 1 ether);


        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestPayableBid);

        bids[msg.sender] = currentBid;

        if(currentBid < bids[highestBidder]){
            highestPayableBid = min(currentBid + bidInc, bids[highestBidder]);

        }else {
            highestPayableBid = min(currentBid, bids[highestBidder] + bidInc);
            highestBidder = payable (msg.sender);
        }

    }

    function finalizeAuc() public {
        require(auctionState == AucState.Cancelled || auctionState == AucState.Ended || block.number > etBlock);
        require(msg.sender == auctioneer || bids[msg.sender]>0);

        address payable person;
        uint value;

        if(auctionState == AucState.Cancelled){
            person = payable(msg.sender);
            value = bids[msg.sender];
        }else {
            if(msg.sender == auctioneer){
                person =auctioneer;
                value = highestPayableBid;

            }else {
                if(msg.sender == highestBidder){
                    person = highestBidder;
                    value = bids[highestBidder]- highestPayableBid;
                }else {
                    person = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }


        bids[msg.sender]=0;
        // value transfer
        person.transfer(value);
    }

 }