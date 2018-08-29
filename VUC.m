% In this version, try to make the volume button press and make the plot
% and descriptions when any parameter is changed.

function varargout = VUC(varargin)
% Last Modified by GUIDE v2.5 18-Aug-2018 20:38:00

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
resetImage = imread('img/reset.jpg');
set(handles.resetButton, 'CData', resetImage);
% Update handles structure2
guidata(hObject, handles);
global lowerBound;
lowerBound = 0;
global upperBound;
upperBound = 5;
global inverseLowerBound;
inverseLowerBound = 0;
global inverseUpperBound;
inverseUpperBound = 5;
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
global originallyNegativeArea;
originallyNegativeArea = 0;
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
global inverseUpperBound;
global inverseLowerBound;

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
    
    % Set the ivnerse bounds and its statement, according to the volume
    % configuration and the newly selected
    if ((methodChoice == "Shell" && axisOri == "y") || (methodChoice == "Disk" && axisOri == "x"))
%         [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
        [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
    else
%         [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
        [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
    end
    
    set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
    set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
%     set(handles.lowerBoundEdit, 'string', lowerBound);
%     set(handles.upperBoundEdit, 'string', upperBound);
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
global inverseLowerBound;
global inverseUpperBound;
global originallyNegativeArea;

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
    simple_exp_string = functionChoice(6:end); % String of function w/o "f(x)="
    f(x) = str2sym(simple_exp_string);
    
    % If the view option upon redrawing the plot is still 3D, store the
    % viewpoint of the plot to be reused when 3D plot redrawn.
    if (viewMode == "3D")
      [az, el] = view;
    end
    
    % Removes plot contents of axes and turn off 3D rotation in case volume
    % is in 2D.
    delete(handles.axes1.Children)
        cla reset, rotate3d off
        
    % Calls different volume calculation methods depending on method picked. 
    originallyNegativeArea
    if(strcmp(methodChoice, "Disk"))
        
        % Some test for flipping bounds and inverting them if the original
        % area before a method/axis switch was negative area in reflective
        % function of x^2.
        if (simple_exp_string == "x^2" && originallyNegativeArea == 1 && axisOri == "x")
            actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, -axisValue);
        else
            
            % Takes care of when f(x) = 2^x rotated around vertical axis.
            if (lowerBound == 0 && simple_exp_string == "2^x" && axisOri == "x")
                actual_volume = diskmethod1(simple_exp_string, .0001, upperBound, axisOri, axisValue);
            else
                actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
            end
        end
        
        estimated_volume = diskmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, axisValue, radiusMethod);
%         actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, axisValue);
        
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
    % Draw the function line, it's mirror and the axis of rotation, then
    % reuse the axis limits.th
    if (methodChoice == "Shell" || (methodChoice == "Disk" && axisOri == "x"))
      shape_plot_xlim = xlim;
      shape_plot_ylim = ylim;
      shape_plot_zlim = zlim;

      if (methodChoice == "Shell" && axisOri == "x")
        plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "x") 
      else
          % Original negative area, so flip the axis of rotation across
          % y-axis.
%           if (originallyNegativeArea == 1)
%               plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, -axisValue, viewMode, "y") 
%           else
              plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "y") 
