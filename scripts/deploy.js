const hre = require("hardhat");

async function main() {
  const MockNft = await ethers.getContractFactory("SampleERC721");
  const mocknft = await MockNft.deploy();
  // await mockNft.waitForDeployment();
  await mocknft.deployed();
  console.log(
    // `mockNft deployed to ${mockNft.target}`
    `mockNft deployed to ${mocknft.address}`
  );

  const ERC6551Account = await ethers.getContractFactory(
    "ExampleERC6551Account"
  );
  const erc6551Account = await ERC6551Account.deploy();
  await erc6551Account.deployed();

  // await ERC6551Account.waitForDeployment();

  console.log(
    // `ExampleERC6551Account deployed to ${ERC6551Account.target}`
    `ExampleERC6551Account deployed to ${erc6551Account.address}`
  );

  const ERC6551Registry = await ethers.getContractFactory("ERC6551Registry");
  const erc6551Registry = await ERC6551Registry.deploy();
  await erc6551Registry.deployed();

  console.log(`ERC6551Registry deployed to ${erc6551Registry.address}`);

  // accounts = await ethers.getSigners();
  // console.log("Acc 1", accounts[1]);

  // console.log("****Minting token from Account 1****");
  // await mocknft.safeMint("0x889C9983762ddbDCaA08e8E3d9cC975E14c2a8eB", "1");
  // // console.log("Owner of ID 1 =>", await mocknft.ownerOf(1));
  // console.log("Owner of NFT Contract =>", await mocknft.owner());

  // console.log(
  //   "****Calling ERC6551 Registry function 'createAccount' from Account 1****"
  // );
  // const tbaAccount = await erc6551Registry.createAccount(
  //   erc6551Account.address,
  //   31337,
  //   mocknft.address,
  //   1,
  //   0,
  //   "0x"
  // );
  // const txReceipt = await tbaAccount.wait();
  // const tbaAccountCheck = await erc6551Registry.account(
  //   erc6551Account.address,
  //   31337,
  //   mocknft.address,
  //   1,
  //   0
  // );
  // console.log("TBA Check Check =>", tbaAccountCheck);
    
  //********calling event *******//
  // await erc6551Registry.on("AccountCreated",(account,implementation,chainId,tokenContract,tokenId,salt) => {
  //   let data = {
  //     account,
  //     implementation,
  //     chainId,
  //     tokenContract,
  //     tokenId,
  //     salt
  //   }
  //   console.log("Dataaaaaaa Prrrrrrinted ==>",data)
  // })
}

// // const tbaOwner = await

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
