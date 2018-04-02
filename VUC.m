% In this version, try to make the volume button press and make the plot
% and descriptions when any parameter is changed.

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

% Last Modified by GUIDE v2.5 21-Mar-2018 09:26:05

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
startup
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
axisOri = "y";
set(handles.axisEditbox, 'string', int2str(axisValue));
global methodChoice;
methodChoice = "Disk";
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
global lowerBound;
global upperBound;

functionContents = cellstr(get(handles.functionMenu, 'String'));
funcChoice = functionContents{get(hObject, 'Value')};

% Sets default bounds of revolution according to function picked. i.e when
% x^2 selected, bounds change to 0<=x<=2.
if (funcChoice == "f(x)=x^2")
    lowerBound = 0;
    upperBound = 1;
    set(handles.lowerBoundEdit, 'String', lowerBound);
    set(handles.upperBoundEdit, 'String', upperBound);
end
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
    simple_exp_string = funcChoice(6:end);
    axisString = strcat(axisOri, {' = '}, num2str(axisValue));
    f(x) = str2sym(simple_exp_string);
    
    % Calls different volume calculation methods depending on method picked. 
    if(strcmp(methodChoice, "Disk"))
        estimated_volume = diskmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, axisValue);
        actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
        
        if(axisOri == "y")
            xPlotBounds = [lowerBound upperBound];
        else
            g(x) = finverse(f);
            xPlotBounds = [double(g(lowerBound)) double(g(upperBound))];
%             xLimits = [-double(g(abs(axisValue-lowerBound))) double(g(abs(upperBound)))];
%             xlim(xLimits)
        end
        
        funcLine = fplot(f(x), xPlotBounds, "r");
        set(funcLine, 'LineWidth',2)
        drawDisksAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue)
        uistack(funcLine, "top");
       
    elseif (strcmp(methodChoice, "Shell"))
        estimated_volume = shellmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, axisValue);
        actual_volume = shellmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
        
        if(axisOri == "x") %Draws line of axis of rotation too.
            xPlotBounds = [lowerBound upperBound];
%             yL = ylim;
%             line([axisValue axisValue], yL);  %x-axis
        else
            g(x) = finverse(f)
            xPlotBounds = [double(g(lowerBound)) double(g(upperBound))];
%             xL = xlim;
%             line(xL, [axisValue axisValue]);
        end
        funcLine = fplot(f(x), xPlotBounds, "r");
        set(funcLine, 'LineWidth',2)
        drawShellsAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue)
        uistack(funcLine, "top");
    end
    
    string1 = 'The volume under the function of ';
    statementString = strcat(string1, {' '}, funcChoice, {' rotated about '}, ...
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
%end
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
    global lowerBound;
    global upperBound;
    global methodChoice;
    global axisOri;
    axis_input = str2double(get(hObject,'String'));
   
    if(isnan(axis_input))
        d = errordlg('Axis Value must be a Real number', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    elseif(methodChoice == "Shell" && str2double(axis_input) < upperBound && str2double(axis_input) > lowerBound)
        d = errordlg('Axis of revolution for shell method cannot be between bounds.', 'Axis Error');
        disp("Wa")
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        axisValue = axis_input;
    end
% Hints: get(hObject,'String') returns contents of axisEditbox as text
%        str2double(get(hObject,'String')) returns contents of axisEditbox as a double
volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
global methodChoice;
% hObject    handle to the selected object in axisButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get selected axis from radio button. If Disk method selected, bound
% statement in perspective of opposite axis
axisPicked = get(get(handles.axisButtonGroup,'SelectedObject'),'string');

if (methodChoice == "Disk")
    if (axisPicked == "x")
         bound_statement = "<= y <=";
    else
         bound_statement = "<= x <=";
    end
else
    bound_statement = "<= " + axisPicked(1) + " <=";
end
    
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
axisOri = axisPicked;
volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% Function that returns two-value vector representing bounds for a function 
% with y as the input variable instead of x. For example, if origFunctionText 
% = x^2 and bounds are 0 and 4, returns [0 2] since sqrt(4) = 2, so show 
% graph up to point where finverse(y) = 2.

function inverseString = inverseString(origFunction)
inverseString = char(finverse(str2sym(origFunction)));
end
