% state_in est une matrice de N ligneset 16 colonnes.
% Les N lignes représentent le nombre de traces.
% Les 16 colonnes représentent les 16 bytes.
function [state_out] = shiftrows(state_in)

size_state = size(state_in);
nb_states = size_state(1);
state_out = zeros(nb_states,16);

state_out(:,1) = state_in(:,1);
state_out(:,2) = state_in(:,6);
state_out(:,3) = state_in(:,11);
state_out(:,4) = state_in(:,16);

state_out(:,5) = state_in(:,5);
state_out(:,6) = state_in(:,10);
state_out(:,7) = state_in(:,15);
state_out(:,8) = state_in(:,4);

state_out(:,9) = state_in(:,9);
state_out(:,10) = state_in(:,14);
state_out(:,11) = state_in(:,3);
state_out(:,12) = state_in(:,8);

state_out(:,13) = state_in(:,13);
state_out(:,14) = state_in(:,2);
state_out(:,15) = state_in(:,7);
state_out(:,16) = state_in(:,12);
end

