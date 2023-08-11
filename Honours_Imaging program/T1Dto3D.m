function [ answer ] = T1Dto3D( tmp, S_Dimensions )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

answer = zeros(1,3);

answer(3) = floor(tmp/(S_Dimensions(1)*S_Dimensions(2)));
tmp = mod(tmp,(S_Dimensions(1)*S_Dimensions(2)));

answer(2) = floor(tmp/(S_Dimensions(1)));
answer(1) = mod(tmp,(S_Dimensions(1)));



end

