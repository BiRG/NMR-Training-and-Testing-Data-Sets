function varargout = GUICorrelation(varargin)
% GUICORRELATION M-file for GUICorrelation.fig
%      
%   INPUT:list of metabolites present
%         filepath of output directory

%   OUTPUT:number of correlated metabolites
%          list of correlated metabolites
%          correlation matrices
% 

% Last Modified by GUIDE v2.5 13-Jan-2010 09:29:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUICorrelation_OpeningFcn, ...
                   'gui_OutputFcn',  @GUICorrelation_OutputFcn, ...
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


% --- Executes just before GUICorrelation is made visible.
function GUICorrelation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Initialize Variables
samesim=varargin{3};
handles.MATRIX1=[]; 
set(handles.correlation1,'data',handles.MATRIX1);
handles.selectedCells1= [0,0];
handles.MATRIX2=[];
set(handles.correlation2,'data',handles.MATRIX2);
handles.selectedcell2= [0,0];

%Indicates Matrix1 loaded from file
handles.loadon1=0;
%Indicates Matrix2 loaded from file
handles.loadon2=0;

handles.FULL1=[]; %Loaded Correlation Matrix1
handles.FULL2=[]; %Loaded Correlation Matrix2
handles.cpos=[]; %Records which row of the loaded matrix is altered

n=length(varargin{1}); %Count how many metabolites are in the mixtures
handles.meta=varargin{1}; %Read in metabolite names
set(handles.metabolites,'String',handles.meta);
handles.outputdir=(varargin{2});

set(handles.load1,'visible','on');
set(handles.loadmsg1,'visible','off');
set(handles.load2,'visible','on');
set(handles.loadmsg2,'visible','off');

handles.z=0; %Counts correlations altered by user in GUI
handles.mets_used=[];
handles.metsout=[]; %List of Correlated Metabolites
handles.output = hObject;

handles.samematrix=0; %Indicates to use same correlation for both mixtures
handles.okpress= 0;

if samesim==1
    handles.samematrix=1;
    set(handles.updatecorrelation2,'visible','off');
    set(handles.newvalue2,'visible','off');
    set(handles.samecorr,'visible','off');
    set(handles.load2,'visible','off');
    set(handles.loadmsg2,'visible','off');
    set(handles.cratio,'visible','off');
end;
guidata(hObject, handles);
uiwait(handles.figure1);


% UIWAIT makes GUICorrelation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUICorrelation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Put metabolite names and correlation1 matrix into output array
if handles.okpress == 1
   nc=size(handles.MATRIX1);
   if handles.loadon1 == 1
       handles.metsout = get(handles.metabolites,'String');
   end;
   if handles.samematrix ==1
       handles.MATRIX2=handles.MATRIX1;
   end;
   varargout{1}=nc;
   varargout{2}=handles.metsout;
   varargout{3}=handles.MATRIX1;
   varargout{4}=handles.MATRIX2;
   close(handles.figure1);
 
 end;

% Get default command line output from handles structure
%varargout{1} = handles.output;



% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
uiresume(handles.figure1);
handles.okpress=1;

if handles.samematrix ==1;
    handles.MATRIX2 = handles.MATRIX1;
end;

if handles.cratio ==1; %Calculate correlations from fold values
   if handles.loadon1 == 1
    for i=1:handles.z
       for j=1:handles.z 
            handles.FULL2(i,j)=handles.FULL2(i,j)*handles.FULL1(i,j);
       end;
    end;
   else    
    for k=1:handles.z
        for l=1:handles.z
            handles.MATRIX2(k,l)=handles.MATRIX1(k,l)*handles.MATRIX2(k,l);
        end;
    end;
    end;
end;

if handles.loadon1 == 1 %Reinsert altered correlations into original full matrices
    for i=1:handles.z
        for j=1:handles.z
            handles.FULL1(handles.cpos(i),handles.cpos(j))=handles.MATRIX1(i,j);
            handles.FULL2(handles.cpos(i),handles.cpos(j))=handles.MATRIX2(i,j);
        end;
    end;
    %Output file containing altered correlations
    if handles.z > 0
    file=fopen(strcat(handles.outputdir,'/Correlation_Alterations.txt'),'w');
    fprintf(file, '\n%s\n\n','Alterations to Correlation for Mixture 1');
    for i=1:handles.z
        for j=1:handles.z
          fprintf(file,'%g\t',handles.MATRIX1(i,j));
        end;
        fprintf(file,'\n');
    end;
    fprintf(file, '\n%s\n\n','Alterations to Correlation for Mixture 2');
    for i=1:handles.z
        for j=1:handles.z
          fprintf(file,'%g\t',handles.MATRIX2(i,j));
        end;
        fprintf(file,'\n');
    end;
    handles.meta=cellstr(handles.meta);
    for i=1:handles.z
        metabolitename=handles.meta{handles.cpos(i)};
        fprintf(file,'\n%s',metabolitename);
    end;
    fclose(file);
    end;
    handles.MATRIX1=handles.FULL1;
    handles.MATRIX2=handles.FULL2;
end;

guidata(hObject,handles);


