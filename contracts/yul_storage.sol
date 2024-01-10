// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

contract YulStorage {
    uint256 x; //slot0  -> sequence
    uint256 y; //slot1

    function set(uint256 _x, uint256 _y) external {
        x = _x;
        y = _y;
    }

    function get() external view returns(uint256, uint256) {
        return (x, y);
    }

    function getLocationsWithYul() external pure returns(uint256 _xL, uint256 _yL) {
        assembly {
            _xL := x.slot // where it's located
            _yL := y.slot
        }
    }

    function getFromStorageWithYul() external view returns(uint256 _xS, uint256 _yS) {
        assembly {
            _xS := sload(x.slot)
            _yS := sload(y.slot)
        }
    }

    function setStorageWithYul(uint256 _x, uint256 _y) external {
        assembly {
            sstore(x.slot, _x)
            sstore(y.slot, _y)
        }
    }

    // demo purpose -> cauition!
    function inCaseWeAreIdiot(uint slot, uint256 _v) external {
        assembly {
            sstore(slot, _v)
        }
    }
}