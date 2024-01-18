// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Timer.sol";

/// This contract represents most simple crowdfunding campaign.
/// This contract does not protects investors from not receiving goods
/// they were promised from crowdfunding owner. This kind of contract
/// might be suitable for campaigns that does not promise anything to the
/// investors except that they will start working on some project.
/// (e.g. almost all blockchain spinoffs.)
contract Crowdfunding {

    address private owner;

    Timer private timer;

    uint256 public goal;

    uint256 public endTimestamp;

    mapping (address => uint256) public investments;

    
    // ukupan uložen iznos sredstava
    uint256 private totalInvested;

    constructor(
        address _owner,
        Timer _timer,
        uint256 _goal,
        uint256 _endTimestamp
    ) {
        owner = (_owner == address(0) ? msg.sender : _owner);
        timer = _timer; // Not checking if this is correctly injected.
        goal = _goal;
        endTimestamp = _endTimestamp;
    }

    function crowdfundingOngoing() private view returns (bool) {
        return timer.getTime() <= endTimestamp;
    }

    function isGoalReached() private view returns (bool) {
        return totalInvested >= goal;
    }

    function invest() public payable {
        // TODO Your code here
        //revert("Not yet implemented");
        
        // provjeri je li crowdfunding aktivan
        require(crowdfundingOngoing());

        // provjeri salje li se nenegativna vrijednost
        require(msg.value >= 0);

        investments[msg.sender] += msg.value;
        totalInvested += msg.value;

        
    }

    function claimFunds() public {
        // TODO Your code here
        //revert("Not yet implemented");

        // provjeri je li crowdfunding aktivan, ako nije baci gresku
        require(!crowdfundingOngoing());

        // nije moguce povući sredstva ako NIJE dosegnut cilj
        require(isGoalReached());

        bool isOwner = msg.sender == owner;
        // nitko osim vlasnika ne može povući sredstva
        require(isOwner);


        address payable payTo = payable(owner);
        payTo.transfer(totalInvested);
        
    }

    function refund() public {
        // TODO Your code here
        //revert("Not yet implemented");

        // provjeri je li crowdfunding aktivan, ako nije baci gresku
        require(!crowdfundingOngoing());

        // nije moguce povući sredstva ako JEST dosegnut cilj
        require(!isGoalReached());


        address payable payTo = payable(msg.sender);
        payTo.transfer(investments[msg.sender]);
        investments[msg.sender] = 0;
        
    }
    
}