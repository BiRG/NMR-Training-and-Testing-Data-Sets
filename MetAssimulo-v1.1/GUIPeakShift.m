function varargout = GUIPeakShift(varargin)
% GUIPEAKSHIFT : GUI for altering peak shift settings.
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIPeakShift_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIPeakShift_OutputFcn, ...
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


% --- Executes just before GUIPeakShift is made visible.
function GUIPeakShift_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIPeakShift (see VARARGIN)
% Choose default command line output for GUIPeakShift
handles.update = varargin{1};
set(handles.Update,'Value',handles.update);
handles.thresh3 = varargin{2};
set(handles.thresh_ind_pd,'String',num2str(handles.thresh3));
handles.Howbroad = varargin{3};
set(handles.howbroad,'String',num2str(handles.Howbroad));
handles.pKamean = varargin{4};
set(handles.pkamean,'String',num2str(handles.pKamean));
handles.sd2 = varargin{5};
set(handles.sd,'String',num2str(handles.sd2));
handles.howclose2 = varargin{6};
set(handles.howclose,'String',num2str(handles.howclose2));
handles.max_shift = varargin{7};
set(handles.max_shift_ab,'String',num2str(handles.max_shift));
handles.pHval1 = varargin{8};
set(handles.mix1_mean_pH,'String',num2str(handles.pHval1));
handles.pHval2 = varargin{9};
set(handles.mix2_mean_pH,'String',num2str(handles.pHval2));
handles.sdev1 = varargin{10};
set(handles.mix1_sd,'String',num2str(handles.sdev1));
handles.sdev2 = varargin{11};
set(handles.mix2_sd,'String',num2str(handles.sdev2));
handles.pHsame1 = varargin{13};
set(handles.samepH1,'Value',handles.pHsame1);
handles.pHsame2 = varargin{12};
set(handles.samepH2,'Value',handles.pHsame2);
handles.okpeakpressed = 0;
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes GUIPeakShift wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIPeakShift_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.okpeakpressed == 1    
    varargout{1} = handles.thresh3;
    varargout{2} = handles.Howbroad;
    varargout{3} = handles.sd2;
    varargout{4} = handles.howclose2;
    varargout{5} = handles.max_shift;
    varargout{6} = handles.update; 
    varargout{7} = handles.pHsame1;
    varargout{8} = handles.pHsame2;
    varargout{9} = handles.pHval1;
    varargout{10} = handles.pHval2;
    varargout{11} = handles.sdev1;
    varargout{12} = handles.sdev2;
    varargout{13} = handles.pKamean;
    
else
    varargout{1:13}=0;
end;
close(gcf);
% Get default command line output from handles structure

% --- Executes on button press in okpeak.
function okpeak_Callback(hObject, eventdata, handles)
% hObject    handle to okpeak (see GCBO)

handles.okpeakpressed = 1;
uiresume(handles.figure1);
guidata(hObject,handles);

% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.update = 1;
    guidata(hObject,handles);
    else
    handles.update = 0;
    guidata(hObject,handles);
end


function sd_Callback(hObject, eventdata, handles)
handles.sd2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function sd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pkamean_Callback(hObject, eventdata, handles)
handles.pKamean = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function pkamean_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function howclose_Callback(hObject, eventdata, handles)
handles.howclose2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function howclose_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_shift_ab_Callback(hObject, eventdata, handles)
handles.max_shift = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function max_shift_ab_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function howbroad_Callback(hObject, eventdata, handles)
handles.Howbroad = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function howbroad_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function thresh_ind_pd_Callback(hObject, eventdata, handles)
handles.thresh3 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function thresh_ind_pd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in samepH1.
function samepH1_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.pHsame1 = 1;
    guidata(hObject,handles);
    else
    handles.pHsame1 = 0;
    guidata(hObject,handles);
end

% --- Executes on button press in samepH2.
function samepH2_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.pHsame2 = 1;
    guidata(hObject,handles);
    else
    handles.pHsame2 = 0;
    guidata(hObject,handles);
end


function mix1_mean_pH_Callback(hObject, eventdata, handles)
handles.pHval1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function mix1_mean_pH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mix2_mean_pH_Callback(hObject, eventdata, handles)
handles.pHval2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function mix2_mean_pH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mix1_sd_Callback(hObject, eventdata, handles)
handles.sdev1 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function mix1_sd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mix2_sd_Callback(hObject, eventdata, handles)
handles.sdev2 = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function mix2_sd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
