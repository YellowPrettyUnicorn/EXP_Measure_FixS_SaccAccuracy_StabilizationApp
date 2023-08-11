function [ Source ] = Fill_Source( S_dimensions, Transmitter_locs)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Source=zeros(S_dimensions(1)*S_dimensions(2)*S_dimensions(3),1); %Just a point source for starters


for n = 1:size(Transmitter_locs,1)
    Source(T3Dto1D(Transmitter_locs(n,1),Transmitter_locs(n,2),Transmitter_locs(n,3), S_dimensions(1),S_dimensions(2)))=1;
end

end

