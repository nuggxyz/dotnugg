import { ethers } from 'ethers';

const Box = '█';
const Box2 = '░';
const Reset = '\x1B[0m';
const Red = '\x1B[31m';
const Green = '\x1B[32m';
const Yellow = '\x1B[33m';
const Blue = '\x1B[34m';
const Purple = '\x1B[35m';
const Cyan = '\x1B[36m';
const Gray = '\x1B[37m';
const White = '\x1B[97m';

const colorLookup: { [_: number]: string } = {
    0: ' ',
    1: Green + Box + Reset,
    2: Yellow + Box + Reset,
    3: Blue + Box + Reset,
    4: Cyan + Box + Reset,
    5: Purple + Box + Reset,
    6: Gray + Box + Reset,
    7: Red + Box + Reset,
    8: White + Box2 + Reset,
    9: White + Box + Reset,
    10: Green + Box2 + Reset,
    11: Yellow + Box2 + Reset,
    12: Red + Box2 + Reset,
    13: Blue + Box2 + Reset,
    14: Cyan + Box2 + Reset,
    15: Purple + Box2 + Reset,
    16: Gray + Box2 + Reset,
    17: Red + Box2 + Reset,
    18: Blue + Box2 + Reset,
};

type Group = {
    key: number;
    len: number;
};

function DecodeByteToGroup(data: number): Group {
    // if len(data) != 1 {
    // 	log.Fatal("trying to decode row not of length 2" + string(data))
    // }

    const [a, b] = toUint4(data);

    // fmt.Println(a, b+1)
    return {
        key: a,
        len: b + 1,
    };
}

function DecodeBytesToGroups(data: Uint8Array): Group[] {
    // if len(data) != 1 {
    // 	log.Fatal("trying to decode row not of length 2" + string(data))
    // }
    let res: Group[] = [];
    for (let i = 0; i < data.length; i++) {
        res.push(DecodeByteToGroup(data[i]));
    }
    return res;
}

function toUint4(c: number): [number, number] {
    return [c >> 4, c & 0xf];
}

function EncodeToText(arr: Group[], width: number, height: number): string[] {
    let res: string[] = [];
    let i = 0;

    res.push(CreateNumberedRow(width));

    // for i := range arr {
    for (let y = 0; y < height; y++) {
        let tmp = '';
        // if y == int(d.Len.Y)-1 {
        // 	res.push("\n")
        // }
        for (let x = 0; x < width; x++) {
            // console.log(arr[i]);
            if (arr[i]) {
                tmp += colorLookup[arr[i].key] + colorLookup[arr[i].key];
                if (x + 1 < width) {
                    tmp += ' ';
                }
                arr[i].len--;
                if (arr[i].len == 0) {
                    i++;
                }
            } else {
                tmp += ' ';
            }
        }
        res.push(y.toString().padEnd(2) + ' ' + tmp + ' ' + y.toString().padStart(2));
    }

    res.push(CreateNumberedRow(width));

    return res;
}

function CreateNumberedRow(num: number): string {
    let res = '   ';
    for (var i = 0; i < num; i++) {
        res += (i % 10).toString() + '  ';
    }
    return res;
}

export const bashit = (input: string, width: number, height: number) => {
    const bytes = ethers.utils.base64.decode(input.replace('data:groups;base64,', ''));

    const groups = DecodeBytesToGroups(bytes);

    const output = EncodeToText(groups, width, height);
    output.forEach((x) => {
        console.log(x);
    });
};
