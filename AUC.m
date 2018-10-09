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

% Last Modified by GUIDE v2.5 10-Jul-2018 12:18:47

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
function AreaUnderCurve_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AreaUnderCurve (see VARARGIN)

% Choose default command line output for AreaUnderCurve
handles.output = hObject;
% reads in images needed throughout the area under the curve application.
homeImage = imread('homebutton.jpg');
set(handles.homeButton, 'CData', homeImage);
resetImage = imread('reset1.jpg');
set(handles.resetButton, 'CData', resetImage);
% Defines global variables that need to be set before user makes
% selections.
guidata(hObject, handles);
global lowerBound;
global upperBound;
global rectCount;
global methodPicked;
lowerBound = 0;
upperBound = 20;
rectCount = 5;

% initializes subinterval slider to default values.
maxNumberOfRect = 100;
set(handles.intervalSlider, 'Min', 5);
set(handles.intervalSlider, 'Max', maxNumberOfRect);
set(handles.intervalSlider, 'Value', 5);
set(handles.intervalSlider, 'SliderStep', [1/maxNumberOfRect , 10/maxNumberOfRect ]);
% initializes integration method to trapz method.
set(handles.integratioMethodButtonGroup, 'SelectedObject', handles.trapzIntegrationRadioButton);
methodPicked = 'trapz';
% UIWAIT makes AreaUnderCurve wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AreaUnderCurve_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function lowerBoundEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to lowerBoundEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global lowerBound;
global upperBound;
tempLowerBound = lowerBound;
lowerBound = str2double(get(hObject,'String'));
% checks to make sure value entered as the lower bound is an integer.
% Throws an error if that is not the case.
if(isnan(lowerBound))
    d = errordlg('Domain must be an real number', 'Domain Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    lowerBound = tempLowerBound;
    set(handles.lowerBoundEditBox, 'string', lowerBound);
else
    % Error checking to make sure that the lower bound's value is less than
    % the upper bound value
    if(lowerBound < -100)
%         plot(0,0);
        d = errordlg('Lower Domain must be LARGER than -101 and SMALLER than 99.', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        lowerBound = tempLowerBound;
        set(handles.lowerBoundEditBox, 'string', lowerBound);
    end
    if(lowerBound >= upperBound)
%         plot(0,0);
        d = errordlg('Lower Domain must be SMALLER than Upper Domain.', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        lowerBound = tempLowerBound;
        set(handles.lowerBoundEditBox, 'string', lowerBound);
    end
    intervalSlider_Callback(handles.intervalSlider, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function lowerBoundEditBox_CreateFcn(hObject, ~, ~)
% hObject    handle to lowerBoundEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% sets tooltip for lower bound edit text box
toolTipString = sprintf('Enter a real number for lower bound. \nMust be SMALLER THAN 100 \nMust be LARGER THAN -101');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function upperBoundEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global upperBound;
global lowerBound;
tempUpperBound = upperBound;
upperBound = str2double(get(hObject,'String'));
% checks to make sure value entered as the lower bound is an real number.
% Throws an error if that is not the case.
if(isnan(upperBound))
    d = errordlg('Domain must be real number', 'Domain Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    upperBound = tempUpperBound;
    set(handles.upperBoundEditBox, 'string', upperBound);
else
    % Error checking to make sure that the lower bound's value is less than
    % the upper bound value
    if(upperBound > 100)
%         plot(0,0);
        d = errordlg('Upper Domain must be LARGER than -100 and SMALLER than 101.', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        upperBound = tempUpperBound;
        set(handles.upperBoundEditBox, 'string', upperBound);
    end
    if(lowerBound >= upperBound)
%         plot(0,0);
        d = errordlg('Upper Bound must be LARGER than Lower Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        upperBound = tempUpperBound;
        set(handles.upperBoundEditBox, 'string', upperBound);
    end
    intervalSlider_Callback(handles.intervalSlider, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function upperBoundEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% Sets tooltip for upper bound text box
toolTipString = sprintf('Enter a real number for upper bound. \nMust be SMALLER THAN 101 \nMust be LARGER THAN -100');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in functionSelectionDropdownMenu.
function functionSelectionDropdownMenu_Callback(hObject, eventdata, handles)
% hObject    handle to functionSelectionDropdownMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global functionChoice;
global lowerBound;
global upperBound;
% When a function is selected, first all the fields for the exponential and
% polynomial coefficients are hidden.

set(handles.fifthCoefficientEditBox,'Visible','off');
set(handles.fourthCoefficientEditBox,'Visible','off');
set(handles.thirdCoefficientEditBox,'Visible','off');
set(handles.secondCoefficientEditBox,'Visible','off');
set(handles.firstCoefficientEditBox,'Visible','off');
set(handles.constantEditBox,'Visible','off');
set(handles.aBox,'Visible','off');
set(handles.bBox,'Visible','off');
set(handles.cBox,'Visible','off');
set(handles.constantBox,'Visible','off');
set(handles.functionExampleTextBox,'Visible','off');
set(handles.secondDegreeTextBox,'Visible','off');
set(handles.firstDegreeTextBox,'Visible','off');
functionContents = cellstr(get(handles.functionSelectionDropdownMenu, 'String'));
functionChoice = functionContents{get(hObject, 'Value')};
if(strcmp(functionChoice,'Exponential'))
    % set default parameters when creating a exponential function is
    % selected.
    upperBound = 1;
    lowerBound = 0;
    set(handles.lowerBoundEditBox, 'string', lowerBound);
    set(handles.upperBoundEditBox, 'string', upperBound);
    set(handles.fifthCoefficientEditBox, 'string', '1');
    set(handles.fourthCoefficientEditBox, 'string', '1');
    set(handles.thirdCoefficientEditBox, 'string', '0');
elseif(strcmp(functionChoice,'Polynomial'))
    % set default parameters when creating a polynomial function is
    % selected.
    upperBound = 1;
    lowerBound = 0;
    set(handles.lowerBoundEditBox, 'string', lowerBound);
    set(handles.upperBoundEditBox, 'string', upperBound);
    set(handles.fifthCoefficientEditBox, 'string', '0');
    set(handles.fourthCoefficientEditBox, 'string', '0');
    set(handles.thirdCoefficientEditBox, 'string', '0');
    set(handles.secondCoefficientEditBox, 'string', '1');
    set(handles.firstCoefficientEditBox, 'string', '0');
    set(handles.constantEditBox, 'string', '0');
elseif(strcmp(functionChoice,'f(x)=x^3+5*x^2'))
    upperBound = 20;
    lowerBound = 0;
    set(handles.lowerBoundEditBox, 'string', lowerBound);
    set(handles.upperBoundEditBox, 'string', upperBound);
elseif(strcmp(functionChoice,'f(x)=x^2+1'))
    upperBound = 20;
    lowerBound = 0;
    set(handles.lowerBoundEditBox, 'string', lowerBound);
    set(handles.upperBoundEditBox, 'string', upperBound);
end
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function functionSelectionDropdownMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionSelectionDropdownMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% Sets tooltip for functionSelectionDropdownMenu 
toolTipString = sprintf('Select a preset function or\ncreate an exponential or polynomial function.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in calculatePushButton.
function calculatePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to calculatePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global funcSelected;
global lowerBound;
global upperBound;
global rectCount;
global funcText;
global functionChoice;
global methodPicked;
global AUC;
if(strcmp(functionChoice, 'Select a function'))
    resetButton_Callback(handles.resetButton, eventdata, handles);
else
    if(lowerBound > upperBound)
        newString = 'Fix domain';
        set(handles.text4, 'string', newString);
%         plot(0,0);
        d = errordlg('LOWER bound is larger than UPPER bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        if(strcmp(functionChoice, 'Exponential'))
            % When exponential function option is selected:
            %   -Set bounds to 0 and 1.
            %   -Set the function so that it's e^x (first and second boxes = 1)
            newOptions = {'Exponential', 'Polynomial', 'f(x)=x^3+5*x^2','f(x)=x^2+1'};
            set(handles.functionSelectionDropdownMenu,'String',newOptions,'Value',1);
            rectCount = ceil(get(handles.intervalSlider, 'Value'));
            set(handles.functionExampleTextBox, 'string', 'f(x) = a*e^bx + c');
            set(handles.fifthCoefficientEditBox,'Visible','on');
            set(handles.fourthCoefficientEditBox,'Visible','on');
            set(handles.thirdCoefficientEditBox,'Visible','on');
            set(handles.aBox,'Visible','on');
            set(handles.bBox,'Visible','on');
            set(handles.cBox,'Visible','on');
            set(handles.functionExampleTextBox,'Visible','on');
            set(handles.aBox, 'string', 'a =');
            set(handles.bBox, 'string', 'b =');
            set(handles.cBox, 'string', 'c =');
            a = str2double(get(handles.fifthCoefficientEditBox, 'String'));
            b = str2double(get(handles.fourthCoefficientEditBox, 'String'));
            c = str2double(get(handles.thirdCoefficientEditBox, 'String'));
            bStr = get(handles.fourthCoefficientEditBox, 'String');
            bStr = insertBefore(bStr,"","^");
            bStr = bStr(1:1:end-1);
            if(a == 1)
                funcText = "e" + {bStr+ "^x"}+ "+" + c;
            elseif(a == -1)
                funcText = "-e" + {bStr+ "^x"}+ "+" + c;
            elseif(a == 0)
                funcText = '0';
            else
                funcText = a + "e" + {bStr+ "^x"}+ "+" + c;
            end
            funcSelected = 3;
        elseif(strcmp(functionChoice, 'Polynomial'))
            % Makes the forms for the coefficients and their captions visible.
            newOptions = {'Polynomial','Exponential', 'f(x)=x^3+5*x^2','f(x)=x^2+1'};
            set(handles.functionSelectionDropdownMenu,'String',newOptions,'Value',1);
            rectCount = ceil(get(handles.intervalSlider, 'Value'));
            set(handles.fifthCoefficientEditBox,'Visible','on');
            set(handles.fourthCoefficientEditBox,'Visible','on');
            set(handles.thirdCoefficientEditBox,'Visible','on');
            set(handles.secondCoefficientEditBox,'Visible','on');
            set(handles.firstCoefficientEditBox,'Visible','on');
            set(handles.constantEditBox,'Visible','on');
            set(handles.aBox,'Visible','on');
            set(handles.bBox,'Visible','on');
            set(handles.cBox,'Visible','on');
            set(handles.constantBox,'Visible','on');
            set(handles.secondDegreeTextBox,'Visible','on');
            set(handles.firstDegreeTextBox,'Visible','on');
            set(handles.functionExampleTextBox,'Visible','on');
            set(handles.functionExampleTextBox, 'string', 'Coefficients of Degrees');
            set(handles.aBox, 'string', '5th =');
            set(handles.bBox, 'string', '4th =');
            set(handles.cBox, 'string', '3rd =');
            a = str2double(get(handles.fifthCoefficientEditBox, 'String'));
            b = str2double(get(handles.fourthCoefficientEditBox, 'String'));
            c = str2double(get(handles.thirdCoefficientEditBox, 'String'));
            d = str2double(get(handles.secondCoefficientEditBox, 'String'));
            e = str2double(get(handles.firstCoefficientEditBox, 'String'));
            cons = str2double(get(handles.constantEditBox, 'String'));
            if (a == 0)
                funcText = " " + b + "*x^4 + " + c + "*x^3 + " + d + "*x^2 + " + e + "*x + " + cons;
            elseif(a == 1 || a == -1)
                funcText = "*x^5 + " + b + "*x^4 + " + c + "*x^3 + " + d + "*x^2 + " + e + "*x + " + cons;
            else 
                funcText = a + "*x^5 + " + b + "*x^4 + " + c + "*x^3 + " + d + "*x^2 + " + e + "*x + " + cons;
            end
            funcSelected = 4;
        else
             funcText = functionChoice(6:length(functionChoice));
             if(strcmp(funcText,'x^3+5*x^2'))
                 funcSelected = 1;
                 newOptions = {'f(x)=x^3+5*x^2','f(x)=x^2+1','Exponential','Polynomial'};
                 set(handles.functionSelectionDropdownMenu,'String',newOptions,'Value',1);
             elseif(strcmp(funcText,'x^2+1'))
                 funcSelected = 2;
                 newOptions = {'f(x)=x^2+1','f(x)=x^3+5*x^2','Exponential','Polynomial'};
                 set(handles.functionSelectionDropdownMenu,'String',newOptions,'Value',1);
             end
        end

        step = (upperBound - lowerBound)/rectCount;
        x = lowerBound:step:upperBound;
        if(funcSelected == 4)
            t = @(x) a*x.^5+b*x.^4+c*x.^3+d*x.^2+e*x+cons;
            h = fplot(@(x) a*x.^5+b*x.^4+c*x.^3+d*x.^2+e*x+cons, [lowerBound, upperBound], 'r');
        elseif(funcSelected == 3)
            if (strcmp(funcText, "0"))
                t = @(x) 0*x;
                h = fplot(@(x) 0*x, [lowerBound, upperBound], 'r');
            else
                t = @(x) a*exp(b*x)+c;
                h = fplot(@(x) a*exp(b*x)+c, [lowerBound, upperBound], 'r');
            end
        elseif(funcSelected == 1)
            t = @(x) x.^3+5*x.^2;
            h = fplot(@(x) x.^3+5*x.^2, [lowerBound, upperBound], 'r');
        elseif(funcSelected == 2)
            t = @(x) x.^2+1;
            h = fplot(@(x) x.^2+1, [lowerBound, upperBound], 'r');
        end
        x2 = (lowerBound:.0001:upperBound);
        functionPoints = t(x);
        actualPoints = t(x2);
        actualArea = trapz(x2, actualPoints);
        xAxis = xlabel('x');
        yAxis = ylabel('f(x)');
        set(xAxis, 'fontSize', 16);
        set(yAxis, 'fontSize', 16);
        set(h, 'LineWidth', 2);
        if(lower(methodPicked) == 'trapz')
            % builds out the patching that fills the rectangles to show the
            % area under the curve
            xverts = [x(1:end-1); x(1:end-1); x(2:end); x(2:end)];
            yverts = [zeros(1,length(x)-1); functionPoints(1:end-1); functionPoints(2:end); zeros(1,length(x)-1)];
            p = patch(xverts,yverts,'b','LineWidth',1);
            uistack(h, 'top');
            AUC = trapz(x, functionPoints);
        else
            if(lower(methodPicked) == 'left')
                riemannsPoints = lowerBound:step:upperBound-step;
                functionPoints = t(riemannsPoints);
                AUC = sum(functionPoints*step);
            elseif(lower(methodPicked) == 'midpoint')
                riemannsPoints = lowerBound+(step/2):step:upperBound-(step/2);
                functionPoints = t(riemannsPoints);
                AUC = sum(functionPoints*step);
            elseif(lower(methodPicked) == 'right')
                riemannsPoints = lowerBound+step:step:upperBound;
                functionPoints = t(riemannsPoints);
                AUC = sum(functionPoints*step);
            end
            % builds out the patching that fills the rectangles to show the
            % area under the curve
            xverts = [x(1:end-1); x(1:end-1);...
                     x(2:end); x(2:end)];
            yverts = [zeros(1,length(riemannsPoints)); functionPoints(1:end); functionPoints(1:end);...
                    zeros(1,length(riemannsPoints))];
            p = patch(xverts,yverts,'b','LineWidth',1);
            uistack(h, 'top');
        end
        format shortG
        errorPerc = ((AUC - actualArea)/actualArea)*100;
        set(handles.estVolText, 'string', strcat({'  Estimated Area: '}, sprintf('%.4f', AUC)));
        set(handles.actVolText, 'string', strcat({'  Actual Area: '}, sprintf('%.4f', actualArea)));
        if(isnan(errorPerc) || round(AUC,4) == round(actualArea,4))
            set(handles.errorText, 'string', strcat({'  Relative Error: '}, {'0%'}));
        else
            if(errorPerc > 0)
                set(handles.errorText, 'ForegroundColor', 'red', 'string', strcat({'  Relative Error: '}, sprintf('%.4f', errorPerc), {'% (overestimate)'}));
            else
                set(handles.errorText, 'ForegroundColor', 'blue', 'string', strcat({'  Relative Error: '}, sprintf('%.4f', errorPerc), {'% (underestimate)'}));
            end
        end
        % sets up legend in the display axis
        areaString = 'Area Under f(x)='; funcString = 'f(x)=';
        funcText = strrep(funcText, "+ 0.", "+   0.");
        funcText = strrep(funcText, " 1*x", "x");
        funcText = strrep(funcText, " 1^x", "x");
        funcText = strrep(funcText, "^^", "^");
        funcText = strrep(funcText, " 0*x^4 +", "");
        funcText = strrep(funcText, " 0*x^3 +", "");
        funcText = strrep(funcText, " 0*x^2 +", "");
        funcText = strrep(funcText, " 0*x +", "");
        funcText = strrep(funcText, "^0", "");
        funcText = strrep(funcText, "+ 0", "");
        funcText = strrep(funcText, "+0", "");
        funcText = strrep(funcText, "+  0", "");
        funcText = strrep(funcText, "e^1^x", "e^x");
        funcText = strrep(funcText, "e^-^1^x", "e^-^x");
        funcText = strrep(funcText, "*", "");
        funcText = strrep(funcText, " ", "");
%         funcText = strrep(funcText, "+   0.", "+ .");
        lineLeg = strcat(funcString, char(3), funcText); 
        patchLeg = strcat(areaString, char(3), funcText); 
        leg = legend([h, p], lineLeg, patchLeg, 'location', 'northwest');
        leg.FontSize = 14;
    end
end


% --- Executes whe selected object is changed in integratioMethodButtonGroup.
function integratioMethodButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in integratioMethodButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global methodPicked;
hh = get(get(handles.integratioMethodButtonGroup,'SelectedObject'),'string');
methodPicked = string(hh);
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

function fifthCoefficientEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fifthCoefficientValue;
tempValue = fifthCoefficientValue;
if(isnan(str2double(get(handles.fifthCoefficientEditBox, 'string'))))
    if(isempty(get(handles.fifthCoefficientEditBox, 'string')))
        fifthCoefficientValue = 0;
        set(handles.fifthCoefficientEditBox, 'string', 0);
    else
        newString = 'Must be a REAL NUMBER';
        set(handles.fifthCoefficientEditBox, 'string', tempValue);
%         plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    fifthCoefficientValue = get(handles.fifthCoefficientEditBox, 'string');
end 
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

function fifthCoefficientEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global fifthCoefficientValue;
fifthCoefficientValue = 0;
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fourthCoefficientEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global forthCoefficientValue;
tempValue = forthCoefficientValue;
if(isnan(str2double(get(handles.fourthCoefficientEditBox, 'string'))))
    if(isempty(get(handles.fourthCoefficientEditBox, 'string')))
        forthCoefficientValue = 0;
        set(handles.fourthCoefficientEditBox, 'string', 0);
    else
        newString = 'Must be a REAL NUMBER';
        set(handles.fourthCoefficientEditBox, 'string', tempValue);
%         plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    forthCoefficientValue = get(handles.fourthCoefficientEditBox, 'string');
end

calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

function fourthCoefficientEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global forthCoefficientValue;
forthCoefficientValue = 0;
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function thirdCoefficientEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global thirdCoefficientValue;
tempValue = thirdCoefficientValue;
if(isnan(str2double(get(handles.thirdCoefficientEditBox, 'string'))))
    if(isempty(get(handles.thirdCoefficientEditBox, 'string')))
        thirdCoefficientValue = 0;
        set(handles.thirdCoefficientEditBox, 'string', 0);
    else
        newString = 'Must be a REAL NUMBER';
        set(handles.thirdCoefficientEditBox, 'string', tempValue);
%         plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    thirdCoefficientValue = get(handles.thirdCoefficientEditBox, 'string');
end
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function thirdCoefficientEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global thirdCoefficientValue;
thirdCoefficientValue = 0;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function secondCoefficientEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global secondCoefficientValue;
tempValue = secondCoefficientValue;
if(isnan(str2double(get(handles.secondCoefficientEditBox, 'string'))))
    if(isempty(get(handles.secondCoefficientEditBox, 'string')))
        secondCoefficientValue = 0;
        set(handles.secondCoefficientEditBox, 'string', 0);
    else
        newString = 'Must be a REAL NUMBER';
        set(handles.secondCoefficientEditBox, 'string', tempValue);
%         plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    secondCoefficientValue = get(handles.secondCoefficientEditBox, 'string');
end
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function secondCoefficientEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global secondCoefficientValue;
secondCoefficientValue = 0;
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
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

function firstCoefficientEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global firstCoefficientValue;
tempValue = firstCoefficientValue;
if(isnan(str2double(get(handles.firstCoefficientEditBox, 'string'))))
    if(isempty(get(handles.firstCoefficientEditBox, 'string')))
        firstCoefficientValue = 0;
        set(handles.firstCoefficientEditBox, 'string', 0);
    else
        newString = 'Must be a REAL NUMBER';
        set(handles.firstCoefficientEditBox, 'string', tempValue);
%         plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    firstCoefficientValue = get(handles.firstCoefficientEditBox, 'string');
end
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function firstCoefficientEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global firstCoefficientValue;
firstCoefficientValue = 0;
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
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

% --- Executes on slider movement.
function intervalSlider_Callback(hObject, eventdata, handles)
% hObject    handle to intervalSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rectCount;
rectCount = ceil(get(handles.intervalSlider, 'Value'));
set(handles.stepEdit, 'string', rectCount);
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function intervalSlider_CreateFcn(hObject, ~, handles)
% hObject    handle to intervalSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
toolTipString = sprintf('Slide to increase or decrease\nnumber of subintervals shown');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function stepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to stepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rectCount;
tempRectCount = str2double(get(hObject,'String'));
if(tempRectCount < 1 || (floor(tempRectCount) ~= tempRectCount) || tempRectCount > 101)
    % set(handles.text4, 'string', newString);
%     plot(0,0);
    d = errordlg('Subinterval count must be positive integer equal to or below 100', 'Rectangle Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    set(handles.stepEdit, 'string', rectCount);
else
    rectCount = tempRectCount;
    set(handles.intervalSlider, 'value', rectCount);
end
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function stepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
toolTipString = sprintf('Enter a positive integer less than or equal to 100');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to constantEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
calculatePushButton_Callback(handles.calculatePushButton, eventdata, handles);

% Hints: get(hObject,'String') returns contents of constantEditBox as text
%        str2double(get(hObject,'String')) returns contents of constantEditBox as a double

% --- Executes during object creation, after setting all properties.
function constantEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
toolTipString = sprintf('Enter a real number');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in homeButton.
function homeButton_Callback(hObject, eventdata, handles)
% hObject    handle to homeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(AUC);
run('homescreen');


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


% --- Executes during object creation, after setting all properties.
function leftIntegrationRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftIntegrationRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to display left end point integration method.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 10);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function rightIntegrationRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightIntegrationRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to display right end point integration method.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 10);
elseif ispc
    set(hObject, 'fontSize', 10);
end


% --- Executes during object creation, after setting all properties.
function radiobutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to display midpoint integration method.');
set(hObject, 'TooltipString', toolTipString);


% --- Executes during object creation, after setting all properties.
function trapzIntegrationRadioButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trapzIntegrationRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to display trapezoidal integration method.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 10);
elseif ispc
    set(hObject, 'fontSize', 10);
end


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(AUC);
run('AUC');


% --- Executes during object creation, after setting all properties.
function resetButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
toolTipString = sprintf('Click to reset GUI to default.');
set(hObject, 'TooltipString', toolTipString);
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 11);
end


% --- Executes during object creation, after setting all properties.
function intervalButtonGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intervalButtonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 13);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function boundariesButtonGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boundariesButtonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 13);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function integratioMethodButtonGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to integratioMethodButtonGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 13);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function boundariesTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boundariesTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 13);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function errorText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function actVolText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to actVolText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function estVolText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to estVolText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end


% --- Executes during object creation, after setting all properties.
function functionExampleTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionExampleTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function aBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function bBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function cBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function secondDegreeTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondDegreeTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function firstDegreeTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstDegreeTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end

% --- Executes during object creation, after setting all properties.
function constantBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ismac
    set(hObject, 'fontSize', 14);
elseif ispc
    set(hObject, 'fontSize', 10);
end
