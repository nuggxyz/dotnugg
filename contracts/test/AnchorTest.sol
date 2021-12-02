// // SPDX-License-Identifier: MIT

// pragma solidity 0.8.10;

// import '../interfaces/IDotNugg.sol';
// import '../logic/Matrix.sol';
// import '../logic/Anchor.sol';
// import '../test/Console.sol';

// contract AnchorTest {
//     /**
//      * @notice done
//      * @dev
//      */

//     function initialize() internal view returns (IDotNugg.Matrix memory) {
//         IDotNugg.Pixel[] memory pallet = new IDotNugg.Pixel[](2);
//         pallet[0] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 1, g: 1, b: 1, a: 255}), zindex: 2, exists: true});
//         pallet[1] = IDotNugg.Pixel({rgba: IDotNugg.Rgba({r: 255, g: 255, b: 255, a: 27}), zindex: 3, exists: true});

//         IDotNugg.Matrix memory input = Matrix.create(33, 33);
//         input.width = 33;
//         input.height = 33;

//         input.data[2][4] = pallet[0];
//         input.data[2][5] = pallet[0];
//         input.data[2][6] = pallet[0];
//         input.data[2][7] = pallet[0];
//         input.data[2][8] = pallet[0];
//         input.data[2][9] = pallet[0];
//         input.data[2][10] = pallet[0];
//         input.data[2][11] = pallet[0];
//         input.data[2][12] = pallet[0];
//         input.data[2][13] = pallet[0];
//         input.data[2][14] = pallet[0];
//         input.data[2][15] = pallet[0];
//         input.data[2][16] = pallet[0];
//         input.data[2][17] = pallet[0];
//         input.data[2][18] = pallet[0];
//         input.data[2][19] = pallet[0];
//         input.data[2][20] = pallet[0];
//         input.data[2][21] = pallet[0];
//         input.data[2][22] = pallet[0];
//         input.data[2][23] = pallet[0];
//         input.data[2][24] = pallet[0];
//         input.data[2][25] = pallet[0];
//         input.data[2][26] = pallet[0];
//         input.data[2][27] = pallet[0];
//         input.data[2][28] = pallet[0];
//         input.data[2][29] = pallet[0];
//         input.data[3][4] = pallet[1];
//         input.data[3][5] = pallet[1];
//         input.data[3][6] = pallet[1];
//         input.data[3][7] = pallet[1];
//         input.data[3][8] = pallet[1];
//         input.data[3][9] = pallet[1];
//         input.data[3][10] = pallet[1];
//         input.data[3][11] = pallet[1];
//         input.data[3][12] = pallet[1];
//         input.data[3][13] = pallet[1];
//         input.data[3][14] = pallet[1];
//         input.data[3][15] = pallet[1];
//         input.data[3][16] = pallet[1];
//         input.data[3][17] = pallet[1];
//         input.data[3][18] = pallet[1];
//         input.data[3][19] = pallet[1];
//         input.data[3][20] = pallet[1];
//         input.data[3][21] = pallet[1];
//         input.data[3][22] = pallet[1];
//         input.data[3][23] = pallet[1];
//         input.data[3][24] = pallet[1];
//         input.data[3][25] = pallet[1];
//         input.data[3][26] = pallet[1];
//         input.data[3][27] = pallet[1];
//         input.data[3][28] = pallet[1];
//         input.data[3][29] = pallet[1];
//         input.data[4][4] = pallet[0];
//         input.data[4][5] = pallet[0];
//         input.data[4][6] = pallet[0];
//         input.data[4][7] = pallet[0];
//         input.data[4][8] = pallet[0];
//         input.data[4][9] = pallet[0];
//         input.data[4][10] = pallet[0];
//         input.data[4][11] = pallet[0];
//         input.data[4][12] = pallet[0];
//         input.data[4][13] = pallet[0];
//         input.data[4][14] = pallet[0];
//         input.data[4][15] = pallet[0];
//         input.data[4][16] = pallet[0];
//         input.data[4][17] = pallet[0];
//         input.data[4][18] = pallet[0];
//         input.data[4][19] = pallet[0];
//         input.data[4][20] = pallet[0];
//         input.data[4][21] = pallet[0];
//         input.data[4][22] = pallet[0];
//         input.data[4][23] = pallet[0];
//         input.data[4][24] = pallet[0];
//         input.data[4][25] = pallet[0];
//         input.data[4][26] = pallet[0];
//         input.data[4][27] = pallet[0];
//         input.data[4][28] = pallet[0];
//         input.data[4][29] = pallet[0];
//         input.data[5][4] = pallet[1];
//         input.data[5][5] = pallet[1];
//         input.data[5][6] = pallet[1];
//         input.data[5][7] = pallet[1];
//         input.data[5][8] = pallet[1];
//         input.data[5][9] = pallet[1];
//         input.data[5][10] = pallet[1];
//         input.data[5][11] = pallet[1];
//         input.data[5][12] = pallet[1];
//         input.data[5][13] = pallet[1];
//         input.data[5][14] = pallet[1];
//         input.data[5][15] = pallet[1];
//         input.data[5][16] = pallet[1];
//         input.data[5][17] = pallet[1];
//         input.data[5][18] = pallet[1];
//         input.data[5][19] = pallet[1];
//         input.data[5][20] = pallet[1];
//         input.data[5][21] = pallet[1];
//         input.data[5][22] = pallet[1];
//         input.data[5][23] = pallet[1];
//         input.data[5][24] = pallet[1];
//         input.data[5][25] = pallet[1];
//         input.data[5][26] = pallet[1];
//         input.data[5][27] = pallet[1];
//         input.data[5][28] = pallet[1];
//         input.data[5][29] = pallet[1];
//         input.data[6][4] = pallet[0];
//         input.data[6][5] = pallet[0];
//         input.data[6][6] = pallet[0];
//         input.data[6][7] = pallet[0];
//         input.data[6][8] = pallet[0];
//         input.data[6][9] = pallet[0];
//         input.data[6][10] = pallet[0];
//         input.data[6][11] = pallet[0];
//         input.data[6][12] = pallet[0];
//         input.data[6][13] = pallet[0];
//         input.data[6][14] = pallet[0];
//         input.data[6][15] = pallet[0];
//         input.data[6][16] = pallet[0];
//         input.data[6][17] = pallet[0];
//         input.data[6][18] = pallet[0];
//         input.data[6][19] = pallet[0];
//         input.data[6][20] = pallet[0];
//         input.data[6][21] = pallet[0];
//         input.data[6][22] = pallet[0];
//         input.data[6][23] = pallet[0];
//         input.data[6][24] = pallet[0];
//         input.data[6][25] = pallet[0];
//         input.data[6][26] = pallet[0];
//         input.data[6][27] = pallet[0];
//         input.data[6][28] = pallet[0];
//         input.data[6][29] = pallet[0];
//         input.data[7][4] = pallet[1];
//         input.data[7][5] = pallet[1];
//         input.data[7][6] = pallet[1];
//         input.data[7][7] = pallet[1];
//         input.data[7][8] = pallet[1];
//         input.data[7][9] = pallet[1];
//         input.data[7][10] = pallet[1];
//         input.data[7][11] = pallet[1];
//         input.data[7][12] = pallet[1];
//         input.data[7][13] = pallet[1];
//         input.data[7][14] = pallet[1];
//         input.data[7][15] = pallet[1];
//         input.data[7][16] = pallet[1];
//         input.data[7][17] = pallet[1];
//         input.data[7][18] = pallet[1];
//         input.data[7][19] = pallet[1];
//         input.data[7][20] = pallet[1];
//         input.data[7][21] = pallet[1];
//         input.data[7][22] = pallet[1];
//         input.data[7][23] = pallet[1];
//         input.data[7][24] = pallet[1];
//         input.data[7][25] = pallet[1];
//         input.data[7][26] = pallet[1];
//         input.data[7][27] = pallet[1];
//         input.data[7][28] = pallet[1];
//         input.data[7][29] = pallet[1];
//         input.data[8][4] = pallet[0];
//         input.data[8][5] = pallet[0];
//         input.data[8][6] = pallet[0];
//         input.data[8][7] = pallet[0];
//         input.data[8][8] = pallet[0];
//         input.data[8][9] = pallet[0];
//         input.data[8][10] = pallet[0];
//         input.data[8][11] = pallet[0];
//         input.data[8][12] = pallet[0];
//         input.data[8][13] = pallet[0];
//         input.data[8][14] = pallet[0];
//         input.data[8][15] = pallet[0];
//         input.data[8][16] = pallet[0];
//         input.data[8][17] = pallet[0];
//         input.data[8][18] = pallet[0];
//         input.data[8][19] = pallet[0];
//         input.data[8][20] = pallet[0];
//         input.data[8][21] = pallet[0];
//         input.data[8][22] = pallet[0];
//         input.data[8][23] = pallet[0];
//         input.data[8][24] = pallet[0];
//         input.data[8][25] = pallet[0];
//         input.data[8][26] = pallet[0];
//         input.data[8][27] = pallet[0];
//         input.data[8][28] = pallet[0];
//         input.data[8][29] = pallet[0];
//         input.data[9][4] = pallet[1];
//         input.data[9][5] = pallet[1];
//         input.data[9][6] = pallet[1];
//         input.data[9][7] = pallet[1];
//         input.data[9][8] = pallet[1];
//         input.data[9][9] = pallet[1];
//         input.data[9][10] = pallet[1];
//         input.data[9][11] = pallet[1];
//         input.data[9][12] = pallet[1];
//         input.data[9][13] = pallet[1];
//         input.data[9][14] = pallet[1];
//         input.data[9][15] = pallet[1];
//         input.data[9][16] = pallet[1];
//         input.data[9][17] = pallet[1];
//         input.data[9][18] = pallet[1];
//         input.data[9][19] = pallet[1];
//         input.data[9][20] = pallet[1];
//         input.data[9][21] = pallet[1];
//         input.data[9][22] = pallet[1];
//         input.data[9][23] = pallet[1];
//         input.data[9][24] = pallet[1];
//         input.data[9][25] = pallet[1];
//         input.data[9][26] = pallet[1];
//         input.data[9][27] = pallet[1];
//         input.data[9][28] = pallet[1];
//         input.data[9][29] = pallet[1];
//         input.data[10][4] = pallet[0];
//         input.data[10][5] = pallet[0];
//         input.data[10][6] = pallet[0];
//         input.data[10][7] = pallet[0];
//         input.data[10][8] = pallet[0];
//         input.data[10][9] = pallet[0];
//         input.data[10][10] = pallet[0];
//         input.data[10][11] = pallet[0];
//         input.data[10][12] = pallet[0];
//         input.data[10][13] = pallet[0];
//         input.data[10][14] = pallet[0];
//         input.data[10][15] = pallet[0];
//         input.data[10][16] = pallet[0];
//         input.data[10][17] = pallet[0];
//         input.data[10][18] = pallet[0];
//         input.data[10][19] = pallet[0];
//         input.data[10][20] = pallet[0];
//         input.data[10][21] = pallet[0];
//         input.data[10][22] = pallet[0];
//         input.data[10][23] = pallet[0];
//         input.data[10][24] = pallet[0];
//         input.data[10][25] = pallet[0];
//         input.data[10][26] = pallet[0];
//         input.data[10][27] = pallet[0];
//         input.data[10][28] = pallet[0];
//         input.data[10][29] = pallet[0];
//         input.data[11][4] = pallet[1];
//         input.data[11][5] = pallet[1];
//         input.data[11][6] = pallet[1];
//         input.data[11][7] = pallet[1];
//         input.data[11][8] = pallet[1];
//         input.data[11][9] = pallet[1];
//         input.data[11][10] = pallet[1];
//         input.data[11][11] = pallet[1];
//         input.data[11][12] = pallet[1];
//         input.data[11][13] = pallet[1];
//         input.data[11][14] = pallet[1];
//         input.data[11][15] = pallet[1];
//         input.data[11][16] = pallet[1];
//         input.data[11][17] = pallet[1];
//         input.data[11][18] = pallet[1];
//         input.data[11][19] = pallet[1];
//         input.data[11][20] = pallet[1];
//         input.data[11][21] = pallet[1];
//         input.data[11][22] = pallet[1];
//         input.data[11][23] = pallet[1];
//         input.data[11][24] = pallet[1];
//         input.data[11][25] = pallet[1];
//         input.data[11][26] = pallet[1];
//         input.data[11][27] = pallet[1];
//         input.data[11][28] = pallet[1];
//         input.data[11][29] = pallet[1];
//         input.data[12][4] = pallet[0];
//         input.data[12][5] = pallet[0];
//         input.data[12][6] = pallet[0];
//         input.data[12][7] = pallet[0];
//         input.data[12][8] = pallet[0];
//         input.data[12][9] = pallet[0];
//         input.data[12][10] = pallet[0];
//         input.data[12][11] = pallet[0];
//         input.data[12][12] = pallet[0];
//         input.data[12][13] = pallet[0];
//         input.data[12][14] = pallet[0];
//         input.data[12][15] = pallet[0];
//         input.data[12][16] = pallet[0];
//         input.data[12][17] = pallet[0];
//         input.data[12][18] = pallet[0];
//         input.data[12][19] = pallet[0];
//         input.data[12][20] = pallet[0];
//         input.data[12][21] = pallet[0];
//         input.data[12][22] = pallet[0];
//         input.data[12][23] = pallet[0];
//         input.data[12][24] = pallet[0];
//         input.data[12][25] = pallet[0];
//         input.data[12][26] = pallet[0];
//         input.data[12][27] = pallet[0];
//         input.data[12][28] = pallet[0];
//         input.data[12][29] = pallet[0];
//         input.data[13][4] = pallet[1];
//         input.data[13][5] = pallet[1];
//         input.data[13][6] = pallet[1];
//         input.data[13][7] = pallet[1];
//         input.data[13][8] = pallet[1];
//         input.data[13][9] = pallet[1];
//         input.data[13][10] = pallet[1];
//         input.data[13][11] = pallet[1];
//         input.data[13][12] = pallet[1];
//         input.data[13][13] = pallet[1];
//         input.data[13][14] = pallet[1];
//         input.data[13][15] = pallet[1];
//         input.data[13][16] = pallet[1];
//         input.data[13][17] = pallet[1];
//         input.data[13][18] = pallet[1];
//         input.data[13][19] = pallet[1];
//         input.data[13][20] = pallet[1];
//         input.data[13][21] = pallet[1];
//         input.data[13][22] = pallet[1];
//         input.data[13][23] = pallet[1];
//         input.data[13][24] = pallet[1];
//         input.data[13][25] = pallet[1];
//         input.data[13][26] = pallet[1];
//         input.data[13][27] = pallet[1];
//         input.data[13][28] = pallet[1];
//         input.data[13][29] = pallet[1];
//         input.data[14][4] = pallet[0];
//         input.data[14][5] = pallet[0];
//         input.data[14][6] = pallet[0];
//         input.data[14][7] = pallet[0];
//         input.data[14][8] = pallet[0];
//         input.data[14][9] = pallet[0];
//         input.data[14][10] = pallet[0];
//         input.data[14][11] = pallet[0];
//         input.data[14][12] = pallet[0];
//         input.data[14][13] = pallet[0];
//         input.data[14][14] = pallet[0];
//         input.data[14][15] = pallet[0];
//         input.data[14][16] = pallet[0];
//         input.data[14][17] = pallet[0];
//         input.data[14][18] = pallet[0];
//         input.data[14][19] = pallet[0];
//         input.data[14][20] = pallet[0];
//         input.data[14][21] = pallet[0];
//         input.data[14][22] = pallet[0];
//         input.data[14][23] = pallet[0];
//         input.data[14][24] = pallet[0];
//         input.data[14][25] = pallet[0];
//         input.data[14][26] = pallet[0];
//         input.data[14][27] = pallet[0];
//         input.data[14][28] = pallet[0];
//         input.data[14][29] = pallet[0];
//         input.data[15][4] = pallet[1];
//         input.data[15][5] = pallet[1];
//         input.data[15][6] = pallet[1];
//         input.data[15][7] = pallet[1];
//         input.data[15][8] = pallet[1];
//         input.data[15][9] = pallet[1];
//         input.data[15][10] = pallet[1];
//         input.data[15][11] = pallet[1];
//         input.data[15][12] = pallet[1];
//         input.data[15][13] = pallet[1];
//         input.data[15][14] = pallet[1];
//         input.data[15][15] = pallet[1];
//         input.data[15][16] = pallet[1];
//         input.data[15][17] = pallet[1];
//         input.data[15][18] = pallet[1];
//         input.data[15][19] = pallet[1];
//         input.data[15][20] = pallet[1];
//         input.data[15][21] = pallet[1];
//         input.data[15][22] = pallet[1];
//         input.data[15][23] = pallet[1];
//         input.data[15][24] = pallet[1];
//         input.data[15][25] = pallet[1];
//         input.data[15][26] = pallet[1];
//         input.data[15][27] = pallet[1];
//         input.data[15][28] = pallet[1];
//         input.data[15][29] = pallet[1];
//         input.data[16][4] = pallet[0];
//         input.data[16][5] = pallet[0];
//         input.data[16][6] = pallet[0];
//         input.data[16][7] = pallet[0];
//         input.data[16][8] = pallet[0];
//         input.data[16][9] = pallet[0];
//         input.data[16][10] = pallet[0];
//         input.data[16][11] = pallet[0];
//         input.data[16][12] = pallet[0];
//         input.data[16][13] = pallet[0];
//         input.data[16][14] = pallet[0];
//         input.data[16][15] = pallet[0];
//         input.data[16][16] = pallet[0];
//         input.data[16][17] = pallet[0];
//         input.data[16][18] = pallet[0];
//         input.data[16][19] = pallet[0];
//         input.data[16][20] = pallet[0];
//         input.data[16][21] = pallet[0];
//         input.data[16][22] = pallet[0];
//         input.data[16][23] = pallet[0];
//         input.data[16][24] = pallet[0];
//         input.data[16][25] = pallet[0];
//         input.data[16][26] = pallet[0];
//         input.data[16][27] = pallet[0];
//         input.data[16][28] = pallet[0];
//         input.data[16][29] = pallet[0];
//         input.data[17][4] = pallet[1];
//         input.data[17][5] = pallet[1];
//         input.data[17][6] = pallet[1];
//         input.data[17][7] = pallet[1];
//         input.data[17][8] = pallet[1];
//         input.data[17][9] = pallet[1];
//         input.data[17][10] = pallet[1];
//         input.data[17][11] = pallet[1];
//         input.data[17][12] = pallet[1];
//         input.data[17][13] = pallet[1];
//         input.data[17][14] = pallet[1];
//         input.data[17][15] = pallet[1];
//         input.data[17][16] = pallet[1];
//         input.data[17][17] = pallet[1];
//         input.data[17][18] = pallet[1];
//         input.data[17][19] = pallet[1];
//         input.data[17][20] = pallet[1];
//         input.data[17][21] = pallet[1];
//         input.data[17][22] = pallet[1];
//         input.data[17][23] = pallet[1];
//         input.data[17][24] = pallet[1];
//         input.data[17][25] = pallet[1];
//         input.data[17][26] = pallet[1];
//         input.data[17][27] = pallet[1];
//         input.data[17][28] = pallet[1];
//         input.data[17][29] = pallet[1];
//         input.data[18][4] = pallet[0];
//         input.data[18][5] = pallet[0];
//         input.data[18][6] = pallet[0];
//         input.data[18][7] = pallet[0];
//         input.data[18][8] = pallet[0];
//         input.data[18][9] = pallet[0];
//         input.data[18][10] = pallet[0];
//         input.data[18][11] = pallet[0];
//         input.data[18][12] = pallet[0];
//         input.data[18][13] = pallet[0];
//         input.data[18][14] = pallet[0];
//         input.data[18][15] = pallet[0];
//         input.data[18][16] = pallet[0];
//         input.data[18][17] = pallet[0];
//         input.data[18][18] = pallet[0];
//         input.data[18][19] = pallet[0];
//         input.data[18][20] = pallet[0];
//         input.data[18][21] = pallet[0];
//         input.data[18][22] = pallet[0];
//         input.data[18][23] = pallet[0];
//         input.data[18][24] = pallet[0];
//         input.data[18][25] = pallet[0];
//         input.data[18][26] = pallet[0];
//         input.data[18][27] = pallet[0];
//         input.data[18][28] = pallet[0];
//         input.data[18][29] = pallet[0];
//         input.data[19][4] = pallet[1];
//         input.data[19][5] = pallet[1];
//         input.data[19][6] = pallet[1];
//         input.data[19][7] = pallet[1];
//         input.data[19][8] = pallet[1];
//         input.data[19][9] = pallet[1];
//         input.data[19][10] = pallet[1];
//         input.data[19][11] = pallet[1];
//         input.data[19][12] = pallet[1];
//         input.data[19][13] = pallet[1];
//         input.data[19][14] = pallet[1];
//         input.data[19][15] = pallet[1];
//         input.data[19][16] = pallet[1];
//         input.data[19][17] = pallet[1];
//         input.data[19][18] = pallet[1];
//         input.data[19][19] = pallet[1];
//         input.data[19][20] = pallet[1];
//         input.data[19][21] = pallet[1];
//         input.data[19][22] = pallet[1];
//         input.data[19][23] = pallet[1];
//         input.data[19][24] = pallet[1];
//         input.data[19][25] = pallet[1];
//         input.data[19][26] = pallet[1];
//         input.data[19][27] = pallet[1];
//         input.data[19][28] = pallet[1];
//         input.data[19][29] = pallet[1];
//         input.data[20][4] = pallet[0];
//         input.data[20][5] = pallet[0];
//         input.data[20][6] = pallet[0];
//         input.data[20][7] = pallet[0];
//         input.data[20][8] = pallet[0];
//         input.data[20][9] = pallet[0];
//         input.data[20][10] = pallet[0];
//         input.data[20][11] = pallet[0];
//         input.data[20][12] = pallet[0];
//         input.data[20][13] = pallet[0];
//         input.data[20][14] = pallet[0];
//         input.data[20][15] = pallet[0];
//         input.data[20][16] = pallet[0];
//         input.data[20][17] = pallet[0];
//         input.data[20][18] = pallet[0];
//         input.data[20][19] = pallet[0];
//         input.data[20][20] = pallet[0];
//         input.data[20][21] = pallet[0];
//         input.data[20][22] = pallet[0];
//         input.data[20][23] = pallet[0];
//         input.data[20][24] = pallet[0];
//         input.data[20][25] = pallet[0];
//         input.data[20][26] = pallet[0];
//         input.data[20][27] = pallet[0];
//         input.data[20][28] = pallet[0];
//         input.data[20][29] = pallet[0];
//         input.data[21][4] = pallet[1];
//         input.data[21][5] = pallet[1];
//         input.data[21][6] = pallet[1];
//         input.data[21][7] = pallet[1];
//         input.data[21][8] = pallet[1];
//         input.data[21][9] = pallet[1];
//         input.data[21][10] = pallet[1];
//         input.data[21][11] = pallet[1];
//         input.data[21][12] = pallet[1];
//         input.data[21][13] = pallet[1];
//         input.data[21][14] = pallet[1];
//         input.data[21][15] = pallet[1];
//         input.data[21][16] = pallet[1];
//         input.data[21][17] = pallet[1];
//         input.data[21][18] = pallet[1];
//         input.data[21][19] = pallet[1];
//         input.data[21][20] = pallet[1];
//         input.data[21][21] = pallet[1];
//         input.data[21][22] = pallet[1];
//         input.data[21][23] = pallet[1];
//         input.data[21][24] = pallet[1];
//         input.data[21][25] = pallet[1];
//         input.data[21][26] = pallet[1];
//         input.data[21][27] = pallet[1];
//         input.data[21][28] = pallet[1];
//         input.data[21][29] = pallet[1];

