% In this version, try to make the volume button press and make the plot
% and descriptions when any parameter is changed.

function varargout = VUC(varargin)
% Last Modified by GUIDE v2.5 20-Sep-2018 15:49:35

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
resetImage = imread('img/reset1.jpg');
set(handles.resetButton, 'CData', resetImage);
% Update handles structure2
guidata(hObject, handles);
global lowerBound;
lowerBound = 0;
global upperBound;
upperBound = 1;
global inverseLowerBound;
inverseLowerBound = 0;
global inverseUpperBound;
inverseUpperBound = 1;
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

% ax=axes;
% text('Hello World!', 'Parent', ax);
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
global axisValue;

functionContents = cellstr(get(handles.functionMenu, 'String'));
functionContents = functionContents{get(hObject, 'Value')};

% Check for case where switching function and function not one-to-one given
% axis and boundary configurations, or "Select a function" picked.
if (strcmp(functionContents, "Select a function") || ~isValidVolume(functionContents(6:end), ...
        methodChoice, lowerBound, upperBound, axisOri))
    
    if (strcmp(functionContents, "Select a function"))
        f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
    else
        f = errordlg(sprintf(...
                'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
            , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        viewModeChanged = 1;
    end
    
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
    
% No errors, keep moving along and make new volume.
else
    % Removes "select a function" from function menu when first switched.
%     if (strcmp(functionChoice, "Select a function"))
%       funcList = hObject.String;
%       funcList(1) = [];
%       if get(hObject,'ListboxTop') >= 1
%         set(hObject, 'String', funcList) 
%       end
%       
%       functionContents
%     else
%       
%     end
    
    functionChoice = functionContents;
    
    % Reset parameters of volume once function changed.
    lowerBound = 0;
    upperBound = 1;
    axisValue = 0;
    set(handles.lowerBoundEdit, 'string', lowerBound);
    set(handles.upperBoundEdit, 'string', upperBound);
    set(handles.axisEditbox, 'string', axisValue);
    
    % Reset axis edit to be aligned with the Y-radio button.
    
    
    % Set the inverse bounds and its statement, according to the volume
    % configuration and the newly selected
    if ((methodChoice == "Shell" && axisOri == "y") || (methodChoice == "Disk" && axisOri == "x"))
        [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 1);
    else
        [inverseLowerBound, inverseUpperBound] = inverseBounds(functionChoice(6:end), lowerBound, upperBound, 0);
    end
    
    set(handles.inverseLowBoundChar, 'string', round(inverseLowerBound,3));
    set(handles.inverseUpBoundChar, 'string', round(inverseUpperBound, 4));
    volumeButton_Callback(handles.volumeButton, eventdata, handles);
end
% volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function functionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
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
global originallyNegativeArea;

 % If 3D selected, plot volume using 3D functions. Else, draw patches in
 % 2D. Nothing changes about calculations though, so nest it right.
if (strcmp(functionChoice, "Select a function"))
    f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
else
    if (viewMode == "3D")
        set(handles.figure1, 'pointer', 'watch')
        drawnow;
    end
    
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
    
    simple_exp_string = functionChoice(6:end); % String of function w/o "f(x)="
    
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
    if(strcmp(methodChoice, "Disk"))
        
        % Some test for flipping bounds and inverting them if the original
        % area before a method/axis switch was negative area in reflective
        % function of x^2.
        if (simple_exp_string == "x^2" && originallyNegativeArea == 1 && axisOri == "x")
            actual_volume = diskmethod1(simple_exp_string, lowerBound, upperBound, axisOri, -axisValue);
            estimated_volume = diskmethod2(simple_exp_string, steps, lowerBound, upperBound, axisOri, -axisValue, radiusMethod);
        else
            temp_lowerBound = 0;
            % Takes care of when f(x) = 2^x rotated around vertical axis.
            if (lowerBound == 0 && simple_exp_string == "2^x" && axisOri == "x")
                temp_lowerBound = .0001;
            else
                temp_lowerBound = lowerBound;
            end
            actual_volume = diskmethod1(simple_exp_string, temp_lowerBound, upperBound, axisOri, axisValue);
            estimated_volume = diskmethod2(simple_exp_string, steps, temp_lowerBound, upperBound, axisOri, axisValue, radiusMethod);
        end
        
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
        % View mode is 2D
        else
            volumePatch = drawDisksAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, radiusMethod);
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
        % View mode is in 2D.
        else
            volumePatch = drawShellsAsRects(simple_exp_string, lowerBound, upperBound, steps, axisOri, axisValue, radiusMethod);
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
        [origPlot, mirrorPlot, axis] = plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "x");
      else
          % Original negative area, so flip the axis of rotation across
          % y-axis.
        [origPlot, mirrorPlot, axis] = plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "y");
        
      end
      xlim(shape_plot_xlim);
      ylim(shape_plot_ylim);
      zlim(shape_plot_zlim);
    else
