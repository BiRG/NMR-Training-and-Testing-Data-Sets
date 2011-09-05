function varargout = GUIInputParameters(varargin)
% GUIInputParameters: M-file for GUIInputParameters.fig
%
% Alter parameters, choose correlations, whether concentrations are given 
% as fold changes, simulate with/without peak shift.
%
% The default parameters can also be changed in the parameters.txt file.
%
%--------------------------------------------------------------------------
%         ** Harriet Muncey - Imperial College London (2010) **
%--------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIInputParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIInputParameters_OutputFcn, ...
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

% --- Executes just before GUIInputParameters is made visible.
function GUIInputParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIInputParameters (see VARARGIN)
% Reads in the parameters file.

if exist('Input/parameters.txt','file') ~= 2
    warning('Unable to find parameters.txt file in Input directory');
    close(gcbf);
else
[parameter_name, parameter_value] = textread('Input/parameters.txt','%q\t %q\t ','headerlines',1,'commentstyle','matlab');


%%% Identify Input Parameters & Assign Handles %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% General
index(1)=strmatch('SNR',parameter_name);
index(2)=strmatch('# of Replicates(Mix1)',parameter_name);
index(3)=strmatch('# of Replicates(Mix2)',parameter_name);

handles.SNR = str2double(parameter_value{index(1)});
handles.nreplcontrol = str2double(parameter_value{index(2)});
handles.nreplcase = str2double(parameter_value{index(3)});

% Switches
index(4)=strmatch('Same concentration for both mixtures',parameter_name);
index(5)=strmatch('Peak Shift On',parameter_name);
index(6)=strmatch('Display Output',parameter_name);
index(7)=strmatch('Mix 2 given as fold changes',parameter_name);

handles.samesim = str2double(parameter_value{index(4)});
set(handles.sameconc,'Value',handles.samesim);
if handles.samesim==1
    handles.Ratios=0;
else
    handles.Ratios = str2double(parameter_value{index(7)});
end;
set(handles.ratios,'Value',handles.Ratios);
handles.peak_shift_on = str2double(parameter_value{index(5)});
set(handles.shift_on,'Value',handles.peak_shift_on);
if handles.peak_shift_on~=1
    set(handles.peakshift,'visible','off');
end;
handles.display_output = str2double(parameter_value{index(6)});
set(handles.display_out,'Value',handles.display_output);


handles.correlate = 0;
handles.both = 0;
handles.quit=0;
handles.okpressed = 0;


% File Names
index(8)=strmatch('Mix1 Conc Filename',parameter_name);
index(9)=strmatch('Mix2 Conc Filename',parameter_name);
index(10)=strmatch('NSSD Location',parameter_name);
index(11)=strmatch('Experiments File',parameter_name);
index(12)=strmatch('Protons File',parameter_name);
index(13)=strmatch('Local Names File',parameter_name);
index(14)=strmatch('Synonym Converter',parameter_name);
index(15)=strmatch('Original pKa file',parameter_name);
index(16)=strmatch('Original multiplet file',parameter_name);
index(17)=strmatch('Original peak file',parameter_name);
index(18)=strmatch('Original acid base file',parameter_name);
index(19)=strmatch('Converted pKa file',parameter_name);
index(20)=strmatch('Converted multiplet file',parameter_name);
index(21)=strmatch('Converted peak file',parameter_name);
index(22)=strmatch('Converted acid base file',parameter_name);
index(23)=strmatch('Output ppm Values',parameter_name);
index(24)=strmatch('Output Mix 1',parameter_name,'exact');
index(25)=strmatch('Output Mix 2',parameter_name,'exact');
index(26)=strmatch('Output Metabolites not included',parameter_name);
index(27)=strmatch('Output Simulated Concs Mix1',parameter_name);
index(28)=strmatch('Output Simulated Concs Mix2',parameter_name);
index(29)=strmatch('Output Converted pKa',parameter_name);
index(30)=strmatch('Output Converted Multiplets',parameter_name);
index(31)=strmatch('Output Converted Peaks',parameter_name);
index(32)=strmatch('Output Converted Acid Base Limits',parameter_name);
index(33)=strmatch('Output pKa',parameter_name);
index(34)=strmatch('Output Acid Base Limits',parameter_name);
index(35)=strmatch('Output Mix 1 pH list',parameter_name);
index(36)=strmatch('Output Mix 2 pH list',parameter_name);

