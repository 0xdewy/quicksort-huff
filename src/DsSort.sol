pragma solidity >= 0.8.0;

contract DsSort {
    function sort(uint[] memory data) public pure returns (uint[] memory) {
        unchecked {
            quickSort(data, 0, data.length - 1);
        }
        return data;
    }

    function safeSub(uint a) public pure returns (uint) {
        unchecked {
            if (a == 0) return a;
            else return a - 1;
        }
    }

    function quickSort(
        uint[] memory arr,
        uint left,
        uint right
    ) internal pure {
        unchecked {
            uint pivot = arr[left + ((right - left) / 2)];
            uint i = left;
            uint j = right;
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
