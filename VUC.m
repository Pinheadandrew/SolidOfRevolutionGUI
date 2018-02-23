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

% Last Modified by GUIDE v2.5 07-Feb-2018 13:04:47

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
global lowerBound;
lowerBound = 0;
global upperBound;
upperBound = 5;
global steps;
steps = 5;
global axisValue;
axisValue = 0;
global axisOri;
axisOri = "x";

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
global funcChoice;

functionContents = cellstr(get(handles.functionMenu, 'String'));
funcChoice = functionContents{get(hObject, 'Value')};
end

% Hints: contents = cellstr(get(hObject,'String')) returns functionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from functionMenu


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
global upperBound;
global lowerBound;
global funcChoice;
global steps;
global methodChoice;
global axisValue;
global axisOri;

if (strcmp(funcChoice, "Select a function"))
    plot(0,0);
    f = errordlg('No Function Selected.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
else
    syms x
    simple_exp = funcChoice(6:end);
    if (strcmp(methodChoice, "Disk"))
        estimated_volume = diskmethod2(simple_exp, steps, lowerBound, upperBound);
        actual_volume = diskmethod1(simple_exp, lowerBound, upperBound);
        % actual_volume = diskwithaxis(simple_exp, lowerBound, upperBound, axisOri, axisValue);
        axisString = "x-axis";
    elseif (strcmp(methodChoice, "Shell"))
        estimated_volume = shellmethod2(simple_exp, steps, lowerBound, upperBound);
        actual_volume = shellmethod1(simple_exp, lowerBound, upperBound);
        axisString = "y-axis";
    end
    fplot(str2sym(simple_exp), [lowerBound upperBound])
    
    string1 = 'The volume under the function of ';

    statementString = strcat(string1, {' '}, funcChoice, {' rotated around the '}, ...
        axisString, {' with '}, num2str(steps), ...
        {' steps between the interval of '}, num2str(lowerBound), {' to '},...
        num2str(upperBound), {' is '}, sprintf('%0.4f', estimated_volume));
    
    statementString2 = strcat("Actual Volume:", {' '}, sprintf('%0.4f', actual_volume));

    set(handles.statementText, 'string', statementString);
    set(handles.actualVolumeText, 'string', statementString2);
end
end

function diskEdit_Callback(hObject, eventdata, handles)
    global lowerBound;
    global upperBound;
    global diskWidth;
    global steps;
    
    stepInput = str2double(get(hObject,'String'));
    
    if(isnan(stepInput))
        d = errordlg('Disk Count must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    elseif(stepInput <= 0)
            newString = 'Nonpositive Disk Count';
            set(handles.boundStatement, 'string', newString);
            plot(0,0);
            d = errordlg('Number of steps must be positive', 'Disk Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
    else
        steps = stepInput;
        diskWidth = (upperBound - lowerBound)/steps;
    end

% hObject    handle to diskEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diskEdit as text
%        str2double(get(hObject,'String')) returns contents of diskEdit as a double
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


function lowerBoundEdit_Callback(hObject, eventdata, handles)
% hObject    handle to lowerBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global lowerBound;
    global upperBound;
    lower_input = str2double(get(hObject,'String'));
   
    if(isnan(lower_input))
        d = errordlg('Domain must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    elseif(lower_input >= upperBound)
        plot(0,0);
        d = errordlg('Fix Lower Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        lowerBound = lower_input;
    end

% Hints: get(hObject,'String') returns contents of lowerBoundEdit as text
%        str2double(get(hObject,'String')) returns contents of lowerBoundEdit as a double
end

% --- Executes during object creation, after setting all properties.
function lowerBoundEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowerBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function upperBoundEdit_Callback(hObject, eventdata, handles)
% hObject    handle to upperBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global lowerBound;
    global upperBound;
    upper_input = str2double(get(hObject,'String'));
    
    if(isnan(upper_input))
        d = errordlg('Domain must be an Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    elseif(upper_input <= lowerBound)
        newString = 'Fix domain';
        set(handles.boundStatement, 'string', newString);
        plot(0,0);
        d = errordlg('Fix Upper Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        upperBound = upper_input;
    end
end
% Hints: get(hObject,'String') returns contents of upperBoundEdit as text
%        str2double(get(hObject,'String')) returns contents of upperBoundEdit as a double


% --- Executes during object creation, after setting all properties.
function upperBoundEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in methodMenu.
function methodMenu_Callback(hObject, eventdata, handles)
% hObject    handle to methodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global methodChoice;

methodContents = cellstr(get(handles.methodMenu, 'String'));
methodChoice = methodContents{get(hObject, 'Value')};

% Hints: contents = cellstr(get(hObject,'String')) returns methodMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methodMenu
end

% --- Executes during object creation, after setting all properties.
function methodMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function axisEditbox_Callback(hObject, eventdata, handles)
% hObject    handle to axisEditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global axisValue;
    axis_input = str2double(get(hObject,'String'));
   
    if(isnan(axis_input))
        d = errordlg('Axis Value must be a Real number', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        axisValue = axis_input;
    end
% Hints: get(hObject,'String') returns contents of axisEditbox as text
%        str2double(get(hObject,'String')) returns contents of axisEditbox as a double

end
% --- Executes during object creation, after setting all properties.
function axisEditbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axisEditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes when selected object is changed in axisButtonGroup.
function axisButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
global axisOri;
% hObject    handle to the selected object in axisButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axisPicked = get(get(handles.axisButtonGroup,'SelectedObject'),'string');
bound_statement = "<= " + axisPicked(1) + " <=";
set(handles.boundStatement, 'string', bound_statement);

position = get(handles.axisEditbox,'Position');

% Positions the axis value box adjacent to the axis orientation selected.
% Also sets the axis orientation parameter in the volume function.
if (axisPicked == "x")
    position(2) = 3.2;
    set(handles.axisEditbox, 'Position', position)
    set(get(handles.axisButtonGroup,'SelectedObject'),'string',"x   =")
    set(handles.yAxisRadio,'string',"y")
else
    position(2) = 1;
    set(handles.axisEditbox, 'Position', position)
    set(get(handles.axisButtonGroup,'SelectedObject'),'string',"y   =")
    set(handles.xAxisRadio,'string',"x")
end
end
