function [ answer ] = distance( loc1, loc2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


answer = sqrt((loc1(1)-loc2(1))^2+(loc1(2)-loc2(2))^2+(loc1(3)-loc2(3))^2);

end

