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

% Last Modified by GUIDE v2.5 22-Dec-2018 14:40:15

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
% AUCimage = imread('img/AUC.jpg');
% set(handles.AUCpicture, 'CData', AUCimage);
% VUCimage = imread('img/VSR.jpg');
% set(handles.VUCpicture, 'CData', VUCimage);

% Resizing images
% VSRimage = imread('img/Homescreen_VSR.jpg');
% set(handles.VUCpicture,'Units','pixels');
% resizePos = get(handles.VUCpicture,'Position');
% VSRimage= imresize(VSRimage, [resizePos(4), resizePos(3)]);
% set(handles.VUCpicture, 'CData', VSRimage);

myImage = imread('img/Homescreen_AUC.jpg');
set(handles.AUCaxes,'Units','pixels');
resizePos = get(handles.AUCaxes,'Position');
myImage= imresize(myImage, [resizePos(4) resizePos(3)]);
axes(handles.AUCaxes);
imshow(myImage);
% set(handles.AUCaxes,'Units','normalized');

% AUCimage = imread('img/Homescreen_AUC.jpg');
% set(handles.AUCpicture,'Units','pixels');
% resizePos = get(handles.AUCpicture,'Position');
% AUCimage= imresize(AUCimage, [resizePos(4), resizePos(3)]);
% set(handles.AUCpicture, 'CData', AUCimage);

% myImage = imread('img/Homescreen_VSR.jpg');
% set(handles.VSRaxes,'Units','pixels');
% resizePos = get(handles.VSRaxes,'Position');
% myImage= imresize(myImage, [resizePos(4) resizePos(3)]);
% axes(handles.VSRaxes);
% imshow(myImage);
% set(handles.VSRaxes,'Units','normalized');

myImage = imread('img/Homescreen_VSR.jpg');
set(handles.VSRaxes,'Units','pixels');
resizePos = get(handles.VSRaxes,'Position');
myImage= imresize(myImage, [resizePos(4) resizePos(3)]);
axes(handles.VSRaxes);
imshow(myImage);
set(handles.VSRaxes,'Units','normalized');

msu = imread('img/MSUlogo.jpeg');
set(handles.msuLogo,'Units','pixels');
resizePos = get(handles.msuLogo,'Position');
msu= imresize(msu, [resizePos(4), resizePos(3)]);
set(handles.msuLogo, 'CData', msu);
set(handles.msuLogo,'Units','normalize');
% End test


% Vertically centering the description for each GUI between the
% buttons.
set(handles.AUCbutton,'Units','pixels');
set(handles.VUCbutton,'Units','pixels');
set(handles.AUCdesc,'Units','pixels');
set(handles.VUCdesc,'Units','pixels');

buttonPosition = get(handles.AUCbutton, 'Position');
imgPosition = get(handles.AUCaxes, 'Position');
AUCdescPosition = get(handles.AUCdesc, 'Position');
VUCdescPosition = get(handles.VUCdesc, 'Position');

y_at_button_top = (buttonPosition(2) + buttonPosition(4));
spaceBetween = imgPosition(2) - y_at_button_top;
unusedHeight_AUC = spaceBetween - AUCdescPosition(4);
unusedHeight_VUC = spaceBetween - VUCdescPosition(4);
moveAUCDescUpBy = unusedHeight_AUC/2;
moveVUCDescUpBy = unusedHeight_VUC/2;
AUCdescPosition(2) = y_at_button_top + moveAUCDescUpBy;
VUCdescPosition(2) = y_at_button_top + moveVUCDescUpBy;

set(handles.AUCdesc, 'position', AUCdescPosition);
set(handles.VUCdesc, 'position', VUCdescPosition);

set(handles.VSRaxes,'Units','normalize');
set(handles.AUCaxes,'Units','normalize');
set(handles.AUCbutton,'Units','normalize');
set(handles.VUCbutton,'Units','normalize');
set(handles.AUCdesc,'Units','normalize');
set(handles.VUCdesc,'Units','normalize');

guidata(hObject, handles);

% UIWAIT makes homescreen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
% function varargout = homescreen_OutputFcn(hObject, eventdata, handles) 
function varargout = homescreen_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AUCpicture.
function AUCbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AUCpicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('AUC');

% --- Executes on button press in VUCpicture.
function VUCbutton_Callback(hObject, eventdata, handles)
% hObject    handle to VUCpicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('VUC');

%--- Executes during object creation, after setting all properties.
function msuLogo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msuLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% msulogo = imread('img/MSU-Logo.png');
% set(handles.msuLogo,'Units','pixels');
% resizePos = get(handles.msuLogo,'Position');
% MSU= imresize(msulogo, [resizePos(4), resizePos(3)]);
% set(handles.msuLogo, 'CData', MSU);
% set(handles.msuLogo,'Units','normalize');


% --- Executes on button press in vsr_tutorial.
function vsr_tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to vsr_tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% edit(fullfile(matlabroot, 'toolbox\matlab\general\private\openpdf.m'))

% filename = 'MATLAB WORKBOOK1.pdf';
% % read data from file
% [~, ~, xlsxdata] = xlsread(filename);
% assignin('base','xlsxdata',xlsxdata);

url = 'https://ximera.osu.edu/mooculus/calculus1/master/approximatingTheAreaUnderACurve/digInApproximatingAreaWithRectangles';
% Running on Windows
if ispc
    % Running on compiled app
    if isdeployed
        web(url, '-browser')
      % Running in MATLAB editor
    else
        web(url, '-browser')
    end
% Running on Mac
else 
    % Running on compiled app
    if isdeployed
        web(url, '-browser')
      % Running in MATLAB editor
    else
        web(url, '-browser')
    end
end


% --- Executes on button press in auc_tutorial.
function auc_tutorial_Callback(hObject, eventdata, handles)
% hObject    handle to auc_tutorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

url = 'https://ximera.osu.edu/mooculus/calculus1/master/approximatingTheAreaUnderACurve/digInApproximatingAreaWithRectangles';
% Running on Windows
if ispc
    % Running on compiled app
    if isdeployed
        web(url, '-browser')
      % Running in MATLAB editor
    else
        web(url, '-browser')
    end
% Running on Mac
else 
    % Running on compiled app
    if isdeployed
        web(url, '-browser')
      % Running in MATLAB editor
    else
        web(url, '-browser')
    end
end


% --- Executes on button press in AUCpicture.
function AUCpicture_Callback(hObject, eventdata, handles)
% hObject    handle to AUCpicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('AUC');


% --- Executes on button press in VUCpicture.
function VUCpicture_Callback(hObject, eventdata, handles)
% hObject    handle to VUCpicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(homescreen);
run('VUC');


% --- Executes during object creation, after setting all properties.
% function AUCdesc_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to AUCdesc (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% if ismac
%     set(hObject, 'fontSize', 13);
% elseif ispc
%     set(hObject, 'fontSize', 14);
% end

% --- Executes during object creation, after setting all properties.
% function VUCdesc_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to VUCdesc (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% if ismac
%     set(hObject, 'fontSize', 13);
% elseif ispc
%     set(hObject, 'fontSize', 14);
% end
