## Empty Loop Issue
Due to insufficient validation, an attacker can pass an empty array to bypass
the execution of code inside a loop.

### Scenario
Alice and Bob are hosting a private party, and they've set up a secure ticketing system. To gain entry to the party, you need a ticket, which can only be obtained if both Alice and Bob provide you with an invitation.

### Goal
Gain access to Alice and Bob's private party by minting a ticket without their permission. Vulnerable contract can be found in [empty-loop.sol](empty-loop.sol).

### Proof of Concept
Proof of Concept can be found in [empty-loop.t.sol](../../test/empty-loop/empty-loop.t.sol).

### Mitigation
Fixed contract can be found in [empty-loop-fixed.sol](empty-loop-fixed.sol).

### Run Tests
```shell
forge test --match-path test/empty-loop/empty-loop.t.sol -vvv
```