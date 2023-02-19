// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IToken
/// @notice Interface for Token contract
/// @author mektigboy
interface IToken {
    function totalSupply() external view returns (uint256);

    function transfer(address, uint256) external returns (bool);

    function balanceOf(address) external view returns (uint256);
}
