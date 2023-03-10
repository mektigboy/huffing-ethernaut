// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IFallout
/// @notice Interface for Fallout contract
/// @author mektigboy
interface IFallout {
    function owner() external view returns (address);

    function Fal1out() external payable;

    function allocate() external payable;

    function sendAllocation(address) external;

    function collectAllocations() external;

    function allocatorBalance(address) external view returns (uint256);
}
