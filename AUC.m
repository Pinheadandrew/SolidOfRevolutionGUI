function varargout = AUC(varargin)
% AREAUNDERCURVE MATLAB code for AreaUnderCurve.fig
%      AREAUNDERCURVE, by itself, creates a new AREAUNDERCURVE or raises the existing
%      singleton*.
%
%      H = AREAUNDERCURVE returns the handle to a new AREAUNDERCURVE or the handle to
%      the existing singleton*.
%
%      AREAUNDERCURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AREAUNDERCURVE.M with the given input arguments.
%
%      AREAUNDERCURVE('Property','Value',...) creates a new AREAUNDERCURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AreaUnderCurve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AreaUnderCurve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AreaUnderCurve

% Last Modified by GUIDE v2.5 17-Nov-2017 11:57:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AreaUnderCurve_OpeningFcn, ...
                   'gui_OutputFcn',  @AreaUnderCurve_OutputFcn, ...
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


% --- Executes just before AreaUnderCurve is made visible.
function AreaUnderCurve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AreaUnderCurve (see VARARGIN)

% Choose default command line output for AreaUnderCurve
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
guidata(hObject, handles);
global lowerBound 
lowerBound = 0;
global upperBound 
upperBound = 20;
global step
step = 5;
global methodPicked;
methodPicked = 'trapz';
set(handles.uibuttongroup1, 'SelectedObject', handles.radiobutton4);
set(handles.text4, 'string', 'Select a function');
% UIWAIT makes AreaUnderCurve wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AreaUnderCurve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global step;
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
    if(strcmp(intervalChoice,'5'))
        bDiff = upperBound - lowerBound;
        step = bDiff/5;
    elseif(strcmp(intervalChoice, '10'))
        bDiff = upperBound - lowerBound;
        step = bDiff/10;
    elseif(strcmp(intervalChoice, '15'))
        bDiff = upperBound - lowerBound;
        step = bDiff/15;
    elseif(strcmp(intervalChoice, '20'))
        bDiff = upperBound - lowerBound;
        step = bDiff/20;
    elseif(strcmp(intervalChoice, '50'))
        bDiff = upperBound - lowerBound;
        step = bDiff/50;
    end
    popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global upperBound;
global lowerBound;
tempUpperBound = upperBound;
upperBound = str2double(get(hObject,'String'));
if(isnan(upperBound))
    d = errordlg('Domain must be Integer', 'Domain Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    upperBound = tempUpperBound;
else
    if(lowerBound >= upperBound)
        newString = 'Fix domain';
        set(handles.text4, 'string', newString);
        plot(0,0);
        d = errordlg('Fix Upper Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        upperBound = tempUpperBound;
        popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
        pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
     else
        popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
        pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
     end
end


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global funcSelected;
global lowerBound;
global upperBound;
global step;
global funcText;
global functionChoice;
global methodPicked;
if(lower(methodPicked) == 'trapz')
    x = (lowerBound:step:upperBound);
    functionContents = cellstr(get(handles.popupmenu2, 'String'));
    functionChoice = functionContents{get(hObject, 'Value')};
    if(strcmp(functionChoice,'f(x)=x^3+5x^2'))
        funcSelected = x.^3+5*x.^2;
        funcText = 'f(x)=x^{\3}+5x^2';
    elseif(strcmp(functionChoice, 'f(x)=x^2+1'))
        funcSelected = x.^2+1;
        funcText = 'f(x)=x^2+1';
    end
    pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
elseif(lower(methodPicked) == 'left')
    disp('Left')
    functionContents = cellstr(get(handles.popupmenu2, 'String'));
    functionChoice = functionContents{get(hObject, 'Value')};
    if(strcmp(functionChoice,'f(x)=x^3+5x^2'))
        funcText = 'q^3+5*q^2';
    elseif(strcmp(functionChoice, 'f(x)=x^2+1'))
        funcText = 'q^2+1';
    end
    syms q
    f(q) = str2sym(funcText);
    
    riemannsPoints = lowerBound:step:upperBound-step;
    rectHeights = double(f(riemannsPoints));
    plot(riemannsPoints,rectHeights);
    disp(sum(rectHeights*step))
%     disp(length(riemannsPoints))
%     disp(length(rectHeights))
%     
%     xverts = [riemannsPoints(1:end-1); riemannsPoints(1:end-1); ...
%         riemannsPoints(2:end); riemannsPoints(2:end)];
%     yverts = [zeros(1,length(riemannsPoints)); rectHeights(1:end-1); ... 
%         rectHeights(2:end); zeros(1,length(riemannsPoints))];
%     yverts
%     p = patch(xverts,yverts,'b','LineWidth',1.5);
elseif(lower(methodPicked) == 'center')
    functionContents = cellstr(get(handles.popupmenu2, 'String'));
    functionChoice = functionContents{get(hObject, 'Value')};
    if(strcmp(functionChoice,'f(x)=x^3+5x^2'))
        funcText = 'q^3+5*q^2';
    elseif(strcmp(functionChoice, 'f(x)=x^2+1'))
        funcText = 'q^2+1';
    end
    syms q
    f(q) = str2sym(funcText);
    
    riemannsPoints = lowerBound+(step/2):step:upperBound-(step/2);
    rectHeights = double(f(riemannsPoints));
    plot(riemannsPoints,rectHeights);
    disp(sum(rectHeights*step))
    
    xverts = [riemannsPoints(1:end-1); riemannsPoints(1:end-1); ...
        riemannsPoints(2:end); riemannsPoints(2:end)];
    xverts
    yverts = [zeros(1,length(riemannsPoints)); rectHeights(1:end-1); ... 
        rectHeights(2:end); zeros(1,length(riemannsPoints))];
    yverts
    p = patch(xverts,yverts,'b','LineWidth',1.5);
end



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global funcSelected
global x;
global AUC;
global lowerBound;
global step;
global upperBound;
global funcText;
global functionChoice;
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
    x = lowerBound:step:upperBound;
    AUC = trapz(x,funcSelected);
    plot(x,funcSelected);
    string = 'Area Under the Curve for';
    string1 = 'with intervals from';
    newString = strcat(string, {' '}, funcText, string1, {' '}, int2str(lowerBound), {' to '}, int2str(upperBound), {' is '}, int2str(AUC));
    set(handles.text4, 'string', newString);
    xverts = [x(1:end-1); x(1:end-1); x(2:end); x(2:end)];
    yverts = [zeros(1,length(x)-1); funcSelected(1:end-1); funcSelected(2:end); zeros(1,length(x)-1)];
    p = patch(xverts,yverts,'b','LineWidth',1.5);
end


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global methodPicked;

hh = get(get(handles.uibuttongroup1,'SelectedObject'),'string');
methodPicked = string(hh);
popupmenu2_Callback(handles.popupmenu2, eventdata, handles);
