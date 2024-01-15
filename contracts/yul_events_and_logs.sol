// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;
/*
    test it on testnet not in remix
*/

contract Log {
    event SomeLog(uint256 indexed a, uint256 indexed b);
    event SomeLogV2(uint256 indexed a, bool);
    event SomeLogV3(uint256 a);

    function emitLog() external {
        emit SomeLog(5, 6);
    }

    function yulEmitLog() external {
        assembly {
            // keccak256("SomeLog(uint256,uint256)")
            let
                signature
            := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc
            log3(0, 0, signature, 5, 6) // memory mentioned none because we dont have any memory allocation for returning indexed values
        }
    }

    function v2EmitLog() external {
        emit SomeLogV2(5, true);
    }

    function v2YulEmitLog() external {
        assembly {
            // keccak256("SomeLogV2(uint256,bool)") -> solidty under the hood using keccak256 for the tx signature for the events
            let
                signature
            := 0x113cea0e4d6903d772af04edb841b17a164bff0f0d88609aedd1c4ac9b0c15c2
            mstore(0x00, 1) // lets first allocate the memory space
            log2(0, 0x20, signature, 5) // this is how one indexed and non-indexed variables to be logged
        }
    }

    function v3YulEmitLog() external {
        emit SomeLogV3(1);
    }
}