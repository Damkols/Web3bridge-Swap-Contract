import { ethers } from "hardhat";

async function main() {
 const tokenDeploy = await ethers.deployContract("TokenB");
 tokenDeploy.waitForDeployment();
 console.log(tokenDeploy);
 console.log(`TokenA deployed to ${tokenDeploy.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
 console.error(error);
 process.exitCode = 1;
});
