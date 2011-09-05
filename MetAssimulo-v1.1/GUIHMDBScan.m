function varargout = GUIHMDBScan(varargin)
% GUIHMDBSCAN M-file for GUIHMDBScan.fig
%      GUIHMDBSCAN, by itself, creates a new GUIHMDBSCAN or raises the existing
%      singleton*.
%
%      H = GUIHMDBSCAN returns the handle to a new GUIHMDBSCAN or the handle to
%      the existing singleton*.
%
%      GUIHMDBSCAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIHMDBSCAN.M with the given input arguments.
%
%      GUIHMDBSCAN('Property','Value',...) creates a new GUIHMDBSCAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIHMDBScan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIHMDBScan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIHMDBScan

% Last Modified by GUIDE v2.5 11-Mar-2010 14:19:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIHMDBScan_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIHMDBScan_OutputFcn, ...
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


% --- Executes just before GUIHMDBScan is made visible.
function GUIHMDBScan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIHMDBScan (see VARARGIN)

% Choose default command line output for GUIHMDBScan
handles.biofluids{1}='Amniotic Fluid';
handles.biofluids{2}='Aqueous Humour';
handles.biofluids{3}='Ascites Fluid';
handles.biofluids{4}='Bile';
handles.biofluids{5}='Blood';
handles.biofluids{6}='Breast Milk';
handles.biofluids{7}='Cellular Cytoplasm';
handles.biofluids{8}='CSF';
handles.biofluids{9}='Lymph';
handles.biofluids{10}='Pericardial Effusion';
handles.biofluids{11}='Prostate Tissue';
handles.biofluids{12}='Saliva';
handles.biofluids{13}='Semen';
handles.biofluids{14}='Sweat';
handles.biofluids{15}='Tears';
handles.biofluids{16}='Urine';
set(handles.fluids,'Value',16);
set(handles.fluids,'String',handles.biofluids);
handles.output = hObject;
handles.sex=3;
handles.val=16;
handles.age=[0,0,0,0,0,0,1];
handles.go=0;
handles.fluidout=handles.biofluids{handles.val};
set(handles.any,'Value',1);
set(handles.both,'Value',1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIHMDBScan wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIHMDBScan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%if exist('handles.go','var')~=0
  if handles.go == 1
    varargout{1} = handles.sex;
    varargout{2} = handles.age;
    varargout{3} = handles.fluidout;
    close(handles.figure1);
  end;
% else
%     varargout{1} = 0;
%     varargout{2} = 0;
%     varargout{3} = 0;
% end;



% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
fluids_Callback(hObject, eventdata, handles);
handles.go=1;
guidata(hObject,handles);
uiresume(handles.figure1);

% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in old.
function old_Callback(hObject, eventdata, handles)
% hObject    handle to old (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(6) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else handles.age(6) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of old


% --- Executes on button press in child.
function child_Callback(hObject, eventdata, handles)
% hObject    handle to child (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(3) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else
    handles.age(3) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of child


% --- Executes on button press in adult.
function adult_Callback(hObject, eventdata, handles)
% hObject    handle to adult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(5) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else
    handles.age(5) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of adult


% --- Executes on button press in both.
function both_Callback(hObject, eventdata, handles)
% hObject    handle to both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.sex=3;
    set(handles.female,'Value',0);
    set(handles.male,'Value',0);
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of both


% --- Executes on button press in female.
function female_Callback(hObject, eventdata, handles)
% hObject    handle to female (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.sex = 1;
    set(handles.male,'Value',0);
    set(handles.both,'Value',0);
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of female


% --- Executes on button press in male.
function male_Callback(hObject, eventdata, handles)
% hObject    handle to male (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.sex = 2;
    set(handles.female,'Value',0);
    set(handles.both,'Value',0);
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of male


% --- Executes on button press in any.
function any_Callback(hObject, eventdata, handles)
% hObject    handle to any (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(7) = 1;
    for i=1:6
        handles.age(i) = 0;
    end;
    set(handles.child,'Value',0);
    set(handles.adult,'Value',0);
    set(handles.old,'Value',0);
    set(handles.new,'Value',0);
    set(handles.infant,'Value',0);
    set(handles.teen,'Value',0);
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of any


% --- Executes on button press in teen.
function teen_Callback(hObject, eventdata, handles)
% hObject    handle to teen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(4) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else
    handles.age(4) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of teen


% --- Executes on button press in infant.
function infant_Callback(hObject, eventdata, handles)
% hObject    handle to infant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(2) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else
    handles.age(2) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of infant


% --- Executes on button press in new.
function new_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.age(1) = 1;
    handles.age(7) = 0;
    set(handles.any,'Value',0);
    guidata(hObject,handles);
else
    handles.age(1) = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of new


% --- Executes on selection change in fluids.
function fluids_Callback(hObject, eventdata, handles)
% hObject    handle to fluids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.val = get(handles.fluids,'Value');
handles.fluidout=handles.biofluids{handles.val};
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns fluids contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fluids


% --- Executes during object creation, after setting all properties.
function fluids_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fluids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