% --- Executes on selection change in metabolites.
function metabolites_Callback(hObject, eventdata, handles)
% hObject    handle to metabolites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns metabolites contents as cell array
%        contents{get(hObject,'Value')} returns selected item from metabolites
% --- Executes during object creation, after setting all properties.

function metabolites_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metabolites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);



% --- Executes on button press in add1.
function add1_Callback(hObject, eventdata, handles)
% 
check =1;
if handles.loadon1 == 0 && handles.loadon2 == 0
set(handles.load1,'visible','off');
set(handles.load2,'visible','off');
set(handles.loadmsg1,'visible','off');
set(handles.loadmsg2,'visible','off');
end; 
%get appropriate metabolite name 
val = get(handles.metabolites,'Value');
string_list = get(handles.metabolites,'String');
sel_met=string_list{val};
handles.z=handles.z +1; %counts # correlated metabolites
z=handles.z;
x=strcat(num2str(handles.z),' : ',sel_met);
if z > 1
for i = 2:z
    if strcmp(sel_met,handles.metsout(i-1)) == 1
        check = 0;
    end;
end;
end;
if check == 0
    warning('Metabolite already loaded into editor.');
    handles.z=handles.z-1;
else
handles.mets_used{handles.z} = x;
handles.metsout{handles.z} = sel_met;

%updatecorrelation1 list of correlated metabolites
set(handles.correlated_metabolites,'String',handles.mets_used);

MATRIX1=handles.MATRIX1;
MATRIX2=handles.MATRIX2;

if handles.loadon1 == 1
FULL1=handles.FULL1;
FULL2=handles.FULL2;
end;

%expand correlation1 matrix
n=(size(MATRIX1));
x1=zeros(n(1),1);
MATRIX1=[MATRIX1,x1];
x1=zeros(1,n(1)+1);
MATRIX1=[MATRIX1;x1];

for i= 1:(size(MATRIX1));
MATRIX1(i,i)=1;
end;

if handles.loadon1 == 1
   %find correlations of selected metabolites 
   handles.cpos=cat(1,handles.cpos,val); %store position
   for i= 1:z;
      for j=1:z;
          MATRIX1(i,j)=FULL1(handles.cpos(i),handles.cpos(j));
          if handles.samecorr == 1
              MATRIX2=MATRIX1;
              FULL2=FULL1;
          end;
      end;
   end;
end;    
handles.MATRIX1=MATRIX1;

%updatecorrelation1 table
set(handles.correlation1,'data',MATRIX1);

%expand correlation2 matrix
n=(size(MATRIX2));
x2=zeros(n(1),1);
MATRIX2=[MATRIX2,x2];
x2=zeros(1,n(1)+1);
MATRIX2=[MATRIX2;x2];

for i= 1:(size(MATRIX2));
 MATRIX2(i,i)=1;
end;

if handles.loadon2 == 1
   %find correlations of selected metabolites 
   for i= 1:z;
      for j=1:z;
          MATRIX2(i,j)=FULL2(handles.cpos(i),handles.cpos(j));
      end;
   end;
end;

handles.MATRIX2=MATRIX2;
if handles.samematrix == 1
    handles.MATRIX2=handles.MATRIX1;
end;
    
%updatecorrelation2 table
set(handles.correlation2,'data',handles.MATRIX2);
guidata(hObject,handles);
end;



% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in correlated_metabolites.
function correlated_metabolites_Callback(hObject, eventdata, handles)
% hObject    handle to correlated_metabolites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.correlated_metabolites = get(hObject,'String');
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns correlated_metabolites contents as cell array
%        contents{get(hObject,'Value')} returns selected item from correlated_metabolites

% --- Executes during object creation, after setting all properties.
function correlated_metabolites_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correlated_metabolites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newvalue1_Callback(hObject, eventdata, handles)
% hObject    handle to newvalue1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newvalue1 as text
%        str2double(get(hObject,'String')) returns contents of newvalue1 as a double

% --- Executes during object creation, after setting all properties.
function newvalue1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newvalue1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatecorrelation1.
function updatecorrelation1_Callback(hObject, eventdata, handles)
% hObject    handle to updatecorrelation1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
new1 = get(handles.newvalue1,'String');
new1 =str2num(new1);
loc1=handles.selectedCells1;
i=loc1(1);
j=loc1(2);
%Check number entered is valid and update entry
if isnan(new1) == 1
    warning('***** Please enter a number *****')
    else if new1 > 1
        warning('***** Correlations must be less than 1 *****')
    else if new1 < -1
        warning('***** Correlations must be larger than -1 *****')
    else if isempty(handles.selectedCells1) == 1
        warning('***** Please select a cell to update *****')          
    else if i == j
        warning('***** Diagonal entries must be 1 *****')
        else
        handles.MATRIX1(i,j)=new1;
        handles.MATRIX1(j,i)=new1;
        set(handles.correlation1,'data',handles.MATRIX1);
    end; 
    end;
    end;
    end;
end;
if handles.samematrix == 1;
    handles.MATRIX2 = handles.MATRIX1;
    set(handles.correlation2,'data',handles.MATRIX2);
