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
keyHexReal  = ["00";"01";"02";"03";"04";"05";"06";"07";"08";"09";"0a";"0b";"0c";"0d";"0e";"0f"];
keyDecReal = hex2dec(keyHexReal);
keyDecMask = [2; 4; 6; 8; 10; 12; 14; 16; 18; 20; 22; 24; 26; 28; 30; 32];
keyDecFake = bitxor(keyDecReal, keyDecMask);
% Fake key 
round_key_256_fake = zeros(11,16);
round_key_256_fake(1,:) = keyDecFake;
for i = 1:10
    round_key_256_fake(i+1,:) = key_schedule(round_key_256_fake(i,:),i);
end
% Real key 
round_key_256_Real = zeros(11,16);
round_key_256_Real(1,:) = keyDecReal;
for i = 1:10
    round_key_256_Real(i+1,:) = key_schedule(round_key_256_Real(i,:),i);
end

%% Init Round
% aF and aR
aF = shiftrows(bitxor(plaintextDec,round_key_256_fake(1,:)));
aR = shiftrows(bitxor(plaintextDec,round_key_256_Real(1,:)));

%% 9 rounds for AES-128
for r=1:9
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
    
    % Sbox True Key
    SboxTrueKey = bitxor(SboxTrans,SboxResult);
    SboxTrueKeyVerifie = SboxResultTrue;
    
    % Remasking
    remasking = bitxor(MixColumnResult,MixColumnResultTrans);
    
    % Key modifie
    NewkeyFake = round_key_256_fake(r+1,:);
    NewkeyReal = round_key_256_Real(r+1,:);

    % XOR
    XOR = bitxor(remasking, NewkeyFake);
    TrueXor = bitxor(MixColumnResultTrue, NewkeyReal);
    
    % aF and aR
    aF = shiftrows(XOR);
    aR = shiftrows(TrueXor);
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
NewkeyFake = round_key_256_fake(11,:);
NewkeyReal = round_key_256_Real(11,:);

Intermediate1Fake = bitxor(SboxResult,NewkeyReal');
Intermediate2Fake = bitxor(Intermediate1Fake,SboxTrans);
Ciphertext = Intermediate2Fake;
CiphertextHex = dec2hex(Ciphertext);

Intermediate1Real = bitxor(SboxResultTrue,NewkeyReal');
Chiffre = Intermediate1Real;
ChiffreHex = dec2hex(Chiffre);
