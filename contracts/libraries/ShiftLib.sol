pragma solidity 0.8.10;

import '../test/Event.sol';

library ShiftLib {
    using Event for uint256;

    // function chop(
    //     uint256[] memory input,
    //     // uint256 b,
    //     uint256 bstart,
    //     uint256 bend
    // ) internal  returns (uint256[] memory output) {
    //     // require(pos <= input.length * 256, 'SL:B4:0');
    //     res = bit(input[pos / 256], b, pos % 256);
    // }

    // event log(string);
    // event logs(bytes);

    // event log_address(address);
    // event log_bytes32(bytes32);
    // event log_int(int256);
    // event log_uint(uint256);
    // event log_bytes(bytes);
    // event log_string(string);

    // event log_named_address(string key, address val);
    // event log_named_bytes32(string key, bytes32 val);
    // event log_named_decimal_int(string key, int256 val, uint256 decimals);
    // event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    // event log_named_int(string key, int256 val);
    // event log_named_uint(string key, uint256 val);
    // event log_named_bytes(string key, bytes val);
    // event log_named_string(string key, string val);

    function reverse(uint256 input) internal pure returns (uint256 v) {
        v = input;

        // v =
        //     ((v & 0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0) >> 4) |
        //     ((v & 0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) << 4);

        // swap bytes
        v =
            ((v & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00) >> 8) |
            ((v & 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) << 8);

        // swap 2-byte long pairs
        v =
            ((v & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000) >> 16) |
            ((v & 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) << 16);

        // swap 4-byte long pairs
        v =
            ((v & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000) >> 32) |
            ((v & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) << 32);

        // swap 8-byte long pairs
        v =
            ((v & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000) >> 64) |
            ((v & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) << 64);

        // swap 16-byte long pairs
        v = (v >> 128) | (v << 128);
    }

    function rbit(
        uint256[] memory input,
        uint256 b,
        uint256 pos
    ) internal returns (uint256 res) {
        // pos.log('pos');
        // (input.length * 256).log('input.length');
        require(pos <= input.length * 256, 'SL:B4:0');
        res = rbit(input[pos / 256], b, pos % 256);
    }

    function rbit(
        uint256 input,
        uint256 b,
        uint256 pos
    ) internal returns (uint256 res) {
        input = reverse(input);
        require(pos <= 0xff, 'SL:B4:0');
        assembly {
            // res := and(shr(sub(256, add(pos, 8)), input), sub(exp(2, b), 1))

            res := and(shr(pos, input), sub(exp(2, b), 1))
        }
    }

    function rbit1(uint256[] memory input, uint256 pos) internal returns (bool res) {
        require(pos <= input.length * 256, 'SL:B4:0');
        res = rbit1(input[pos / 256], pos % 256);
    }

    function rbit1(uint256 input, uint256 pos) internal returns (bool res) {
        require(pos <= 0xff, 'SL:B4:0');
        input = reverse(input);

        assembly {
            res := and(shr(pos, input), 0x3)
        }
    }

    function bit(
        uint256[] memory input,
        uint256 b,
        uint256 pos
    ) internal returns (uint256 res) {
        require(pos <= input.length * 256, 'SL:B4:0');
        res = bit(input[pos / 256], b, pos % 256);
    }

    function bit1(uint256[] memory input, uint256 pos) internal returns (bool res) {
        require(pos <= input.length * 256, 'SL:B4:0');
        res = bit1(input[pos / 256], pos % 256);
    }

    function bit(
        uint256[] memory input,
        uint256 b,
        uint256 pos,
        uint256 update
    ) internal returns (uint256 res) {
        res = bit(input[pos / 256], b, pos % 256, update);
    }

    function bit1(
        uint256[] memory input,
        uint256 pos,
        bool update
    ) internal returns (uint256 res) {
        res = bit1(input[pos / 256], pos % 256, update);
    }

    function bit(
        uint256 input,
        uint256 b,
        uint256 pos
    ) internal returns (uint256 res) {
        require(pos <= 0xff, 'SL:B4:0');
        assembly {
            // res := and(shr(sub(256, add(pos, 8)), input), sub(exp(2, b), 1))

            res := and(shr(pos, input), sub(exp(2, b), 1))
        }

        // emit log_named_uint('res', res);
    }

    function bit(
        uint256 input,
        uint256 b,
        uint256 pos,
        uint256 update
    ) internal returns (uint256 res) {
        // input.log('input');
        // input = reverse(input);
        // update.log('update');
        uint256 offset;
        // b.log('b');
        assembly {
            offset := sub(exp(2, b), 1)
        }

        // offset.log('offset');
        assembly {
            if gt(update, offset) {
                revert(0, 0)
            }
            if gt(pos, 0xff) {
                revert(0, 0)
            }
            input := and(not(shl(pos, sub(exp(2, b), 1))), input)
            res := or(input, shl(pos, update))
        }
    }

    function bit1(uint256 input, uint256 pos) internal returns (bool res) {
        require(pos <= 0xff, 'SL:B4:0');

        assembly {
            res := and(shr(pos, input), 0x3)
        }
    }

    function bit1(
        uint256 input,
        uint256 pos,
        bool update
    ) internal returns (uint256 res) {
        require(pos <= 0xff, 'SL:B4:0');
        uint256 tu = update ? 0x1 : 0x0;
        assembly {
            input := and(not(shl(pos, 0x3)), input)
            res := or(input, shl(pos, tu))
        }
    }

    // function bit3(uint256 input, uint256 pos) internal  returns (uint256 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xb)
    //     }
    // }

    // function bit4(uint256 input, uint256 pos) internal  returns (uint256 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xf)
    //     }
    // }

    // function bit6(uint256 input, uint256 pos) internal  returns (uint256 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0x3f)
    //     }
    // }

    // function bit8(uint256 input, uint256 pos) internal  returns (uint256 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xff)
    //     }
    // }

    // function bit12(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xfff)
    //     }
    // }

    // function bit16(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xffff)
    //     }
    // }

    // function bit20(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xfffff)
    //     }
    // }

    // function bit24(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xffffff)
    //     }
    // }

    // function bit28(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xfffffff)
    //     }
    // }

    // function bit32(uint256 input, uint256 pos) internal  returns (uint16 res) {
    //     require(pos <= 0xff, 'SL:B4:0');

    //     assembly {
    //         res := and(shr(pos, input), 0xffffffff)
    //     }
    // }

    // function bit1(
    //     uint256 input,
    //     uint256 pos,
    //     bool update
    // ) internal  returns (uint256 res) {
    //     require(pos <= 0xff, 'SL:B4:0');
    //     uint256 tu = update ? 0x1 : 0x0;
    //     assembly {
    //         input := and(not(shl(pos, 0x3)), input)
    //         res := or(input, shl(pos, tu))
    //     }
    // }

    // function bit3(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xb && pos <= 0xff, 'SL:B3:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xb)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit4(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xf && pos <= 0xff, 'SL:B4:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xf)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit6(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xff && pos <= 0xff, 'SL:B8:0');
    //     assembly {
    //         input := and(not(shl(pos, 0x3f)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit8(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xff && pos <= 0xff, 'SL:B8:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit12(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xfff && pos <= 0xff, 'SL:B12:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xfff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit16(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xffff && pos <= 0xff, 'SL:B16:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xffff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit20(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xfffff && pos <= 0xff, 'SL:B16:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xfffff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit24(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xffffff && pos <= 0xff, 'SL:B16:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xffffff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit28(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xfffffff && pos <= 0xff, 'SL:B16:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xfffffff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }

    // function bit32(
    //     uint256 input,
    //     uint256 pos,
    //     uint256 update
    // ) internal  returns (uint256 res) {
    //     require(update <= 0xffffffff && pos <= 0xff, 'SL:B16:0');
    //     assembly {
    //         input := and(not(shl(pos, 0xffffffff)), input)
    //         res := or(input, shl(pos, update))
    //     }
    // }
}
