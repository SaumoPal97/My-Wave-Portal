// SPDX-License-Identifier: UNLICENSED
// prevents the pragma warning from coming
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;
    // address[] senders;
    // mapping(address => uint256) waveMap;
    mapping(address => uint256) public lastWavedAt;


    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave { 
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    constructor() payable {
        //totalWaves = 0;  not needed as variable automatically initialized to 0
        console.log("Yo yo, this is Saumo");
    }

    function wave(string memory _message) public { 
        require(
            lastWavedAt[msg.sender] + 15 seconds < block.timestamp,
            "Wait 15m"
        );

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
        // senders.push(msg.sender);
        // waveMap[msg.sender] += 1;
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);
        seed = randomNumber;

        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.00001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more monet than the contract has");

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw moneu from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) { 
        // for (uint i=0; i<senders.length; i++) {
        //     console.log("%s waved at you %d times", senders[i], waveMap[senders[i]]);
        // }
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}