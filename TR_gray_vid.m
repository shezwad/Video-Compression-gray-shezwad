function Comp_img1 = TR_gray_vid(Lu,m)

[pad_image1, L0, W0] = padding(Lu);
% pad_image1 = double(pad_image1);
[MB1 , L1, W1] = macroblock(pad_image1);
DCT_coef1 = DCT(MB1);
[Quantization1,Q_L] = quant(DCT_coef1,m,1);
[DC_mat1,first1] = DC_extraction(Quantization1);
Zig_out1 = zigzag(Quantization1);
[Run_out1] = Run_length(Zig_out1);
[T1,Prob1,Symbol1] = sym_prob(Run_out1);
[T4,Prob4,Symbol4] = sym_prob(DC_mat1);
[CODE_WORD1,CODEBOOK1] = HUFFMAN(Prob1,Symbol1);
[CODE_WORD4,CODEBOOK4] = HUFFMAN(Prob4,Symbol4);
text1 = '1.jpg';text4 = '4.jpg';
A1 = HUFFENCODE(Run_out1,CODEBOOK1,text1);
A4 = HUFFENCODE(DC_mat1,CODEBOOK4,text4);
DECODE1 = HUFFDECODE(text1,CODEBOOK1,Prob1);
DECODE4 = HUFFDECODE(text4,CODEBOOK4,Prob4);
I_Run_out1 = Inv_Run_length(DECODE1);
I_DC_mat1 = Inv_DC_extraction(DECODE4,first1);
I_Zig_out1 = Inv_zigzag(I_Run_out1,I_DC_mat1,L1,W1);
I_Quantization1 = Inv_quant(I_Zig_out1,m,1);
I_DCT_coef1 = Inv_DCT(I_Quantization1);
[Comp_img1] = Inv_padding_vid(I_DCT_coef1,L0,W0);

end