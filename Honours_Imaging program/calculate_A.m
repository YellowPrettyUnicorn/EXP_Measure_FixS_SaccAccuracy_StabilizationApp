function [ A_Matrix ] = calculate_A( Receiver_locs, S_Dimensions, S_Resolution, S_Start, c, frequency) 
%The A matrix is calculated here
%   The A matrix will be used to calculate 

%First A is initialized. A has a length of #receivers and a width of
%#source voxels
A_Matrix = complex(zeros(size(Receiver_locs, 1), S_Dimensions(1)*S_Dimensions(2)*S_Dimensions(3)),0);

%Then for every receiver an array of elements is calculated.
%note that A_matrix is 2D and source 3D. To improve
%performance, the voxels in source are mapped to a 1D space.
for M=1:size(Receiver_locs, 1)
    for pos=1:S_Dimensions(1)*S_Dimensions(2)*S_Dimensions(3);
        %for every receiver, for every voxel calculate A
        %first calculate the distance between voxel and receiver
        
        
        %In this section 1D to 3D is calculated. It is quicker to not do
        %this in a separate function
        current3D = zeros(1,3);
        current3D(3) = floor(pos/(S_Dimensions(1)*S_Dimensions(2)));
        tmp = mod(pos,(S_Dimensions(1)*S_Dimensions(2)));
        current3D(2) = floor(tmp/(S_Dimensions(1)));
        current3D(1) = mod(tmp,(S_Dimensions(1)));

        
        dist = distance(Receiver_locs(M,:),(S_Start+current3D))*S_Resolution;
            
        %then map the voxel to the correct 1D counterpart

        %then calculate the entire formula
        %disp(-2*1i*pi*frequency*dist/c);
        A_Matrix(M,pos) = exp(-2*1i*pi*frequency*dist/c)/(4*pi*dist);
    end
end


end

% for M=1:size(Receiver_locs, 1)
%     for x=1:S_Dimensions(1);
%         for y=1:S_Dimensions(2);
%             for z=1:S_Dimensions(3);
%                 %for every receiver, for every voxel calculate A
%                 %first calculate the distance between voxel and receiver
%                 dist = pdist([Receiver_locs(M,:);(S_Start+[x,y,z])])*S_Resolution;
%                 
%                 %then map the voxel to the correct 1D counterpart
%                 current = T3Dto1D(x,y,z,S_Dimensions(1),S_Dimensions(2));
%                 
%                 %then calculate the entire formula
%                 %disp(-2*1i*pi*frequency*dist/c);
%                 A_Matrix(M,current) = exp(-2*1i*pi*frequency*dist/c)/(4*pi*dist);
%             end
%         end
%     end
% end