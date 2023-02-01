// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Factory.sol";

contract FactoryTest is Test {
    Factory public factory;
    bytes32[10] public modules;

    function setUp() public {
        factory = new Factory();

        modules[0] = bytes32("sum-of-numbers");
        for (uint256 i = 1; i < 10; i++) {
            modules[i] = bytes32(0);
        }
    }

    function testNewHub() public {
        factory.newHub(1 * 10**18, modules, false);
        (, , , uint256 price,) = factory.getHubById(1);
        assertEq(price, 1 * 10**18);
    }
}
