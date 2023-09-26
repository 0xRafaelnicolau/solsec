## Array Duplicate Elements
Brief explanation of the issue

### Scenario
Scenario in which the issue can occur

### Goal
Describe the goal of the exploit based on the scenario. Vulnerable contract can be found in [array-duplicates.sol](../../src/array-duplicates/array-duplicates.sol).

### Solution
The Proof of Concept and functionality test can be found in [array-duplicates.t.sol](array-duplicates.t.sol).

### Mitigation
Fixed contract can be found in [array-duplicates-fixed.sol](../../src/array-duplicates/array-duplicates-fixed.sol).

### Run Tests
```shell
forge test --match-path test/array-duplicates/array-duplicates.t.sol -vvv
```