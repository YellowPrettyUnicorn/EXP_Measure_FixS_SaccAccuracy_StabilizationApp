function [ Receiver_locs, Transmitter_locs] = Transducer_Init(S_Resolution)
% Initialization of values

%initial receiver locs
%Receiver_locs = [100,100,100;  100,100,-100;  100,-100,100;  100,-100,-100; ...
%                 -100,100,100; -100,100,-100; -100,-100,100; -100,-100,-100];

             
             
i=1;
for x=1:6:60
    for y=1:6:60
        Receiver_locs(i,:)=[x,y,-100];
        i=i+1;
    end
end
             
%point source
%Transmitter_locs = [25,11,12];

%multiple sources             
%Transmitter_locs = [25,11,12; 4,22,25; 13,15,14];

%line
Transmitter_locs = [20,20,5; 20,20,10; 20,20,15; 20,20,20; 20,20,25; 20,20,30];


end

