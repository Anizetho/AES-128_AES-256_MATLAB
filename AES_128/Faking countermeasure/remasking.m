function [state_out] = remasking(state_in,m_number_matrix)
size_state = size(state_in);
nb_states = size_state(1);
state_out = zeros(nb_states,16);

state_out = bitxor(state_in,m_number_matrix);
end

