## Array Storage Pointers
Writing to pointers pointers can lead to logic issues.

### Scenario
Image a scenario where users can join a queue and wait for their turn to perform a specific action. The contract allows users to pay a fee to skip the queue. However, there's an issue with the contract's logic that will lead to the user who wants to skip the queue to loose money.

### Goal
Demonstrate how users will pay to skip the queue without actually advancing their position. Vulnerable contract can be found in [array-storage-pointers.sol](array-storage-pointers.sol).

### Proof of Concept
Proof of Concept can be found in [array-storage-pointers.t.sol](../../test/array-storage-pointers/array-storage-pointers.t.sol).

### Mitigation
Fixed contract can be found in [array-storage-pointers-fixed.sol](array-storage-pointers-fixed.sol).

### Run Tests
```shell
forge test --match-path test/array-storage-pointers/array-storage-pointers.t.sol -vvv
```