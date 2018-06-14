% In this version, try to make the volume button press and make the plot
% and descriptions when any parameter is changed.

function varargout = VUC(varargin)
% Last Modified by GUIDE v2.5 06-Jun-2018 13:13:27

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
resetImage = imread('img/resetbutton.jpg');
set(handles.resetButton, 'CData', resetImage);
% Update handles structure2
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
global functionChoice;
functionChoice = "Select a function";
global viewModeChanged;
viewModeChanged = 0;
maxNumberOfRect = 75;
set(handles.stepSlider, 'Min', 1);
set(handles.stepSlider, 'Max', maxNumberOfRect);
set(handles.stepSlider, 'Value', 5);
set(handles.stepSlider, 'SliderStep', [1/maxNumberOfRect , 10/maxNumberOfRect ]);

% Setting some multi-line tooltips, wherever necessary.
set(handles.stepSlider, 'TooltipString', ...
    sprintf("Drag for a number between 0 and 75 to set the number \n of subintervals in determining the estimated volume."));
set(handles.upperBoundEdit, 'TooltipString', ...
    sprintf("Enter the upper bound for the area to be rotated.\nMin.: -50\nMax.: 50"));
set(handles.lowerBoundEdit, 'TooltipString', ...
    sprintf("Enter the lower bound for the area to be rotated.\nMin.: -50\nMax.: 50"));
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
global functionChoice;
global lowerBound;
global upperBound;
global methodChoice;
global axisOri;
global viewModeChanged;

functionContents = cellstr(get(handles.functionMenu, 'String'));
functionContents = functionContents{get(hObject, 'Value')};

% Check for case where switching function and function not one-to-one given
% axis and boundary configurations.
if (~isValidVolume(functionContents(6:end), methodChoice, lowerBound, upperBound, axisOri))
    plot(0,0);
    f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
    viewModeChanged = 1;
    
    % Find the index of previous function that was working in the function
    % menu, to reset the selected function to that. Cycle through that
    % menu to match the global Function choice and if match found, set the
    % function menu to that selection.
    functionStrings = handles.functionMenu.String;
    functionIndex = 1;
    for i=1:length(functionStrings)
        currentFuncString = functionStrings(i);
        currentFuncString = currentFuncString{1};
        if (strcmp(currentFuncString, functionChoice))
            functionIndex = i;
        end
    end
    set(handles.functionMenu, 'Value', functionIndex);
else
    functionChoice = functionContents;
end

% Sets default bounds of revolution according to function picked. i.e when
% x^2 selected, bounds change to 0<=x<=2.
if (functionChoice == "f(x)=x^2")
    lowerBound = 0;
    upperBound = 1;
    set(handles.lowerBoundEdit, 'String', lowerBound);
    set(handles.upperBoundEdit, 'String', upperBound);
end

volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
global upperBound;
global lowerBound;
global functionChoice;
global steps;
global methodChoice;
global axisValue;
global axisOri;
global viewMode;
global fullSolid;
global radiusMethod;
global az;
global el;
global viewModeChanged;

 % If 3D selected, plot volume using 3D functions. Else, draw patches in
 % 2D. Nothing changes about calculations though, so nest it right.