%       plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "x");
      [origPlot, mirrorPlot, axis] = plotWithReflection(simple_exp_string, lowerBound, upperBound,  axisOri, axisValue, viewMode, "x");
    end
    
    % If the viewmode is in 2D, add the volume's 2D patch to the legend.
    if(viewMode == "2D")
       leg = legend([origPlot, mirrorPlot, axis, volumePatch], "f(x) = " + simple_exp_string, ...
           "f(x) mirrored", "Axis of rotation", "Rotated Area", 'location', 'northeast');
    else
       leg = legend([origPlot, mirrorPlot, axis], "f(x) = " + simple_exp_string, ...
           "f(x) mirrored", "Axis of rotation", 'location', 'northeast');
    end
    
    leg.FontSize = 12;
    uistack(axis,"top") % Axis line
    uistack(leg,"top")
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
    
    if (viewMode == "3D")
        set(handles.figure1, 'pointer', 'arrow')
    end
    
%     legend = findobj('type', 'legend')
%     A = legend.String;
%     a= A{1}
%     b=A{2}
%     c= A{3}
%     A{4} = 'Rotated Area'
%     legendI
end
end

% Setting the number of subintervals that comprise of the estimated volume.
function diskEdit_Callback(hObject, eventdata, handles)
    global lowerBound;
    global upperBound;
    global diskWidth;
    global steps;
    global functionChoice;
    
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
    
    if (~strcmp(functionChoice, "Select a function"))
        volumeButton_Callback(handles.volumeButton, eventdata, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function diskEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diskEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'TooltipString', ...
    sprintf("Enter a number between 0 and 75 to set the number \n of subintervals in determining the estimated volume."));
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
    global inverseLowerBound;
    global inverseUpperBound;
    
    lower_input = str2double(get(hObject,'String'));
    funcString = functionChoice(6:end);
    
    if (strcmp(functionChoice, "Select a function"))
        f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    elseif(isnan(lower_input))
        d = errordlg('The new bound must be a real number.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
    elseif(lower_input >= upperBound)
        d = errordlg('The upper bound must be greater than the lower bound.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % Lower bound must be within range of -50 and 50.
    elseif(lower_input < -50 || lower_input > 50)
        d = errordlg('The bound value must fall within the range of -50 and 50.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.lowerBoundEdit, 'string', lowerBound);
        viewModeChanged = 1;
    % If entering lower bound to create invalid instance, produce error
    % message and reset bound to what it was previously.
    elseif (~isValidVolume(funcString, methodChoice, lower_input, upperBound, axisOri))
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
    else
        % Changed the upper bound and the bounds are not the same sign
        % (lower bound negative whie upper bound positive), change the
        % lower bound to 0 and alert the user this happened and
        
        % Different signs between upper bound and new lower bound. Change
        % upper bound to 0.
        tempUpper = upperBound;
        if (sameSigns(upperBound, lower_input) == 0 && funcString ~= "2^x")
            if (upperBound > 0)
                tempUpper = 0;
                
%                 set(handles.upperBoundEdit, 'string', upperBound);
                f = warndlg(sprintf(...
                    'In minimizing complexity of generated volumes, the bounds should have the same signs, with the exception of areas under the function, 2^x.\n\nThe upper bound will be changed to 0.')...
                    , 'Bounds Update');
                set(f, 'WindowStyle', 'modal');
                uiwait(f);
                viewModeChanged = 1;
            end
        end
        
        % Set the inverse bounds based on new lower bound and upper bound.
        [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
            lower_input, tempUpper, 0);
        
%         set(handles.upperBoundEdit, 'string', tempUpper);
        
        % Inverse bound of lower bound turns out to be greater than that
        % of upper bound, swap the inverse bounds in the statement on GUI.
        if (inverseLowerBound > inverseUpperBound)
            temp_upper = inverseUpperBound;
            inverseUpperBound = inverseLowerBound;
            inverseLowerBound = temp_upper;
        end
        
        set(handles.upperBoundEdit, 'string', tempUpper);
        set(handles.inverseLowBoundChar, 'string', round(inverseLowerBound, 4));
        set(handles.inverseUpBoundChar, 'string', round(inverseUpperBound, 4));
        
        if (~axisOutsideBounds(funcString, methodChoice, lower_input, tempUpper, axisOri, axisValue))
            if (methodChoice == "Shell")
                d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the X-bounds of the area to be rotated, hightlighted to the left.'),'Shell Volume Error');
                set(handles.xBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                set(handles.xBoundsBackground ,'ShadowColor', [1 .2 0])
                set(handles.lowerBoundEdit ,'BackgroundColor', [.706 1 1])
                set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                set(d, 'WindowStyle', 'modal');
                uiwait(d);
                set(handles.xBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                set(handles.xBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                set(handles.lowerBoundEdit ,'BackgroundColor', [1 1 1])
            elseif (methodChoice == "Disk")
                d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the Y-bounds of the area, highlighted to the left.'),'Disk Volume Error');
                set(handles.yBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                set(handles.yBoundsBackground ,'ShadowColor', [1 .2 0])
                set(handles.lowerBoundEdit ,'BackgroundColor', [.706 1 1])
                set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                set(d, 'WindowStyle', 'modal');
                uiwait(d);
                set(handles.yBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                set(handles.yBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                set(handles.lowerBoundEdit ,'BackgroundColor', [1 1 1])
            end
            set(handles.lowerBoundEdit, 'string', lowerBound);
            set(handles.upperBoundEdit, 'string', upperBound);
            
            % Reset the inverse bounds to what they were in the previous,
            % vaid state of program.
            [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                lowerBound, upperBound, 0);


            % Inverse bound of lower bound turns out to be greater than that
            % of upper bound, swap the inverse bounds in the statement on GUI.
            if (inverseLowerBound > inverseUpperBound)
                temp_upper = inverseUpperBound;
                inverseUpperBound = inverseLowerBound;
                inverseLowerBound = temp_upper;
            end
            set(handles.inverseLowBoundChar, 'string', round(inverseLowerBound, 4));
            set(handles.inverseUpBoundChar, 'string', round(inverseUpperBound, 4));
        else
            lowerBound = lower_input;
            upperBound = tempUpper;
        end
        volumeButton_Callback(handles.volumeButton, eventdata, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function lowerBoundEdit_CreateFcn(hObject, eventdata, handles)
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'TooltipString', ...
    sprintf("Enter the lower bound for the area to be rotated.\nMin.: -50\nMax.: 50"));
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
    global inverseLowerBound;
    global inverseUpperBound;
    
    upper_input = str2double(get(hObject,'String'));
    funcString = functionChoice(6:end);
    
    if (strcmp(functionChoice, "Select a function"))
        f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.upperBoundEdit, 'string', upperBound);
    elseif(isnan(upper_input))
        d = errordlg('The new bound must be a real number.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
    elseif(upper_input <= lowerBound)
        d = errordlg('The upper bound must be greater than the lower bound.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    elseif(upper_input < -50 || upper_input > 50)
        d = errordlg('The bound value must fall within the range of -50 and 50.', 'Bound Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    elseif (~isValidVolume(funcString, methodChoice, lowerBound, upper_input, axisOri))
        f = errordlg(sprintf(...
            'Cannot enter negative bounds, as the function\nis not one-to-one within the domain entered.\n              e.g y=2^x, 0<y<infinity')...
        , 'Invalid Volume Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.upperBoundEdit, 'string', upperBound);
        viewModeChanged = 1;
    else
        % Changed the upper bound and the bounds are not the same sign
        % (lower bound negative whie upper bound positive), change the
        % lower bound to 0 and alert the user this happened and why.
        tempLower = lowerBound;
        if (sameSigns(upper_input, lowerBound) == 0 && funcString ~= "2^x")
            if (upper_input > 0)
                tempLower = 0;
                [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                    tempLower, upper_input, 0);
                
%                 opts = struct('WindowStyle','modal', 'Interpreter','tex');
%                 f = warndlg('\fontsize{15} In minimizing complexity of generated volumes, the bounds should have the same signs, with the exception of areas under the function, 2^x.\n\nThe lower bound will be changed to 0.', 'Bounds Update', opts);
                f = warndlg(sprintf('In minimizing complexity of generated volumes, the bounds should have the same signs, with the exception of areas under the function, 2^x.\n\nThe lower bound will be changed to 0.'), 'Bounds Update');
                set(f, 'WindowStyle', 'modal');
                uiwait(f);
                viewModeChanged = 1;
            end
        end
        
         [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
            tempLower, upper_input, 0);
        
         % Inverse bound of lower bound turns out to be greater than that
         % of upper bound, swap the inverse bounds in the statement on GUI.
         if (inverseLowerBound > inverseUpperBound)
            [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                upper_input, tempLower, 0);
         end
         
        % Set the inverse upper bound according to the new upper bound, and display the new
        % inverse range.
        set(handles.lowerBoundEdit, 'string', tempLower);
        set(handles.inverseLowBoundChar, 'string', round(inverseLowerBound, 4));
        set(handles.inverseUpBoundChar, 'string', round(inverseUpperBound, 4));
        
        % Lower bound is such that: lower bound < axis value < upper bound,
    % which is invalid for creating volumes in that axis of rotation is between bounds.
        if (~axisOutsideBounds(funcString, methodChoice, tempLower, upper_input, axisOri, axisValue))
            if (methodChoice == "Shell")
                d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the X-bounds of the area to be rotated,\nhighlighted on the left.'),'Shell Volume Error');
                set(handles.xBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                set(handles.xBoundsBackground ,'ShadowColor', [1 .2 0])
                set(handles.upperBoundEdit ,'BackgroundColor', [.706 1 1])
                set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                set(d, 'WindowStyle', 'modal');
                uiwait(d);
                set(handles.xBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                set(handles.xBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                set(handles.upperBoundEdit ,'BackgroundColor', [1 1 1])
            elseif (methodChoice == "Disk")
                d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the Y-bounds of the area, highlighted to the left.'),'Disk Volume Error');
                set(handles.yBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                set(handles.yBoundsBackground ,'ShadowColor', [1 .2 0])
                set(handles.upperBoundEdit ,'BackgroundColor', [.706 1 1])
                set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                set(d, 'WindowStyle', 'modal');
                uiwait(d);
                set(handles.yBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                set(handles.yBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                set(handles.upperBoundEdit ,'BackgroundColor', [1 1 1])
            end
            set(handles.lowerBoundEdit, 'string', lowerBound);
            set(handles.upperBoundEdit, 'string', upperBound);
            % Reset the inverse bounds to what they were in the previous,
            % vaid state of program.
            [inverseLowerBound, inverseUpperBound] = inverseBounds(funcString, ...
                lowerBound, upperBound, 0);

            % Inverse bound of lower bound turns out to be greater than that
            % of upper bound, swap the inverse bounds in the statement on GUI.
            if (inverseLowerBound > inverseUpperBound)
                temp_upper = inverseUpperBound;
                inverseUpperBound = inverseLowerBound;
                inverseLowerBound = temp_upper;
            end
            set(handles.inverseLowBoundChar, 'string', round(inverseLowerBound, 4));
            set(handles.inverseUpBoundChar, 'string', round(inverseUpperBound, 4));
%             set(handles.upperBoundEdit, 'string', upperBound);
        else
            lowerBound = tempLower;
            upperBound = upper_input;
        end
    volumeButton_Callback(handles.volumeButton, eventdata, handles);
    end
% volumeButton_Callback(handles.volumeButton, eventdata, handles);
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
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'TooltipString', ...
    sprintf("Enter the upper bound for the area to be rotated.\nMin.: -50\nMax.: 50"));
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
   
    if (strcmp(functionChoice, "Select a function"))
        f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
        set(f, 'WindowStyle', 'modal');
        uiwait(f);
        set(handles.axisEditbox, 'string', axisValue);
    elseif(isnan(axis_input))
        d = errordlg('The axis value must be a real number.', 'Axis Value Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        set(handles.axisEditbox, 'string', axisValue);
    elseif (~axisOutsideBounds(functionChoice(6:end), methodChoice, lowerBound, upperBound, axisOri, axis_input))
        if (methodChoice == "Shell")
            d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the bounds of the area to be rotated, hightlighted to the left.'),'Shell Volume Error');
            set(handles.xBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statenebt to illustrate limits of vertical.
            set(handles.xBoundsBackground ,'ShadowColor', [1 .2 0])
            set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
            set(handles.xBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) % 
            set(handles.xBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
            set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
        elseif (methodChoice == "Disk")
            d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the Y-bounds of the area, highlighted to the left.'),'Disk Volume Error');
            set(handles.yBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statenebt to illustrate limits of vertical.
            set(handles.yBoundsBackground ,'ShadowColor', [1 .2 0])
            set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
            set(d, 'WindowStyle', 'modal');
            uiwait(d);
            set(handles.yBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) % 
            set(handles.yBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
            set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
        end
        set(handles.axisEditbox, 'string', axisValue);
    else
        axisValue = axis_input;
        volumeButton_Callback(handles.volumeButton, eventdata, handles);
    end
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

set(hObject, 'TooltipString', ...
    sprintf("Enter a real number to set the axis of rotation, perpendicular to the axis orientation selected.\nIf 'X' selected, the new axis value must be outside of the X-boundaries, set within the 'Bounds of Area' box above.\n Otherwise, if 'Y' selected, the new axis value must be outside of the Y-boundaries."));
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
global viewMode;

% Get selected axis from radio button. If Disk method selected, bound
% statement in perspective of opposite axis
axisPicked = lower(get(get(handles.axisButtonGroup,'SelectedObject'),'string'));

% Switching axis orientation and the volume to be generated violates the
% negative bounds constraint under some configurations, i.e. when y=2^x,
% 0<y<infinity. If this occurs, make error message and switch back to
% previous axis orientation.
if (strcmp(functionChoice, "Select a function"))
    f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
    position = get(handles.axisEditbox,'Position');
    
    if (axisOri == "x")
        position(2) = 2.9;
        set(handles.axisEditbox, 'Position', position)
        set(handles.xAxisRadio,'Value', 1)
        set(handles.xAxisRadio,'string',"X    =")
        set(handles.yAxisRadio,'string',"Y")
        set(handles.methodText, 'string', "Shell");
        set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
    elseif (axisOri == "y")
        position(2) = 0.76923;
        set(handles.axisEditbox, 'Position', position)
        set(handles.yAxisRadio,'Value', 1)
        set(handles.yAxisRadio,'string',"Y    =")
        set(handles.xAxisRadio,'string',"X")
        set(handles.methodText, 'string', "Disk");
        set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
    end
else
    % If new orientation selected, prompt user to enter a new axis value,
    % or go back to previous configuration. Then, update the plot and GUI
    % based afterwards.
    if (axisPicked ~= axisOri)
        if (axisPicked == "y")
          set(handles.yBoundsBackground ,'HighlightColor', [0 .71 1]) % Highlight around x-boundary statenebt to illustrate limits of vertical.
          set(handles.yBoundsBackground ,'ShadowColor', [0 1 1])
        else
          set(handles.xBoundsBackground ,'HighlightColor', [0 .71 1]) % Highlight around x-boundary statenebt to illustrate limits of vertical.
          set(handles.xBoundsBackground ,'ShadowColor', [0 1 1])
        end
        
        position = get(handles.axisEditbox,'Position');
        
        % Positions the axis value box adjacent to the axis orientation selected.
        % Also sets the axis orientation parameter in the volume function.
        if (axisPicked == "x")
            position(2) = 2.9;
            set(handles.axisEditbox, 'Position', position)
            set(get(handles.axisButtonGroup,'SelectedObject'),'string',"X    =")
            set(handles.yAxisRadio,'string',"Y")
            set(handles.methodText, 'string', "Shell");
            set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
        else
            position(2) = 0.76923;
            set(handles.axisEditbox, 'Position', position)
            set(get(handles.axisButtonGroup,'SelectedObject'),'string',"Y    =")
            set(handles.xAxisRadio,'string',"X")
            set(handles.methodText, 'string', "Disk");
            set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
        end
        
        % Prompts user to enter a new axis value.
        prompt = {sprintf('Enter a new number for the axis value to rotate the area about(or enter 0 to rotate about the x/y-axis).\n\nMake sure the new axis value is outside the bounds highlighted to the left.')};
        title = 'Axis Change';
        definput = {'0'};
        opts.Interpreter = 'tex';
        enteredAxis = inputdlg(prompt,title,[1 40],definput,opts);
        enteredAxisString = cell2mat(enteredAxis);
        newAxisValue = str2double((enteredAxisString));
        
        % New axis value entered not a number, error message and revert
        % GUI.
        if(isnan(newAxisValue))
            %Error message if user entered non-numeric value, instead of hitting
            %'Cancel'.
            if(~isempty(enteredAxisString))
                d = errordlg('The axis value must be a real number.', 'Axis Value Error');
                set(d, 'WindowStyle', 'modal');
                uiwait(d);
            end
            
            % Reset axis box and selected axis string to what it
            % was before error
            if (axisPicked == "y")
                position(2) = 2.9;
                set(handles.axisEditbox, 'Position', position)
                set(handles.xAxisRadio, 'value', 1.0)
                set(handles.xAxisRadio,'string',"X    =")
                set(handles.yAxisRadio,'string',"Y")
                set(handles.methodText, 'string', "Shell");
                set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
            elseif (axisPicked == "x")
                position(2) = 0.76923;
                set(handles.axisEditbox, 'Position', position)
                set(handles.yAxisRadio, 'value', 1.0)
                set(handles.yAxisRadio,'string',"Y    =")
                set(handles.xAxisRadio,'string',"X")
                set(handles.methodText, 'string', "Disk");
                set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
            end
        else % New axis value is valid number, but must be checked so that it's not violating
             % constraint between axis value, bounds and volume method.
             
             % Based on axis orientation selected, create local variable
             % that is either the disc or shell method, in case the new
             % axis value is not valid with the method that is
             % attempted to be used, and switch back to what it was before.
             if (axisPicked == "y")
                 methodFor_AoB_Check = "Disk";
             elseif (axisPicked == "x")
                 methodFor_AoB_Check = "Shell";
             end
             
             set(handles.axisEditbox, 'string', newAxisValue);
             
             if (~axisOutsideBounds(functionChoice(6:end), methodFor_AoB_Check, lowerBound, upperBound, axisPicked, newAxisValue))
                 % Constraint violated trying to make disc volume.
                 if (axisPicked == "y")
                     d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the Y-bounds of the area to be rotated,\nhighlighted on the left.'),'Disk Volume Error');
                     set(handles.yBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                     set(handles.yBoundsBackground ,'ShadowColor', [1 .2 0])
                     set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                     set(d, 'WindowStyle', 'modal');
                     uiwait(d);
                     set(handles.yBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                     set(handles.yBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                     set(handles.xAxisRadio,'value', 1)
                     set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                     
                     % Reset axis box and selected axis string to what it
                     % was before error, to be aligned with x-radio.
                     position(2) = 2.9;
                     set(handles.axisEditbox, 'Position', position)
                     set(get(handles.axisButtonGroup,'SelectedObject'),'string',"X    =")
                     set(handles.yAxisRadio,'string',"Y")
                     set(handles.methodText, 'string', "Shell");
                     set(handles.radiusMethodRadioGroup, 'title', 'Method of Shell Height');
                     
                 % Constraint violated trying to make shell volume.
                 elseif (axisPicked == "x")
                     d = errordlg(sprintf('Cannot generate a shell volume, given the axis of rotation\nis set between the X-bounds of the area to be rotated,\nhighlighted on the left.'),'Shell Volume Error');
%                      d = errordlg(sprintf('Cannot generate a disk volume, given the axis of rotation\nis set between the Y-bounds of the area to be rotated,\n' ...
%                         + 'highlighted on the left.'),'Disk Volume Error');
                     set(handles.xBoundsBackground ,'HighlightColor', [1 .2 0]) % Highlight around x-boundary statement to show bound violated.
                     set(handles.xBoundsBackground ,'ShadowColor', [1 .2 0])
                     set(handles.axisEditbox ,'BackgroundColor', [0.969 0.816 0.816])
                     set(d, 'WindowStyle', 'modal');
                     uiwait(d);
                     set(handles.xBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) %
                     set(handles.xBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
                     set(handles.yAxisRadio,'value', 1)
                     set(handles.axisEditbox ,'BackgroundColor', [1 1 1])
                     
                     % Reset axis box and selected axis string to what it
                     % was before error, to be aligned with y-radio.
                     position(2) = 0.76923;
                     set(handles.axisEditbox, 'Position', position)
                     set(get(handles.axisButtonGroup,'SelectedObject'),'string',"Y    =")
                     set(handles.xAxisRadio,'string',"X")
                     set(handles.methodText, 'string', "Disk");
                     set(handles.radiusMethodRadioGroup, 'title', 'Method of Disc Radius');
                 end
                 set(handles.axisEditbox, 'string', axisValue);
                 
             % Axis meets constraint, generate new volume and set new
             % volume method.
             else
                 axisOri = axisPicked;
                 axisValue = newAxisValue;
                 methodChoice = methodFor_AoB_Check;
             end
        end
    end
    
    % Reset that highlight around the bounds that are constrainted from the
    % user's new axis value to enter,
    if (axisPicked == "y")
        set(handles.yBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) % 
        set(handles.yBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
    else
        set(handles.xBoundsBackground ,'HighlightColor', [0.94 0.94 0.94]) % 
        set(handles.xBoundsBackground ,'ShadowColor', [0.94 0.94 0.94])
    end
    
    % Upon selection of the rotation method used, make changes to UI, changing
    % some titles.
    subIntsLabelString = "Number of " + methodChoice + "s";
    set(handles.subintervalGroup, 'title', subIntsLabelString);

    if(viewMode == "3D")
        set(handles.solidViewRadiogroup, 'Visible', "on");
        set(handles.subintervalGroup, 'title', subIntsLabelString);
    else
        set(handles.solidViewRadiogroup, 'Visible', "off");
    end
    volumeButton_Callback(handles.volumeButton, eventdata, handles);
end
% volumeButton_Callback(handles.volumeButton, eventdata, handles);
end

% --- Executes on button press in homeButton.
function homeButton_Callback(hObject, ~, handles)
close(VUC);
run('homescreen');
end

% --- Executes during object creation, after setting all properties.
function homeButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to homeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to navigate back to Home Screen.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
end

% --- Callback from button group that sets whether to view the solid of
% revolution from a 2D perspective or as 3D volumes.
function threeDButton_Callback(hObject, eventdata, handles)
global viewMode;
global fullSolid;
global viewModeChanged;
global functionChoice;

if (strcmp(functionChoice, "Select a function"))
    f = errordlg('No function selected. Choose one in the "Function Rotated" list to the right.', 'Function Error');
    set(f, 'WindowStyle', 'modal');
    uiwait(f);
else
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
end

% --- Executes during object creation, after setting all properties.
function threeDButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threeDButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when selected object is changed in solidViewRadiogroup.
set(hObject, 'TooltipString', ...
    sprintf("Press to view the current volume as either a 3D representation,\nor a 2D representation as a cross-section of the solid cut along\nthe X-Y plane."));
end

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
    global functionChoice;
    
    steps = ceil(get(handles.stepSlider, 'Value'));
    set(handles.diskEdit, 'string', steps);
    
    if (~strcmp(functionChoice, "Select a function"))
        volumeButton_Callback(handles.volumeButton, eventdata, handles);
    end
end

function stepSlider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject, 'TooltipString', ...
    sprintf("Slide for a number between 0 and 75 to set the number \n of subintervals in determining the estimated volume."));
end

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
close(VUC);
run('VUC');
end

% --- Executes during object creation, after setting all properties.
function resetButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to reset GUI to default values.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
end

% --- Executes when selected object is changed in radiusMethodRadioGroup.
function radiusMethodRadioGroup_SelectionChangedFcn(hObject, eventdata, handles)
global radiusMethod;
global functionChoice;

methodPicked = get(get(handles.radiusMethodRadioGroup,'SelectedObject'),'string');

if(methodPicked == "Left")
    radiusMethod = "l";
elseif (methodPicked == "Midpoint")
    radiusMethod = "m";
elseif (methodPicked == "Right")
    radiusMethod = "r";
end

if (~strcmp(functionChoice, "Select a function"))
    volumeButton_Callback(handles.volumeButton, eventdata, handles);
end
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


% --- Executes during object creation, after setting all properties.
function xBoundsBackground_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xBoundsBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end

% --- Executes during object creation, after setting all properties.
function yBoundsBackground_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yBoundsBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- Executes during object creation, after setting all properties.
function leftRadiusRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftRadiusRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'TooltipString', ...
    sprintf("Click to determine and display the disc's radius / shell's\nheight based on the left-endpoint integration method."));

end

% --- Executes during object creation, after setting all properties.
function midRadiusRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to midRadiusRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'TooltipString', ...
    sprintf("Click to determine and display the disc's radius / shell's\nheight based on the midpoint integration method."));
end

% --- Executes during object creation, after setting all properties.
function rightRadiusRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightRadiusRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'TooltipString', ...
    sprintf("Click to determine and display the disc's radius / shell's\nheight based on the right-point integration method."));
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over axisEditbox.
function axisEditbox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axisEditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
end
