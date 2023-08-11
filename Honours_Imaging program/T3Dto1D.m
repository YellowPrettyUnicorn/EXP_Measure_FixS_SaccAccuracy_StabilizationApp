function [ answer ] = T3Dto1D( x, y, z, Lx, Ly)
%map 3D voxel to 1D line

answer = (z-1)*Lx*Ly+(y-1)*Lx + x;

end

