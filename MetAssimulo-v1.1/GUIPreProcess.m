function varargout = GUIPreProcess(varargin)
% GUIPREPROCESS : GUI for altering spectra processing parameters.
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIPreProcess_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIPreProcess_OutputFcn, ...
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


% --- Executes just before GUIPreProcess is made visible.
function GUIPreProcess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIPreProcess (see VARARGIN)
% Choose default command line output for GUIPreProcess

handles.Xstart = varargin{1};
set(handles.xstart,'String',num2str(handles.Xstart));
handles.Xend = varargin{2};
set(handles.xend,'String',num2str(handles.Xend));
handles.Datapoints = varargin{3};
set(handles.xincrement,'String',num2str(handles.Datapoints));
handles.Bins = varargin{4};
set(handles.bins,'String',handles.Bins);
handles.Standard = varargin{5};
set(handles.standardbound,'String',handles.Standard);
handles.Water0 = varargin{6};
set(handles.waterlower,'String',handles.Water0);
handles.Water1 = varargin{7};
set(handles.waterupper,'String',handles.Water1);
handles.Binsbc = varargin{8};
set(handles.binsbc,'String',handles.Binsbc);
handles.Bandwidth1 = varargin{9};
set(handles.bandwidth1, 'String',num2str(handles.Bandwidth1));
handles.Bandwidth2 = varargin{10};
set(handles.bandwidth2, 'String',num2str(handles.Bandwidth2));
handles.Threshold1 = varargin{11};
set(handles.threshold1,'String',num2str(handles.Threshold1));
handles.Threshold2 = varargin{12};
set(handles.threshold2,'String',num2str(handles.Threshold2));

handles.okprocpressed = 0;
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);


% UIWAIT makes GUIPreProcess wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIPreProcess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.okprocpressed ==1   
    varargout{1} = handles.Xstart;
    varargout{2} = handles.Xend;
    varargout{3} = handles.Datapoints;
    varargout{4} = handles.Bins;
    varargout{5} = handles.Standard;
    varargout{6} = handles.Water0;
    varargout{7} = handles.Water1;
    varargout{8} = handles.Binsbc;
    varargout{9} = handles.Bandwidth1;
    varargout{10} = handles.Bandwidth2;
    varargout{11} = handles.Threshold1;
    varargout{12} = handles.Threshold2;
else
    [parameter_name, parameter_value] = textread('Input/parameters.txt','%q\t %q\t ','headerlines',1);
    varargout{1:14}=0;
end;
close(gcf); 

% --- Executes on button press in okspectra.
function okspectra_Callback(hObject, eventdata, handles)
% hObject    handle to okspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
uiresume(handles.figure1);
handles.okprocpressed =1;
guidata(hObject,handles);

function binsbc_Callback(hObject, eventdata, handles)
handles.Binsbc = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function binsbc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bins_Callback(hObject, eventdata, handles)
handles.Bins = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function bins_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xstart_Callback(hObject, eventdata, handles)
handles.Xstart = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function xstart_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xend_Callback(hObject, eventdata, handles)
handles.Xend = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function xend_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function waterlower_Callback(hObject, eventdata, handles)
handles.Water0 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function waterlower_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xincrement_Callback(hObject, eventdata, handles)
handles.Datapoints = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function xincrement_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function waterupper_Callback(hObject, eventdata, handles)
handles.Water1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function waterupper_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function standardbound_Callback(hObject, eventdata, handles)
handles.Standard = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function standardbound_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bandwidth2_Callback(hObject, eventdata, handles)
handles.Bandwidth2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function bandwidth2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function threshold2_Callback(hObject, eventdata, handles)
handles.Threshold2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function threshold2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bandwidth1_Callback(hObject, eventdata, handles)
handles.Bandwidth1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function bandwidth1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function threshold1_Callback(hObject, eventdata, handles)
handles.Threshold1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function threshold1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

