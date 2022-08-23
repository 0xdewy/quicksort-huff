pragma solidity >=0.8.0;

contract InsertionSort {
    function _insertionSort(uint[] memory arr, uint numElements)
        internal
        pure
        returns (uint[] memory)
    {
        unchecked {
            uint i;
            uint key;
            uint j;
            for (i = 1; i < numElements; i++) {
                key = arr[i];
                j = i - 1;


                while (j != type(uint256).max && arr[j] > key) {
                    arr[j + 1] = arr[j];
                    j = j - 1;
                }
                arr[j + 1] = key;
            }
        }
        return arr;
    }

    function insertionSort(uint[] memory arr) external virtual pure returns (uint[] memory) {
        return _insertionSort(arr, arr.length);
    }
}
