// import { hexStripZeros } from "ethers/lib/utils";
// const ethers = require("hardhat")
const hre = require("hardhat")



async function main() {
  const Quiz = await hre.ethers.getContractFactory("TriviaQuiz")
  console.log("deploying...")
  const QuizDeployed = await Quiz.deploy(
    "0x10fa54a7adb4b4cb5b19989d3d1a9a75e23aabac75bb5b5942fab9a87838caf8", 
    3,  {
    value: ethers.utils.parseEther("0.0875") // Specify the amount of Ether you want to send
    }
  );
  console.log("line 10")////QuizDeployed.address)
  // console.log("QuizDeployed",QuizDeployed,"\n\n")
  await QuizDeployed.waitForDeployment();
  console.log("Line 14")
  await QuizDeployed.deploy; //ed
  console.log("The latest quiz contract was deployed", QuizDeployed.target)
  console.log("Deployed by ",QuizDeployed.runner.address)
///////
  // const [deployer] = await ethers.getSigners();

  // console.log("Deploying contracts with the account:", deployer.address);
  // const QUIZ = await ethers.deployContract("QuizDeployed");
  // console.log("Token address:", await QUIZ.getAddress());


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
