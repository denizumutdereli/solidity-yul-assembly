// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

contract YulStorageComplex {
    uint256[3] fixedArray;
    uint[] bigArray;
    uint[8] smallArray;

    mapping(uint256 => uint256) public testMapping;
    mapping(uint256 => mapping(uint256 => uint256)) public nestedMapping;
    mapping(address => uint256[]) public addressList;

    constructor() {
        fixedArray = [1,11,111];
        bigArray = [10,100,1000];
        smallArray = [1,2,3];

        testMapping[0] = 1;
        testMapping[1] = 2;

        nestedMapping[2][8] = 9;

        addressList[address(1)] = [9, 99, 999];
    }

    // EVM is using sequential indexing for the fixed array and valute gether logic is slot + index 
    function fixedArrayView(uint256 index) external view returns(uint256 s, bytes32 a, uint256 r) {
        assembly {
            // index 0
            s := fixedArray.slot
            a := add(s, index) //0x0000000000000000000000000000000000000000000000000000000000000003
            r := sload(a) //10
        }
    }

    /* 
        For the dynamic arrays on EVM its more complicated. At first it does only keeps the length of the array
        The elements themselves are strored at the slot keccak256(slot)
        The gether function logic is keccak256(slot) + index
    */
    function readbigArrayLocation(uint256 index) external view returns(uint256 s, bytes32 l, uint256 r) {
        uint256 slot;
        assembly {
            slot := bigArray.slot
            s := slot
        }
        
        l = keccak256(abi.encode(slot));

        assembly {
            r := sload(add(l, index))
        }
    }

    /*
        Mappings use a hash-based approach for storage since they don't store their elements in sequential slots.
        The slot for a value corresponding to a key k in a mapping stored at slot s is keccak256(abi.encode(k, s)). 
        This formula ensures that each key maps to a unique slot.
    */
    function getMapping(uint256 key) external view returns(bytes32 l, uint256 r) {
        uint256 slot;
        assembly {
             slot := testMapping.slot
        }

        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        assembly {
            l := location
            r := sload(location)
        }
    }

    /* 
        Nested mappings add another layer of hashing.
        For a nested mapping, the location of a value is determined by first calculating the slot of the inner mapping 
        and then applying the hash-based approach of regular mappings.

        If you have a mapping like mapping (uint => mapping (uint => uint)) nestedMapping stored at slot s, 
        the slot for the value corresponding to keys k1 and k2 is calculated as keccak256(abi.encode(k2, keccak256(abi.encode(k1, s)))). 
        Here, k1 is the key for the outer mapping, and k2 is the key for the inner mapping.
        
    */
    function getNestedMapping() external view returns(bytes32 l, uint256 r) {
        uint256 slot;
        assembly {
            slot := nestedMapping.slot
        }

        bytes32 location = keccak256(
            abi.encode(
                uint256(8),
                keccak256(abi.encode(uint256(2), uint256(slot)))
            )
        );
        assembly {
            l := location
            r := sload(location)
        }
    }

    function getNestedMappingListLength() external view returns(bytes32 l, uint256 r) {
        uint256 slot;
        assembly {
            slot := addressList.slot
        }

        bytes32 location = keccak256(
            abi.encode(
                address(1),
                uint256(slot)
            )
        );

        assembly {
            l := location
            r := sload(location)
        }
    }

    function getNestedMappingListValue(uint256 index) external view returns(bytes32 l, uint256 r) {
        uint256 slot;

        assembly {
            slot := addressList.slot
        }

        bytes32 location = keccak256(
            abi.encode(
                keccak256(
                    abi.encode(
                        address(1),
                        uint256(slot)
                    )
                )
            )
        );

        assembly {
            l := location
            r := sload(add(location, index))
        }

    }
}