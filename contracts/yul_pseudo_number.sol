// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
    ***** DO NOT USE THIS, this is predictable. *****
    Just playing arround with yul functions and the memory blocks.
    This approach still does not provide truly random numbers.
    More robust solutions like Chainlink VRF should be considered ***
*/

contract pseudoRandomNumber__DoNotUseIt___ {
    uint256 public randomNumber;
    uint256 public difficulty = block.prevrandao;
    function generateRandomNumber() external {
        
        assembly {
            function generateSeed(offset,  entropy) -> seed {
                let currentTimestamp := timestamp()
                let currentDifficulty := sload(difficulty.slot)
                let currentSender := caller()
                seed := xor(currentTimestamp, xor(currentDifficulty, currentSender))
                seed := add(seed, offset)
                for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                    let memValue := mload(0x80)
                    let updatedValue := add(memValue, mul(i, 3))
                    updatedValue := add(updatedValue, add(seed, i))
                    mstore(0x80, updatedValue)
                }
                seed := mload(0x80)
            }

            // Generate two different seeds
            let seed1 := generateSeed(1,1)
            let seed2 := generateSeed(3,1)

            // Split and concatenate
            // Use the higher 128 bits of seed1 and lower 128 bits of seed2
            let highBits := and(seed1, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000)
            let lowBits := and(seed2, 0x00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            let finalSeed := xor(highBits, lowBits)

            let finalSeed2 := generateSeed(1,finalSeed)
            // Store the finalSeed in the contract's storage (at slot 0)
            sstore(0, finalSeed)

             // Shuffle the hexadecimal digits of the finalSeed
            let shuffledNumber := 0
            let digitMask := 0xf
            let shiftAmount := 0
            for { let i := 0 } lt(i, 64) { i := add(i, 1) } {
                // Extract a 4-bit digit
                let digit := and(shr(shiftAmount, finalSeed), digitMask)

                // Randomize the position to place this digit
                let newPosition := and(mul(i, 7), 0xff)

                // Place the digit in the new position
                digit := shl(newPosition, digit)
                shuffledNumber := or(shuffledNumber, digit)

                // Prepare for next digit
                shiftAmount := add(shiftAmount, 4)
            }

            // Store the shuffled number in the contract's storage
            sstore(0, shuffledNumber)
        }
    }
}