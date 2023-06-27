pragma solidity >= 0.8.0;

contract DsSort {
    function sort(uint256[] memory data) public pure returns (uint256[] memory) {
        unchecked {
            quickSort(data, 0, data.length - 1);
        }
        return data;
    }

    function safeSub(uint256 a) public pure returns (uint256) {
        unchecked {
            if (a == 0) return a;
            else return a - 1;
        }
    }

    function quickSort(uint256[] memory arr, uint256 left, uint256 right) internal pure {
        unchecked {
            uint256 pivot = arr[left + ((right - left) / 2)];
            uint256 i = left;
            uint256 j = right;
            // if (i == j) return;
            while (true) {
                while (arr[i] < pivot) i++;
                while (pivot < arr[j]) {
                    j = safeSub(j);
                }
                if (i > j) break;

                (arr[i], arr[j]) = (arr[j], arr[i]);
                i++;
                j = safeSub(j);
            }

            if (i < right) quickSort(arr, i, right);

            if (left < j) quickSort(arr, left, j);
        }
    }
}
