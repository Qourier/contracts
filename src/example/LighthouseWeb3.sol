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