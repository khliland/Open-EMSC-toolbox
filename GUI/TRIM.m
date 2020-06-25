function varargout = TRIM(varargin)
% TRIM MATLAB code for TRIM.fig
%      TRIM, by itself, creates a new TRIM or raises the existing
%      singleton*.
%
%      H = TRIM returns the handle to a new TRIM or the handle to
%      the existing singleton*.
%
%      TRIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIM.M with the given input arguments.
%
%      TRIM('Property','Value',...) creates a new TRIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TRIM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TRIM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TRIM

% Last Modified by GUIDE v2.5 12-Nov-2013 15:25:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TRIM_OpeningFcn, ...
                   'gui_OutputFcn',  @TRIM_OutputFcn, ...
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


% --- Executes just before TRIM is made visible.
function TRIM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TRIM (see VARARGIN)

% Choose default command line output for TRIM
handles.output = hObject;
global selectedGlob upperLower rightLeft
upperLower = [];
if ~isempty(selectedGlob) % Check if dataset has been selected
    ex = evalin('base', ['exist(''',selectedGlob,''',''var'');']);
    if ex
        handles.dataset = evalin('base',selectedGlob);
        handles.lower = min(str2num(handles.dataset.v));
        handles.upper = max(str2num(handles.dataset.v));
        set(handles.edit1,'String', num2str(handles.lower));
        set(handles.edit2,'String', num2str(handles.upper));
        handles.rightLeft = rightLeft;
        doPlot(handles);
    else
        errordlg('No data set selected')
    end
else
    errordlg('No data set selected')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TRIM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TRIM_OutputFcn(hObject, eventdata, handles) 
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
lower = str2num(get(handles.edit1,'String'));
mini  = min(str2num(handles.dataset.v));
if lower < handles.upper
    if lower >= mini
        handles.lower = lower;
        doPlot(handles)
    else
        set(handles.edit1,'String',mini)
        handles.lower = mini;
        doPlot(handles)
    end
else
    set(handles.edit1,'String',num2str(handles.lower))
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
upper = str2num(get(handles.edit2,'String'));
maxi  = max(str2num(handles.dataset.v));
if upper > handles.lower
    if upper <= maxi
        handles.upper = upper;
        doPlot(handles)
    else
        set(handles.edit2,'String',maxi)
        handles.upper = maxi;
        doPlot(handles)
    end
else
    set(handles.edit2,'String',num2str(handles.upper))
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global upperLower
upperLower = [];
set(handles.uitable1,'Data',upperLower)
mini  = min(str2num(handles.dataset.v));
maxi  = max(str2num(handles.dataset.v));
set(handles.edit1,'String',mini)
set(handles.edit2,'String',maxi)
handles.lower = mini;
handles.upper = maxi;
doPlot(handles)
guidata(hObject, handles);

function doPlot(handles)
axes(handles.axes1)
hold off
plot(str2num(handles.dataset.v),handles.dataset.d')
axis tight
yl = get(gca,'YLim');
hold on
patch([[1,1],[1,1]*handles.lower], [yl yl(2:-1:1)],[0.7,0.7,0.7])
alpha(0.7)
patch([[1,1]*handles.upper,[1,1]*max(str2num(handles.dataset.v))], [yl yl(2:-1:1)],[0.7,0.7,0.7])
alpha(0.7)
plot([1,1]*handles.lower,yl,'-w')
plot([1,1]*handles.lower,yl,'--k')
plot([1,1]*handles.upper,yl,'-w')
plot([1,1]*handles.upper,yl,'--k')

global upperLower
if ~isempty(upperLower)
    r = range(yl);
    y2 = yl(2)-r*0.005;
    y1 = yl(1)+r*0.005;
    for i=1:size(upperLower,1)
        patch([upperLower(i,:) upperLower(i,2:-1:1)],[repmat(y1,1,2), repmat(y2,1,2)],[0.5,1,0.5],'EdgeColor',[0.5,1,0.5])
        alpha(0.3)
    end
end
set(gca,'YLim',yl)
set(get(gca,'Children'),'ButtonDownFcn', {@mouseclick_callback,handles})
set(gca,'ButtonDownFcn', {@mouseclick_callback,handles})
if handles.rightLeft == 1
    set(gca,'XDir','reverse')
else
    set(gca,'XDir','normal')
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pt = get(handles.axes1, 'CurrentPoint');
% disp('Yo!')


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% dcm_obj = datacursormode(get(hObject,'Parent'));
% set(dcm_obj,'UpdateFcn',@myUpdateFcn)
% set(dcm_obj, 'enable', 'on')
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

function mouseclick_callback(hObject, event_obj, handles)
pos = [];
while isempty(pos)
    try
        pos = round(get(hObject,'Currentpoint'));
    catch e
    end
    hObject = get(hObject,'Parent');
end
lowup = [handles.lower, handles.upper];
[~,m] = min(abs(lowup-pos(1)));
if m == 1
    handles.lower = pos(1);
    set(handles.edit1,'String',num2str(handles.lower))
else
    handles.upper = pos(1);
    set(handles.edit2,'String',num2str(handles.upper))
end
doPlot(handles)
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global upperLower selectedGlob
if isempty(upperLower)
    close
else
    keep = [];
    vars = str2num(handles.dataset.v);
    for i=1:size(upperLower,1)
        [~, mini] = min((vars-min(upperLower(i,:))).^2);
        [~, maxi] = min((vars-max(upperLower(i,:))).^2);
        if mini < maxi
            keep = [keep, mini:maxi];
        else
            keep = [keep, mini:-1:maxi];
        end
    end
    keep = unique(keep);
%     keep = setdiff(1:length(vars),keep);
    assignin('base', 'KeepMyVariables', keep);
    evalin('base',[selectedGlob '_trim = ' selectedGlob ';']);
%     evalin('base',[selectedGlob '_trim.d(:,KeepMyVariables) = NaN'])
    evalin('base',[selectedGlob '_trim.v = ' selectedGlob '_trim.v(KeepMyVariables,:);'])
    evalin('base',[selectedGlob '_trim.d = ' selectedGlob '_trim.d(:,KeepMyVariables);'])
    evalin('base','clear KeepMyVariables')
    selectedGlob = [selectedGlob '_trim'];
    close
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global upperLower

selected = [str2num(get(handles.edit2,'String')) str2num(get(handles.edit1,'String'))];
upperLower = [selected;upperLower];
set(handles.uitable1,'Data',upperLower)
mini  = min(str2num(handles.dataset.v));
maxi  = max(str2num(handles.dataset.v));
set(handles.edit1,'String',mini)
set(handles.edit2,'String',maxi)
handles.lower = mini;
handles.upper = maxi;
doPlot(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
