// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IHub.sol";

interface ICallback {
    function completeTask(uint256, bytes memory) external;
}

contract Hub is IHub {

    event Created(
        uint256 task_id,
        bytes32 module,
        bytes[5] params,
        address callback,
        uint256 tasks,
        uint256 createdAt
    );
    
    event Completed(
        uint256 task_id,
        bytes result,
        address qourier,
        uint256 tasks,
        uint256 completedAt
    );

    address private _personal;

    uint256 private _price;
    bytes32[10] private _modules;
    mapping(bytes32 => bool) private _module; // Supported modules

    mapping(address => uint256) private _balances; // Qourier balances

    uint256 private _task_id;
    mapping(uint256 => Task) private _tasks; // Task list

    constructor(
        address personal_,
        uint256 price_,
        bytes32[10] memory modules_
    ) {
        _personal = personal_ != address(0) ? personal_ : address(0);
        _price = price_;
        _modules = modules_;

        for (uint256 i = 0; i < 10; i++) {
            if (modules_[i] != bytes32(0)) {
                _module[modules_[i]] = true;
            }
        }
    }

    modifier onlyQourier() {
        if (_personal != address(0) && _personal != msg.sender) {
            revert("This is a personal hub.");
        }
        _;
    }

    modifier lowPrice() {
        require(
            msg.value >= _price,
            "You have issued inadequate funding for the task."
        );
        _;
    }

    modifier supportModule(bytes32 m) {
        require(
            _module[m],
            "This module is not supported in this hub."
        );
        _;
    }

    function createTask0(
        bytes32 module_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, [bytes(""), "", "", "", ""]);
    }

    function createTask1(
        bytes32 module_, 
        bytes[1] memory params_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, [params_[0], "", "", "", ""]);
    }

    function createTask2(
        bytes32 module_, 
        bytes[2] memory params_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, [params_[0], params_[1], "", "", ""]);
    }

    function createTask3(
        bytes32 module_, 
        bytes[3] memory params_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, [params_[0], params_[1], params_[2], "", ""]);
    }

    function createTask4(
        bytes32 module_, 
        bytes[4] memory params_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, [params_[0], params_[1], params_[2], params_[3], ""]);
    }

    function createTask5(
        bytes32 module_, 
        bytes[5] memory params_
    ) payable public lowPrice supportModule(module_) {
        _createTask(module_, params_);
    }

    function _createTask(
        bytes32 module_, 
        bytes[5] memory params_
    ) private {
        _task_id++;
        _tasks[_task_id] = Task({
            module: module_,
            params: params_,
            result: "",
            callback: msg.sender,
            qourier: address(0),
            tasks: msg.value / _price,
            createdAt: block.timestamp,
            completedAt: 0
        });
        emit Created(
            _task_id, 
            _tasks[_task_id].module,
            _tasks[_task_id].params,
            _tasks[_task_id].callback,
            _tasks[_task_id].tasks,
            _tasks[_task_id].createdAt
        );
    }

    function completeTask(
        uint256 task_id_,
        bytes memory result_
    ) public onlyQourier {
        Task storage t = _tasks[task_id_];
        require(
            t.tasks >= 1, 
            "The task had already been completed."
        );

        t.result = result_;
        t.qourier = msg.sender;
        t.tasks -= 1;
        t.completedAt = block.timestamp;

        ICallback(t.callback).completeTask(task_id_, result_);

        _balances[msg.sender] += _price;

        emit Completed(
            task_id_,
            t.result,
            t.qourier,
            t.tasks,
            t.completedAt
        );
    }

    function topUpTask(
        uint256 task_id_
    ) public payable {
        Task storage t = _tasks[task_id_];
        t.tasks += msg.value / _price;
    }

    function getTask(
        uint256 task_id_
    ) public view returns(Task memory task) {
        task = _tasks[task_id_];
    }

    function numberOfTasks() public view returns(uint256) {
        return _task_id;
    }

    function getHub() public view returns(
        address personal, 
        uint256 task_id,
        uint256 price,
        bytes32[10] memory modules
    ) {
        personal = _personal;
        task_id = _task_id;
        price = _price;
        modules = _modules;
    }

    function getBalance(
        address qourier_
    ) public view returns(uint256) {
        return _balances[qourier_];
    }

    function withdraw() public payable {
        if (getBalance(msg.sender) > 0) {
            payable(msg.sender).transfer(getBalance(msg.sender));
        } 
    }
}
