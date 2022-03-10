module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const yourToken = await ethers.getContract("YourToken", deployer);


  await deploy("Vendor", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
   from: deployer,
   args: [yourToken.address],
   log: true,
  });
  const Vendor = await deployments.get("Vendor");
  const vendor = await ethers.getContract("Vendor", deployer);
  console.log("\n 🏵  Sending all 1000 tokens to the vendor...\n");

  const result = await yourToken.transfer( vendor.address, ethers.utils.parseEther("1000") );

  console.log("\n 🤹  Sending ownership to frontend address...\n")
  // ToDo: change address with your burner wallet address vvvv
  await vendor.transferOwnership( "0x1A72b429372352B92201bB7Cd42dF4baD68e037b" );
};

module.exports.tags = ["Vendor"];
