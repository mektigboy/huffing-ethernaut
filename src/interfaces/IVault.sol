// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IVault
/// @notice Interface for Vault contract
/// @author mektigboy
interface IVault {
    function locked() external view returns (bool);
    
    function unlock(bytes32) external;
}
