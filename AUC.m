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

% Last Modified by GUIDE v2.5 28-Feb-2018 10:27:05

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
AUCimage = imread('img/homebutton.jpg');
set(handles.pushbutton2, 'CData', AUCimage);
% Update handles structure
guidata(hObject, handles);
guidata(hObject, handles);
global lowerBound 
lowerBound = 0;
global upperBound 
upperBound = 20;
global rectCount;
rectCount = 5;
global methodPicked;
methodPicked = 'trapz';
maxNumberOfRect = 100;
set(handles.slider3, 'Min', 5);
set(handles.slider3, 'Max', maxNumberOfRect);
set(handles.slider3, 'Value', 5);
set(handles.slider3, 'SliderStep', [1/maxNumberOfRect , 10/maxNumberOfRect ]);
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

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global lowerBound;
global upperBound;
tempLowerBound = lowerBound;
lowerBound = str2double(get(hObject,'String'));
if(isnan(lowerBound))
    d = errordlg('Domain must be an Integer', 'Domain Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    lowerBound = tempLowerBound;
    set(handles.edit1, 'string', lowerBound);
else
    if(lowerBound >= upperBound)
        newString = 'Fix domain';
        set(handles.text4, 'string', newString);
        plot(0,0);
        d = errordlg('Fix Upper Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        lowerBound = tempLowerBound;
    end
    slider3_Callback(handles.slider3, eventdata, handles)
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
    set(handles.edit2, 'string', upperBound);
else
    if(lowerBound >= upperBound)
        newString = 'Fix domain';
        set(handles.text4, 'string', newString);
        plot(0,0);
        d = errordlg('Upper Bound must be LARGER than Lower Bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
        upperBound = tempUpperBound;
        set(handles.edit2, 'string', upperBound);
    end
    slider3_Callback(handles.slider3, eventdata, handles)
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


% --- Executes on selection change in functionMenu.
function functionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to functionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global functionChoice;
global lowerBound;
global upperBound;
% When a function is selected, first all the fields for the exponential and
% polynomial coefficients are hidden.

set(handles.edit4,'Visible','off');
set(handles.edit5,'Visible','off');
set(handles.edit6,'Visible','off');
set(handles.edit7,'Visible','off');
set(handles.edit8,'Visible','off');
set(handles.constantEdit,'Visible','off');
set(handles.aBox,'Visible','off');
set(handles.bBox,'Visible','off');
set(handles.cBox,'Visible','off');
set(handles.constantBox,'Visible','off');
set(handles.text5,'Visible','off');
set(handles.degree2nd,'Visible','off');
set(handles.degree1st,'Visible','off');

functionContents = cellstr(get(handles.functionMenu, 'String'));

functionChoice = functionContents{get(hObject, 'Value')};
if(strcmp(functionChoice,'Exponential'))
    upperBound = 1;
    lowerBound = 0;
    set(handles.edit1, 'string', lowerBound);
    set(handles.edit2, 'string', upperBound);
    set(handles.edit4, 'string', '1');
    set(handles.edit5, 'string', '1');
    set(handles.edit6, 'string', '0');
elseif(strcmp(functionChoice,'Polynomial'))
    upperBound = 1;
    lowerBound = 0;
    set(handles.edit1, 'string', lowerBound);
    set(handles.edit2, 'string', upperBound);
    set(handles.edit4, 'string', '0');
    set(handles.edit5, 'string', '0');
    set(handles.edit6, 'string', '0');
    set(handles.edit7, 'string', '1');
    set(handles.edit8, 'string', '0');
    set(handles.constantEdit, 'string', '0');
elseif(strcmp(functionChoice,'f(x)=x^3+5*x^2'))
    upperBound = 20;
    lowerBound = 0;
    set(handles.edit1, 'string', lowerBound);
    set(handles.edit2, 'string', upperBound);
elseif(strcmp(functionChoice,'f(x)=x^2+1'))
    upperBound = 20;
    lowerBound = 0;
    set(handles.edit1, 'string', lowerBound);
    set(handles.edit2, 'string', upperBound);
end
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

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

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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
global actual_area;
global rectHeights;
global symFunc;
functionContents = cellstr(get(handles.functionMenu, 'String'));
functionChoice = functionContents{get(handles.functionMenu, 'Value')};
if(not(strcmp(functionChoice, 'Select a function')))
    if(lowerBound > upperBound)
        newString = 'Fix domain';
        set(handles.text4, 'string', newString);
        plot(0,0);
        d = errordlg('LOWER bound is larger than UPPER bound', 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    else
        if(strcmp(functionChoice, 'Exponential'))
            % When exponential function option is selected:
            %   -Set bounds to 0 and 1.
            %   -Set the function so that it's e^x (first and second boxes = 1)
            rectCount = ceil(get(handles.slider3, 'Value'));
            set(handles.text5, 'string', 'a*e^bx + c');
            set(handles.edit4,'Visible','on');
            set(handles.edit5,'Visible','on');
            set(handles.edit6,'Visible','on');
            set(handles.aBox,'Visible','on');
            set(handles.bBox,'Visible','on');
            set(handles.cBox,'Visible','on');
            set(handles.text5,'Visible','on');
            set(handles.aBox, 'string', 'a');
            set(handles.bBox, 'string', 'b');
            set(handles.cBox, 'string', 'c');
            a = char(str2sym(get(handles.edit4, 'String')));
            b = char(str2sym(get(handles.edit5, 'String')));
            c = char(str2sym(get(handles.edit6, 'String')));
            funcText = a + "* e^" + b + "*x + " + c;
            symFunc = a + "*exp(" + b + "*q)+" + c;
        elseif(strcmp(functionChoice, 'Polynomial'))
            % Makes the forms for the coefficients and their captions visible.
            rectCount = ceil(get(handles.slider3, 'Value'));
            set(handles.edit4,'Visible','on');
            set(handles.edit5,'Visible','on');
            set(handles.edit6,'Visible','on');
            set(handles.edit7,'Visible','on');
            set(handles.edit8,'Visible','on');
            set(handles.constantEdit,'Visible','on');
            set(handles.aBox,'Visible','on');
            set(handles.bBox,'Visible','on');
            set(handles.cBox,'Visible','on');
            set(handles.constantBox,'Visible','on');
            set(handles.degree2nd,'Visible','on');
            set(handles.degree1st,'Visible','on');
            set(handles.text5,'Visible','on');
            set(handles.text5, 'string', 'Coefficients of Degrees');
            set(handles.aBox, 'string', '5th');
            set(handles.bBox, 'string', '4th');
            set(handles.cBox, 'string', '3rd');
            a = char(str2sym(get(handles.edit4, 'String')));
            b = char(str2sym(get(handles.edit5, 'String')));
            c = char(str2sym(get(handles.edit6, 'String')));
            d = char(str2sym(get(handles.edit7, 'String')));
            e = char(str2sym(get(handles.edit8, 'String')));
            cons = char(str2sym(get(handles.constantEdit, 'String')));
            funcText = a + " * x^5 + " + b + " * x^4 + " + c + " * x^3 + " + d + " * x^2 + " + e + " * x + " + cons;
            symFunc = a + "*q^5+" + b + "*q^4+" + c + "*q^3+" + d + "*q^2+" + e + "*q+" + cons;
        else
            funcText = functionChoice(6:length(functionChoice));
            symFunc = strrep(funcText, "x", "q");
        end
        syms q
        f(q) = str2sym(symFunc);
        actual_area = int(f(q), lowerBound, upperBound);
        step = (upperBound - lowerBound)/rectCount;
        x = lowerBound:step:upperBound;
        funcSelected = double(f(x));
        h = fplot(f(q), [lowerBound, upperBound], 'r');
        xAxis = xlabel(strcat(num2str(lowerBound), char(3), '< X <', char(3), num2str(upperBound)));
        yAxis = ylabel('f(x)');
        set(xAxis, 'fontSize', 16);
        set(yAxis, 'fontSize', 16);
        set(h, 'LineWidth', 2);
        if(lower(methodPicked) == 'trapz')
            xverts = [x(1:end-1); x(1:end-1); x(2:end); x(2:end)];
            yverts = [zeros(1,length(x)-1); funcSelected(1:end-1);...
                funcSelected(2:end); zeros(1,length(x)-1)];
            p = patch(xverts,yverts,'b','LineWidth',1);
            uistack(h, 'top');
            AUC = trapz(x, funcSelected);
        else
            if(lower(methodPicked) == 'left')
                riemannsPoints = lowerBound:step:upperBound-step;
                rectHeights = double(f(riemannsPoints));
                AUC = sum(rectHeights*step);
            elseif(lower(methodPicked) == 'center')
                riemannsPoints = lowerBound+(step/2):step:upperBound-(step/2);
                rectHeights = double(f(riemannsPoints));
                AUC = sum(rectHeights*step);
            elseif(lower(methodPicked) == 'right')
                riemannsPoints = lowerBound+step:step:upperBound;
                rectHeights = double(f(riemannsPoints));
                AUC = sum(rectHeights*step);
            end
            xverts = [x(1:end-1); x(1:end-1);...
                     x(2:end); x(2:end)];
            yverts = [zeros(1,length(riemannsPoints)); rectHeights(1:end); rectHeights(1:end);...
                    zeros(1,length(riemannsPoints))];
            p = patch(xverts,yverts,'b','LineWidth',1);
            uistack(h, 'top');
        end
        format shortG
        errorPerc = ((AUC - actual_area)/actual_area)*100;
        set(handles.estVolText, 'string', strcat({'  Estimated Area: '}, sprintf('%.2f', AUC)));
        set(handles.actVolText, 'string', strcat({'  Actual Area: '}, sprintf('%.2f', actual_area)));
        if(isnan(errorPerc))
            set(handles.errorText, 'string', strcat({'  Error: '}, {'0%'}));
        else
            set(handles.errorText, 'string', strcat({'  Error: '}, sprintf('%g', errorPerc), {'%'}));
        end
        areaString = 'Area Under f(x)=';
        funcString = 'f(x)=';
        lineLeg = strcat(funcString, char(3), funcText);
        patchLeg = strcat(areaString, char(3), funcText);
        leg = legend([h, p], lineLeg, patchLeg, 'location', 'northwest');
        leg.FontSize = 14;
        uistack(leg,"top")
    end
end

% --- Executes whe selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global methodPicked;
hh = get(get(handles.uibuttongroup1,'SelectedObject'),'string');
methodPicked = string(hh);
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edit4;
tempValue = edit4;
if(isnan(str2double(get(handles.edit4, 'string'))))
    if(isempty(get(handles.edit4, 'string')))
        edit4 = 0;
        set(handles.edit4, 'string', 0);
    else
        newString = 'Must be an INTEGER VALUE';
        set(handles.edit4, 'string', tempValue);
        plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    edit4 = get(handles.edit4, 'string');
end 
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global edit4;
edit4 = 0;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edit5;
tempValue = edit5;
if(isnan(str2double(get(handles.edit5, 'string'))))
    if(isempty(get(handles.edit5, 'string')))
        edit5 = 0;
        set(handles.edit5, 'string', 0);
    else
        newString = 'Must be an INTEGER VALUE';
        set(handles.edit5, 'string', tempValue);
        plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    edit5 = get(handles.edit5, 'string');
end

pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global edit5;
edit5 = 0;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edit6;
tempValue = edit6;
if(isnan(str2double(get(handles.edit6, 'string'))))
    if(isempty(get(handles.edit6, 'string')))
        edit6 = 0;
        set(handles.edit6, 'string', 0);
    else
        newString = 'Must be an INTEGER VALUE';
        set(handles.edit6, 'string', tempValue);
        plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    edit6 = get(handles.edit6, 'string');
end
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global edit6;
edit6 = 0;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edit7;
tempValue = edit7;
if(isnan(str2double(get(handles.edit7, 'string'))))
    if(isempty(get(handles.edit7, 'string')))
        edit7 = 0;
        set(handles.edit7, 'string', 0);
    else
        newString = 'Must be an INTEGER VALUE';
        set(handles.edit7, 'string', tempValue);
        plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    edit7 = get(handles.edit7, 'string');
end
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global edit7;
edit7 = 0;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global edit8;
tempValue = edit8;
if(isnan(str2double(get(handles.edit8, 'string'))))
    if(isempty(get(handles.edit8, 'string')))
        edit8 = 0;
        set(handles.edit8, 'string', 0);
    else
        newString = 'Must be an INTEGER VALUE';
        set(handles.edit8, 'string', tempValue);
        plot(0,0);
        d = errordlg(newString, 'Domain Error');
        set(d, 'WindowStyle', 'modal');
        uiwait(d);
    end
else
    edit8 = get(handles.edit8, 'string');
end
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global edit8;
edit8 = 0;
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rectCount;
rectCount = ceil(get(handles.slider3, 'Value'));
set(handles.stepEdit, 'string', rectCount);
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in intervalMenu.
function intervalMenu_Callback(hObject, eventdata, handles)
% hObject    handle to intervalMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global step;
global lowerBound;
global upperBound;
global rectCount;
contents = cellstr(get(hObject,'String'));
rectCount = contents{get(hObject,'Value')};
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
functionMenu_Callback(handles.functionMenu, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function intervalMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intervalMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to stepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepEdit as text
%        str2double(get(hObject,'String')) returns contents of stepEdit as a double

global rectCount;
tempRectCount = str2double(get(hObject,'String'));
if(tempRectCount < 1 || (floor(tempRectCount) ~= tempRectCount) || tempRectCount > 101)
    % set(handles.text4, 'string', newString);
    plot(0,0);
    d = errordlg('Subinterval count must be positive integer equal to or below 100', 'Rectangle Error');
    set(d, 'WindowStyle', 'modal');
    uiwait(d);
    set(handles.stepEdit, 'string', rectCount);
else
    rectCount = tempRectCount;
    set(handles.slider3, 'value', rectCount);
end
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function stepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function constantEdit_Callback(hObject, eventdata, handles)
% hObject    handle to constantEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);

% Hints: get(hObject,'String') returns contents of constantEdit as text
%        str2double(get(hObject,'String')) returns contents of constantEdit as a double

% --- Executes during object creation, after setting all properties.
function constantEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constantEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(AUC);
run('homescreen');
