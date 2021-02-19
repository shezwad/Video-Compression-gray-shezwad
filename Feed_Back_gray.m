function [Comp_img1] = Feed_Back_gray(Lu,m)

[pad_image1, L0, W0] = padding(Lu);
[MB1 , L1, W1] = macroblock(pad_image1);
DCT_coef1 = DCT(MB1);
[Quantization1,Q_L] = quant(DCT_coef1,m,1);
I_Quantization1 = Inv_quant(Quantization1,m,1);
I_DCT_coef1 = Inv_DCT(I_Quantization1);
[Comp_img1] = Inv_padding(I_DCT_coef1,L0,W0);

end