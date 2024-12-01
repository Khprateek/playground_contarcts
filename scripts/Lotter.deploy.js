const { ethers, run } = require("hardhat");

/**
 * Deploys the LoanNex contract with the specified parameters and verifies the contract.
 * @returns {Promise<void>}
 */

async function main() {
  const Lotter = await ethers.getContractFactory("Lottery");
  const lotter = await Lotter.deploy();
  await lotter.deployed();

  console.log('Lotter is deployed to: ', lotter.address);
  // Lotter is deployed to:  0x40268B8e5741E94222696A5119dCDC44B3dE9e19
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
