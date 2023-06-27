pragma solidity >=0.7.0;

contract Constants {
    uint256[] tinyList = [2, 1, 4, 3];
    uint256[] reverseListSmall = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

    uint256[] duplicatesSmall = [0x44, 0x48, 0x52, 0x55, 0x44];

    function quoteUnquoteEntropy(uint256 seed) public view returns (uint256 entropy) {
        entropy = ((seed + gasleft()) % 0xFFFF);
    }

    function reverseOrderList(uint256 length) public pure returns (uint256[] memory) {
        uint256 last = length - 1;
        uint256[] memory list = new uint[](length);
        for (uint256 i = last; i > 0; i--) {
            list[last - i] = i;
        }
        return list;
    }

    function randomishList(uint256 length, uint256 seed) public view returns (uint256[] memory) {
        uint256 entropy = quoteUnquoteEntropy(length + seed);
        uint256[] memory list = new uint[](length);
        for (uint256 i = 0; i < length; i++) {
            list[i] = entropy;
            entropy = quoteUnquoteEntropy(entropy);
        }
        return list;
    }
}
