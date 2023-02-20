// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IDelegation
/// @notice Interface for Delegation contract
/// @author mektigboy
interface IDelegation {
    function owner() external view returns (address);
}
