function [result] = key_schedule(round_key_256, round)

    rcon = [1, 2, 4, 8, 16, 32, 64];
	w0 = round_key_256(1:4);
	w1 = round_key_256(5:8);
	w2 = round_key_256(9:12);
	w3 = round_key_256(13:16);
	w4 = round_key_256(17:20);
	w5 = round_key_256(21:24);
	w6 = round_key_256(25:28);
	w7 = round_key_256(29:32);  
    
    % 1ère nouvelle colonne : ligne par ligne (4)
    result(1) = bitxor(bitxor(sbox(w7(2)), w0(1)), rcon(round));
    result(2) = bitxor(sbox(w7(3)), w0(2));
    result(3) = bitxor(sbox(w7(4)), w0(3));
    result(4) = bitxor(sbox(w7(1)), w0(4));
    
    result(5:8)   = bitxor(result(1:4), w1);
    result(9:12)  = bitxor(result(5:8), w2);
    result(13:16) = bitxor(result(9:12), w3);

    result(17) = bitxor(sbox(result(13)), w4(1));
    result(18) = bitxor(sbox(result(14)), w4(2));
    result(19) = bitxor(sbox(result(15)), w4(3));
    result(20) = bitxor(sbox(result(16)), w4(4));

    result(21:24) = bitxor(result(17:20), w5);
    result(25:28) = bitxor(result(21:24), w6);
    result(29:32) = bitxor(result(25:28), w7);

end



