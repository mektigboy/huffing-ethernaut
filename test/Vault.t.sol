// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import {Test} from "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {IVault} from "src/interfaces/IVault.sol";

contract Vault is Test {
    address ATTACKER = makeAddr("Attacker");

    IVault vaultInterface;

    bytes32 password = "password";

    function setUp() public {
        address vaultAddress = HuffDeployer
            .config()
            .with_args(abi.encode(password))
            .deploy("Vault");
        vaultInterface = IVault(vaultAddress);
    }

    function test_lock() public {
        assertEq(vaultInterface.locked(), true);
    }

    function test_unlock() public {
        vaultInterface.unlock("password");
        assertEq(vaultInterface.locked(), false);
    }

    function test_PoC() public {
        console.log("VAULT'S STATUS (BEFORE ATTACK): ", vaultInterface.locked());

        // bytes memory code = address(vaultInterface).code;
        
        // console.log("VAULT'S CODE (BEFORE ATTACK): ", );

        vm.prank(ATTACKER);
        
        vaultInterface.unlock("password");
    }
}
