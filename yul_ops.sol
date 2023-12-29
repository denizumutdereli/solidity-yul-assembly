// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// demonstration of the yul logical operations, 
// low-level coding can introduce vulnerabilities if not done correctly
// this is for learning purposes only

contract YulLogicalOperations {

    // Uses assembly to check if a number is prime.
    // Demonstrates the use of loops and conditional statements in Yul.
    function isPrime(uint256 x) public pure returns (bool p) {
        p = true;
        assembly {
            let halfX := add(div(x, 2), 1)
            for { let i := 2 } lt(i, halfX) { i := add(i, 1) } {
                if iszero(mod(x, i)) {
                    p := 0
                    break
                }
            }
        }
    }

    // Demonstrates the 'add' opcode for addition in Yul.
    function checkAdd(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := add(a, b)
        }
    }

    // Showcases the 'div' opcode for division in Yul.
    function checkDiv(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := div(a, b)
        }
    }

    // Uses the 'lt' opcode to compare two numbers in Yul.
    function checkLt(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := lt(a, b)
        }
    }

    // Demonstrates the 'mod' opcode for modulo operation in Yul.
    function checkMod(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := mod(a, b)
        }
    }

    // Illustrates the use of 'iszero' opcode for checking if a number is zero.
    function checkZero(uint256 a) external pure returns (bool c) {
        assembly {
            c := iszero(a)
        }
    }

    // Similar to checkZero, but returns a bytes32 result.
    function checkZeroBytes32(uint256 a) external pure returns (bytes32 c) {
        assembly {
            c := iszero(a)
        }
    }

    // Demonstrates conditional execution in Yul using 'if'.
    function isTruthy() external pure returns (uint256 result) {
        result = 2;
        assembly {
            if 2 {
                result := 1
            }
        }
        return result;
    }

    // Similar to isTruthy, but checks for falsy condition.
    function isFalsy() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if 0 {
                result := 2
            }
        }
        return result;
    }

    // Showcases the use of negation using 'iszero'.
    function negation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(0) {
                result := 2
            }
        }
        return result;
    }

    // Uses conditional 'if' to determine the maximum of two numbers.
    function max(uint256 x, uint256 y) external pure returns (uint256 maximum) {
        assembly {
            if lt(x, y) {
                maximum := y
            }
            if iszero(lt(x, y)) {
                maximum := x
            }
        }
    }

    // Demonstrates a pseudo 'switch' statement in Yul.
    function checkSwitch(uint256 x, uint256 y) external pure returns (uint256 lesser) {
        uint256 sum;
        assembly {
            sum := add(x, y)
            switch lt(x, y)
            case true {
                lesser := x
            }
            case false {
                lesser := y
            }
            default {
                lesser := sum
            }
        }
    }

    // Illustrates how to emulate a 'while' loop using a 'for' loop in Yul.
    function checkWhile() external pure returns (uint256 result) {
        assembly {
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                result := add(result, i)
            }
        }
    }
}
