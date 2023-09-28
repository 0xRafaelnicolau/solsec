## Array Duplicate Elements
Due to insufficient validation, an attacker can pass an array with duplicate elements to steal funds from the protocol.

### Scenario
Imagine you are a security researcher investigating a smart contract for a bank. The bank contract stores user's deposits in a balance array. Users can deposit and withdraw funds from their accounts using the contract. However, a flaw in the contract's logic allows for the withdrawal process to be exploited.

### Goal
Steal all WETH deposited in the contract. Vulnerable contract can be found in [array-duplicates.sol](array-duplicates.sol).

### Proof of Concept
The Proof of Concept can be found in [array-duplicates.t.sol](../../test/array-duplicates/array-duplicates.t.sol).

### Mitigation
Fixed contract can be found in [array-duplicates-fixed.sol](array-duplicates-fixed.sol).

### Run Tests
```shell
forge test --match-path test/array-duplicates/array-duplicates.t.sol -vvv
```