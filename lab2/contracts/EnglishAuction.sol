// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Auction.sol";

contract EnglishAuction is Auction {

    uint internal highestBid;
    uint internal initialPrice;
    uint internal biddingPeriod;
    uint internal lastBidTimestamp;
    uint internal minimumPriceIncrement;

    address internal highestBidder;

    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer,
        uint _initialPrice,
        uint _biddingPeriod,
        uint _minimumPriceIncrement
    ) Auction(_sellerAddress, _judgeAddress, _timer) {
        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        minimumPriceIncrement = _minimumPriceIncrement;

        // Start the auction at contract creation.
        lastBidTimestamp = time();
    }

    function bid() public payable {
        // TODO Your code here
        //revert("Not yet implemented");

        
        uint currentTime = time();

        require(outcome == Outcome.NOT_FINISHED);

        uint timeDiff = currentTime - lastBidTimestamp;
        require(timeDiff < biddingPeriod);

        bool existsHighestBidder = isAddressDefined(highestBidder);
        uint priceToOvercome = existsHighestBidder ? highestBid : initialPrice;
        uint priceDiff = msg.value - priceToOvercome;
        require(priceDiff >= minimumPriceIncrement || (!existsHighestBidder && priceDiff>=0));

        if (existsHighestBidder) {
            address payable payTo = payable(highestBidder);
            payTo.transfer(highestBid);
        }

        lastBidTimestamp = currentTime;
        highestBid = msg.value;
        highestBidder = msg.sender;
        
    }

    function getHighestBidder() public override returns (address) {
        uint currentTime = time();
        uint timeDiff = currentTime - lastBidTimestamp;
        if (timeDiff >= biddingPeriod) {
            Outcome out = isAddressDefined(highestBidder) ? Outcome.SUCCESSFUL : Outcome.NOT_SUCCESSFUL;
            finishAuction(out, highestBidder);
        }

        return highestBidderAddress;
    }

}