function varargout = VUC(varargin)
% VUC MATLAB code for VUC.fig
%      VUC, by itself, creates a new VUC or raises the existing
%      singleton*.
%
%      H = VUC returns the handle to a new VUC or the handle to
%      the existing singleton*.
%
%      VUC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VUC.M with the given input arguments.
%
%      VUC('Property','Value',...) creates a new VUC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VUC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VUC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VUC

% Last Modified by GUIDE v2.5 22-Nov-2017 11:02:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VUC_OpeningFcn, ...
                   'gui_OutputFcn',  @VUC_OutputFcn, ...
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
end


% --- Executes just before VUC is made visible.
function VUC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VUC (see VARARGIN)

% Choose default command line output for VUC
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
global lowBound;
global upBound;
global disks;
global diskWidth;

end

% UIWAIT makes VUC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VUC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in functionMenu.
function functionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to functionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global diskWidth;
global lowerBound;
global upperBound;
global functionChoice;
contents = cellstr(get(hObject,'String'));
intervalChoice = contents{get(hObject,'Value')};
if(strcmp(functionChoice, 'Select a function'))
    newString = 'Select a function';
    set(handles.text4, 'string', newString);
    plot(0,0);
    f = errordlg('Select a function', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
elseif(lowerBound > upperBound)
    newString = 'Fix domain';
    set(handles.text4, 'string', newString);
    plot(0,0);
    d = errordlg('LOWER bound is larger than UPPER bound', 'Domain Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
else
    diskWidth = upperBound - lowerBound / disks;
    end
    popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
end

% Hints: contents = cellstr(get(hObject,'String')) returns functionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from functionMenu
end

% --- Executes during object creation, after setting all properties.
function functionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in volumeButton.
function volumeButton_Callback(hObject, eventdata, handles)
% hObject    handle to volumeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function diskEdit_Callback(hObject, eventdata, handles)
    global lowerBound;
    global upperBound;
    tempLowerBound = lowerBound;
    lowerBound = str2double(get(hObject,'String'));
    if(isnan(lowerBound))
        d = errordlg('Domain must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        lowerBound = tempLowerBound;
    else
        if(lowerBound >= upperBound)
            newString = 'Fix domain';
            set(handles.text4, 'string', newString);
            plot(0,0);
            d = errordlg('Fix Upper Bound', 'Domain Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
            lowerBound = tempLowerBound;
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
         else
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
         end
% hObject    handle to diskEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diskEdit as text
%        str2double(get(hObject,'String')) returns contents of diskEdit as a double
    end
end

% --- Executes during object creation, after setting all properties.
function diskEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diskEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function lowBoundEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lowBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global lowBound;
    global upBound;
    tempLowerBound = lowBound;
    lowBound = str2double(get(hObject,'String'));
    if(isnan(lowerBound))
        d = errordlg('Domain must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        lowerBound = tempLowBound;
    else
        if(lowBound >= upBound)
            newString = 'Fix domain';
            set(handles.text4, 'string', newString);
            plot(0,0);
            d = errordlg('Fix Upper Bound', 'Domain Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
            lowBound = tempLowerBound;
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
         else
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
         end

% Hints: get(hObject,'String') returns contents of lowBoundEdit as text
%        str2double(get(hObject,'String')) returns contents of lowBoundEdit as a double
    end
end

% --- Executes during object creation, after setting all properties.
function lowBoundEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function upBoundEdit_Callback(hObject, eventdata, handles)
% hObject    handle to upBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global upBound;
    global lowBound;
    tempUpperBound = upBound;
    upBound = str2double(get(hObject,'String'));
    if(isnan(upBound))
        d = errordlg('Domain must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        upBound = tempUpperBound;
    else
        if(lowBound >= upBound)
            newString = 'Fix domain';
            set(handles.text4, 'string', newString);
            plot(0,0);
            d = errordlg('Fix Upper Bound', 'Domain Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
            upBound = tempUpperBound;
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
         else
            popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
            pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
        end
    end
end
% Hints: get(hObject,'String') returns contents of upBoundEdit as text
%        str2double(get(hObject,'String')) returns contents of upBoundEdit as a double


% --- Executes during object creation, after setting all properties.
function upBoundEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
