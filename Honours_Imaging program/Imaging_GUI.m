function varargout = Imaging_GUI(varargin)
% IMAGING_GUI MATLAB code for Imaging_GUI.fig
%      IMAGING_GUI, by itself, creates a new IMAGING_GUI or raises the existing
%      singleton*.
%
%      H = IMAGING_GUI returns the handle to a new IMAGING_GUI or the handle to
%      the existing singleton*.
%
%      IMAGING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGING_GUI.M with the given input arguments.
%
%      IMAGING_GUI('Property','Value',...) creates a new IMAGING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Imaging_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Imaging_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Imaging_GUI

% Last Modified by GUIDE v2.5 11-Feb-2015 14:27:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Imaging_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Imaging_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Imaging_GUI is made visible.
function Imaging_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Imaging_GUI (see VARARGIN)

axes(handles.ScatterPlot);
[Receiver_locs, Transmitter_locs] = Transducer_Init(1E-3);
scatter3(Receiver_locs(:,1),Receiver_locs(:,2),Receiver_locs(:,3))
hold on
scatter3(Transmitter_locs(:,1),Transmitter_locs(:,2),Transmitter_locs(:,3),'filled')
hold off
rotate3d on;
axes(handles.US_scan);
setAllowAxesRotate(rotate3d,handles.US_scan,false);


handles.Data = varargin{1}.*abs(varargin{1});
handles.S_Directions = varargin{2}; 
imagesc(real(handles.Data(:,:,1)));
colormap(gray);

set(gca,'YDir','normal');


handles.rangemax = max(handles.Data(handles.Data>0));
handles.rangemin = min(handles.Data(handles.Data<0));

set(handles.text3, 'String', varargin{3});

caxis([handles.rangemin, handles.rangemax]);
% Choose default command line output for Imaging_GUI
handles.output = hObject;
handles.axis = 'Z';
handles.Depth = 0;
% Update handles structure


%plot the location of the transmitters and receivers



guidata(hObject, handles);

% UIWAIT makes Imaging_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Imaging_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes(handles.US_scan);
handles.Depth = get(hObject,'Value');
if(handles.axis=='Z')
    tmp = ceil(handles.Depth*(handles.S_Directions(3)-1)+1);
    imagesc(real(permute(handles.Data(:,:,tmp),[2,1,3])));
    set(handles.text2, 'String', num2str(tmp));
elseif(handles.axis=='Y')
    tmp = ceil(handles.Depth*(handles.S_Directions(2)-1)+1);
    imagesc(real(permute(handles.Data(:,tmp,:),[3,1,2])));
    set(handles.text2, 'String', num2str(tmp));
else
    tmp = ceil(handles.Depth*(handles.S_Directions(1)-1)+1);
    imagesc(real(permute(handles.Data(tmp,:,:),[3,2,1])));
    set(handles.text2, 'String', num2str(tmp));
end
caxis([handles.rangemin, handles.rangemax]);
setAllowAxesRotate(rotate3d,handles.US_scan,false);
set(gca,'YDir','normal');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.\
set(hObject,'Value',0);
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
%function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.axis=get(eventdata.NewValue, 'Tag');
%fprintf('Depth axis:   %s\n', handles.axis);
axes(handles.US_scan);
if(handles.axis=='Z')
    tmp = ceil(handles.Depth*(handles.S_Directions(3)-1)+1);
    imagesc(real(permute(handles.Data(:,:,tmp),[2,1,3])));
    set(handles.text2, 'String', num2str(tmp));
    set(handles.text4, 'String', 'Y');
    set(handles.text5, 'String', 'X');
elseif(handles.axis=='Y')
    tmp = ceil(handles.Depth*(handles.S_Directions(2)-1)+1);
    imagesc(real(permute(handles.Data(:,tmp,:),[3,1,2])));
    set(handles.text2, 'String', num2str(tmp));
    set(handles.text4, 'String', 'Z');
    set(handles.text5, 'String', 'X');
else
    tmp = ceil(handles.Depth*(handles.S_Directions(1)-1)+1);
    imagesc(real(permute(handles.Data(tmp,:,:),[3,2,1])));
    set(handles.text2, 'String', num2str(tmp));
    set(handles.text4, 'String', 'Z');
    set(handles.text5, 'String', 'Y');
end

caxis([handles.rangemin, handles.rangemax]);
setAllowAxesRotate(rotate3d,handles.US_scan,false);
set(gca,'YDir','normal');
guidata(hObject, handles);


function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2

% Hint: place code in OpeningFcn to populate axes2



% scatter3(Receiver_locs(:,1),Receiver_locs(:,2),Receiver_locs(:,3))
% hold on
% scatter3(Transmitter_locs(:,1),Transmitter_locs(:,2),Transmitter_locs(:,3),'filled')
% hold off


% --- Executes during object creation, after setting all properties.
