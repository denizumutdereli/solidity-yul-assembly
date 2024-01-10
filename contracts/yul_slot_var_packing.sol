// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

contract YulStorage {
    uint256 x = 2; //slot0  -> sequence
    uint256 y = 13; //slot1
    uint256 z = 43; // slot2

    uint128 a;
    uint128 b;

    uint128 c = 2;
    uint128 d = 3;

    function set(uint256 _x, uint256 _y) external {
        x = _x;
        y = _y;
    }

    function get() external view returns(uint256, uint256) {
        return (x, y);
    }

    function getVarYul() external pure returns(uint256 r, uint256 m) {
        assembly {
            r := a.slot
            m := b.slot // both in same slot due packing
        }
    }

    function getValueYul() external view returns(uint256 r, uint256 m) {
        assembly {
            r := sload(c.slot)
            m := sload(d.slot)
        }
    }

    function getSlotValYul(uint256 slot) external view returns(uint256 r, bytes32 b) {
        assembly {
            r := sload(slot) // slot 4 is -> 1020847100762815390390123822295304634370
            b := sload(slot) // slot 4 is -> b 0x0000000000000000000000000000000300000000000000000000000000000002
        }
    }

    function getOffset() external pure returns(uint256 slotC, uint256 offsetC, uint256 slotD, uint256 offsetD) {
        assembly {
            slotC := c.slot // 0x0000000000000000000000000000000300000000000000000000000000000002 <- slot4, offset 0 = 2
            offsetC := c.offset
            slotD := d.slot // 0x00000000000000000000000000000003 <- slot4, offset 16 = 3
            offsetD := d.offset
        }
    }

}