%           end
        
      end
      xlim(shape_plot_xlim);
      ylim(shape_plot_ylim);
      zlim(shape_plot_zlim);
    else
      plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "x")
    end
    % Display the estimated and actual volumes and the error percenter b/w
    % both.
    estVolumeString = "Estimated Volume: " + sprintf('%0.4f', estimated_volume);
    actVolumeString = "Actual Volume: " + sprintf('%0.4f', actual_volume);
    errorPerc = ((estimated_volume - actual_volume)/actual_volume)*100;
    errorPerc = round(errorPerc,4);
    
    % New line for volume statements so that string in textboxes aren't
    % overflowing.
    
    if (length(estVolumeString) > 40 || length(actVolumeString) > 40)
        estVolumeString = sprintf("Estimated Volume:\n" + sprintf('%0.4f', estimated_volume));
        actVolumeString = sprintf("Actual Volume:\n" + sprintf('%0.4f', actual_volume));
    end
    
    % Text added on to displayed error percentage, stating estimation type.
    % Set color of error percent statement based on under/overestimate. 
    if (errorPerc < 0)
        estimate_type = " (Underestimate)";
        set(handles.errorText, 'ForegroundColor', 'blue');
    elseif (errorPerc > 0)
        estimate_type = " (Overestimate)";
        set(handles.errorText, 'ForegroundColor', 'red');
    else
        estimate_type = "";
        set(handles.errorText, 'ForegroundColor', 'black');
    end
    
    set(handles.statementText, 'string', estVolumeString);
    set(handles.actualVolumeText, 'string', actVolumeString);
    
    % For undefined percentage, dispaly as 0%
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
    global originallyNegativeArea;
    global inverseLowerBound;
    global inverseUpperBound;
    
    lower_input = str2double(get(hObject,'String'));
    funcString = functionChoice(6:end);
   
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
    elseif (~isValidVolume(funcString, methodChoice, lower_input, upperBound, axisOri))
        plot(0,0);
        f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % Lower bound is such that: lower bound < axis value < upper bound,
    % which is invalid for creating volumes in that axis of rotation is
    % between bounds. If this occurs, error message and revert the lower
    % bound.
    elseif (~axisOutsideBounds(funcString, methodChoice, lower_input, upperBound, axisOri, axisValue))
        if (methodChoice == "Shell")
            d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        elseif (methodChoice == "Disk")
             d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Disk Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        end
        set(handles.lowerBoundEdit, 'string', lowerBound);
        
    else
        % The state of the program is that the bound changed while the
        % volume originated from negative x-bounds for shell object. In
        % the case of changing a, change program's state so that the
        % inverses of the disc volume's bounds are positive integers, so
        % plot different volume.
        if (originallyNegativeArea == 1)
            originallyNegativeArea = 0
            
            [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                lower_input, upperBound, 1);
        
       % Otherwise, just convert the new bound and the range of the
       % function's inverse.
        else
            if ((methodChoice == "Disk" && axisOri == "y") || (methodChoice == "Shell" && axisOri == "x"))
                useInverseFunction = 0;
            else
                useInverseFunction = 1;
            end
        
            [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                lower_input, upperBound, useInverseFunction);
        end
        
        set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
        set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
        
        if (sameSigns(lower_input, upperBound) == 0  && funcString ~= "2^x")
            disp("NOT THE SAME SIGNS. DO SOMETHING")
        end
        
        lowerBound = lower_input;
        
    end
volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function lowerBoundEdit_CreateFcn(hObject, eventdata, handles)

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
    global originallyNegativeArea;
    global inverseLowerBound;
    global inverseUpperBound;
    
    upper_input = str2double(get(hObject,'String'));
    funcString = functionChoice(6:end);
    
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
    elseif (~isValidVolume(funcString, methodChoice, lowerBound, upper_input, axisOri))
        plot(0,0);
        f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    % Lower bound is such that: lower bound < axis value < upper bound,
    % which is invalid for creating volumes in that axis of rotation is between bounds.
    elseif (~axisOutsideBounds(funcString, methodChoice, lowerBound, upper_input, axisOri, axisValue))
        if (methodChoice == "Shell")
            d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        elseif (methodChoice == "Disk")
            d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Disk Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        end
        set(handles.upperBoundEdit, 'string', upperBound);
    else
        % If switching upper bound while current or inverted bounds are
        % negative in case of x^2, reset the thing and switch the inverted
        % bounds to be positive numbers that are the bounds through inverse
        % function.
        if (originallyNegativeArea == 1)
            disp("ORIGINAL NEGATIVE")
            originallyNegativeArea = 0;
            
            if (upper_input <= 0)
              [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
              upper_input, lowerBound, 1);
              disp("YO")
            else
              [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
              lowerBound, upper_input, 1);
            end
        else
            % Determine to use either current function or its inverse based
            % on current volume configuration.
            swapInverseBounds = 0;
            
            if ((methodChoice == "Disk" && axisOri == "y") || (methodChoice == "Shell" && axisOri == "x"))
                useInverseFunction = 0;
                
                % Using shell method with x^2 and the bounds <= 0, swap the
                % lower and upper inverse bounds in the statement.
                if (upper_input <= 0 && funcString == "x^2")
                  swapInverseBounds = 1;
                end
            else
                useInverseFunction = 1;
            end
            
            % Flip the lower and upper inverse bounds.
            if swapInverseBounds == 1
              [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                upper_input, lowerBound, useInverseFunction);
            else
              [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                  lowerBound, upper_input, useInverseFunction);
            end
        end
        
        % Set the inverse upper bound according to the new upper bound, and display the new
        % inverse range.
        set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
        set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
        
        if (sameSigns(upper_input, lowerBound) == 0 && funcString ~= "2^x")
            disp("NOT THE SAME SIGNS. DO SOMETHING")
        end
        
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
global axisOri;
global axisValue;
global lowerBound;
global upperBound;
global functionChoice;
global inverseLowerBound;
global inverseUpperBound;
global originallyNegativeArea;

