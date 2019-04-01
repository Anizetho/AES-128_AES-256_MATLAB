% Cette fonction doit prendre deux décimaux en entrée (ShiftRowsResult, state)
% Elle retourne un décimal en sortie (out).
function [out] = sboxTrans(aF, aR) 
elem1 = sbox(aF);
elem2 = sbox(aR);
out = bitxor(elem1, elem2);

end

