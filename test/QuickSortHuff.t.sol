// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Constants} from "./Data.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {DsSort} from "../src/DsSort.sol";

interface QuickSortHuff {
    function sort(uint256[] calldata array) external view returns (uint256[] memory);
}

contract QuicksortHuffTest is Test, Constants {
    QuickSortHuff private quickSortHuff;
    QuickSortHuff private dsSort;

    uint256[] randomListSmall;
    uint256[] randomListLarge;
    uint256[] reverseListLarge;
    uint256[] customList;

    event GasUsed(uint256 amount, string algorithm);

    function ensureCorrectOrder(uint256[] memory list) public {
        for (uint256 i = 1; i < list.length; i++) {
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
        uint256 gasBefore = gasleft();
        uint256[] memory reverseSorted = quickSortHuff.sort(randomArray);
        uint256 gasAfter = gasBefore - gasleft();
        emit GasUsed(gasAfter, "HuffQuickSort::reverse");
        ensureCorrectOrder(reverseSorted);
    }

    function testQuickSort() public {
        uint256 gasBefore = gasleft();
        uint256[] memory reverseSorted = dsSort.sort(randomArray);
        uint256 gasAfter = gasBefore - gasleft();
        emit GasUsed(gasAfter, "DsSort::reverse");
        ensureCorrectOrder(reverseSorted);
    }

    function testNoItem() public {
        uint256[] memory res = quickSortHuff.sort(customList);
        assertEq(res.length, 0);
    }

    function testSingleItem() public {
        customList.push(1);
        uint256[] memory res = quickSortHuff.sort(customList);
        assertEq(res[0], customList[0]);
        assertEq(res.length, 1);
    }

    function testQuickSortHuffFuzz(uint256[] memory list) public {
        vm.assume(list.length > 1);
        uint256[] memory res = quickSortHuff.sort(list);
        ensureCorrectOrder(res);
    }

    function testQuickSortFuzz(uint256[] memory list) public {
        vm.assume(list.length > 1);
        uint256[] memory res = dsSort.sort(list);
        ensureCorrectOrder(res);
    }

    function testCompareHuffAndOriginal(uint256[] memory list) public {
        uint256[] memory res2 = quickSortHuff.sort(list);
        if (list.length > 1) {
            uint256[] memory res = dsSort.sort(list);
            for (uint256 i = 0; i < res.length; i++) {
                assertEq(res[i], res2[i]);
            }
        }
    }

    function testUintMax() public {
        uint256[] memory list = new uint256[](3);
        list[0] = type(uint256).max;
        list[1] = 0;
        list[2] = 1;
        uint256[] memory res = quickSortHuff.sort(list);
        assertEq(res[2], list[0]);
        assertEq(res[1], list[2]);
    }
}
