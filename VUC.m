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

% Last Modified by GUIDE v2.5 28-May-2018 13:13:46

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
% Choose default command line output for VUC
startup
handles.output = hObject;
VUCimage = imread('img/homebutton.jpg');
set(handles.homeButton, 'CData', VUCimage);
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
global viewMode;
viewMode = "2D";
global fullSolid;
fullSolid = 1;
global radiusMethod;
radiusMethod = "m";
maxNumberOfRect = 100;
set(handles.stepSlider, 'Min', 1);
set(handles.stepSlider, 'Max', maxNumberOfRect);
set(handles.stepSlider, 'Value', 5);
set(handles.stepSlider, 'SliderStep', [1/maxNumberOfRect , 10/maxNumberOfRect ]);
end

% --- Outputs from this function are returned to the command line.
function varargout = VUC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% Choosing the function to rotate the area under its curve.
function functionMenu_Callback(hObject, eventdata, handles)
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
global upperBound;
global lowerBound;
global funcChoice;
global steps;
global methodChoice;
global axisValue;
global axisOri;
global viewMode;
global fullSolid;
global radiusMethod;
global az;
global el;

 % If 3D selected, plot volume using 3D functions. Else, draw patches in
 % 2D. Nothing changes about calculations though, so nest it right.
if (strcmp(funcChoice, "Select a function"))
    plot(0,0);
    f = errordlg('No Function Selected.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
else
    syms x
    simple_exp_string = funcChoice(6:end);
    f(x) = str2sym(simple_exp_string);
    
    % If the view option upon redrawing the plot is still 3D, store the
    % viewpoint of the plot to be reused when 3D plot redrawn.
    if (viewMode == "3D")
      [az, el] = view;
    end
    
    delete(handles.axes1.Children)
        cla reset, rotate3d off
        
    % Calls different volume calculation methods depending on method picked. 
    if(strcmp(methodChoice, "Disk"))
        estimated_volume = diskmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, axisValue, radiusMethod);
        actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
        
        % If 3D selected, plot volume using 3D functions. Else, draw patches in
        % 2D. Nothing changes about calculations though, so nest it right.
        if(viewMode == "3D")
            plotDiscs(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, fullSolid, radiusMethod), rotate3d on
            
         % If half solid selected, have axes bounds same as if full-solid.
            if (fullSolid == 0)
              yPlotBounds = ylim;
              ylim([-yPlotBounds(2) yPlotBounds(2)])
            end
            
            view([az el])
            xlabel('X','FontWeight','bold')
            ylabel('Z','FontWeight','bold')
            zlabel('Y','FontWeight','bold')
        else
            drawDisksAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, radiusMethod);
            xlabel('X','FontWeight','bold')
            ylabel('Y','FontWeight','bold')
        end
        
    %Branch if volume generated via shell method.
    elseif (strcmp(methodChoice, "Shell"))
        estimated_volume = shellmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, axisValue, radiusMethod);
        actual_volume = shellmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
        
        % Sets axes to either 2D representation or 3D volumes.
        if(viewMode == "3D")
            plotShells(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, fullSolid, radiusMethod), rotate3d on
            
            % If half solid selected, have axes bounds same as if full-solid.
            if (fullSolid == 0)
              yPlotBounds = ylim;
              ylim([-yPlotBounds(2) yPlotBounds(2)])
            end
            
            view([az el])
            xlabel('X','FontWeight','bold')
            ylabel('Z','FontWeight','bold')
            zlabel('Y','FontWeight','bold')
        else
            drawShellsAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, radiusMethod);
            xlabel('X','FontWeight','bold')
            ylabel('Y','FontWeight','bold')
        end
    end
    
    % Preserving axis limits when the method is the shell, due to unusual
    % plots w/o using the bounds made from plotting the volume (2D or 3D).
    if (methodChoice == "Shell" || (methodChoice == "Disk" && axisOri == "x"))
      shape_plot_xlim = xlim;
      shape_plot_ylim = ylim;
      shape_plot_zlim = zlim;
      plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode)
      xlim(shape_plot_xlim);
      ylim(shape_plot_ylim);
      zlim(shape_plot_zlim);
    else
      plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode)
    end
    
    % Display the estimated and actual volumes and the error percenter b/w
    % both.
    statementString = "Estimated Volume: " + sprintf('%0.3f', estimated_volume);
    statementString2 = "Actual Volume: " + sprintf('%0.3f', actual_volume);
    errorPerc = ((estimated_volume - actual_volume)/actual_volume)*100;
    
    set(handles.statementText, 'string', statementString);
    set(handles.actualVolumeText, 'string', statementString2);
    
    if(isnan(errorPerc))
      set(handles.errorText, 'string', strcat({'  Error: '}, {'0%'}));
    else
      set(handles.errorText, 'string', strcat({'  Error: '}, sprintf('%0.4f', errorPerc), {'%'}));
    end
    hold off
