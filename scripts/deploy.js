const { ethers } = require("hardhat")
const hre = require("hardhat")

async function main() {
  const Quiz = await hre.ethers.getContractFactory("TriviaQuiz")
  console.log("deploying...")
  const QuizDeployed = await Quiz.deploy(
    "0xf1885eda54b7a053318cd41e2093220dab15d65381b1157a3633a83bfd5c9239", 
    3,  {
    value: ethers.parseEther("0.0175") // Specify the amount of Ether you want to send
    }
  );
  console.log("line 10")////QuizDeployed.address)
  await QuizDeployed.waitForDeployment();
  console.log("Line 14")
  await QuizDeployed.deploy; //ed
  console.log("The latest quiz contract was deployed", QuizDeployed.target)
  console.log("Deployed by ",QuizDeployed.runner.address)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
