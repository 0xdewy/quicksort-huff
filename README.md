## Quicksort-Huff

A gas-optimized quicksort for `uint256[]` written in [Huff](https://github.com/huff-language/huff-rs), based on the [ds-sort](https://github.com/reflexer-labs/ds-sort/blob/master/src/sort.sol) implementation.

### How it works

1. **Quicksort** with Hoare partitioning and a median-of-three pivot. The EVM stack is used as the recursion stack, and the smaller side of each split is sorted first, so at most `log2(n)` ranges are ever pending.
2. Ranges of 16 items or fewer are skipped, then **one insertion sort pass** over the whole array finishes the job. Sentinels (a `0` in the length slot, `uint256.max` one past the end) mean neither loop needs bounds checks.

All indices are memory pointers, so the inner loops do no index math. Any `uint256` value, including `type(uint256).max`, is handled.

### Gas

Execution gas for one `sort` call (Cancun rules):

| input                 | previous version | this version | ds-sort (solc, optimizer on) |
| --------------------- | ---------------: | -----------: | ---------------------------: |
| `Data.randomArray`    |           53,435 |       28,018 |                      153,538 |
| random, n = 100       |           76,216 |       38,044 |                      197,167 |
| random, n = 1000      |        1,160,970 |      545,346 |                    2,988,674 |
| sorted, n = 1000      |          685,970 |      280,024 |                    1,641,405 |
| reverse, n = 1000     |          698,342 |      306,500 |                    1,762,479 |
| all equal, n = 1000   |          787,053 |      434,983 |                    2,622,470 |
| organ pipe, n = 1000  |       18,709,542 |      879,768 |               stack overflow |

### Development

To compile Huff contract into bytecode:
```sh
    huffc src/QuickSort.huff --bytecode
```

To run tests:
```sh
    forge install && forge test
```
