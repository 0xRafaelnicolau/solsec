## Force Revert DoS
By forcing a call to fail, a malicious user can effectively DoS contract functionality.

### Scenario
You find yourself participating in a competitive NFT auction, but you suspect that there will be bidders willing to place significantly higher values on the NFT you desire. You are determined to secure the NFT for yourself, even though you anticipate being outbid by others.

### Goal
Win the NFT. Vulnerable contract can be found in [force-revert-dos.sol](force-revert-dos.sol).

### Proof of Concept
Proof of Concept can be found in [force-revert-dos.t.sol](../../test/force-revert-dos/force-revert-dos.t.sol). Which also contains an Attack contract [attack.sol](../../test/force-revert-dos/attack.sol).

### Mitigation
Fixed contract can be found in [force-revert-dos-fixed.sol](force-revert-dos-fixed.sol).

### Run Tests
```shell
forge test --match-path test/force-revert-dos/force-revert-dos.t.sol -vvv
```