handles.controlfile = parameter_value{index(8)};
handles.casefile = parameter_value{index(9)};
handles.databaseloc = parameter_value{index(10)};
handles.exploc = parameter_value{index(11)};
handles.protonsloc = parameter_value{index(12)};
handles.local_names  = parameter_value{index(13)};
handles.synonyms = parameter_value{index(14)};
handles.pka_file = parameter_value{index(15)};
handles.just_multiplets = parameter_value{index(16)};
handles.multiplets = parameter_value{index(17)};
handles.ab = parameter_value{index(18)};
handles.ConpKa = parameter_value{index(19)};
handles.ConMult = parameter_value{index(20)};
handles.ConPeaks = parameter_value{index(21)};
handles.ConABLims = parameter_value{index(22)};
handles.wherex = parameter_value{index(23)};
handles.wheremix1 = parameter_value{index(24)};
handles.wheremix2 = parameter_value{index(25)};
handles.outname = parameter_value{index(26)};
handles.Concs1Out = parameter_value{index(27)};
handles.Concs2Out = parameter_value{index(28)};
handles.ConpKaOut = parameter_value{index(29)};
handles.ConMultOut = parameter_value{index(30)};
handles.ConPeaksOut = parameter_value{index(31)};
handles.ConABLimsOut = parameter_value{index(32)};
handles.pKaOut = parameter_value{index(33)};
handles.ABLimsOut = parameter_value{index(34)};
handles.PHOut1 = parameter_value{index(35)};
handles.PHOut2 = parameter_value{index(36)};

if any(index(8:36)==0)
    display('Warning: One or more input filenames unspecified')
end;

% Pre Processing

index(37)=strmatch('x-Axis Start',parameter_name);
index(38)=strmatch('x-Axis End',parameter_name);
index(39)=strmatch('# of data points',parameter_name);
index(40)=strmatch('# of bins',parameter_name,'exact');
index(41)=strmatch('Boundary of Standard Peak',parameter_name);
index(42)=strmatch('Excl. Region Lower Bound',parameter_name);
index(43)=strmatch('Excl. Region Upper Bound',parameter_name);
index(44)=strmatch('# of bins (baseline correction)',parameter_name);
index(45)=strmatch('Bandwidth Indiv',parameter_name);
index(46)=strmatch('Bandwidth Mixture',parameter_name);
index(47)=strmatch('Threshold Indiv',parameter_name);
index(48)=strmatch('Threshold Mixture',parameter_name);

handles.xstart = str2double(parameter_value{index(37)});
handles.xend = str2double(parameter_value{index(38)});
handles.datapoints = str2double(parameter_value{index(39)});
handles.bins = str2double(parameter_value{index(40)});
handles.standard = str2double(parameter_value{index(41)});
handles.water0 = str2double(parameter_value{index(42)});
handles.water1 = str2double(parameter_value{index(43)});
handles.binsbc = str2double(parameter_value{index(44)});
handles.bandwidth1 = str2double(parameter_value{index(45)});
handles.bandwidth2 = str2double(parameter_value{index(46)});
handles.threshold1 = str2double(parameter_value{index(47)});
handles.threshold2 = str2double(parameter_value{index(48)});

% Peak Shift Settings

index(49)=strmatch('Threshold for Peak Shift',parameter_name);
index(50)=strmatch('Broadness',parameter_name);
index(51)=strmatch('pKa SD',parameter_name);
index(52)=strmatch('Max distance between peaks in multiplet (ppm)',parameter_name);
index(53)=strmatch('Maximum pH shift (ppm)',parameter_name);
index(54)=strmatch('Update peak shift input files',parameter_name);
index(55)=strmatch('Same pH for all mix1 reps',parameter_name);
index(56)=strmatch('Same pH for all mix2 reps',parameter_name);
index(57)=strmatch('Mix1 pH Mean',parameter_name);
index(58)=strmatch('Mix2 pH Mean',parameter_name);
index(59)=strmatch('Mix1 pH SD',parameter_name);
index(60)=strmatch('Mix2 pH SD',parameter_name);
index(61)=strmatch('pKa Mean',parameter_name);

