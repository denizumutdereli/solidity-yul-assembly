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

    function fixedArrayView(uint256 index) external view returns(uint256 s, bytes32 a, uint256 r) {
        assembly {
            // index 0
            s := fixedArray.slot
            a := add(s, index) //0x0000000000000000000000000000000000000000000000000000000000000003
            r := sload(a) //10
        }
    }

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