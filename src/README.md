# Qourier Smart Contracts

## Hub

```solidity
import "@qourier/contracts/Hub.sol";
```

## qourier-module-v0-sum-of-numbers

### Use by Qouriers

`npm i -g qourier-module-v0-sum-of-numbers`

### Use by Developers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@qourier/contracts/Hub.sol";

contract SumOfNumbers {
    address public hub;
    uint256 public price;

    uint256 private id;
    uint256 private result;

    constructor(address hub_, uint256 price_) {
        hub = hub_;
        price = price_;
    }

    function createTask(string memory one_, string memory two_) public payable {
        Hub(hub).createTask2{ value: price }(
            bytes32("sum-of-numbers"),
            [bytes(one_), bytes(two_)]
        );
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        require(msg.sender == hub, "Only Qourier can change the state.");
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
```

## qourier-module-v0-ticker-symbol

### Use by Qouriers

`npm i -g qourier-module-v0-ticker-symbol`

### Use by Developers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@qourier/contracts/Hub.sol";

contract TickerSymbol {
    address public hub;
    uint256 public price;

    uint256 private id;
    uint256 private result;

    constructor(address hub_, uint256 price_) {
        hub = hub_;
        price = price_;
    }

    function createTask(string memory symbol_) public payable {
        Hub(hub).createTask1{ value: price }(
            bytes32("ticker-symbol"),
            [bytes(symbol_)]
        );
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        require(msg.sender == hub, "Only Qourier can change the state.");
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
```

## qourier-module-v0-lighthouse-web3

### Use by Qouriers

`npm i -g qourier-module-v0-lighthouse-web3`

# Use by Developers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@qourier/contracts/Hub.sol";

contract PushProtocol {
    address public hub;
    uint256 public price;

    uint256 private id;
    uint256 private status;

    constructor(address hub_, uint256 price_) {
        hub = hub_;
        price = price_;
    }

    function createTask(
        string memory notification_title_,
        string memory notification_body_,
        string memory payload_title_,
        string memory payload_body_
    ) public payable {
        Hub(hub).createTask4{ value: price }(
            bytes32("push-protocol"),
            [
                bytes(notification_title_),
                bytes(notification_body_),
                bytes(payload_title_),
                bytes(payload_body_)
            ]
        );
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        require(msg.sender == hub, "Only Qourier can change the state.");
        id = id_;
        status = bytesToUint(result_);
    }

    function getTask() public view returns(uint256, uint256) {
        return (id, status);
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
```

## qourier-module-v0-lighthouse-web3

### Use by Qouriers

`npm i -g qourier-module-v0-lighthouse-web3`

# Use by Developers

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@qourier/contracts/Hub.sol";

contract LighthouseWeb3 {
    address public hub;
    uint256 public price;

    uint256 private id;
    bytes private cid;

    constructor(address hub_, uint256 price_) {
        hub = hub_;
        price = price_;
    }

    function createTask(
        string memory minimum_,
        string memory maximum_,
        string memory cid_
    ) public payable {
        Hub(hub).createTask4{ value: price }(
            bytes32("lighthouse-web3"),
            [
                bytes(abi.encodePacked(msg.sender)),
                bytes(minimum_),
                bytes(maximum_),
                bytes(cid_)
            ]
        );
    }

    function completeTask(uint256 id_, bytes memory result_) external {
        require(msg.sender == hub, "Only Qourier can change the state.");
        id = id_;
        cid = result_; // https://files.lighthouse.storage/viewFile/CID
    }

    function getTask() public view returns(uint256, bytes memory) {
        return (id, cid);
    }
}
```