handles.thresh3 = str2double(parameter_value{index(49)});
handles.howbroad = str2double(parameter_value{index(50)});
handles.sd2 = str2double(parameter_value{index(51)});
handles.howclose2 = str2double(parameter_value{index(52)});
handles.max_shift = str2double(parameter_value{index(53)});
handles.update = str2double(parameter_value{index(54)});
handles.pHsame1 = str2double(parameter_value{index(55)});
handles.pHsame2 = str2double(parameter_value{index(56)});
handles.pHval1 = str2double(parameter_value{index(57)});
handles.pHval2 = str2double(parameter_value{index(58)});
handles.sdev1 = str2double(parameter_value{index(59)});
handles.sdev2 = str2double(parameter_value{index(60)});
handles.pKamean = str2double(parameter_value{index(61)});

% Update handles structure.
guidata(hObject, handles);

% Makes GUIInputParameters wait for user response.
uiwait(handles.figure1);
end;

% --- Outputs from this function are returned to the command line.
function varargout = GUIInputParameters_OutputFcn(hObject, eventdata, handles) 
if ~isempty(handles)
    if handles.okpressed == 1
        varargout{1} = handles.SNR;
        varargout{2} = handles.nreplcontrol;
        varargout{3} = handles.nreplcase;
        varargout{4} = handles.controlfile;
        varargout{5} = handles.casefile;
        varargout{6} = handles.xstart;
        varargout{7} = handles.xend;
        varargout{8} = handles.datapoints;
        varargout{9} = handles.databaseloc;
        varargout{10} = handles.bins;
        varargout{11} = handles.standard;
        varargout{12} = handles.water0;
        varargout{13} = handles.water1;
        varargout{14} = handles.exploc; 
        varargout{15} = handles.protonsloc; 
        varargout{16} = handles.binsbc;
        varargout{17} = handles.local_names;
        varargout{18} = handles.synonyms;
        varargout{19} = handles.bandwidth1;
        varargout{20} = handles.bandwidth2;
        varargout{21} = handles.threshold1;
        varargout{22} = handles.threshold2;
        varargout{23} = handles.Ratios;
        varargout{24} = handles.peak_shift_on;
        varargout{25} = handles.thresh3;
        varargout{26} = handles.howbroad;
        varargout{27} = handles.sd2;
        varargout{28} = handles.howclose2;
        varargout{29} = handles.max_shift;
        varargout{30} = handles.update; 
        varargout{31} = handles.pHsame1;
        varargout{32} = handles.pHsame2;
        varargout{33} = handles.pHval1;
        varargout{34} = handles.pHval2;
        varargout{35} = handles.sdev1;
        varargout{36} = handles.sdev2;
        varargout{37} = handles.pka_file;
        varargout{38} = handles.just_multiplets;
        varargout{39} = handles.multiplets;
        varargout{40} = handles.ab;
        varargout{41} = handles.ConpKa;
        varargout{42} = handles.ConMult;
        varargout{43} = handles.ConPeaks;
        varargout{44} = handles.ConABLims;
        varargout{45} = handles.wherex;
        varargout{46} = handles.wheremix1;
        varargout{47} = handles.wheremix2;
        varargout{48} = handles.outname;
        varargout{49} = handles.Concs1Out ; 
        varargout{50} = handles.Concs2Out;
        varargout{51} = handles.ConpKaOut;
        varargout{52} = handles.ConMultOut;
        varargout{53} = handles.ConPeaksOut;
        varargout{54} = handles.ConABLimsOut;
        varargout{55} = handles.pKaOut;
        varargout{56} = handles.ABLimsOut;
        varargout{57} = handles.PHOut1;
        varargout{58} = handles.PHOut2; 
        varargout{59} = handles.pKamean;
        varargout{60} = handles.correlate;
        varargout{61} = handles.both;
        varargout{62} = handles.sameconc;
        varargout{63} = handles.display_output;
        close(handles.figure1);
        
   else
        disp('');
        disp('*************************');
        disp('*  Program  Terminated  *');
        disp('*************************');
        for i=1:65
            varargout{i}=0;
        end;
        close(handles.figure1);
    end;
else
     disp('');
     disp('*************************');
     disp('*  Program  Terminated  *');
     disp('*************************');
     for i=1:65
        varargout{i}=0;
     end;
     close(gcf);
end;

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)

% Resumes GUIInputParameters.
uiresume(handles.figure1);
% Gets the values from the
if  exist ('SimulateSpectrum.m','file')== 2
    handles.okpressed = 1;
    guidata(hObject,handles);
else warning('Please run MetAssimulo in the MetAssimulo directory.');
    guidata(hObject,handles);
