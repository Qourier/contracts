// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../Hub.sol";

contract HowToUse {
    address public hub;
    uint256 public price;
    
    uint256 private id;
    uint256 private result;

    constructor(address hub_, uint256 price_) { 
        hub = hub_;
        price = price_;
    }

    function createTask() public payable {
        Hub(hub).createTask2{ value: price }(bytes32("sum-of-numbers"), [bytes("3"), bytes("4")]);
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        id = id_;
        result = bytesToUint(result_);
    }

    function getTask() public view returns(uint256, uint256) {
        return (id, result);
    }

    function bytesToUint(bytes memory b) public pure returns (uint256) {
        uint256 res = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                res = res * 10 + (c - 48);
            }
        }
        return res;
    }
}