// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/AntiSnipingAuction.sol";

contract AntiSnipingAuctionTest is Test {
    AntiSnipingAuction auction;
    address alice = address(1);
    address bob = address(2);
    address owner = address(99); // separate owner

    function setUp() public {
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(owner, 0 ether);

        vm.prank(owner);
        auction = new AntiSnipingAuction(2 minutes, 1 ether, 0.1 ether);
    }

    function testInitialBid() public {
        vm.prank(alice);
        auction.bid{value: 1.5 ether}();
        assertEq(auction.highestBid(), 1.5 ether);
        assertEq(auction.highestBidder(), alice);
    }

    function testAntiSnipingExtension() public {
        vm.prank(alice);
        auction.bid{value: 1.5 ether}();

        vm.warp(block.timestamp + 100);
        uint originalEnd = auction.endTime();

        vm.prank(bob);
        auction.bid{value: 1.7 ether}();

        assertGt(auction.endTime(), originalEnd);
    }

    function testWithdraw() public {
        vm.prank(alice);
        auction.bid{value: 1.5 ether}();

        vm.prank(bob);
        auction.bid{value: 1.7 ether}();

        uint before = alice.balance;

        vm.prank(alice);
        auction.withdraw();

        uint afterBalance = alice.balance;
        assertEq(afterBalance - before, 1.5 ether);
    }

    function testEndAuction() public {
        vm.prank(alice);
        auction.bid{value: 1.5 ether}();

        uint end = auction.endTime();
        vm.warp(end + 1);

        uint beforeOwner = owner.balance;

        vm.prank(owner);
        auction.endAuction();

        uint afterOwner = owner.balance;
        assertEq(afterOwner - beforeOwner, 1.5 ether);
        assertTrue(auction.ended());
    }
}
