function [result] = key_schedule(round_key_256, round)

    rcon = [1, 2, 4, 8, 16, 32, 64, 128, 27, 54];
	w0 = round_key_256(1:4);
	w1 = round_key_256(5:8);
	w2 = round_key_256(9:12);
	w3 = round_key_256(13:16); 
    
    % 1ère nouvelle colonne : ligne par ligne (4)
    result(1) = bitxor(bitxor(sbox(w3(2)), w0(1)), rcon(round));
    result(2) = bitxor(sbox(w3(3)), w0(2));
    result(3) = bitxor(sbox(w3(4)), w0(3));
    result(4) = bitxor(sbox(w3(1)), w0(4));
    
    result(5:8)   = bitxor(result(1:4), w1);
    result(9:12)  = bitxor(result(5:8), w2);
    result(13:16) = bitxor(result(9:12), w3);

end



