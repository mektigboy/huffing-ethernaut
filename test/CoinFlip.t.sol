// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {ICoinFlip} from "src/interfaces/ICoinFlip.sol";

contract CoinFlip is Test {
    address OWNER = makeAddr("Owner");

    address ATTACKER = makeAddr("Attacker");

    ICoinFlip coinFlipInterface;

    function setUp() public {
        vm.prank(OWNER);
        address coinFlipAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("CoinFlip");
        coinFlipInterface = ICoinFlip(coinFlipAddress);
    }

    function test_consecutiveWins() public {
        assertEq(coinFlipInterface.consecutiveWins(), 0);
    }

    function test_flip() public {
        assertEq(coinFlipInterface.lastHash(), 0);

        vm.roll(16656420);

        bytes32 blockHash = coinFlipInterface.flip(true);

        console.log("BLOCKHASH: ", uint256(blockHash));

        // assertEq(coinFlipInterface.lastHash(), 0);

        // assertEq(coinFlipInterface.flip(true), blockhash(block.number - 1));
    }
}
