// const { keccak256 } = require('js-sha3');
const { keccak256 } = require("@ethersproject/keccak256");

const keccak256Hash = (answers) => {
  // Convert the array of numbers to a Uint8Array.
  const answersUint8Array = new Uint8Array(answers);
  console.log("uint8 array",answersUint8Array)

  // Calculate the keccak256 hash of the Uint8Array.
  const hash = keccak256(answersUint8Array);
  console.log("hash",hash)
  // Convert the hash to a hexadecimal string.
  const hexHash = hash.toString('hex');
  console.log("hexHash",hexHash);
  return hexHash;
};

// Example usage:

const answers = [1, 2, 3];
const answerHash = keccak256Hash(answers);

console.log("answerHash", answerHash); 




//OLD LOGIC BELOW

// Generate a random salt
// const salt = crypto.randomBytes(32).toString('hex');
// Concatenate the answers and the salt into a single string
// const concatenatedAnswersSalt = answers.join("") + salt;
// Hash the concatenated string using Keccak-256
// const answerHash = sha3.keccak_256(concatenatedAnswersSalt);

//WE SEND THIS HASH TO THE CONSTRUCTOR AS A STRING:
// const answerHash0x= "0x"+ answerHash;




// console.log("Answer Hash:", answerHash);
// console.log("Answer Hash 0x:", answerHash0x);

