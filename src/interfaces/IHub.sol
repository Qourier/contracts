// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IHub {

    struct Task {
        bytes32 module;
        bytes[5] params;
        bytes result;
        address callback;
        address qourier;
        uint256 tasks;
        uint256 createdAt;
        uint256 completedAt;
    }
    
}