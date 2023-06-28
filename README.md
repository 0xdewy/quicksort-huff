## Quicksort-Huff

[ds-sort](https://github.com/reflexer-labs/ds-sort/blob/master/src/sort.sol) quicksort implementation written in [Huff](https://github.com/huff-language/huff-rs).

### Development 

To compile Huff contract into bytecode:
```sh
    huffc src/QuickSort.huff --bytecode

```

To run tests:
```sh
    forge install && forge test
```

### Warning

The sort function cannot handle uint256.max as it is currently used as a flag to indicate that the list is sorted


