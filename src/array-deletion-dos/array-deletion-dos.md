## Array Deletion DoS
A big array can become undeletable due to it's gas cost, causing a Denial of Service. 

### Scenario
Imagine a scenario where users can register their addresses in a contract. However, over time, the number of registered users becomes excessively large.
As the number of users in the array grows larger, it becomes increasingly expensive to delete it. If the gas costs for deleting the array surpasses the block gas limit, the function `deleteAllUsers` will be effectively DoS. Vulnerable contract can be found in [array-deletion-dos.sol](array-deletion-dos.sol).