import { ethers } from "hardhat";

async function main() {
 //  const tokenDeploy = await ethers.deployContract("TokenB");
 //  tokenDeploy.waitForDeployment();
 //  console.log(tokenDeploy);
 //  console.log(`TokenA deployed to ${tokenDeploy.target}`);
 //tokenA address: 0x0C436099148f67C17fEf7E982971f3560B231442
 // tokenB address: 0x4185706399673c8521b7b37Ca22de8310206F1Bd

 const amount = ethers.parseEther("10");

 const token = await ethers.getContractAt(
  "IToken",
  "0x0C436099148f67C17fEf7E982971f3560B231442"
 );

 await token.mint("0xF4e8Ac6446551E8046540a495120F3648d3B00e4", amount);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
 console.error(error);
 process.exitCode = 1;
});