end;
    

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
uiresume(handles.figure1);

function nreplcontrol_Callback(hObject, eventdata, handles)
handles.nreplcontrol = str2double(get(hObject,'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function nreplcontrol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Reads in the parameters file.
[parameter_name, parameter_value] = textread('Input/parameters.txt','%q\t %q\t ','headerlines',1);
temp=strmatch('# of Replicates(Mix1)',parameter_name);
set(hObject,'String',parameter_value(temp));


function nreplcase_Callback(hObject, eventdata, handles)
handles.nreplcase = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function nreplcase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Reads in the parameters file.
[parameter_name, parameter_value] = textread('Input/parameters.txt','%q\t %q\t ','headerlines',1);
temp=strmatch('# of Replicates(Mix2)',parameter_name);
set(hObject,'String',parameter_value(temp));

function sigtonoise_Callback(hObject, eventdata, handles)
handles.SNR = str2double(get(hObject, 'String'));
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function sigtonoise_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Reads in the parameters file.
[parameter_name, parameter_value] = textread('Input/parameters.txt','%q\t %q\t ','headerlines',1);
temp=strmatch('SNR',parameter_name);
set(hObject,'String',parameter_value(temp));

% --- Executes on button press in ratios.
function ratios_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.Ratios = 1;
    guidata(hObject,handles);
    else
    handles.Ratios = 0;
    guidata(hObject,handles);
end

% --- Executes on button press in correlate.
function correlate_Callback(hObject, eventdata, handles)
% hObject    handle to correlate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.correlate = 1;
    guidata(hObject,handles);
    else
    handles.correlate = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of correlate


% --- Executes on button press in peakshift.
function peakshift_Callback(hObject, eventdata, handles)
% hObject    handle to peakshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.thresh3,handles.howbroad,handles.sd2,handles.howclose2,handles.max_shift,handles.update,handles.pHsame1,handles.pHsame2,handles.pHval1,handles.pHval2,handles.sdev1,handles.sdev2,handles.pKamean]=GUIPeakShift(handles.update,handles.thresh3,handles.howbroad,handles.pKamean,handles.sd2,handles.howclose2,handles.max_shift,handles.pHval1,handles.pHval2,handles.sdev1,handles.sdev2,handles.pHsame1,handles.pHsame2);
guidata(hObject,handles);

% --- Executes on button press in preproc.
function preproc_Callback(hObject, eventdata, handles)

% hObject    handle to preproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%handles    structure with handles and user data (see GUIDATA)
[handles.xstart,handles.xend,handles.datapoints,handles.bins,handles.standard,handles.water0,handles.water1,handles.binsbc,handles.bandwidth1,handles.bandwidth2,handles.threshold1,handles.threshold2]=GUIPreProcess(handles.xstart,handles.xend,handles.datapoints,handles.bins,handles.standard,handles.water0,handles.water1,handles.binsbc,handles.bandwidth1,handles.bandwidth2,handles.threshold1,handles.threshold2);
guidata(hObject,handles);


% --- Executes on button press in hmdb.
function hmdb_Callback(hObject, eventdata, handles)
% hObject    handle to hmdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
uiresume(handles.figure1);
guidata(hObject,handles);
HMDBScan();

% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in both.
function both_Callback(hObject, eventdata, handles)
% hObject    handle to both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.both = 1;
    guidata(hObject,handles);
    else
    handles.both = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of both


% --- Executes on button press in sameconc.
function sameconc_Callback(hObject, eventdata, handles)
% hObject    handle to sameconc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.samesim=1;
    handles.Ratios=0;
    guidata(hObject,handles);
else
    handles.samesim=0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of sameconc



% --- Executes on button press in addspectra.
function addspectra_Callback(hObject, eventdata, handles)
% hObject    handle to addspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
guidata(hObject,handles);
AddNewSpectra();


% --- Executes on button press in shift_on.
function shift_on_Callback(hObject, eventdata, handles)
% hObject    handle to shift_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.peak_shift_on=1;
    set(handles.peakshift,'visible','on');
    guidata(hObject,handles);
else
    handles.peak_shift_on=0;
    set(handles.peakshift,'visible','off');
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of shift_on


% --- Executes on button press in display_out.
function display_out_Callback(hObject, eventdata, handles)
% hObject    handle to display_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.display_output=1;
    guidata(hObject,handles);
else
    handles.display_output=0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of display_out
