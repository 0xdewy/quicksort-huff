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
    QuickSortHuff private quickSortHuff;
    QuickSortHuff private dsSort;

    uint[] randomListSmall;
    uint[] randomListLarge;
    uint256[] reverseListLarge;
    uint[] customList;

    event GasUsed(uint amount, string algorithm);

    function ensureCorrectOrder(uint[] memory list) public {
        for (uint i = 1; i < list.length; i++) {
            assertLe(list[i - 1], list[i]);
        }
    }

    function setUp() public {
        address huffsort = HuffDeployer.deploy("QuickSort");
        quickSortHuff = QuickSortHuff(huffsort);
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
        uint[] memory res = quickSortHuff.sort(customList);
        assertEq(res.length, 0);
    }

    function testSingleItem() public {
        customList.push(1);
        uint[] memory res = quickSortHuff.sort(customList);
        assertEq(res[0], customList[0]);
        assertEq(res.length, 1);
    }

    function testQuickSortHuffFuzz(uint[] memory list) public {
        uint256[] memory res = quickSortHuff.sort(list);
        ensureCorrectOrder(res);
    }

    function testCompareHuffAndOriginal(uint[] memory list) public {
        uint[] memory res2 = quickSortHuff.sort(list);
        if (list.length > 1) {
            uint[] memory res = dsSort.sort(list);
            for (uint i = 0; i < res.length; i++) {
                assertEq(res[i], res2[i]);
            }
        }
    }
}
