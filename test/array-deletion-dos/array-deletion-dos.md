## Array Deletion DoS
Array deletion can lead to DoS when hardchecks are performed against it's length.

### Scenario
Imagine a DAO that allows members to create and execute proposals. However, there's a vulnerability in the contract's functionality that can be exploited to make it impossible to create new proposals.

### Goal
Your objective is to break the DAO by making it impossible for anyone to create new proposals. Vulnerable contract can be found in [array-duplicates.sol](../../src/array-deletion-dos/array-deletion-dos.sol).

### Proof of Concept
The Proof of Concept can be found in [array-deletion-dos.t.sol](array-deletion-dos.t.sol).

### Mitigation
Fixed contract can be found in [array-deletion-dos-fixed.sol](../../src/array-deletion-dos/array-deletion-dos-fixed.sol).

### Run Tests
```shell
forge test --match-path test/array-deletion-dos/array-deletion-dos.t.sol -vvv
```