methodContents = get(get(handles.methodRadioGroup,'SelectedObject'),'string');

% If switching from disc to shell method and the resulting shell volume
% cannot be generating due to the axis constraint, revert back to the disk
% method. Else, assign the global variable methodChoice to whatever selected.
if (methodChoice == "Disk" && methodContents == "Shell" && ...
        ~axisOutsideBounds(functionChoice(6:end), methodContents, lowerBound, upperBound, axisOri, axisValue))
    opts.Interpreter = 'tex';
    opts.Default = 'Cancel';
    fontSettings = '\fontsize{12}';
    warningMessage = strcat(fontSettings, {'Warning: by switching to the Shell method, a volume '}, ...
        {'would fail to generate, given the current axis of rotation is between the bounds of the area. '}, ...
        {'You can set a new axis below, or hit "Cancel" to revert back to the previous parameters.'});
    
%     if ((methodContents == "Shell" && axisOri == "y") || (methodContents == "Disk" && axisOri == "x"))
%         [tempInverseLower, tempInverseUpper] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
%     end
    lowBoundAxis = axisOri + "=" + num2str(lowerBound);
    upperBoundAxis = axisOri + "=" + num2str(upperBound);
    
    answer = questdlg(warningMessage, 'Warning', lowBoundAxis,...
        upperBoundAxis, 'Cancel', opts);
    switch answer
        case lowBoundAxis
            methodChoice = "Shell";
            axisValue = lowerBound;
            set(handles.axisEditbox, 'string', axisValue);
        case upperBoundAxis
            methodChoice = "Shell";
            axisValue = upperBound;
            set(handles.axisEditbox, 'string', axisValue);
        case 'Cancel'
            set(handles.discRadio, 'Value', 1.0);
    end
    
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
    % If the method changes, and the domain of the integration changes
    % between the x and y-axis, change the bounds accordingly so same
    % volume generated. Also display inverse of the new bounds.
    if (~strcmp(methodChoice, methodContents))
        syms x
        f(x) = str2sym(functionChoice(6:end));
        
        % Configurations in which domain for integration is in respect to dY.
        if ((methodContents == "Shell" && axisOri == "y") || (methodContents == "Disk" && axisOri == "x"))
            
            % Switching to disk dY from shell dXand the function is x^2, bounds are both
            % negative. In this case, make inverse bounds the original
            % negative bounds, flip them and change the actual bounds using
            % the original function.
            if (functionChoice(6:end) == "x^2" && lowerBound <= 0 && upperBound <= 0)
                inverseLowerBound = lowerBound
                inverseUpperBound = upperBound
                [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), -upperBound, -lowerBound, 0);
                originallyNegativeArea = 1
            else
                [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
                [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
            end
            
            % If switching to domain in respect to dX, use regular function
        % selected to reset the bounds.
        elseif ((methodContents == "Shell" && axisOri == "x") || (methodContents == "Disk" && axisOri == "y"))
            if (originallyNegativeArea == 1)
                lowerBound = inverseLowerBound;
                upperBound = inverseUpperBound;
                [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), inverseUpperBound, inverseLowerBound, 0);
            else
                [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
                [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
            end
        end
        
        set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
        set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        set(handles.upperBoundEdit, 'string', upperBound);
    end
    methodChoice = methodContents;
end

subIntsLabelString = "Number of " + methodChoice + "s";
set(handles.subintervalGroup, 'title', subIntsLabelString);

% Upon selection of the rotation method used, make changes to UI, changing
% some titles.
if(viewMode == "3D")
  set(handles.solidViewRadiogroup, 'Visible', "on");
  set(handles.subintervalGroup, 'title', subIntsLabelString);
else
  set(handles.solidViewRadiogroup, 'Visible', "off");
end

% Based on method and the axis orientation picked, reset the bound 
% and the inverse bound statements in the boundary section.
if (methodChoice == "Shell")
  set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
  if (axisOri == "y")
    set(handles.boundStatement, 'string', "< Y <");
    set(handles.inverseAxisBoundStatement, 'string', "< X <");
  else
    set(handles.boundStatement, 'string', "< X <");
    set(handles.inverseAxisBoundStatement, 'string', "< Y <");
  end
else
  set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
    if (axisOri == "y")
      set(handles.boundStatement, 'string', "< X <");
      set(handles.inverseAxisBoundStatement, 'string', "< Y <");
    else
      set(handles.boundStatement, 'string', "< Y <");
      set(handles.inverseAxisBoundStatement, 'string', "< X <");
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
    global functionChoice;
    global axisOri;
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
    elseif (~axisOutsideBounds(functionChoice(6:end), methodChoice, lowerBound, upperBound, axisOri, axis_input))
        if (methodChoice == "Shell")
            d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Shell Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        elseif (methodChoice == "Disk")
            d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the bounds of the area to be rotated.'),'Disk Volume Error');
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
        end
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

% --- Executes when axis orientation is selected in button group of axes
% buttons.
function axisButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
global axisOri;
global functionChoice;
global lowerBound;
global upperBound;
global methodChoice;
global axisValue;
global inverseLowerBound;
global inverseUpperBound;
global originallyNegativeArea;

% Get selected axis from radio button. If Disk method selected, bound
% statement in perspective of opposite axis
axisPicked = get(get(handles.axisButtonGroup,'SelectedObject'),'string');

% Switching axis orientation and the volume to be generated violates the
% negative bounds constraint under some configurations, i.e. when y=2^x,
% 0<y<infinity. If this occurs, make error message and switch back to
% previous axis orientation.
if (~isValidVolume(functionChoice(6:end), methodChoice, lowerBound, upperBound, axisPicked))
    f = errordlg(sprintf(...
        'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
    set(handles.yAxisRadio, 'Value', 1.0);
else
    % If new orientation selected, prompt user to enter a new axis value,
    % or go back to previous configuration. Then, update the plot and GUI
    % based afterwards.
    if (axisPicked ~= axisOri)
        
        % Change and paramters to assist user in determining new axis.
        if (methodChoice == "Disk")
            if (axisPicked == "x")
                bound_statement = "< Y <";
                inverse_bound_statement = "< X <";
            else
                bound_statement = "< X <";
                inverse_bound_statement = "< Y <";
            end
        else
            bound_statement = "< " + upper(axisPicked(1)) + " <";
            
            if (axisPicked == "x")
                inverse_bound_statement = "< Y <";
            else
                inverse_bound_statement = "< X <";
            end
        end
        set(handles.boundStatement, 'string', bound_statement);
        set(handles.inverseAxisBoundStatement, 'string', inverse_bound_statement);
         
        % Inverts the bounds, while the user is prompted for a new axis to
        % show the forbidden space for the new axis.
        if ((methodChoice == "Shell" && axisPicked == "y") || (methodChoice == "Disk" && axisPicked == "x"))
            [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
            [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
        else
            [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
            [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
        end
        
        set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
        set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        set(handles.upperBoundEdit, 'string', upperBound);
        % END SWITCHING PARAMETER ZONE
        
        prompt = {'Enter a new number for the axis value to rotate the area about, or enter 0 to rotate about the x/y-axis).'};
        title = 'Axis Change';
        definput = {'0'};
        opts.Interpreter = 'tex';
        newAxisValue = inputdlg(prompt,title,[1 40],definput,opts);
        
        if(isnan(str2double(newAxisValue)))
            disp("Not a number!")
            % CHANGE TO ERROR MESSAGE AND REVERT TO PREVIOUS
        
        % Change paramters back to what it was before (down to line 718).
        % If 'cancel' selected, revert to previous axis orientation.
        elseif (isempty(newAxisValue)) 
            if ((methodChoice == "Shell" && axisOri == "y") || (methodChoice == "Disk" && axisOri == "x"))
                [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
                [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
            else
            % If switching to domain in respect to dX, use regular function
            % selected to reset the bounds.
                [lowerBound, upperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
                [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
                
            end
            
            set(handles.inverseLowBoundChar, 'string', inverseLowerBound);
            set(handles.inverseUpBoundChar, 'string', inverseUpperBound);
            set(handles.lowerBoundEdit, 'string', lowerBound);
            set(handles.upperBoundEdit, 'string', upperBound);
            
            if (axisOri == "x")
                set(handles.xAxisRadio, 'value', 1.0)
                axisPicked = "x";
            else
                set(handles.yAxisRadio, 'value', 1.0)
                axisPicked = "y";
            end
            
            set(handles.axisEditbox, 'string', axisValue);
        else
            axisValue = str2double(newAxisValue);
            set(handles.axisEditbox, 'string', axisValue);
        end
end
    if (methodChoice == "Disk")
        if (axisPicked == "x")
            bound_statement = "< Y <";
            inverse_bound_statement = "< X <";
        else
            bound_statement = "< X <";
            inverse_bound_statement = "< Y <";
        end
    else
        bound_statement = "< " + upper(axisPicked(1)) + " <";
            
        if (axisPicked == "x")
            inverse_bound_statement = "< Y <";
        else
            inverse_bound_statement = "< X <";
        end
    end
    
    set(handles.boundStatement, 'string', bound_statement);
    set(handles.inverseAxisBoundStatement, 'string', inverse_bound_statement);
    
    position = get(handles.axisEditbox,'Position');
    
    % Positions the axis value box adjacent to the axis orientation selected.
    % Also sets the axis orientation parameter in the volume function.
    if (axisPicked == "x")
        position(2) = 2.9;
        set(handles.axisEditbox, 'Position', position)
        set(get(handles.axisButtonGroup,'SelectedObject'),'string',"x     =")
        set(handles.yAxisRadio,'string',"y")
    else
        position(2) = 0.76923;
        set(handles.axisEditbox, 'Position', position)
        set(get(handles.axisButtonGroup,'SelectedObject'),'string',"y     =")
        set(handles.xAxisRadio,'string',"x")
    end
    axisOri = axisPicked;
end
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

function stepSlider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
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
elseif (axisOrient == "x")
    if (methChoice == "Disk")
       if (funcChoice == "x^2" || funcChoice == "2^x")
           if (lowBound < 0 || upBound < 0)
               valid = 0;
           end
       end
    end
end
end

function [newLower, newUpper] = inverseBounds(functionString, lowerBound, upperBound, inverse)

% If the method/axis switches to Disk/Y or Shell/X, generate bounds using
% function's inverse for inverse bounds along x-axis
% bounds.
if (inverse == 1)
    if (functionString == "x^2")
        newLower = lowerBound^(1/2);
        newUpper = upperBound^(1/2);
    % Inversions b/w bounds of function 2^x
    elseif (functionString == "2^x")
        % Undefined case when evaluating log2(0), which is
        % undefined/negative infinity.
        if (lowerBound == 0)
            lowerBound = .0001;
        elseif (upperBound == 0)
            upperBound = .0001;
        end
        
        newLower = double(log2(lowerBound));
        newUpper = double(log2(upperBound));
    % Otherwise, with f(x) = x, bounds among dx and dy are the same.
    else
        newLower = lowerBound;
        newUpper = upperBound;
    end
    
% If the method/axis switches to Disk/X or Shell/Y, generate bounds using
% function for inverse bounds along y-axis
elseif (inverse == 0) 
    if (functionString == "x^2")
        newLower = lowerBound^2;
        newUpper = upperBound^2;
    elseif (functionString == "2^x")
        newLower = 2^lowerBound;
        newUpper = 2^upperBound;
    else
        newLower = lowerBound;
        newUpper = upperBound;
    end
end
end

function sameSigns = sameSigns(bound1, bound2)
    if bound1*bound2 < 0
        sameSigns = 0;
    else
        sameSigns = 1;
    end
end
