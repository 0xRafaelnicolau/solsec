## Storage Array Loop DoS
Looping throw a big storage array can lead to Denial of Service if the block gas limit is exceeded.

### Scenario
Imagine a scenario where users can register their addresses in a contract. However, over time, the number of registered users becomes excessively large. If `deleteAllUsers` is called, and the number os users is to big, the call may exceed the block gas limit and become effectively DoS. Vulnerable contract can be found in [storage-array-loop-dos.sol](storage-array-loop-dos.sol).