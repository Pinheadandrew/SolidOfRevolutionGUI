function varargout = homescreen(varargin)
% HOMESCREEN MATLAB code for homescreen.fig
%      HOMESCREEN, by itself, creates a new HOMESCREEN or raises the existing
%      singleton*.
%
%      H = HOMESCREEN returns the handle to a new HOMESCREEN or the handle to
%      the existing singleton*.
%
%      HOMESCREEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOMESCREEN.M with the given input arguments.
%
%      HOMESCREEN('Property','Value',...) creates a new HOMESCREEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before homescreen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to homescreen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help homescreen

% Last Modified by GUIDE v2.5 24-Nov-2018 11:51:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @homescreen_OpeningFcn, ...
                   'gui_OutputFcn',  @homescreen_OutputFcn, ...
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


% --- Executes just before homescreen is made visible.
function homescreen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to homescreen (see VARARGIN)

% Choose default command line output for homescreen
handles.output = hObject;
AUCimage = imread('img/AUC.jpg');
set(handles.pushbutton1, 'CData', AUCimage);
VUCimage = imread('img/VSR.jpg');
set(handles.pushbutton2, 'CData', VUCimage);
% Update handles structure
% 
% axes(handles.someAxes);
% MSUimage = imread('img/MSU-Logo.png');
% set(handles.someAxes,'Units','pixels');
% resizePos = get(handles.someAxes,'Position');
% MSUimage= imresize(MSUimage, [resizePos(3) resizePos(3)]);
% imshow(MSUimage)
% set(handles.someAxes,'Units','normalized');
% uistack(handles.msu_logo, 'top');
% axes(handles.otherAxes);
% MSUimage = imread('img/MSU-Logo.png');
% imshow(MSUimage)

% set(handles.someAxes,'Visible','On')
% set(handles.otherAxes,'Visible','On')

% image(MSUimage)
guidata(hObject, handles);

% UIWAIT makes homescreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = homescreen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function AUCbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('AUC');

% --- Executes on button press in pushbutton2.
function VUCbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('VUC');

% --- Executes during object creation, after setting all properties.
function msu_logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msu_logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
msulogo = imread('img/MSU-Logo.png');
set(hObject, 'CData', msulogo);


% --- Executes on button press in vsr_tutorial.
function vsr_tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to vsr_tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ispc
    winopen('MATLAB WORKBOOK1.pdf')
else
    open('MATLAB WORKBOOK1.pdf')
end


% --- Executes on button press in auc_tutorial.
function auc_tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to auc_tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ispc
    winopen('MATLAB WORKBOOK1.pdf')
else
    open('MATLAB WORKBOOK1.pdf')
end
