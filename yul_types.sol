// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// demonstration of the yul logical operation, 
// low-level coding can introduce vulnerabilities if not done correctly
// this is for learning purposes only

contract YulDataTypes {
    // The function uses inline assembly to assign the decimal value 100 to a variable.
    function getNumber() external pure returns (uint256) {
        uint256 value;
        assembly {
            value := 100 // ':=' is the Yul opcode for assignment.
        }
        return value;
    }

    // It shows how hexadecimal constants are handled in Yul assembly.
    function getHexValue() external pure returns (uint256) {
        uint256 value;
        assembly {
            value := 0x64 // Hexadecimal representation of 100.
        }
        return value;
    }

    // This function attempts to assign a bytes32 value to a boolean, showcasing type conversions in Yul.
    function getAssignments() external pure returns (bool) {
        bool _rep;
        bytes32 zero = bytes32("1"); // 0 => false, 1+ => true
        assembly {
            _rep := zero // Illustrates implicit type conversion.
        }
        return _rep;
    }

    // It assigns a string to a bytes32 variable and then converts it to a Solidity string.
    // Using string memory when assigning is not supported due to string will be on heap memory, so we allocate space for the string with bytes32
    function getString() external pure returns (string memory) {
        bytes32 rep;
        assembly {
            rep := "when out of byte space Yul noise" // Assigning a string directly in Yul. This is a raw byte assignment.
        }
        return string(abi.encode(rep)); // Converting bytes32 to re-back string
    }
}