if (strcmp(functionChoice, "Select a function"))
    % plot(0,0);
    f = errordlg('No Function Selected.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
else
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    if (viewMode == "2D")
        set(handles.threeDButton, 'String', "View in 3D");
        set(handles.solidViewRadiogroup, 'Visible', "off");
        
        % If plot result of changing view mode from 3D to 2d, set angle to
        % default of 2D plot.
        if (viewModeChanged == 1)
            [az, el] = view(2);
        end
    else
        set(handles.threeDButton, 'String', "View in 2D");
        set(handles.solidViewRadiogroup, 'Visible', "on");
        
        % If plot result of changing view mode from 2D to 3D, set angle to
        % default of 3D plot.
        if (viewModeChanged == 1)
            [az, el] = view(3);
        end
    end
    viewModeChanged = 0;
    
    syms x
    simple_exp_string = functionChoice(6:end);
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
              
              % Handling plot bounds of function 2^x rotating around y-axis
              if (simple_exp_string ~= "2^x" && axisOri ~= "x" && methodChoice ~= "Disk")
                ylim([-yPlotBounds(2) yPlotBounds(2)]) %% THIS LINE HAS SOME PROBLEMS SUCH AS F(X) = 2^X && bounds 0<x<1
              else
                  if (abs(yPlotBounds(1)) < yPlotBounds(2))
                      ylim([-yPlotBounds(2) yPlotBounds(2)])
                  else
                      ylim([yPlotBounds(1) -yPlotBounds(1)])
                  end
              end
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
    estVolumeString = "Estimated Volume: " + sprintf('%0.4f', estimated_volume);
    actVolumeString = "Actual Volume: " + sprintf('%0.4f', actual_volume);
    errorPerc = ((estimated_volume - actual_volume)/actual_volume)*100;
    
    % New line for volume statements so that string in textboxes aren't
    % overflowing.
    
    if (length(estVolumeString) > 40 || length(actVolumeString) > 40)
        estVolumeString = sprintf("Estimated Volume:\n" + sprintf('%0.4f', estimated_volume));
        actVolumeString = sprintf("Actual Volume:\n" + sprintf('%0.4f', actual_volume));
    end
    
    % Text added on to displayed error percentage, stating estimation type.
    if (errorPerc < 0)
        estimate_type = " (Underestimate)";
    elseif (errorPerc > 0)
        estimate_type = " (Overestimate)";
    else
        estimate_type = "";
    end
    set(handles.statementText, 'string', estVolumeString);
    set(handles.actualVolumeText, 'string', actVolumeString);
    
    if(isnan(errorPerc))
      set(handles.errorText, 'string', strcat({'  Error: '}, {'0% '}));
    else
      set(handles.errorText, 'string', strcat({'  Error: '}, sprintf('%0.4f', errorPerc), {'%'}, estimate_type));
    end
    
    hold off
    set(handles.figure1, 'pointer', 'arrow')
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
    if(isnan(stepInput) || stepInput <= 0 || stepInput > 75 || (floor(stepInput) ~= stepInput))
      d = errordlg('Number of subintervals must be positive integer less than or equal to 75', 'Subinterval Count Error');
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
    global functionChoice;
    global axisOri;
    global viewModeChanged;
    lower_input = str2double(get(hObject,'String'));
   
    if(isnan(lower_input))
        d = errordlg('The bound must be a real number.', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    elseif(lower_input >= upperBound)
        plot(0,0);
        d = errordlg('The upper bound must be greater than the lower bound.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % Lower bound must be within range of -50 and 50.
    elseif(lower_input < -50 || lower_input > 50)
        plot(0,0);
        d = errordlg('The bound value must fall within the range of -50 and 50.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % If entering lower bound to create invalid instance, produce error
    % message and reset bound to what it was previously.
    elseif (~isValidVolume(functionChoice(6:end), methodChoice, lower_input, upperBound, axisOri))
        plot(0,0);
        f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % Lower bound is such that: lower bound < axis value < upper bound,
    % which is invalid for creating shell volumes.
    elseif (methodChoice == "Shell" && ~isValidShellVolume(axisValue, lower_input, upperBound))
        d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
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
    global lowerBound;
    global upperBound;
    global axisValue;
    global methodChoice;
    global functionChoice;
    global axisOri;
    global viewModeChanged;
    upper_input = str2double(get(hObject,'String'));
    
    if(isnan(upper_input))
        d = errordlg('The bound must be a real number.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
    elseif(upper_input <= lowerBound)
        plot(0,0);
        d = errordlg('The upper bound must be greater than the lower bound.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    elseif(upper_input < -50 || upper_input > 50)
        plot(0,0);
        d = errordlg('The bound value must fall within the range of -50 and 50.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    elseif (~isValidVolume(functionChoice(6:end), methodChoice, lowerBound, upper_input, axisOri))
        plot(0,0);
        f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    elseif (methodChoice == "Shell" && ~isValidShellVolume(axisValue, lowerBound, upper_input))
        d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
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
function methodRadioGroup_SelectionChangedFcn(hObject, eventdata, handles)
global methodChoice;
global viewMode;
global fullSolid;
global axisOri;
global axisValue;
global lowerBound;
global upperBound;
global functionChoice;

methodContents = get(get(handles.methodRadioGroup,'SelectedObject'),'string');

% If switching from disc to shell method and the resulting shell volume
% cannot be generating due to the axis constraint, revert back to the disk
% method. Else, assign the global variable methodChoice to whatever selected.
if (methodChoice == "Disk" && methodContents == "Shell" && ~isValidShellVolume(axisValue, lowerBound, upperBound))
    d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    set(handles.discRadio, 'Value', 1.0);
    
% Switching between methods and the new volume uses a function that is not
% one-to-one given the domain specified by the defined lower and upper
% bound, so produce an error message. After message cleared, return
% selected method to what it was previously that was working.
elseif (~isValidVolume(functionChoice, methodContents, lowerBound, upperBound, axisOri))
    f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.discRadio, 'Value', 1.0);
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
        d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
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
global viewModeChanged;

if (viewMode == "3D")
    viewMode = "2D";
else
    viewMode = "3D";
    set(handles.fullSolidRadio, 'Value', 1.0);
    fullSolid = 1;
end

viewModeChanged = 1;

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
close(VUC);
run('VUC');
end

% --- Executes when selected object is changed in radiusMethodRadioGroup.
function radiusMethodRadioGroup_SelectionChangedFcn(hObject, eventdata, handles)
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

% Function used to check for weird cases, like when function used to collect
% radius/height is x^(1/2) and a negative bound is used, which is awkward
% since x^(1/2) doesn't accept negative values.
function valid = isValidVolume(funcChoice, methChoice, lowBound, upBound, axisOrient)
% Cases
valid = 1;
if (axisOrient == "y")
    % Cases where shell method rotating area parallel to axis parallel to
    % x-axis. Here, can't enter a negative bound when the function
    % selected is x^2 or 2^x.
    if (methChoice == "Shell")
       if (funcChoice == "x^2" || funcChoice == "2^x")
           if (lowBound < 0 || upBound < 0)
               valid = 0;
           end
       end
    end
    % Cases where disk method rotating area perpendicular to axis parallel
    % to y-axis. Here, can't enter a negative bound when the function
    % selected is x^2 or 2^x.
else
    if (methChoice == "Disk")
       if (funcChoice == "x^2" || funcChoice == "2^x")
           if (lowBound < 0 || upBound < 0)
               valid = 0;
           end
       end
    end
end
end

% Function that tries to reset viewing angle to what it was before some
% error messages that, for example, views a 3D object from the top.
function resetViewAngle
    global az;
    global el;
    [az, el] = view;
end