end;
guidata(hObject,handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in correlation1.
function correlation1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to correlation1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
handles.selectedCells1 = eventdata.Indices;
guidata(hObject,handles);
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


function newvalue2_Callback(hObject, eventdata, handles)
% hObject    handle to newvalue1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newvalue1 as text
%        str2double(get(hObject,'String')) returns contents of newvalue1 as a double

% --- Executes during object creation, after setting all properties.
function newvalue2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newvalue1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatecorrelation1.
function updatecorrelation2_Callback(hObject, eventdata, handles)
% hObject    handle to updatecorrelation2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
new2 = get(handles.newvalue2,'String');
new2 =str2num(new2);
loc2=handles.selectedcell2;
i=loc2(1);
j=loc2(2);

%Check number entered is valid and update entry
if isnan(new2) == 1
    warning('***** Please enter a number *****')
    else if isempty(handles.selectedcell2) == 1
        warning('***** Please select a cell to update *****') 
    else if new2 >1
        warning('***** Correlations must be < 1 *****')
    else if new2 <-1
        warning('***** Correlations must be > -1 *****')
    else if i == j
        warning('***** Diagonal entries must be 1 *****')
        else
        handles.MATRIX2(i,j)=new2;
        handles.MATRIX2(j,i)=new2;
        set(handles.correlation2,'data',handles.MATRIX2);
    end; 
    end;
    end;
    end; 
end;
if handles.samematrix ==1;
  handles.MATRIX2 = handles.MATRIX1;
  warning('***** You have indicated the two correlation matrices are the SAME *****');
end;

guidata(hObject,handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in correlation2.
function correlation2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to correlation2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
handles.selectedcell2 = eventdata.Indices;
guidata(hObject,handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in samecorr.
function samecorr_Callback(hObject, eventdata, handles)
% hObject    handle to samecorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.samematrix = 1;
    handles.FULL2=handles.FULL1;
    set(handles.load2,'visible','off');
    set(handles.loadmsg2,'visible','on');
    set(handles.updatecorrelation2,'visible','off');
    set(handles.newvalue2,'visible','off');
    guidata(hObject,handles);
elseif handles.z==0
    handles.samematrix = 0;
    guidata(hObject,handles);
    set(handles.load2,'visible','on');
    set(handles.loadmsg2,'visible','off');
    set(handles.updatecorrelation2,'visible','on');
    set(handles.newvalue2,'visible','on');
    n=size(handles.FULL1);
    handles.FULL2=zeros(n(1),n(1));
    for i=1:n(1)
        handles.FULL2(i,i)=1;
    end;
    guidata(hObject,handles);
    else handles.samematrix = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of samecorr


% --- Executes on button press in load1.
function load1_Callback(hObject, eventdata, handles)
% hObject    handle to load1 (see GCBO)
% Load Correlation Matrix for Mixture 1
varargout=uiimport;
handles.meta = varargout.textdata;
set(handles.metabolites,'String',handles.meta);
handles.FULL1= varargout.data;
handles.loadon1 = 1;
set(handles.load1,'visible','off');
set(handles.loadmsg1,'visible','on');

if handles.samematrix ==1
    handles.FULL2=handles.FULL1;
    set(handles.load2,'visible','off');
    set(handles.loadmsg2,'visible','on');
else
handles.FULL2=zeros(size(handles.FULL1));
for i=1:size(handles.FULL1)
    handles.FULL2(i,i)=1;
end;       
end;
guidata(hObject,handles);



function loadmsg1_Callback(hObject, eventdata, handles)
% hObject    handle to loadmsg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loadmsg1 as text
%        str2double(get(hObject,'String')) returns contents of loadmsg1 as a double


% --- Executes during object creation, after setting all properties.
function loadmsg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadmsg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load2.
function load2_Callback(hObject, eventdata, handles)
% hObject    handle to load2 (see GCBO)
% Load Correlation Mixture 2
if strcmp(get(handles.loadmsg1,'visible'),'off') == 1
    warning('Please load Mixture 1 correlations first.')
else
check=1;
varargout=uiimport;
match =strcmp(varargout.textdata,handles.meta);
for i= 1:length(match)
  if match(i) == 0
    warning('Both correlation matrices must contain the same metabolites.')
    check=0;
    close(gcbf);
  end;
end;
if check ==1
handles.FULL2=varargout.data;
handles.loadon2=1;
set(handles.load2,'visible','off');
set(handles.loadmsg2,'visible','on');
guidata(hObject,handles);
end;
end;


function loadmsg2_Callback(hObject, eventdata, handles)
% hObject    handle to loadmsg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loadmsg2 as text
%        str2double(get(hObject,'String')) returns contents of loadmsg2 as a double


% --- Executes during object creation, after setting all properties.
function loadmsg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadmsg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cratio.
function cratio_Callback(hObject, eventdata, handles)
% hObject    handle to cratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.cratio = 1;
    guidata(hObject,handles);
    else
    handles.cratio = 0;
    guidata(hObject,handles);
end;
% Hint: get(hObject,'Value') returns toggle state of cratio
