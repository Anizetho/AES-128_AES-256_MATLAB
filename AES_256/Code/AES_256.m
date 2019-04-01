%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  AES-256                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;
clc ;

%% Simulate AES-256
%Test
plaintextHex = ["00";"11";"22";"33";"44";"55";"66";"77";"88";"99";"aa";"bb";"cc";"dd";"ee";"ff"];
plaintext = hex2dec(plaintextHex');
[nb_traces, nb_bytes]=size(plaintext);


% Key scheduling
% Test
keyHex  = ["00";"01";"02";"03";"04";"05";"06";"07";"08";"09";"0a";"0b";"0c";"0d";"0e";"0f";"10";"11";"12";"13";"14";"15";"16";"17";"18";"19";"1a";"1b";"1c";"1d";"1e";"1f"];
key = hex2dec(keyHex);
round_key_256 = zeros(8,32);
round_key_256(1,:) = key;
for i = 1:7
    round_key_256(i+1,:) = key_schedule(round_key_256(i,:),i);
end


% Init Round
% For test
XOR = bitxor(plaintext, key(1:16)');

% 13 rounds for AES-256
for r=1:7
    if r==1
        SboxResult = sbox(XOR);
        ShiftRowsResult = shiftrows(SboxResult');
        %test = conversion(ShiftRowsResult)
        MixColumnResult = mixcolumns(ShiftRowsResult);
        NewKey = round_key_256(r,(17:32));
        XOR = bitxor(MixColumnResult,NewKey);
    else
        for k=1:2
            SboxResult = sbox(XOR);
            ShiftRowsResult = shiftrows(SboxResult');
            MixColumnResult = mixcolumns(ShiftRowsResult);
            if k==1
                NewKey = round_key_256(r,(1:16));
            else
                NewKey = round_key_256(r,(17:32));
            end
            XOR = bitxor(MixColumnResult,NewKey);
        end
    end
end


% Finish Round
SboxResult = sbox(XOR);
ShiftRowsResult = shiftrows(SboxResult');
NewKey = round_key_256(8,(1:16));
XOR = bitxor(ShiftRowsResult,NewKey);
Ciphertext = XOR;
CiphertextHex = dec2hex(Ciphertext);

