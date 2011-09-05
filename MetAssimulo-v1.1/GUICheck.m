function varargout = GUICheck(varargin)
% GUICHECK M-file for GUICheck.fig
%   Check for duplicate information. 
%
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUICheck_OpeningFcn, ...
                   'gui_OutputFcn',  @GUICheck_OutputFcn, ...
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


% --- Executes just before GUICheck is made visible.
function GUICheck_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUICheck (see VARARGIN)
handles.name=char(varargin{1});
% Choose default command line output for GUICheck
handles.out=0;
set(handles.txtmet,'String',handles.name);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUICheck wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUICheck_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.stop==1;
    varargout{1} = handles.out;
    guidata(hObject,handles);
    close(handles.figure1);
end;


% --- Executes on button press in yes.
function yes_Callback(hObject, eventdata, handles)
% hObject    handle to yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
handles.out=0;
handles.stop=1;
guidata(hObject,handles);



% --- Executes on button press in no.
function no_Callback(hObject, eventdata, handles)
% hObject    handle to no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
handles.out=1;
handles.stop=1;
guidata(hObject,handles);
