function varargout = TaskPlanningGUI(varargin)

%TASKPLANNINGGUI M-file for TaskPlanningGUI.fig
%      TASKPLANNINGGUI, by itself, creates a new TASKPLANNINGGUI or raises the existing
%      singleton*.
%
%      H = TASKPLANNINGGUI returns the handle to a new TASKPLANNINGGUI or the handle to
%      the existing singleton*.
%
%      TASKPLANNINGGUI('Property','Value',...) creates a new TASKPLANNINGGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TaskPlanningGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TASKPLANNINGGUI('CALLBACK') and TASKPLANNINGGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TASKPLANNINGGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TaskPlanningGUI

% Last Modified by GUIDE v2.5 02-Nov-2015 08:49:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TaskPlanningGUI_OpeningFcn, ...
    'gui_OutputFcn',  @TaskPlanningGUI_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before TaskPlanningGUI is made visible.
function TaskPlanningGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global windowWidth xPos yPos robotSize robotXCenter robotYCenter blobColor BoardMapData VideoFeedData Phi
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
windowWidth = 1000; %windowWidth is the number of location points to keep
robotSize = 0.1651*300; %This is an actual-size robot, in meters

xPos = linspace(0, 0, windowWidth*3);
yPos = linspace(0, 0, windowWidth*3);
xPos(windowWidth*3) = 1920;
yPos(windowWidth*3) = 1350;
Phi = -90;

robotXCenter = xPos(windowWidth*3);
robotYCenter = yPos(windowWidth*3);
blobColor = 'green';

%Obtain the Data for the BoardMap
BoardScale = imread('BoardScale1-20.jpg');
BoardMapData = BoardScale;

%Select the plot on the left
axes(handles.BoardMap);

%Plot the Robot Trajectory and the Robot on the BoardMap
hold on
imshow(BoardMapData);
plot(xPos, yPos, '.');
robotBlob = patch([robotXCenter-robotSize robotXCenter-robotSize ...
    robotXCenter robotXCenter+robotSize robotXCenter+robotSize], ...
    [robotYCenter-robotSize robotYCenter+robotSize robotYCenter+ ...
    1.5*robotSize robotYCenter+robotSize robotYCenter-robotSize], blobColor);
rotate(robotBlob, [0,0,1], Phi - 90, [robotXCenter,robotYCenter, 0]);
hold off

%View the scene from the Kinect
% %initialize the color and depth video streams from the kinect
 colorVid = videoinput('kinect', 1, 'RGB_640x480');
% depthVid = imaq.VideoDevice('kinect', 2, 'Depth_640x480');
% 
 %colorVid = videoinput('winvideo',1, 'YUY2_320x240');
set(colorVid, 'FramesPerTrigger', Inf);
% set(depthVid, 'FramesPerTrigger', Inf);
set(colorVid, 'ReturnedColorspace', 'rgb');
% set(depthVid, 'ReturnedColorspace', 'gray');
colorVid.FrameGrabInterval = 1;  % distance between captured frames 
% depthVid.FrameGrabInterval = 1;
start(colorVid);
%start(depthVid);

% Choose default command line output for TaskPlanningGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TaskPlanningGUI wait for user response (see UIRESUME)
% uiwait(handles.GUIBackGround);

while(1)
if(task ==0)
    VideoFeedData = 0 ; 
end
end


% --- Outputs from this function are returned to the command line.
function varargout = TaskPlanningGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = hObject;



% --- Executes on button press in AutomaticMode.
function AutomaticMode_Callback(hObject, eventdata, handles)
global task prevTask
% hObject    handle to AutomaticMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
task = prevTask;

% --- Executes on button press in ManualMode.
function ManualMode_Callback(hObject, eventdata, handles)
global task
% hObject    handle to ManualMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
task = 0;


% --- Executes on selection change in SubTask.
function SubTask_Callback(hObject, eventdata, handles)
% hObject    handle to SubTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SubTask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SubTask


% --- Executes during object creation, after setting all properties.
function SubTask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Task.
function Task_Callback(hObject, eventdata, handles)
% hObject    handle to Task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Task contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Task


% --- Executes during object creation, after setting all properties.
function Task_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Task (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on GUIBackGround or any of its controls.
function GUIBackGround_WindowKeyPressFcn(hObject, eventdata, handles)
global windowWidth xPos yPos robotSize robotXCenter robotYCenter blobColor BoardMapData Phi
% hObject    handle to GUIBackGround (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case'uparrow'
            xPos(1) = [];
            yPos(1) = [];
        xPos = [xPos  xPos(length(xPos))+20*cos(Phi*pi/180)];
        yPos = [yPos  yPos(length(yPos))+20*sin(Phi*pi/180)];
    case'downarrow'
                    xPos(1) = [];
            yPos(1) = [];
        xPos = [xPos  xPos(length(xPos))-20*cos(Phi*pi/180)];
        yPos = [yPos  yPos(length(yPos))-20*sin(Phi*pi/180)];
    case 'leftarrow'
        Phi = Phi - 5;
    case 'rightarrow'
        Phi = Phi + 5;
end
robotXCenter = xPos(windowWidth*3);
robotYCenter = yPos(windowWidth*3);

%Refresh the plot of the Board Map
cla(handles.BoardMap);
axes(handles.BoardMap);
hold on
imshow(BoardMapData);
plot(xPos, yPos, '.');
robotBlob = patch([robotXCenter-robotSize robotXCenter-robotSize ...
    robotXCenter robotXCenter+robotSize robotXCenter+robotSize], ...
    [robotYCenter-robotSize robotYCenter+robotSize robotYCenter+ ...
    1.5*robotSize robotYCenter+robotSize robotYCenter-robotSize], blobColor);
rotate(robotBlob, [0,0,1], Phi - 90, [robotXCenter,robotYCenter, 0]);
hold off        
%update handles data structure
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function BoardMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoardMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate BoardMap


% --- Executes during object creation, after setting all properties.
function VideoFeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoFeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate VideoFeed






