const sha3 = require('js-sha3');
const crypto = require('crypto');
const { Utils } = require("alchemy-sdk");
const { ethers } = require("hardhat");


// console.log(utils)
// let hexString = "0x68656c6c6f20776f726c64";
// let byteArray = utils.arrayify(hexString); 
// console.log(byteArray); // [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]

// Suppose the answers are ["answer1", "answer2", "answer3"]
const answers = [1, 2, 3];

// Generate a random salt
const salt = crypto.randomBytes(32).toString('hex');

// Concatenate the answers and the salt into a single string
const concatenatedAnswersSalt = answers.join("") + salt;

// Hash the concatenated string using Keccak-256
const answerHash = sha3.keccak_256(concatenatedAnswersSalt);
// console.log(typeof(answerHash));
// if (answerHash.length > 64) {
//     answerHash = answerHash.substring(0, 64); // Truncate to 64 characters
// }
const answerHash0x= "0x"+ answerHash;
// const answerHashBytes32Array = Utils.arrayify("0x"+answerHash); 
// const FINAL_HASH = Utils.hexlify(answerHash)

// const FINAL_HASH = Utils.hexlify(answerHashBytes32Array)
// console.log(typeof answerHashBytes32, answerHashBytes32,"\n\n");


console.log("Answer Hash:", answerHash);
// console.log("Salt:", salt);
console.log("Answer Hash 0x:", answerHash0x);
// console.log("answerHashBytes32:", answerHashBytes32Array);
// console.log("FinalHash",FINAL_HASH)

