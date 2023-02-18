// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ICoinFlip
/// @notice Interface for CoinFlip contract
/// @author mektigboy
interface ICoinFlip {
    function consecutiveWins() external view returns (uint256);

    function flip(bool) external returns (bytes32);

    function lastHash() external view returns (uint256);
}
