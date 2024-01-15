// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

/* 
    memory allows to deal with data larger than 32 bytes
*/

contract YulMemoryComplex {
    // if you want to return a structed array, its not possible with one value, it requies two of them
    function returnPreStoredValuesInMemory() external pure returns (uint256, uint256, uint256) {
        assembly {
            mstore(0x00, 1)  // 0 -> 32bytes -> 1 
            mstore(0x20, 2) // next block -> 2
            mstore(0x40, 3) // the last block in this example.
            return(0x00, 0x60) // range between 0 - 96 , this returns area of the memory not the variables
        }
    }

    function requireInMemoryAndFallback() external view {
        assembly {
            if iszero(
                eq(caller(), 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
            ) {
                revert(0, 0) // normally yul expect where do we want to return. however, most of the time, it's always the very begining
            }
        }
    }

    function thisaNormalHash() external pure returns (bytes32) {
        bytes memory toBeHashed = abi.encode(1, 2, 3);
        return keccak256(toBeHashed);
    }

    function hashInMemory() external pure returns (bytes32) {
        assembly {

            // lets alloacate a space
            let freeMemoryPointer := mload(0x40)

            // store 1, 2, 3 in memory
            mstore(freeMemoryPointer, 1)
            mstore(add(freeMemoryPointer, 0x20), 2)
            mstore(add(freeMemoryPointer, 0x40), 3)

            // update memory pointer
            mstore(0x40, add(freeMemoryPointer, 0x60)) // increase memory pointer by 96 bytes

            mstore(0x00, keccak256(freeMemoryPointer, 0x60))
            return(0x00, 0x60)  // as an example if you look the memory between 0x00 - 0x10 you will got out of boundry error even the tx mined
        }
    }
}