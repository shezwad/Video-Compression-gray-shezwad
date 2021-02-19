x = VideoReader('sh.mp4');
m = 90;
mbSize = 8;
p = 7;

for i = 1:1:x.NumberOfFrames
    
%     i = 1;  
    a1 = read(x,i);
    b1 = read(x,i+1);
    a = rgb2gray(a1);
    b = rgb2gray(b1);
    [a, L0, W0] = padding(a);
    [b, L0, W0] = padding(b);
    a = double(a);
    b = double(b);
    
    if i == 1
    Result90(:,:,1) = TR_gray_vid(a,m);
    end
    
    [motionVect, EScomputations] = Motion_Est(b, a, mbSize, p);
    imgComp = motion_Pred(a, motionVect, mbSize);
    b = Feed_Back_gray(b,m);
    
    residual = double(imgComp) - double(b);
    
    MV = reshape(motionVect,[1,2*length(motionVect)]);
    
    [MB , L1, W1] = macroblock(residual);
    DCT_coef = DCT(MB);
    [Quantization,Q_L] = quant(DCT_coef,m,1);
    [DC_mat,first] = DC_extraction(Quantization);
     Zig_out = zigzag(Quantization);
    [Run_outa] = Run_length(DC_mat);
    [Run_outb] = Run_length(Zig_out);
    [Run_outc] = Run_length(MV);
    [Ta,Proba,Symbola] = sym_prob(Run_outa);
    [Tb,Probb,Symbolb] = sym_prob(Run_outb);
    [Tc,Probc,Symbolc] = sym_prob(Run_outc);
    [CODE_WORDa,CODEBOOKa] = HUFFMAN(Proba,Symbola);
    [CODE_WORDb,CODEBOOKb] = HUFFMAN(Probb,Symbolb);
    [CODE_WORDc,CODEBOOKc] = HUFFMAN(Probc,Symbolc);
    texta = 'res_dc.txt';textb = 'res_ac.txt';textc = 'mvtxt';
    Aa = HUFFENCODE(Run_outa,CODEBOOKa,texta);
    Ab = HUFFENCODE(Run_outb,CODEBOOKb,textb);
    Ac = HUFFENCODE(Run_outc,CODEBOOKc,textc);
    DECODEa = HUFFDECODE(texta,CODEBOOKa,Proba);
    DECODEb = HUFFDECODE(textb,CODEBOOKb,Probb);
    DECODEc = HUFFDECODE(textc,CODEBOOKc,Probc);
    I_Run_outa = Inv_Run_length(DECODEa);
    I_Run_outb = Inv_Run_length(DECODEb);
    I_Run_outc = Inv_Run_length(DECODEc);
    I_DC_mata = Inv_DC_extraction(I_Run_outa,first);
    I_Zig_out = Inv_zigzag(I_Run_outb,I_DC_mata,L1,W1);
    I_Quantization = Inv_quant(I_Zig_out,m,1);
    I_DCT_coef = Inv_DCT(I_Quantization);
    testing1 = Inv_padding_vid(I_DCT_coef,L0,W0);
    testing1 = floor(testing1);
    I_MV = reshape(I_Run_outc,[2,length(I_Run_outc)/2]);
   
    RE = Result90(:,:,i);
    B_Res = motion_Pred(RE, I_MV, mbSize);
    Result90(:,:,i+1) = B_Res - testing1;
    
end

  
    
  