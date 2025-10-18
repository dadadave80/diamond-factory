// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

interface IFactory {
    function clone(address owner) external returns (address);
}
