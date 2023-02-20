// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IDelegate
/// @notice Interface for Delegate contract
/// @author mektigboy
interface IDelegate {
    function owner() external view returns (address);

    function pwn() external;
}
