// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IFallback
/// @notice Interface for Fallback contract
/// @author mektigboy
interface IFallback {
    function contributions(address) external view returns (uint256);

    function owner() external view returns (address);

    function contribute() external payable;

    function getContribution() external view returns (uint256);

    function withdraw() external;
}
