Contract Addresses:
Quiztopia on Goerli, Optimism Goerli, Mumbai, Scroll: 
----

Post Contract on Goerli, Arbitrum Goerli, Mumbai, Scroll:
----

```shell
npx hardhat compile
npx hardhat run --network goerli scripts/deploy.ts

###to Verify the Contract:
npx hardhat --network goerli verify --contract "contracts/<token>.sol:<token>" <deploy addr> "<TOKEN CONTRACT NAME>" "<TOKEN NAME>"
npx hardhat help
npx hardhat test


```