async function main() {
  const Lotter = await ethers.getContractFactory('Lotter');
  const lotter = await Lotter.deploy();

  await lotter.deployed();
  console.log(`The Lotter contract address is ${lotter.address}`);
  return;
}

const runMain = async () => {
  try{
    await main();
    process.exit(0);
  }
  catch (error){
    console.error(error);
    process.exit(1);
  }
}
runMain();

