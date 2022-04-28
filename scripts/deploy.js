const hre = require("hardhat");
const fs = require('fs');

async function main() {
  // deploy contract to network and wait for it to be deployed
  const Blog = await hre.ethers.getContractFactory("Blog");
  const blog = await Blog.deploy("NEW BLOG!!");
  await blog.deployed();

  console.log("Greeter deployed to:", blog.address);

  // fs from Node allows you to write to local files pretty easily
  // creates a new config.js file
  fs.writeFileSync('./config.js', `
  export const contractAddress = "${blog.address}"
  export const ownerAddress = "${blog.signer.address}"
  `)
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
