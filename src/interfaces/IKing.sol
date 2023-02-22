// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IKing
/// @notice Interface for King contract
/// @author mektigboy
interface IKing {
    function prize() external view returns (uint256);

    function owner() external view returns (address);

    function _king() external view returns (address);
}
