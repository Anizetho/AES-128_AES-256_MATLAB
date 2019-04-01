%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  AES-128                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;
clc ;

%% Simulate AES-128
plaintextHex = ["00";"11";"22";"33";"44";"55";"66";"77";"88";"99";"aa";"bb";"cc";"dd";"ee";"ff"];
plaintextDec = hex2dec(plaintextHex');
[nb_traces, nb_bytes]=size(plaintextDec);

% Key scheduling
keyHexReal  = ["00";"01";"02";"03";"04";"05";"06";"07";"08";"09";"0a";"0b";"0c";"0d";"0e";"0f";"10";"11";"12";"13";"14";"15";"16";"17";"18";"19";"1a";"1b";"1c";"1d";"1e";"1f"];
keyDecReal = hex2dec(keyHexReal);
keyDecMask = [2; 4; 6; 8; 10; 12; 14; 16; 18; 20; 22; 24; 26; 28; 30; 32; 34; 36; 38; 40; 42; 44; 46; 48; 50; 52; 54; 56; 58; 60; 62; 64];
keyDecFake = bitxor(keyDecReal, keyDecMask);
% Fake key 
round_key_256_fake = zeros(8,32);
round_key_256_fake(1,:) = keyDecFake;
for i = 1:7
    round_key_256_fake(i+1,:) = key_schedule(round_key_256_fake(i,:),i);
end
% Real key 
round_key_256_Real = zeros(8,32);
round_key_256_Real(1,:) = keyDecReal;
for i = 1:7
    round_key_256_Real(i+1,:) = key_schedule(round_key_256_Real(i,:),i);
end

% Mask mh
maskA = randi([0 255],10,16);
maskB = mixcolumns(maskA);

%% Init Round
% aF and aR
aF = shiftrows(bitxor(plaintextDec,round_key_256_fake(1,(1:16))));
aR = shiftrows(bitxor(plaintextDec,round_key_256_Real(1,(1:16))));

%% 13 rounds for AES-128
for r=1:7
    if r==1
        ShiftRowsResult = aF;
        ShiftRowsResultTrue = aR;
        
        % Normal
        SboxResult = sbox(ShiftRowsResult);
        SboxResultTrue = sbox(ShiftRowsResultTrue);
        MixColumnResult = mixcolumns(SboxResult');
        MixColumnResultTrue = mixcolumns(SboxResultTrue');
        MixColumnResultTrueVerifie = conversion(MixColumnResultTrue);
        
        % Particular
        SboxTrans = sboxTrans(aF, aR);
        MixColumnResultTrans = mixcolumns(SboxTrans');
        
        % Remasking
        remasking = bitxor(MixColumnResult,MixColumnResultTrans);

        % Key modifie
        NewkeyFake = round_key_256_fake(r,(17:32));
        NewkeyFakeHex = conversion(NewkeyFake);
        NewkeyReal = round_key_256_Real(r,(17:32));
        NewkeyRealHex = conversion(NewkeyReal);

        % XOR
        XOR = bitxor(NewkeyFake,remasking);
        TrueXor = bitxor(MixColumnResultTrue, NewkeyReal);
        XorVerifie = conversion(XOR);
        TrueXorVerifie = conversion(TrueXor);

        % aF and aR
        aF = shiftrows(XOR);
        aR = shiftrows(TrueXor);
        
    else
        for k=1:2
            ShiftRowsResult = aF;
            ShiftRowsResultTrue = aR;
    
            % Normal
            SboxResult = sbox(ShiftRowsResult);
            SboxResultTrue = sbox(ShiftRowsResultTrue);
            MixColumnResult = mixcolumns(SboxResult');
            MixColumnResultTrue = mixcolumns(SboxResultTrue');
            MixColumnResultTrueVerifie = conversion(MixColumnResultTrue);

            % Particular
            SboxTrans = sboxTrans(aF, aR);
            MixColumnResultTrans = mixcolumns(SboxTrans');

            % Remasking
            remasking = bitxor(MixColumnResult,MixColumnResultTrans);
            
            if k==1
                NewkeyFake = round_key_256_fake(r,(1:16));
                NewkeyReal = round_key_256_Real(r,(1:16));
            else
                NewkeyFake = round_key_256_fake(r,(17:32));
                NewkeyReal = round_key_256_Real(r,(17:32));
            end
            NewkeyFakeHex = conversion(NewkeyFake);
            NewkeyRealHex = conversion(NewkeyReal);
            % XOR
            XOR = bitxor(NewkeyFake,remasking);
            TrueXor = bitxor(MixColumnResultTrue, NewkeyReal);
            TrueXorVerifie = conversion(TrueXor);

            % aF and aR
            aF = shiftrows(XOR);
            aR = shiftrows(TrueXor);
        end
    end
end


%% Finish Round
ShiftRowsResult = aF;
ShiftRowsResultTrue = aR;

% Normal
SboxResult = sbox(ShiftRowsResult);
SboxResultTrue = sbox(ShiftRowsResultTrue);

% Particular
SboxTrans = sboxTrans(aF, aR);

% Sbox True Key
SboxTrueKey = bitxor(SboxTrans,SboxResult);
SboxTrueKeyVerifie = SboxResultTrue;

% Finish : CipherText
NewkeyFake = round_key_256_fake(8,(1:16));
NewkeyReal = round_key_256_Real(8,(1:16));

Intermediate1Fake = bitxor(SboxResult,NewkeyReal');
Intermediate2Fake = bitxor(Intermediate1Fake,SboxTrans);
Ciphertext = Intermediate2Fake;
CiphertextHex = dec2hex(Ciphertext);

Intermediate1Real = bitxor(SboxResultTrue,NewkeyReal');
Chiffre = Intermediate1Real;
ChiffreHex = dec2hex(Chiffre);
