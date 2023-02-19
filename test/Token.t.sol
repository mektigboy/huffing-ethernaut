// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IToken} from "src/interfaces/IToken.sol";

contract Token is Test {
    address OWNER = makeAddr("Owner");
    address ATTACKER = makeAddr("Attacker");

    IToken tokenInterface;

    function setUp() public {
        vm.prank(OWNER);
        address tokenAddress = HuffDeployer
            .config()
            .with_args(abi.encodePacked(OWNER, abi.encode(21000000)))
            .deploy("Token");
        tokenInterface = IToken(tokenAddress);
    }

    function test_totalSupply() public {
        assertEq(tokenInterface.totalSupply(), 21000000);
    }
}