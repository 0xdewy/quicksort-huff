// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {Constants} from "./Data.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {DsSort} from "../src/DsSort.sol";
import {InsertionSort} from "../src/InsertionSort.sol";

interface QuickSortHuff {
    function sort(uint256[] calldata array)
        external
        view
        returns (uint256[] memory);
}

contract ContractTest is Test, Constants {
    // Contest private contest;
    QuickSortHuff private quickSortHuff;
    QuickSortHuff private dsSort;

    uint lowestGas = 280000; // Dssort
    address sort;

    uint[] randomListSmall;
    uint[] randomListLarge;
    uint256[] reverseListLarge;
    uint[] customList;

    event GasUsed(uint amount, string algorithm);
    event List(uint[] list);

    function ensureCorrectOrder(uint[] memory list) public {
        for (uint i = 1; i < list.length; i++) {
            assertLe(list[i - 1], list[i]);
        }
    }

    function deployQuickSort() public {
        string[] memory inputs = new string[](3);
        inputs[0] = "huffc";
        inputs[1] = "./src/QuickSortHuff.huff";
        inputs[2] = "--bytecode";
        bytes memory bytecode = vm.ffi(inputs);
        if (bytecode.length == 0) {
            revert("Could not find bytecode");
        }
        // console.logBytes(bytecode);

        assembly {
            sstore(sort.slot, create(0, add(bytecode, 0x20), mload(bytecode)))
        }
        if (address(sort) == address(0)) {
            console.logBytes(bytecode);
            revert("Could not deploy address");
        }
    }

    function setUp() public {
        deployQuickSort();
        quickSortHuff = QuickSortHuff(sort);
        dsSort = QuickSortHuff(address(new DsSort()));

        randomListSmall = randomishList(10, 6);
        randomListLarge = randomishList(1000, 2);
        reverseListLarge = reverseOrderList(1000);
    }

    function testRandomSmall() public {
        uint256[] memory reverseSorted = quickSortHuff.sort(randomListSmall);
        ensureCorrectOrder(reverseSorted);
    }

    function testQuickSortHuff() public {
        uint gasBefore = gasleft();
        uint256[] memory reverseSorted = quickSortHuff.sort(reverseListLarge);
        uint gasAfter = gasBefore - gasleft();
        emit GasUsed(gasAfter, "HuffQuickSort::reverse");
        ensureCorrectOrder(reverseSorted);
    }

    function testQuickSort() public {
        uint gasBefore = gasleft();
        dsSort.sort(reverseListLarge);
        uint gasAfter = gasBefore - gasleft();
        emit GasUsed(gasAfter, "DsSort::reverse");
    }

    function testNoItem() public {
        quickSortHuff.sort(customList);
    }

    function testSingleItem() public {
        customList.push(1);
        quickSortHuff.sort(customList);
    }

    function testQuickSortHuffFuzz(uint[] memory list) public {
        uint256[] memory res = quickSortHuff.sort(list);
        ensureCorrectOrder(res);
    }

    function testCompareHuffAndOriginalPass(uint[] memory list) public {
        uint[] memory res2 = quickSortHuff.sort(list);
        if (list.length > 1) {
            uint[] memory res = dsSort.sort(list);
            for (uint i = 0; i < res.length; i++) {
                assertEq(res[i], res2[i]);
            }
        }
    }
}
