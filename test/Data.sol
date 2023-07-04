pragma solidity >=0.7.0;

contract Constants {
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

    uint256[] tinyList = [2, 1, 4, 3];
    uint256[] reverseListSmall = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];

    uint256[] duplicatesSmall = [0x44, 0x48, 0x52, 0x55, 0x44];

    uint256[] randomArray = [
        726,
        6888,
        9823,
        4187,
        2451,
        4659,
        1649,
        6301,
        9121,
        6895,
        2709,
        6592,
        4408,
        7691,
        3398,
        4516,
        688,
        2901,
        3908,
        7840,
        9960,
        8879,
        693,
        4268,
        4712,
        5235,
        1740,
        7476,
        2805,
        4589,
        3758,
        7540,
        6830,
        2827,
        3020,
        1832,
        4740,
        1616,
        9650,
        6529,
        4329,
        8624,
        6952,
        7358,
        3086,
        2875,
        4806,
        7825,
        3445,
        2201,
        1904,
        6592,
        4408,
        7691,
        3398,
        4516,
        688,
        2901,
        3908,
        7840,
        9960,
        8879,
        693,
        4268,
        4712,
        5235,
        1740,
        7476,
        2805,
        4589,
        3758,
        7540,
        6830,
        2827,
        3020,
        1832,
        4740,
        1616,
        9650
    ];
}