end
end

% Setting the number of subintervals that comprise of the estimated volume.
function diskEdit_Callback(hObject, eventdata, handles)
    global lowerBound;
    global upperBound;
    global diskWidth;
    global steps;
    
    stepInput = str2double(get(hObject,'String'));
    
    % Step input not an integer, or out of range of 0<x<101, throw error.
    if(isnan(stepInput) || stepInput <= 0 || stepInput > 100 || (floor(stepInput) ~= stepInput))
      d = errordlg('Number of subintervals must be positive integer less than or equal to 100', 'Subinterval Count Error');
      set(d, 'WindowStyle', 'modal');
      set(handles.diskEdit, 'string', steps);
      uiwait(d);
    else
      steps = stepInput;
      diskWidth = (upperBound - lowerBound)/steps;
      set(handles.stepSlider, 'value', stepInput);
    end
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

% Setting the lower bound of the volume.
function lowerBoundEdit_Callback(hObject, eventdata, handles)
    global lowerBound;
    global upperBound;
    global axisValue;
    global methodChoice;
    lower_input = str2double(get(hObject,'String'));
   
    if(isnan(lower_input))
        d = errordlg('Domain must be Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    elseif(lower_input >= upperBound)
        plot(0,0);
        d = errordlg('Fix Lower Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    elseif (methodChoice == "Shell" && ~isValidShellVolume(axisValue, lower_input, upperBound))
        d = errordlg('Cannot generate a shell volume given the bound and axis configuration', 'Shell Volume Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    else
        lowerBound = lower_input;
    end
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

% Setting the upper bound of the volume.
function upperBoundEdit_Callback(hObject, eventdata, handles)
% hObject    handle to upperBoundEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global lowerBound;
    global upperBound;
    global axisValue;
    global methodChoice;
    upper_input = str2double(get(hObject,'String'));
    
    if(isnan(upper_input))
        d = errordlg('Domain must be an Integer', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
    elseif(upper_input <= lowerBound)
        newString = 'Fix domain';
        set(handles.boundStatement, 'string', newString);
        plot(0,0);
        d = errordlg('Fix Upper Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
    elseif (methodChoice == "Shell" && ~isValidShellVolume(axisValue, lowerBound, upper_input))
        d = errordlg('Cannot generate a shell volume given the bound and axis configuration', 'Shell Volume Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
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


% Selecting either the disc or the shell method.
function methodMenu_Callback(hObject, eventdata, handles)
% hObject    handle to methodMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global methodChoice;
global viewMode;
global fullSolid;
global axisOri;
global axisValue;
global lowerBound;
global upperBound;

methodContents = cellstr(get(handles.methodMenu, 'String'));
methodContents = methodContents{get(hObject, 'Value')};

% If switching from disc to shell method and the resulting shell volume
% cannot be generating due to the axis constraint, revert back to the disk
% method. Else, assign the global variable methodChoice to whatever selected.
if (methodChoice == "Disk" && methodContents == "Shell" && ~isValidShellVolume(axisValue, lowerBound, upperBound))
    d = errordlg('Cannot generate a shell volume given the bound and axis configuration', 'Shell Volume Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    set(handles.methodMenu, 'value', 1);
else
    methodChoice = methodContents;
end

subIntsLabelString = "Number of " + methodChoice + "s";
set(handles.subintervalGroup, 'title', subIntsLabelString);


% Upon selection of the rotation method used, make changes to UI, changing
% some titles.
if(viewMode == "3D")
  fullSolid = 1;
  set(handles.fullSolidRadio, 'Value', 1.0);
  set(handles.solidViewRadiogroup, 'Visible', "on");
  set(handles.subintervalGroup, 'title', subIntsLabelString);
else
  %set(handles.methodHeader, 'String', 'Method of Disc Radius');
  set(handles.solidViewRadiogroup, 'Visible', "off");
end

% Based on method and the axis orientation picked, reset the bound 
% statement in the boundary section.
if (methodChoice == "Shell")
  set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
  if (axisOri == "y")
    set(handles.boundStatement, 'string', "<= y <=");
  else
    set(handles.boundStatement, 'string', "<= x <=");
  end
else
  set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
    if (axisOri == "y")
      set(handles.boundStatement, 'string', "<= x <=");
    else
      set(handles.boundStatement, 'string', "<= y <=");
    end
end

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

% Setting the axis line.
function axisEditbox_Callback(hObject, eventdata, handles)
    global axisValue;
    global lowerBound;
    global upperBound;
    global methodChoice;
    axis_input = str2double(get(hObject,'String'));
   
    if(isnan(axis_input))
        d = errordlg('Axis Value must be a Real number', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.axisEditbox, 'string', axisValue);
    elseif(methodChoice == "Shell" && ~isValidShellVolume(axis_input, lowerBound, upperBound))
        d = errordlg('Cannot generate a shell volume given the bound and axis configuration', 'Shell Volume Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.axisEditbox, 'string', axisValue);
    else
        axisValue = axis_input;
    end
    
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
    position(2) = 2.9;
    set(handles.axisEditbox, 'Position', position)
    set(get(handles.axisButtonGroup,'SelectedObject'),'string',"x   =")
    set(handles.yAxisRadio,'string',"y")
else
    position(2) = 0.76923;
    set(handles.axisEditbox, 'Position', position)
    set(get(handles.axisButtonGroup,'SelectedObject'),'string',"y   =")
    set(handles.xAxisRadio,'string',"x")
end
axisOri = axisPicked;
volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes on button press in homeButton.
function homeButton_Callback(hObject, eventdata, handles)
close(VUC);
run('homescreen');
end

% --- Callback from button group that sets whether to view the solid of
% revolution from a 2D perspective or as 3D volumes.
function threeDButton_Callback(hObject, eventdata, handles)
global viewMode;
global fullSolid;
global el;
global az;

if (viewMode == "3D")
    viewMode = "2D";
    set(handles.threeDButton, 'String', "View in 3D");
    set(handles.solidViewRadiogroup, 'Visible', "off");
    [az, el] = view(2);
else
    viewMode = "3D";
    set(handles.threeDButton, 'String', "View in 2D");
    set(handles.fullSolidRadio, 'Value', 1.0);
    set(handles.solidViewRadiogroup, 'Visible', "on");
    fullSolid = 1;
    [az, el] = view(3);
end

volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes when selected object is changed in solidViewRadiogroup.
function solidViewRadiogroup_SelectionChangedFcn(hObject, eventdata, handles)
global fullSolid;

% Get selected axis from radio button. If Disk method selected, bound
% statement in perspective of opposite axis
fullSolidPicked = get(get(handles.solidViewRadiogroup,'SelectedObject'),'string');

if(fullSolidPicked == "Half Solid")
  fullSolid = 0;
else
  fullSolid = 1;
end
volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes on slider movement.
function stepSlider_Callback(hObject, eventdata, handles)
    global steps;
    steps = ceil(get(handles.stepSlider, 'Value'));
    set(handles.diskEdit, 'string', steps);
    volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function stepSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% Method used within callbacks when the volume method is set to Shell. Addresses
% the constraint of keeping axis of rotation outside of bounds of the solid of revolution. 
% If violated (axis between bounds), this returns false.
function valid = isValidShellVolume(axisVal, lowBound, upBound)
    if ((axisVal > lowBound) && (axisVal < upBound))
        valid = 0;
    else
        valid = 1;
    end
end

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global functionChoice;
global lowerBound;
global upperBound;
global axisValue;
global steps;
global radiusMethod;
global methodChoice;

lowerBound = 0;
upperBound = 5;
steps = 5;
axisValue = 0;
radiusMethod = "m";
methodChoice = "Disk";

set(handles.lowerBoundEdit, 'string', lowerBound);
set(handles.upperBoundEdit, 'string', upperBound);
set(handles.diskEdit, 'string', steps);
set(handles.axisEditbox, 'string', axisValue);
set(handles.stepSlider, 'value', steps);
set(handles.radiusMethodRadioGroup,'SelectedObject', handles.midRadiusRadioButton)
volumeButton_Callback(handles.volumeButton, eventdata, handles);
set(handles.methodMenu, 'value', 1);
end

% --- Executes when selected object is changed in radiusMethodRadioGroup.
function radiusMethodRadioGroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in radiusMethodRadioGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global radiusMethod;
methodPicked = get(get(handles.radiusMethodRadioGroup,'SelectedObject'),'string');

if(methodPicked == "Left")
  radiusMethod = "l";
elseif (methodPicked == "Midpoint")
    radiusMethod = "m";
elseif (methodPicked == "Right")
    radiusMethod = "r";
end
volumeButton_Callback(handles.volumeButton, eventdata, handles);
end