//         return input;
//     }

//     function tfizzle()
//         external
//         view
//         returns (
//             uint8,
//             uint8,
//             uint8,
//             uint8
//         )
//     {
//         IDotNugg.Matrix memory input = initialize();

//         (uint8 top, uint8 bot, IDotNugg.Coordinate memory center) = Anchor.getBox(input);

//         return (top, bot, center.a, center.b);
//     }

//     function tswizzle() external view returns (IDotNugg.Coordinate[] memory) {
//         IDotNugg.Matrix memory input = initialize();
//         IDotNugg.Coordinate[] memory anchors = Anchor.getAnchors(input);

//         for (uint8 i = 0; i < anchors.length; i++) {
//             console.log(i, anchors[i].a, anchors[i].b);
//         }

//         return anchors;
//     }

//     function initMix() internal view returns (IDotNugg.Mix memory) {
//         IDotNugg.Mix memory mix;
//         mix.matrix = initialize();
//         mix.version.width = 33;
//         mix.version.height = 33;
//         mix.version.calculatedReceivers = new IDotNugg.Coordinate[](4);
//         mix.version.calculatedReceivers[0].a = 1;
//         mix.version.calculatedReceivers[0].b = 1;
//         mix.version.calculatedReceivers[0].exists = true;
//         mix.version.calculatedReceivers[1].a = 2;
//         mix.version.calculatedReceivers[1].b = 2;
//         mix.version.calculatedReceivers[1].exists = true;
//         mix.version.calculatedReceivers[2].a = 3;
//         mix.version.calculatedReceivers[2].b = 1;
//         mix.version.calculatedReceivers[2].exists = true;

//         return mix;
//     }

//     function tbizzle() external view {
//         IDotNugg.Mix memory mix = initMix();

//         Anchor.convertReceiversToAnchors(mix);
//         for (uint8 i = 0; i < mix.receivers.length; i++) {
//             console.log(i, mix.receivers[i].coordinate.a, mix.receivers[i].coordinate.b);
//             console.log('r', mix.receivers[i].radii.r, 'l', mix.receivers[i].radii.l);
//             console.log('u', mix.receivers[i].radii.u, 'd', mix.receivers[i].radii.d);
//         }
//     }
// }
