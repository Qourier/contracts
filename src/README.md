# Qourier Smart Contracts

## Hub

```solidity
import "@qourier/contracts/Hub.sol";
```

# Use

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@qourier/contracts/Hub.sol";

contract HowToUse {
    address public hub;
    uint256 public price;

    uint256 private id;
    bytes private result; // bytes

    constructor(address hub_, uint256 price_) {
        hub = hub_;
        price = price_;
    }

    function createTask() public payable {
        Hub(hub).createTask2{ value: price }(bytes32("sum-of-numbers"), [bytes("3"), bytes("4")]);
        // createTask  - without params
        // createTask1 - [bytes("param1")]
        // createTask2 - [bytes("param1"), bytes("param2")]
        // createTask3 - [bytes("param1"), bytes("param2"), bytes("param3"), ]
        // createTask4 - [bytes("param1"), bytes("param2"), bytes("param3"), bytes("param4")]
        // createTask5 - [bytes("param1"), bytes("param2"), bytes("param3"), bytes("param4"), bytes("param5")]
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        id = id_;
        result = result_;
    }

    function getTask() public view returns(uint256, uint256) {
        return (id, result);
    }
}
```
