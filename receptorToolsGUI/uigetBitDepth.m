function varargout = uigetBitDepth(varargin)
% UIGETBITDEPTH M-file for uigetBitDepth.fig
%      UIGETBITDEPTH, by itself, creates a new UIGETBITDEPTH or raises the existing
%      singleton*.
%
%      H = UIGETBITDEPTH returns the handle to a new UIGETBITDEPTH or the handle to
%      the existing singleton*.
%
%      UIGETBITDEPTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIGETBITDEPTH.M with the given input arguments.
%
%      UIGETBITDEPTH('Property','Value',...) creates a new UIGETBITDEPTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uigetBitDepth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uigetBitDepth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uigetBitDepth


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uigetBitDepth_OpeningFcn, ...
                   'gui_OutputFcn',  @uigetBitDepth_OutputFcn, ...
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


% --- Executes just before uigetBitDepth is made visible.
function uigetBitDepth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uigetBitDepth (see VARARGIN)

% Choose default command line output for uigetBitDepth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uigetBitDepth wait for user response (see UIRESUME)
% uiwait(handles.uigetBitDepth);


% --- Outputs from this function are returned to the command line.
function varargout = uigetBitDepth_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in bDepthList.
function bDepthList_Callback(hObject, eventdata, handles)
% hObject    handle to bDepthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bitDepth

    listStr = get(hObject,'String');
    listVal = get(hObject,'Value');
    bitDepthStr = listStr{listVal};
    
    if isequal(bitDepthStr,'8 Bit')
        bitDepth = 8;
    elseif isequal(bitDepthStr,'12 Bit')
        bitDepth = 12;
    elseif isequal(bitDepthStr,'16 Bit')
        bitDepth = 16;
    end
    
    close(handles.uigetBitDepth)

% Hints: contents = cellstr(get(hObject,'String')) returns bDepthList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bDepthList


% --- Executes during object creation, after setting all properties.
function bDepthList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bDepthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on uigetBitDepth or any of its controls.
function uigetBitDepth_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uigetBitDepth (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    global bitDepth

    listStr = get(handles.bDepthList,'String');
    listVal = get(handles.bDepthList,'Value');
    bitDepthStr = listStr{listVal};
    
    if isequal(bitDepthStr,'8 Bit')
        bitDepth = 8;
    elseif isequal(bitDepthStr,'12 Bit')
        bitDepth = 12;
    elseif isequal(bitDepthStr,'16 Bit')
        bitDepth = 16;
    end
    
    close(hObject)

% --- Executes when user attempts to close uigetBitDepth.
function uigetBitDepth_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to uigetBitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
