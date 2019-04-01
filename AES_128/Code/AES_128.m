%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  AES-128                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;
clc ;

%% Simulate AES-128
%Test
plaintextHex = ["00";"11";"22";"33";"44";"55";"66";"77";"88";"99";"aa";"bb";"cc";"dd";"ee";"ff"];
plaintext = hex2dec(plaintextHex');
[nb_traces, nb_bytes]=size(plaintext);


% Key scheduling
% Test
keyHex  = ["00";"01";"02";"03";"04";"05";"06";"07";"08";"09";"0a";"0b";"0c";"0d";"0e";"0f"];
key = hex2dec(keyHex);
round_key_256 = zeros(11,16);
round_key_256(1,:) = key;
for i = 1:10
    round_key_256(i+1,:) = key_schedule(round_key_256(i,:),i);
end


% Init Round
XOR = bitxor(plaintext, key');


% 9 rounds for AES-128
for r=1:9
    SboxResult = sbox(XOR);
    ShiftRowsResult = shiftrows(SboxResult');
    MixColumnResult = mixcolumns(ShiftRowsResult);
    NewKey = round_key_256(r+1,:);
    XOR = bitxor(MixColumnResult,NewKey);
    A = dec2hex(XOR);
end

% Finish Round
SboxResult = sbox(XOR);
ShiftRowsResult = shiftrows(SboxResult');
NewKey = round_key_256(11,:);
XOR = bitxor(ShiftRowsResult,NewKey);
Ciphertext = XOR;
CiphertextHex = dec2hex(Ciphertext);

