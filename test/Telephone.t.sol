// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {ITelephone} from "src/interfaces/ITelephone.sol";

contract Telephone is Test {
    address OWNER = makeAddr("Owner");
    address ATTACKER = makeAddr("Attacker");

    ITelephone telephoneInterface;

    function setUp() public {
        vm.prank(OWNER);
        address telephoneAddress = HuffDeployer
            .config()
            .with_args(abi.encode(OWNER))
            .deploy("Telephone");
        telephoneInterface = ITelephone(telephoneAddress);
    }

    function test_owner() public {
        assertEq(telephoneInterface.owner(), OWNER);
    }

    function test_changeOwner() public {
        // assertEq(telephoneInterface.owner(), OWNER);

        // telephoneInterface.changeOwner(ATTACKER);

        // assertEq(telephoneInterface.owner(), ATTACKER);
    }
}
