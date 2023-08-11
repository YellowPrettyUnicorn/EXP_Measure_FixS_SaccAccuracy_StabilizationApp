%Rewritten program for HPB
close;
%clear all;
clc;

disp('IMAGING SIMULATOR by Kees Kroep');
%Initialize and process given values and parameters

S_Resolution = 1E-3; %distance between voxels
S_Start = [0,0,0]; % the s  tartlocation of the sourcespace
S_Directions = [32,32,32];
%V_Slices = [1,3,5,7]; % four slices out of the measured data
%frequency = 50000; % hz, we currenlt0y only use one frequency
frequency = [10000, 60000, 100000];
new_Source_3D = zeros(S_Directions(1),S_Directions(2),S_Directions(3));

c = 320; %speed of sound 

%Initialize position of receivers transmitters and the source space
[ Receiver_locs, Transmitter_locs] = Transducer_Init(S_Resolution);
fprintf('\tTransducer_Init DONE\n\n');

if(~exist('old_S_Directions'))
    old_S_Directions=0;
end
if(~exist('old_Receiver_locs'))
    old_Receiver_locs=0;
end
if(~exist('old_frequency'))
    old_frequency=[0,0,0];
end

i=1;
for frequency_tmp = frequency
    
fprintf('NEW LOOP Frequency = %d KHz\n\n',frequency_tmp/1000);
%disp(old_S_Directions == S_Directions AND old_Receiver_locs == Receiver_locs AND old_frequency2(i) == frequency2(i));
if(isequal(old_S_Directions,S_Directions) && isequal(old_Receiver_locs,Receiver_locs) && old_frequency(i) == frequency(i))
    fprintf('\tA_Matrix from Workspace \tDONE\tSPEED-UP!\n');
    tic;
else

fprintf('\tcalculate_A \t\tSTARTED');
tic;
%Calculate the A_matrix. This matrix is used for both the forward and
%inverse calculations.
[ A_Matrix{i} ] = calculate_A( Receiver_locs, S_Directions, S_Resolution, S_Start, c, frequency_tmp);

fprintf('\tDONE\t');
fprintf('%f seconds\n', toc);
end

%Next up, the Source needs to be filled with data.
[ Source ] = Fill_Source( S_Directions, Transmitter_locs);
fprintf('\tFill_Source \t\tSTARTED\tDONE\n');



fprintf('\tForward Function \tSTARTED');
%Calculate the input of the receivers with a forward function
Data = A_Matrix{i}*Source;

fprintf('\tDONE\n');

fprintf('\tInverse Function \tSTARTED');
%recalculate the source with use of the inverse function
%the inverse of the forward function uses a hermitian operator
new_Source = A_Matrix{i}'*Data;

fprintf('\tDONE\n');

fprintf('\tVisualization \t\tSTARTED');
%Visualize the calculated data


for x=1:S_Directions(1)
    for y=1:S_Directions(2)
        for z=1:S_Directions(3)
            new_Source_3D(x,y,z) = new_Source_3D(x,y,z) + new_Source(T3Dto1D(x, y, z, S_Directions(1),S_Directions(2)));
        end
    end
end

fprintf('\tDONE\t')
fprintf('%f seconds\n\n', toc);
%Here ends the frequency loop
i=i+1;
end


%Weghalen van nutteloze variabelen uit de workspace voor een cleanere
%representatie
varlist1 = {'x','y','z', 'varlist1'};
clear(varlist1{:}); 
varlist2 = {'S_Resolution', 'frequency_tmp', 'c', 'S_Start', 'varlist2', 'i', ...
                           'new_Source', 'old_Receiver_locs', 'old_S_Directions', 'old_frequency', 'transmitter_string'};
clear(varlist2{:});

disp('TODOLIST:');

fprintf('-\treceivers op een bol gooien\n');
fprintf('-\truis op data (experiementeren)\n');
fprintf('-\textra snelheidswinst?\n');



whos; %View workspace

%Make a cell-array of strings used for the GUI
for i=1:size(Transmitter_locs,1)
transmitter_string{i} = strcat('[',num2str(Transmitter_locs(i,1)), ',', num2str(Transmitter_locs(i,2)), ',', num2str(Transmitter_locs(i,3)),']');
end




%store old settings for possible SPEED-UP
old_S_Directions = S_Directions;
old_Receiver_locs = Receiver_locs;
old_frequency = frequency;

%Launch GUI
Imaging_GUI(real(new_Source_3D), S_Directions, transmitter_string);
