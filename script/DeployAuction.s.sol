// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/AntiSnipingAuction.sol";

contract DeployAuction is Script {
    function run() external {
        uint256 privateKey = uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        vm.startBroadcast(privateKey);

        new AntiSnipingAuction(2 minutes, 1 ether, 0.1 ether);

        vm.stopBroadcast();
    }
}
