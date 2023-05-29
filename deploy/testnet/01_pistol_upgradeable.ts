import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";
// import chalk from 'chalk';

const log = console.log;

const parse = (value: string, decimals = 18): BigNumber => {
  return ethers.utils.parseUnits(value, decimals);
};

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  try {
    const { deployments, getNamedAccounts } = hre;
    const { deploy, get } = deployments;

    console.log(`loading fixtures for PistolUpgraeable`);
    const { deployer } = await getNamedAccounts();

    // const hMove = await get("HyperMoveUpgradeable");
    // const busd = await get("BUSDUpgradeable");

    // console.log({ deployer });

    const PistolUpgraeable = await deploy("PistolUpgraeable", {
      from: deployer,
      proxy: {
        owner: deployer,
        proxyContract: "OpenZeppelinTransparentProxy",
        execute: {
          init: {
            methodName: "__pistolUpgradeable__init",
            args: [],
          },
        },
      },
      args: [],
      log: true,
      autoMine: true,
      skipIfAlreadyDeployed: true,
    });

    log(
      `PistolUpgraeable deployed with ${PistolUpgraeable.transactionHash} at ${PistolUpgraeable.address}`
    );
  } catch (err) {
    if (err instanceof Error) {
      log(err.message);
    }
  }
};

export default func;
