pragma solidity >=0.7.0;

contract Constants {
    uint[] tinyList = [2, 1 , 4, 3];
    uint[] reverseListSmall = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

    uint[] duplicatesSmall = [0x44, 0x48, 0x52, 0x55, 0x44];

    function quoteUnquoteEntropy(uint seed) public view returns (uint entropy) {
        entropy = ((seed + gasleft()) % 0xFFFF);
    }

    function reverseOrderList(uint length) public pure returns (uint[] memory) {
        uint last = length - 1;
        uint[] memory list = new uint[](length);
        for (uint i = last; i > 0; i--) {
            list[last - i] = i;
        }
        return list;
    }

    function randomishList(uint length, uint seed) public view returns (uint[] memory) {
        uint entropy = quoteUnquoteEntropy(length + seed);
        uint[] memory list = new uint[](length);
        for (uint i = 0; i < length; i++) {
            list[i] = entropy;
            entropy = quoteUnquoteEntropy(entropy);
        }
        return list;
    }

}
