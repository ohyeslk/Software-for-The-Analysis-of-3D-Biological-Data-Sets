function varargout = removeRefMeanGUI(varargin)
% REMOVEREFMEANGUI MATLAB code for removeRefMeanGUI.fig
%      REMOVEREFMEANGUI, by itself, creates a new REMOVEREFMEANGUI or raises the existing
%      singleton*.
%
%      H = REMOVEREFMEANGUI returns the handle to a new REMOVEREFMEANGUI or the handle to
%      the existing singleton*.
%
%      REMOVEREFMEANGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REMOVEREFMEANGUI.M with the given input arguments.
%
%      REMOVEREFMEANGUI('Property','Value',...) creates a new REMOVEREFMEANGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before removeRefMeanGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to removeRefMeanGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help removeRefMeanGUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @removeRefMeanGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @removeRefMeanGUI_OutputFcn, ...
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


% --- Executes just before removeRefMeanGUI is made visible.
function removeRefMeanGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to removeRefMeanGUI (see VARARGIN)

% Choose default command line output for removeRefMeanGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes removeRefMeanGUI wait for user response (see UIRESUME)
% uiwait(handles.removeRefMeanGUI);


% --- Outputs from this function are returned to the command line.
function varargout = removeRefMeanGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get Reference Image
        imgList = get(handles.refImageList,'String');
        listVal = get(handles.refImageList,'Value');
        imgName = imgList{listVal};

        if isequal(imgName,'No Images Open')
            errordlg('No Images Selected','make Hist Error');
            return
        end

        imgHandle = findobj('Name',imgName);
        ref_img = get(imgHandle,'UserData');
        bitDepth = str2double(imgName(1:2));
    
        % Convert to 8 bit
        imgHi = 2^bitDepth-1;
        imgLo = 0;
        ref_img_8 = uint8(255.*double((ref_img-imgLo))./double((imgHi-imgLo)));
        m = mean(ref_img(:));
        m_8 = mean(ref_img_8(:));     
    
   % Get Subtractor Image
        imgList = get(handles.subImageList,'String');
        listVal = get(handles.subImageList,'Value');
        imgName = imgList{listVal};

        if isequal(imgName,'No Images Open')
            errordlg('No Images Selected','make Hist Error');
            return
        end

        imgHandle = findobj('Name',imgName);
        sub_img = get(imgHandle,'UserData');
        bitDepth = str2double(imgName(1:2));
        
        % Convert to 8 bit
        imgHi = 2^bitDepth-1;
        imgLo = 0;
        sub_img_8 = uint8(255.*double((sub_img-imgLo))./double((imgHi-imgLo)));
        sub_img_8 = sub_img_8 - m_8;
        sub_img = sub_img-m;
        
        figure('Name',[num2str(bitDepth) ' Bit_Ref Remove_' imgName],'NumberTitle','Off',...
                'Tag','imageRefRemove');
        set(gcf,'UserData',sub_img);
        imshow(sub_img_8)
        delete(handles.removeRefMeanGUI)
    

% --- Executes on selection change in subImageList.
function subImageList_Callback(hObject, eventdata, handles)
% hObject    handle to subImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subImageList


% --- Executes during object creation, after setting all properties.
function subImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    ihandles = findobj('-regexp','Tag','^image');
    ilist = cell(0);
    
    for i=1:size(ihandles,1)
        ilist = [ilist;cellstr(get(ihandles(i),'Name'))];
    end
    
    if isempty(ilist)
        ilist = cellstr('No Images Open');
    end
    set(hObject,'String',ilist)


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in refImageList.
function refImageList_Callback(hObject, eventdata, handles)
% hObject    handle to refImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns refImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refImageList


% --- Executes during object creation, after setting all properties.
function refImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    ihandles = findobj('-regexp','Tag','^image');
    ilist = cell(0);
    
    for i=1:size(ihandles,1)
        ilist = [ilist;cellstr(get(ihandles(i),'Name'))];
    end
    
    if isempty(ilist)
        ilist = cellstr('No Images Open');
    end
    set(hObject,'String',ilist)


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
