// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AntiSnipingAuction {
    address public owner;
    address public highestBidder;
    uint public highestBid;
    uint public endTime;
    uint public auctionStart;
    uint public minIncrement;
    uint public reservePrice;
    uint public snipingExtension = 1 minutes;

    bool public ended;

    mapping(address => uint) public bids;

    event AuctionStarted(uint endTime);
    event BidPlaced(address bidder, uint amount, uint newEndTime);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _duration, uint _reservePrice, uint _minIncrement) {
        owner = msg.sender;
        auctionStart = block.timestamp;
        endTime = auctionStart + _duration;
        reservePrice = _reservePrice;
        minIncrement = _minIncrement;

        emit AuctionStarted(endTime);
    }

    function bid() external payable {
        require(block.timestamp < endTime, "Auction ended");
        require(msg.value >= reservePrice, "Below reserve");
        require(msg.value >= highestBid + minIncrement, "Too low");

        if (highestBidder != address(0)) {
            bids[highestBidder] = highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        if (endTime - block.timestamp <= snipingExtension) {
            endTime += snipingExtension;
        }

        emit BidPlaced(msg.sender, msg.value, endTime);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        require(bal > 0, "Nothing to withdraw");

        bids[msg.sender] = 0;

        (bool sent, ) = payable(msg.sender).call{value: bal}("");
        require(sent, "Transfer failed");
    }

    function endAuction() external {
        require(block.timestamp >= endTime, "Auction ongoing");
        require(!ended, "Already ended");

        ended = true;

        if (highestBidder != address(0)) {
            (bool sent, ) = payable(owner).call{value: highestBid}("");
            require(sent, "Payment to owner failed");
            emit AuctionEnded(highestBidder, highestBid);
        }
    }
}
