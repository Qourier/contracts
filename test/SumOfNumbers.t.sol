// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "../src/Factory.sol";
import "../src/Hub.sol";
import "../src/interfaces/IHub.sol";
import "../src/example/SumOfNumbers.sol";

contract SumOfNumbersTest is Test, IHub {
    Hub public hub;
    SumOfNumbers public example;
    bytes32[10] public modules;

    function setUp() public {
        modules[0] = bytes32("sum-of-numbers");
        for (uint256 i = 1; i < 10; i++) {
            modules[i] = bytes32(0);
        }
        
        Factory factory = new Factory();
        factory.newHub(1 * 10**18, modules, false);
        (address h, , , uint256 price,) = factory.getHubById(1);
        example = new SumOfNumbers(h, price);
        hub = Hub(h);
    }

    function testHowToUse() public {
        example.createTask{ value: 1 * 10**18 }("11", "24");
        hub.completeTask(1, bytes("35"));
        Task memory task = hub.getTask(1);
        assertEq(task.result, bytes("35"));
        (, uint256 result) = example.getTask();
        assertEq(result, 35);
    }
}
