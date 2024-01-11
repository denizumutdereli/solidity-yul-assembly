// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

/*
    memory usage when:
        1- return values to external contract calls your contract
        2- set the function arguments for external contract calls
        3- get values from external contract calls
        4- revert with an error string
        5- log messages
        6- creating a new contract over your contract
        7- using keccak256 hash function

    - equivalent to heap in other languages
    - there is no garbage collection
    - memory is laid out in 32 byte sequences
    - [0x00-0x20] [0x20-0x40] [0x40-0x60] [0x60-0x80] [0x80-0x100]...
    - mload, mstore, mstore8, msize
    - gas charging is for each memory access and for how far into memory array we are. 
    - relatively cheaper than storage, but composition requires caution

    - mstore(slot, value) stores value in slot
    - mstore8(slot, value) same here but for 1byte
    - mload(slot) retrieves 32byes from slot
    - msize() largest accessed memory index in that transaction
*/

contract YulMemory {
    struct Point {
        uint256 x;
        uint256 y;
    }

    event MemoryPointer(bytes32);
    event MemoryPointerMsize(bytes32, bytes32);

    function highConsuption() external pure {
        assembly {
            pop(mload(0xffffffffffffffff)) // The transaction will ran out of gas.
        }
    }

    function mstore8() external pure {
        assembly {
            mstore8(0x00, 7)
            mstore(0x00, 7)
        }
    }

    function memPointer() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        Point memory p = Point({x: 1, y: 2});

        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function memPointerV2() external {
        bytes32 x40;
        bytes32 _msize;
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        Point memory p = Point({x: 1, y: 2});
        assembly {
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);

        assembly {
            pop(mload(0xff))
            x40 := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(x40, _msize);
    }

    function fixedArray() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        uint256[2] memory arr = [uint256(5), uint256(6)];
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncode() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encode(uint256(5), uint256(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncode2() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encode(uint256(5), uint128(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    function abiEncodePacked() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
        abi.encodePacked(uint256(5), uint128(19));
        assembly {
            x40 := mload(0x40)
        }
        emit MemoryPointer(x40);
    }

    event Debug(bytes32, bytes32, bytes32, bytes32);

    function args(uint256[] memory arr) external {
        bytes32 location;
        bytes32 len;
        bytes32 valueAtIndex0;
        bytes32 valueAtIndex1;
        assembly {
            location := arr
            len := mload(arr)
            valueAtIndex0 := mload(add(arr, 0x20))
            valueAtIndex1 := mload(add(arr, 0x40))
        }
        emit Debug(location, len, valueAtIndex0, valueAtIndex1);
    }

    function breakFreeMemoryPointer(uint256[1] memory foo)
        external
        pure
        returns (uint256)
    {
        assembly {
            mstore(0x40, 0x80)
        }
        uint256[1] memory bar = [uint256(6)];
        return foo[0];
    }

    uint8[] foo = [1, 2, 3, 4, 5, 6];

    function unpacked() external view {
        uint8[] memory bar = foo;
    }
}