import { ethers } from "hardhat";
import MINTABI from "../deployments/polygon/PistolUpgraeable.json";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const mintNFT = async (hre: HardhatRuntimeEnvironment) => {
  try {
    const { deployments, getNamedAccounts } = hre;
    const { deploy, get } = deployments;

    console.log(`loading fixtures for PistolUpgraeable`);
    const { deployer } = await getNamedAccounts();

    const pistolUpgraeable = await ethers.getContractAt(
      "PistolUpgraeable",
      deployer
    );

    const owner = await pistolUpgraeable.owner();
    console.log("owner", owner);
  } catch (err) {
    console.log("mintNFT failed", err);
  }
};

export default mintNFT;
