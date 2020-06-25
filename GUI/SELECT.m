function varargout = SELECT(varargin)
% SELECT MATLAB code for SELECT.fig
%      SELECT, by itself, creates a new SELECT or raises the existing
%      singleton*.
%
%      H = SELECT returns the handle to a new SELECT or the handle to
%      the existing singleton*.
%
%      SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT.M with the given input arguments.
%
%      SELECT('Property','Value',...) creates a new SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SELECT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SELECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SELECT

% Last Modified by GUIDE v2.5 08-Nov-2013 11:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SELECT_OpeningFcn, ...
                   'gui_OutputFcn',  @SELECT_OutputFcn, ...
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


% --- Executes just before SELECT is made visible.
function SELECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SELECT (see VARARGIN)

% Choose default command line output for SELECT
handles.output = hObject;
handles.selected = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SELECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SELECT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
objects = evalin('base','who');
set(hObject,'Data',cellstr(objects));
guidata(hObject, handles);
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
nsel = length(handles.selected);
global selectedGlob
if nsel > 0 % Something selected
    if nsel > 3
        errordlg('Do not select more than 3 objects')
    else
        vars = get(handles.uitable1,'Data');
        if nsel == 1 % Single selection
            c = evalin('base',['class(' vars{handles.selected} ')']);
            if strcmp(c,'struct')
                selectedGlob = vars{handles.selected};
                close
            elseif strcmp(c,'double')
                s = evalin('base',['size(' vars{handles.selected} ')']);
                if prod(s) > 1
                    evalin('base',[vars{handles.selected} '_saisir.d = ' vars{handles.selected} ';'])
                    evalin('base',[vars{handles.selected} '_saisir.i = num2str((1:size(' vars{handles.selected} ',1))'');']);
                    evalin('base',[vars{handles.selected} '_saisir.v = num2str((1:size(' vars{handles.selected} ',2))'');']);
                    selectedGlob = [vars{handles.selected} '_saisir'];
                    close
                else
                    errordlg('Selecting a single scalar makes no sense')
                end
            else
                errordlg('If selecting a single object, make sure it is a Saisir struct or a matrix')
            end
            
        else % Multiple selection
            c = cell(nsel,1);
            for i=1:nsel
                c{i} = evalin('base',['class(' vars{handles.selected(i)} ')']);
            end
            if any(strcmp('struct',c))
                errordlg('If selecting more than one object, make sure none are structs')
            else
                if nsel == 2
                    if any(strcmp('char',c)) && any(strcmp('double',c))
                        evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.d = ' vars{handles.selected(strcmp('double',c))} ';']);
                        [s1,s2] = evalin('base',['size(' vars{handles.selected(strcmp('double',c))} ');']);
                        [s3,s4] = evalin('base',['size(' vars{handles.selected(strcmp('char',c))} ');']);
                        if s1==s3
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.i = ' vars{handles.selected(strcmp('char',c))} ';']);
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.v = num2str((1:size(' vars{handles.selected(strcmp('double',c))} ',2))'');']);
                            selectedGlob = [vars{handles.selected(strcmp('double',c))} '_saisir'];
                            close
                        elseif s1==s4
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.i = ' vars{handles.selected(strcmp('char',c))} ''';']);
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.v = num2str((1:size(' vars{handles.selected(strcmp('double',c))} ',2))'');']);
                            selectedGlob = [vars{handles.selected(strcmp('double',c))} '_saisir'];
                            close
                        elseif s2==s3
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.i = num2str((1:size(' vars{handles.selected(strcmp('double',c))} ',1))'');']);
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.v = ' vars{handles.selected(strcmp('char',c))} ';']);
                            selectedGlob = [vars{handles.selected(strcmp('double',c))} '_saisir'];
                            close
                        elseif s2==s4
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.i = num2str((1:size(' vars{handles.selected(strcmp('double',c))} ',1))'');']);
                            evalin('base',[vars{handles.selected(strcmp('double',c))} '_saisir.v = ' vars{handles.selected(strcmp('char',c))} ''';']);
                            selectedGlob = [vars{handles.selected(strcmp('double',c))} '_saisir'];
                            close
                        else
                            errordlg('Character vector does not match the size of the spectra')
                        end
                    else
                        errordlg('If selecting two objects, make sure one is a char matrix and one is a double matrix')
                    end
                else % nsel == 3
                    if sum(strcmp('char',c))==2 && sum(strcmp('double',c))==1
                        indChar = find(strcmp('char',c));
                        indDouble = find(strcmp('double',c));
                        evalin('base',[vars{handles.selected(indDouble)} '_saisir.d = ' vars{handles.selected(indDouble)} ';']);
                        [s1,s2] = evalin('base',['size(' vars{handles.selected(indDouble)} ');']);
                        [s3,s4] = evalin('base',['size(' vars{handles.selected(indChar(1))} ');']);
                        [s5,s6] = evalin('base',['size(' vars{handles.selected(indChar(2))} ');']);
                        if s1==s3 && s2==s5
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.i = ' vars{handles.selected(indChar(1))} ';']);
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.v = ' vars{handles.selected(indChar(2))} ';']);
                            selectedGlob = [vars{handles.selected(indDouble)} '_saisir'];
                            close
                        elseif s1==s4 && s2==s6
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.i = ' vars{handles.selected(indChar(1))} ''';']);
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.v = ' vars{handles.selected(indChar(2))} ''';']);
                            selectedGlob = [vars{handles.selected(indDouble)} '_saisir'];
                            close
                        elseif s1==s5 && s2==s3
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.i = ' vars{handles.selected(indChar(2))} ';']);
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.v = ' vars{handles.selected(indChar(1))} ';']);
                            selectedGlob = [vars{handles.selected(indDouble)} '_saisir'];
                            close
                        elseif s1==s6 && s2==s4
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.i = ' vars{handles.selected(indChar(2))} ''';']);
                            evalin('base',[vars{handles.selected(indDouble)} '_saisir.v = ' vars{handles.selected(indChar(1))} ''';']);
                            selectedGlob = [vars{handles.selected(indDouble)} '_saisir'];
                            close
                        else
                            errordlg('Make sure character vectors are aligned the same way and have sizes matching the spectra')
                        end
                    else
                        errordlg('If selecting three objects, make sure they are two char matrices and one double matrix')
                    end
                end
            end
        end
    end
end

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
handles.selected = eventdata.Indices(:,1);
guidata(hObject, handles);

% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
