// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Hub.sol";
 
contract Factory {

    event NewHub(
        uint256 hub_id,
        address hub_address,
        address personal,
        uint256 price,
        bytes32[10] modules
    );

    uint256 private _hub_id;
    mapping(uint256 => address) private _hubs;
 
    constructor() {}

    function newHub(
        uint256 price_,
        bytes32[10] memory modules_,
        bool personal_
    ) public {
        _hub_id++;
        address personal = personal_ 
            ? msg.sender 
            : address(0);

        Hub hub = new Hub(personal, price_, modules_);

        _hubs[_hub_id] = address(hub);

        emit NewHub(
            _hub_id, 
            _hubs[_hub_id], 
            personal, 
            price_, 
            modules_
        );
    } 

    function getHubById(
        uint256 hub_id_
    ) public view returns(
        address hub,
        address personal,
        uint256 task_id,
        uint256 price,
        bytes32[10] memory modules
    ) {
        hub = _hubs[hub_id_];
        Hub h = Hub(hub);
        (personal, task_id, price, modules) = h.getHub();
    }

    function getHubByAddress(
        address hub_address_
    ) public view returns(
        address hub,
        address personal,
        uint256 task_id,
        uint256 price,
        bytes32[10] memory modules
    ) {
        hub = hub_address_;
        Hub h = Hub(hub);
        (personal, task_id, price, modules) = h.getHub();
    }

}
