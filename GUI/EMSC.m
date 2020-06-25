function varargout = EMSC(varargin)
% EMSC MATLAB code for EMSC.fig
%      EMSC, by itself, creates a new EMSC or raises the existing
%      singleton*.
%
%      H = EMSC returns the handle to a new EMSC or the handle to
%      the existing singleton*.
%
%      EMSC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMSC.M with the given input arguments.
%
%      EMSC('Property','Value',...) creates a new EMSC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMSC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMSC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMSC

% Last Modified by GUIDE v2.5 14-Nov-2013 15:43:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EMSC_OpeningFcn, ...
    'gui_OutputFcn',  @EMSC_OutputFcn, ...
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


% --- Executes just before EMSC is made visible.
function EMSC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMSC (see VARARGIN)

% Choose default command line output for EMSC
handles.output = hObject;
handles.result = 1;
handles.corrected = [];
handles.residuals = [];
handles.model  = [];
handles.interferent = [];
handles.constituent = [];
% Update handles structure
global selectedGlob rightLeft
if ~isempty(selectedGlob) % Check if dataset has been selected
    ex = evalin('base', ['exist(''',selectedGlob,''',''var'');']);
    if ex
        set(handles.edit1,'String',selectedGlob);
        handles.rightLeft = rightLeft;
        guidata(hObject, handles);
        edit1_changed(hObject,handles)
    else
        errordlg('No data set selected')
    end
end


% UIWAIT makes EMSC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EMSC_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit1_changed(hObject,handles)

function edit1_changed(hObject,handles)
set(handles.edit1,'BackgroundColor','red');
set(handles.popupmenu1,'Enable','off')
set(handles.popupmenu2,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.uitable1,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')
set(handles.edit6,'Enable','off')
set(handles.edit7,'Enable','off')
set(handles.edit8,'Enable','off')
set(handles.edit9,'Enable','off')
set(handles.edit10,'Enable','off')
set(handles.edit11,'Enable','off')
set(handles.edit12,'Enable','off')
set(handles.edit13,'Enable','off')
set(handles.edit14,'Enable','off')
set(handles.checkbox1,'Enable','off')
set(handles.checkbox2,'Enable','off')
set(handles.radiobutton1,'Enable','off')
set(handles.radiobutton2,'Enable','off')
set(handles.radiobutton3,'Enable','off')
set(handles.radiobutton4,'Enable','off')
set(handles.radiobutton5,'Enable','off')
set(handles.radiobutton6,'Enable','off')
set(handles.radiobutton7,'Enable','off')
set(handles.radiobutton8,'Enable','off')
set(handles.radiobutton9,'Enable','off')
set(handles.pushbutton11,'Enable','off')
dataname = get(handles.edit1,'String');
axes(handles.axes1)
cla
axes(handles.axes3)
cla
linkaxes([handles.axes1 handles.axes3],'x');
set(handles.text22,'String','')

try
    v = evalin('base', dataname);
catch e
end
if exist('v','var')
    if(~(ismatrix(v) && isnumeric(v)) && (~isfield(v,'i') || ~isfield(v,'d') || ~isfield(v,'v')) )
        msgbox('Wrong data format. Not a proper Saisir struct or numeric matrix.','Data set','error')
    else % Data was accepted. Prepare GUI
        if ismatrix(v) && isnumeric(v)
            v = matrix2saisir(v);
        end
        handles.dataname = dataname;
        handles.data = v;
        n = size(v.i,1);
        set(handles.edit1,'BackgroundColor',[0 0.8 0]);
        set(handles.popupmenu1,'Enable','on')
        set(handles.popupmenu2,'Enable','on')
        spectra = cell(1,n+3);
        for i=1:n
            spectra{i+3} = num2str(i);
        end
        spectra{1} = 'Mean spectrum';
        spectra{2} = 'Re-weighted mean spectrum';
        spectra{3} = 'Predefined';
        set(handles.popupmenu2,'String',spectra)
        set(handles.pushbutton2,'Enable','on')
        [i1 i2] = size(v.i);
        set(handles.uitable1,'Data',mat2cell(v.i,repmat(1,i1,1),i2))
        set(handles.checkbox1,'Enable','on')
        set(handles.edit13,'Enable','on')
        set(handles.edit14,'Enable','on')
        set(handles.pushbutton11,'Enable','on')
        if get(handles.checkbox1,'Value') == 1
            set(handles.uitable1,'Enable','on')
            set(handles.edit3,'Enable','on')
            set(handles.edit4,'Enable','on')
            set(handles.edit6,'Enable','on')
        end
        set(handles.checkbox2,'Enable','on')
        if get(handles.checkbox2,'Value') == 1
            set(handles.edit7,'Enable','on')
            set(handles.edit8,'Enable','on')
            set(handles.edit9,'Enable','on')
            set(handles.edit10,'Enable','on')
            set(handles.edit11,'Enable','on')
            set(handles.edit12,'Enable','on')
            set(handles.radiobutton5,'Enable','on')
            set(handles.radiobutton6,'Enable','on')
            set(handles.radiobutton8,'Enable','on')
            set(handles.radiobutton9,'Enable','on')
        end
        axes(handles.axes1)
        zoom out
        plot_spectra(handles.data);
        if handles.rightLeft == 1
            set(gca,'XDir','reverse')
        else
            set(gca,'XDir','normal')
        end
        zoom reset
        axes(handles.axes3)
        cla
        if handles.rightLeft == 1
            set(gca,'XDir','reverse')
        else
            set(gca,'XDir','normal')
        end
        zoom out
        set(handles.text22,'String',['(' num2str(size(v.d,1)) 'x' num2str(size(v.d,2)) ')'])
    end
end
% Update handles structure
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.uitable1,'Data',{1})


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox1,'Value') == 1
    set(handles.uitable1,'Enable','on')
    set(handles.edit3,'Enable','on')
    set(handles.edit4,'Enable','on')
    set(handles.edit6,'Enable','on')
%     set(handles.checkbox2,'Value',0)
%     set(handles.edit7,'Enable','off')
%     set(handles.edit8,'Enable','off')
%     set(handles.edit9,'Enable','off')
%     set(handles.edit10,'Enable','off')
%     set(handles.edit11,'Enable','off')
%     set(handles.edit12,'Enable','off')
%     set(handles.radiobutton5,'Enable','off')
%     set(handles.radiobutton6,'Enable','off')
%     set(handles.radiobutton8,'Enable','off')
%     set(handles.radiobutton9,'Enable','off')
else
    set(handles.uitable1,'Enable','off')
    set(handles.edit3,'Enable','off')
    set(handles.edit4,'Enable','off')
    set(handles.edit6,'Enable','off')
end
% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
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

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
if get(hObject,'Value') == 3
    set(handles.edit16,'Visible','on')
else
    set(handles.edit16,'Visible','off')
    set(handles.text25,'String','')
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global correctedGlob
if strcmp(get(handles.baseCancel,'Visible'),'on')
    set(handles.popupmenu2,'Value',3)
    set(handles.edit16,'String',[get(handles.edit5,'String') 'custom_reference'])
    set(handles.edit16,'Visible','on')
    handles.reference = matrix2saisir(handles.customReference);
    set(handles.edit16,'BackgroundColor',[0 0.8 0]);
    set(handles.edit16,'ForegroundColor','white');
    set(handles.text25,'String',['(' num2str(size(handles.customReference,1)) 'x' num2str(size(handles.customReference,2)) ')'])
    handles.referencename = get(handles.edit16,'String');
    assignin('base', handles.referencename, handles.reference);
    handles = doCancel(handles);
    edit1_changed(hObject,handles);
else
    disp(' ')
    disp('% Applying EMSC')
    computing(handles.axes3,handles.rightLeft)
    
    prefix    = get(handles.edit5,'String');
    EMSC_type = get(handles.popupmenu1,'Value');
    e = [0 3 2 1 4 5 6 7];
    EMSC_type = e(EMSC_type);
    EMSC_rep  = get(handles.checkbox1,'Value');
    rep_from  = str2num(get(handles.edit3,'String'));
    rep_to    = str2num(get(handles.edit4,'String'));
    rep_CV    = str2num(get(handles.edit6,'String'));
    reference = get(handles.popupmenu2,'Value');
    EMSC_Mie  = get(handles.checkbox2,'Value');
    Mie_m0    = str2num(get(handles.edit9,'String'));
    Mie_r0    = str2num(get(handles.edit12,'String'));
    Mie_step  = str2num(get(handles.edit10,'String'));
    Mie_steps = str2num(get(handles.edit11,'String'));
    Mie_CV    = str2num(get(handles.edit7,'String'));
    Mie_CV_r  = str2num(get(handles.edit8,'String'));
    Mie_ref   = get(handles.radiobutton6,'Value');
    Mie_app   = get(handles.radiobutton9,'Value');
    
    if EMSC_rep == 1 || EMSC_Mie == 1 || reference == 2 % Produce weights when needed
        disp([prefix 'Weights.d = ones(1,size(' handles.dataname '.d,2));'])
        EMSC_Weights.d = ones(1,size(handles.data.d,2));
        disp([prefix 'Weights.v = ' handles.dataname '.v;'])
        EMSC_Weights.v = handles.data.v;
    end
    
    
    if EMSC_rep == 1 % Replicate correction
        disp([prefix 'model = make_emsc_rep_mod(' handles.dataname ', ' num2str(rep_from) ', ' num2str(rep_to) ', ' num2str(EMSC_type) ', ' num2str(rep_CV) ', ' prefix 'weights,0);'])
        EMSC_model = make_emsc_rep_mod(handles.data,rep_from,rep_to,EMSC_type,rep_CV,EMSC_Weights,0);
    else % No replicate correction
        disp([prefix 'model = make_emsc_modfunc(' handles.dataname ',' num2str(EMSC_type) ');'])
        [EMSC_model] = make_emsc_modfunc(handles.data,EMSC_type);
    end
    
    ref_n = 0;
    for i=1:size(EMSC_model.ModelSpecNames,1); % Finds the reference spectrum
        if ~isempty(strfind(EMSC_model.ModelSpecNames(i,:),'Reference'))
            ref_n = i;
            if reference > 3 % Changes the reference spectrum
                disp([prefix 'model.Model(:,' num2str(i) ') = ' handles.dataname '.d(' num2str(reference-3) ',:)'';'])
                EMSC_model.Model(:,i) = handles.data.d(reference-3,:)';
            elseif reference == 2 % Re-weighted mean
                disp([prefix 'model = reweighted_mean(' handles.dataname ', ' prefix 'model, ' prefix 'Weights, ' num2str(std(EMSC_model.Model(:,i))*0.01) ',0);'])
                EMSC_model = reweighted_mean(handles.data,EMSC_model,EMSC_Weights,std(EMSC_model.Model(:,i))*0.01,0);
            elseif reference == 3 % Predefined reference spectrum
                disp([prefix 'model.Model(:,' num2str(i) ') = ' handles.referencename '.d(1,:)'';'])
                EMSC_model.Model(:,i) = handles.reference.d';
            end
        end
    end
    
    if EMSC_Mie == 1 % Perform Mie scattering correction
        disp(['Mie_Ref = ' handles.dataname ';'])
        Mie_Ref   = handles.data;
        disp(['Mie_Ref.d = ' prefix 'model.Model(:,' num2str(ref_n) ')'';'])
        Mie_Ref.d = EMSC_model.Model(:,ref_n)';
        disp('Mie_Ref.i = ''Reference'';');
        Mie_Ref.i = 'Reference';
        disp([prefix 'model_Mie = make_Mie_emsc_mod(Mie_Ref, ' num2str(Mie_app+1) ', ' num2str(Mie_ref+1) ', ' num2str(Mie_CV) ', ' num2str(Mie_CV_r) ', ' num2str(Mie_m0) ', ' num2str(Mie_r0) ', ' num2str(Mie_step) ', ' num2str(Mie_steps) ', ' prefix 'weights);'])
        EMSC_model_Mie = make_Mie_emsc_mod(Mie_Ref,Mie_app+1,Mie_ref+1,Mie_CV,Mie_CV_r,Mie_m0,Mie_r0,Mie_step,Mie_steps,EMSC_Weights);
        
        disp([prefix 'model = [' prefix 'model.Model(:,[' num2str(setdiff(1:EMSC_model.NModelFunc,ref_n)) ']) ' prefix 'model_Mie.Model(:,' num2str(EMSC_model_Mie.NumBasicModelFunc) ':' num2str(EMSC_model_Mie.NumBasicModelFunc + EMSC_model_Mie.NbadSpec) ')];']);
        EMSC_model.Model = [EMSC_model.Model(:,setdiff(1:EMSC_model.NModelFunc,ref_n)) EMSC_model_Mie.Model(:,EMSC_model_Mie.NumBasicModelFunc+(0:EMSC_model_Mie.NbadSpec))];
        disp([prefix 'model.ModelSpecNames = [' prefix 'model.ModelSpecNames; ' prefix 'model_Mie.ModelSpecNames(' num2str(EMSC_model_Mie.NumBasicModelFunc+1) ':' num2str(EMSC_model_Mie.NumBasicModelFunc+EMSC_model_Mie.NbadSpec) ',:)];'])
        EMSC_model.ModelSpecNames = [EMSC_model.ModelSpecNames; EMSC_model_Mie.ModelSpecNames(EMSC_model_Mie.NumBasicModelFunc+(1:EMSC_model_Mie.NbadSpec),:)];
        disp([prefix 'model.NbadSpec = ' prefix 'model_Mie.NbadSpec;'])
        EMSC_model.NbadSpec = EMSC_model_Mie.NbadSpec;
        disp([prefix 'model.NModelFunc = size(' prefix 'model.Model,2);'])
        EMSC_model.NModelFunc = size(EMSC_model.Model,2);
        disp([prefix 'model.Mie = ' prefix 'model_Mie.Mie;'])
        EMSC_model.Mie = EMSC_model_Mie.Mie;
    end
    
    if ~isempty(handles.constituent)
        disp([prefix 'model = add_spec_to_EMSCmod(' prefix 'model, ' handles.constituentname ', 1);'])
        EMSC_model = add_spec_to_EMSCmod(EMSC_model,handles.constituent,1);
    end
    if ~isempty(handles.interferent)
        disp([prefix 'model = add_spec_to_EMSCmod(' prefix 'model, ' handles.interferentname ', 2);'])
        EMSC_model = add_spec_to_EMSCmod(EMSC_model,handles.interferent,2);
    end
    
    disp(['[' prefix 'Corrected, ' prefix 'Residuals, ' prefix 'Parameters] = cal_emsc(' handles.dataname ', ' prefix 'model);'])
    [ZCorrected,ZResiduals,ZParameters] = cal_emsc(handles.data, EMSC_model);
    handles.corrected = ZCorrected;
    handles.residuals = ZResiduals;
    handles.model     = EMSC_model;
    
    doplot(handles);
    
    evalin('base',[prefix 'Corrected = [];'])
    assignin('base', [prefix 'Corrected'], ZCorrected);
    assignin('base', [prefix 'Residuals'], ZResiduals);
    assignin('base', [prefix 'Parameters'], ZParameters);
    correctedGlob = [prefix 'Corrected'];
    
    set(handles.radiobutton1,'Enable','on')
    set(handles.radiobutton2,'Enable','on')
    set(handles.radiobutton3,'Enable','on')
    set(handles.radiobutton4,'Enable','on')
    set(handles.radiobutton7,'Enable','on')
end

% Update handles structure
guidata(hObject, handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
zoom out

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes3)
zoom out


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if eventdata.NewValue == handles.radiobutton1
    axes(handles.axes1)
    zoom off
    axes(handles.axes3)
    zoom off
else
    axes(handles.axes1)
    zoom xon
    axes(handles.axes3)
    zoom xon
end

% Update handles structure
guidata(hObject, handles);


function computing(axess,rightLeft)
axes(axess);
% cla;
limsX = get(gca,'XLim');
limsY = get(gca,'YLim');
if rightLeft == 1
    text(sum(limsX)*0.62,mean(limsY),'Computing','FontSize',30,'Color',[1 1 1])
    text(sum(limsX)*0.6225,mean(limsY)+range(limsY)*0.006,'Computing','FontSize',30)
else
    text(sum(limsX)*0.32,mean(limsY),'Computing','FontSize',30,'Color',[1 1 1])
    text(sum(limsX)*0.3225,mean(limsY)-range(limsY)*0.006,'Computing','FontSize',30)
end
drawnow



function doplot(handles)
axes(handles.axes3)
limsX = get(gca,'XLim');
p = size(handles.data.d,2);
for i=1:p
    xlabs(i,1) = str2double(handles.data.v(i,:));
end
if handles.result == 1
    connected_subplots(handles.axes1,handles.axes3,xlabs,xlabs,handles.data.d,handles.corrected.d)
elseif handles.result == 2
    connected_subplots(handles.axes1,handles.axes3,xlabs,xlabs,handles.data.d,handles.residuals.d)
else
    connected_subplots(handles.axes1,handles.axes3,xlabs,xlabs,handles.data.d,handles.model.Model',handles.model.ModelSpecNames)
end
axes(handles.axes3)
axis('tight');
xlim(limsX)


function handles = doBasePlot(handles)
axes(handles.axes3)
limsX = get(gca,'XLim');
p = size(handles.data.d,2);

reference = get(handles.popupmenu2,'Value');
err = 0;
if reference == 1
    ref = mean(handles.data.d);
elseif reference == 2
    err = 1;
    errordlg('Cannot correct reference when re-weighting is chosen');
elseif reference == 3
    if isfield(handles,'reference')
        ref = handles.reference.d;
    else
        err = 1;
        errordlg('Cannot correct reference when predefined reference has not been chosen/activated')
    end
else
    ref = handles.data.d(reference-1,:);
end

if err == 1
    doCancel(handles)
else
    % Impute missing reference values with linear interpolation
    xlabs = str2num(handles.data.v)';
    diffx = abs(diff(xlabs));
    ind = find(diffx > 2*median(diffx)); % Find unnormal jumps
    X = cell(length(ind),1);
    Y = cell(length(ind),1);
    lseg = zeros(length(ind)*2+1,1);
    if ~isempty(ind)
        refX = ref(1:ind);
        lseg(1) = ind;
        for i=1:length(ind)
            X{i} = xlabs(ind(i)):median(diffx):xlabs(ind(i)+1);
            rdiff = ref(ind(i)+1)-ref(ind(i));
            Y{i} = ref(ind(i)):rdiff/(length(X{i})-1):ref(ind(i)+1);
            refX = [refX Y{i}];
            lseg(2*(i-1)+2) = length(X{i});
            if i<length(ind)
                lseg(2*(i-1)+3) = ind(i+1)-ind(i);
                refX = [refX ref(ind(i))+1:ref(ind(i+1))];
            end
        end
        lseg(end) = length(xlabs)-ind(end);
        refX = [refX ref(ind(end)+1:end)];
    else
        refX = ref;
        lseg = length(diffx)+1;
    end
    
    par1  = str2num(get(handles.basePar1,'String'));
    par2  = str2num(get(handles.basePar2,'String'));
    if get(handles.basePopup,'Value') == 2
        corrected = subbackmod (refX, xlabs, par1, par2, 0);
        baseline  = refX-corrected;
    else
        baseline = als_baseline(refX,par1,par2);
        corrected = refX-baseline;
    end
        
    % Remove imputed values
    baselineX  = baseline(1:lseg(1));
    correctedX = corrected(1:lseg(1));
    for i=1:length(ind)
        baselineX = [baselineX baseline(sum(lseg(1:2*i))+1:sum(lseg(1:2*i+1)))];
        correctedX = [correctedX corrected(sum(lseg(1:2*i))+1:sum(lseg(1:2*i+1)))];
    end
    
    connected_subplots(handles.axes1,handles.axes3,xlabs,xlabs,[ref;baselineX],[correctedX;zeros(1,length(xlabs))])
    handles.customReference = correctedX;
    axes(handles.axes3)
    axis('tight');
    xlim(limsX)
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6,'Visible','off');
set(handles.edit1,'Enable','on');
set(handles.edit5,'Enable','on');
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Visible','on');
if get(handles.checkbox2,'Value') == 1
    set(handles.pushbutton10,'BackgroundColor',[140 240 140]./255)
else
    set(handles.pushbutton10,'BackgroundColor',[240 240 240]./255)
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6,'Visible','on');
set(handles.pushbutton2,'Visible','off');
set(handles.edit1,'Enable','off');
set(handles.edit5,'Enable','off');
set(handles.pushbutton1,'Enable','off');


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.checkbox2,'Value') == 1
    set(handles.edit7,'Enable','on')
    set(handles.edit8,'Enable','on')
    set(handles.edit9,'Enable','on')
    set(handles.edit10,'Enable','on')
    set(handles.edit11,'Enable','on')
    set(handles.edit12,'Enable','on')
    set(handles.radiobutton5,'Enable','on')
    set(handles.radiobutton6,'Enable','on')
    set(handles.radiobutton8,'Enable','on')
    set(handles.radiobutton9,'Enable','on')
%     set(handles.checkbox1,'Value',0)
%     set(handles.uitable1,'Enable','off')
%     set(handles.edit3,'Enable','off')
%     set(handles.edit4,'Enable','off')
%     set(handles.edit6,'Enable','off')
else
    set(handles.edit7,'Enable','off')
    set(handles.edit8,'Enable','off')
    set(handles.edit9,'Enable','off')
    set(handles.edit10,'Enable','off')
    set(handles.edit11,'Enable','off')
    set(handles.edit12,'Enable','off')
    set(handles.radiobutton5,'Enable','off')
    set(handles.radiobutton6,'Enable','off')
    set(handles.radiobutton8,'Enable','off')
    set(handles.radiobutton9,'Enable','off')
end
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton3,'Value') == 1
    handles.result = 1;
elseif get(handles.radiobutton4,'Value') == 1
    handles.result = 2;
else
    handles.result = 3;
end
doplot(handles)

% Update handles structure
guidata(hObject, handles);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
dataname = get(hObject,'String');
set(hObject,'BackgroundColor','white');
set(hObject,'ForegroundColor','black');
set(handles.text23,'String','')
handles.constituentname = [];
handles.constituent = [];
try
    v = evalin('base', dataname);
catch e
end
if exist('v','var')
    if(~(ismatrix(v) && isnumeric(v)) && (~isfield(v,'i') || ~isfield(v,'d') || ~isfield(v,'v')) )
        msgbox('Wrong data format. Not a proper Saisir struct or numeric matrix.','Data set','error')
    else % Data was accepted. Prepare GUI
        if ismatrix(v) && isnumeric(v)
            v = matrix2saisir(v);
        end
        handles.constituentname = dataname;
        handles.constituent = v;
        set(hObject,'BackgroundColor',[0 0.8 0]);
        set(hObject,'ForegroundColor','white');
        set(handles.text23,'String',['(' num2str(size(v.d,1)) 'x' num2str(size(v.d,2)) ')'])
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
dataname = get(hObject,'String');
set(hObject,'BackgroundColor','white');
set(hObject,'ForegroundColor','black');
set(handles.text24,'String','')
handles.interferentname = [];
handles.interferent = [];
try
    v = evalin('base', dataname);
catch e
end
if exist('v','var')
    if(~(ismatrix(v) && isnumeric(v)) && (~isfield(v,'i') || ~isfield(v,'d') || ~isfield(v,'v')) )
        msgbox('Wrong data format. Not a proper Saisir struct or numeric matrix.','Data set','error')
    else % Data was accepted. Prepare GUI
        if ismatrix(v) && isnumeric(v)
            v = matrix2saisir(v);
        end
        handles.interferentname = dataname;
        handles.interferent = v;
        set(hObject,'BackgroundColor',[0 0.8 0]);
        set(hObject,'ForegroundColor','white');
        set(handles.text24,'String',['(' num2str(size(v.d,1)) 'x' num2str(size(v.d,2)) ')'])
    end
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
dataname = get(hObject,'String');
set(hObject,'BackgroundColor','white');
set(hObject,'ForegroundColor','black');
set(handles.text25,'String','')
handles.referencename = [];
handles.reference = [];
try
    v = evalin('base', dataname);
catch e
    disp(e)
end
if exist('v','var')
    if(~(ismatrix(v) && isnumeric(v)) && (~isfield(v,'i') || ~isfield(v,'d') || ~isfield(v,'v')) )
        msgbox('Wrong data format. Not a proper Saisir struct or numeric matrix.','Data set','error')
    else % Data was accepted. Prepare GUI
        if ismatrix(v) && isnumeric(v)
            v = matrix2saisir(v);
        end
        if size(v.d,1) == 1
            handles.referencename = dataname;
            handles.reference = v;
            set(hObject,'BackgroundColor',[0 0.8 0]);
            set(hObject,'ForegroundColor','white');
            set(handles.text25,'String',['(' num2str(size(v.d,1)) 'x' num2str(size(v.d,2)) ')'])
        else
            msgbox('Only one reference spectrum allowed.','Data set','error')
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.baseText,'Visible','on')
set(handles.baseParText1,'Visible','on')
set(handles.baseParText2,'Visible','on')
set(handles.basePar1,'Visible','on')
set(handles.basePar2,'Visible','on')
set(handles.basePopup,'Visible','on')
set(handles.pushbutton2,'String','Correct reference')
set(handles.baseCancel,'Visible','on')
handles = doBasePlot(handles);
guidata(hObject, handles);


% --- Executes on selection change in basePopup.
function basePopup_Callback(hObject, eventdata, handles)
% hObject    handle to basePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    set(handles.baseParText1,'String','Rigidity')
    set(handles.baseParText2,'String','Peak weight')
    set(handles.basePar1,'String','9')
    set(handles.basePar2,'String','0.01')
else
    set(handles.baseParText1,'String','Order')
    set(handles.baseParText2,'String','Threshold')
    set(handles.basePar1,'String','4')
    set(handles.basePar2,'String','0.01')
end
handles = doBasePlot(handles);
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns basePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from basePopup


% --- Executes during object creation, after setting all properties.
function basePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function basePar1_Callback(hObject, eventdata, handles)
% hObject    handle to basePar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basePar1 as text
%        str2double(get(hObject,'String')) returns contents of basePar1 as a double
handles = doBasePlot(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function basePar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basePar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function basePar2_Callback(hObject, eventdata, handles)
% hObject    handle to basePar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = doBasePlot(handles);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of basePar2 as text
%        str2double(get(hObject,'String')) returns contents of basePar2 as a double


% --- Executes during object creation, after setting all properties.
function basePar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basePar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in baseCancel.
function baseCancel_Callback(hObject, eventdata, handles)
% hObject    handle to baseCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = doCancel(handles);
edit1_changed(hObject,handles);
guidata(hObject, handles);

function handles = doCancel(handles)
set(handles.baseText,'Visible','off')
set(handles.baseParText1,'Visible','off')
set(handles.baseParText2,'Visible','off')
set(handles.basePar1,'Visible','off')
set(handles.basePar2,'Visible','off')
set(handles.basePopup,'Visible','off')
set(handles.pushbutton2,'String','Apply EMSC')
set(handles.baseCancel,'Visible','off')


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
