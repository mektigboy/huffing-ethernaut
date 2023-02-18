// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ICoinFlip
/// @notice Interface for CoinFlip contract
/// @author mektigboy
interface ITelephone {
    function owner() external view returns (address);

    function changeOwner(address) external;
}
