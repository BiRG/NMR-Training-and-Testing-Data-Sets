function varargout = GUIAddSpectra(varargin)
% GUIADDSPECTRA : Retrieves requirements for metabolic template
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIAddSpectra_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIAddSpectra_OutputFcn, ...
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


% --- Executes just before GUIAddSpectra is made visible.
function GUIAddSpectra_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIAddSpectra (see VARARGIN)
% Choose default command line output for GUIAddSpectra
handles.output = hObject;
handles.i=0;
handles.metabolites=[];
handles.expno=[];
set(handles.spectra,'String',handles.metabolites);
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);
% UIWAIT makes GUIAddSpectra wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIAddSpectra_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if exist('handles.go','var')~=0
if handles.go ==1
    varargout{1}=handles.metabolites;
    varargout{2}=handles.expno;
    close(handles.figure1);
end;
%else
    %varargout{1}=0;
    %varargout{2}=0;
%end;
% Get default command line output from handles structure



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
handles.go=1;
guidata(hObject,handles);




% --- Executes on selection change in spectra.
function spectra_Callback(hObject, eventdata, handles)
% hObject    handle to spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spectra contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spectra


% --- Executes during object creation, after setting all properties.
function spectra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addspectra.
function addspectra_Callback(hObject, eventdata, handles)
% hObject    handle to addspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('**************************************************************');
disp('* Please Specify Location of Particular Experimental Spectra *');
disp('**************************************************************');
disp('');
path = uigetdir('','Specify Location of Particular Experimental Spectra');
sep=strcat('\',filesep);
parts= regexp(path,sep,'split');
n=size(parts);
a=n(2)-1;
b=n(2);
if isempty(str2num(parts{b}))
    warning('Please ensure you select an Experiment Folder');    
else
    handles.i=handles.i+1;
    handles.metabolites{handles.i}=parts{a};
    handles.expno{handles.i}=parts{b};
    set(handles.spectra,'String',handles.metabolites);
    guidata(hObject,handles);
end;
