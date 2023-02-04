// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Factory.sol";
import "../src/Hub.sol";
import "../src/interfaces/IHub.sol";

contract HubTest is Test, IHub {
    Hub public publicHub;
    Hub public personalHub;

    bytes32 module = bytes32("sum-of-numbers");

    function setUp() public {
        Factory factory = new Factory();

        bytes32[10] memory modules;
        modules[0] = module;
        for (uint256 i = 1; i < 10; i++) {
            modules[i] = bytes32(0);
        }

        factory.newHub(1 * 10**18, modules, false);
        (address hub1, , , ,) = factory.getHubById(1);
        publicHub = Hub(hub1);

        factory.newHub(1 * 10**18, modules, true);
        (address hub2, , , ,) = factory.getHubById(2);
        personalHub = Hub(hub2);
    }

    function testCreateTask() public {
        publicHub.createTask2{ value: 1 * 10**18 }(module, [bytes("5"), bytes("2")]);
        Task memory task = publicHub.getTask(1);
        assertEq(task.module, module);
    }

    function testErrorCreateTask() public {
        vm.expectRevert(bytes("You have issued inadequate funding for the task."));
        publicHub.createTask2(module, [bytes("5"), bytes("2")]);
        vm.expectRevert(bytes("Task not found."));
        Task memory task = publicHub.getTask(1);
        assertEq(task.module, 0x0);
    }
}
