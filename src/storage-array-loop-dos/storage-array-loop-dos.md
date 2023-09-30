## Storage Array Loop DoS
Looping throw a big storage array can lead to Denial of Service if the block gas limit is exceeded.

### Scenario
Imagine a scenario where users can register their addresses in a contract. However, over time, the number of registered users becomes excessively large. If register is called, and the number of users is too large, the _isRegister function will loop through the array, potentially leading to a Denial of Service (DoS) due to exceeding the block gas limit. Vulnerable contract can be found in [storage-array-loop-dos.sol](storage-array-loop-dos.sol).