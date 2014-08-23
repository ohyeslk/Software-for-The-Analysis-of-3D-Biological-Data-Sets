function varargout = saveImageGUI(varargin)
% SAVEIMAGEGUI MATLAB code for saveImageGUI.fig
%      SAVEIMAGEGUI, by itself, creates a new SAVEIMAGEGUI or raises the existing
%      singleton*.
%
%      H = SAVEIMAGEGUI returns the handle to a new SAVEIMAGEGUI or the handle to
%      the existing singleton*.
%
%      SAVEIMAGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVEIMAGEGUI.M with the given input arguments.
%
%      SAVEIMAGEGUI('Property','Value',...) creates a new SAVEIMAGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saveImageGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saveImageGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saveImageGUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saveImageGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @saveImageGUI_OutputFcn, ...
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


% --- Executes just before saveImageGUI is made visible.
function saveImageGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saveImageGUI (see VARARGIN)

% Choose default command line output for saveImageGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes saveImageGUI wait for user response (see UIRESUME)
% uiwait(handles.saveImageGUI);


% --- Outputs from this function are returned to the command line.
function varargout = saveImageGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    % Get Image to Save
        imgList = get(handles.openImageList,'String');
        listVal = get(handles.openImageList,'Value');
        imgName = imgList{listVal};

        if isequal(imgName,'No Images Open')
            errordlg('No Images Selected','make Hist Error');
            return
        end

        imgHandle = findobj('Name',imgName);
        img = get(imgHandle,'UserData');
        bitDepth = str2double(imgName(1:2));
    
        targetBitDepth = get(handles.bitDepthList,'Value');
        if targetBitDepth ==1
            targetBitDepth = 8;
            % Convert to 8 bit
            imgHi = 2^bitDepth-1;
            imgLo = 0;
            img_target = uint8((2^targetBitDepth-1).*double((img-imgLo))./double((imgHi-imgLo)));
        elseif targetBitDepth ==2
            targetBitDepth = 12;
            % Convert to 12 bit... sort of it's 16, but only using 12
            imgHi = 2^bitDepth-1;
            imgLo = 0;
            img_target = uint16((2^targetBitDepth-1).*double((img-imgLo))./double((imgHi-imgLo)));
        elseif targetBitDepth ==3
            targetBitDepth = 16;
            % Convert to 16 bit
            imgHi = 2^bitDepth-1;
            imgLo = 0;
            img_target = uint16((2^targetBitDepth-1).*double((img-imgLo))./double((imgHi-imgLo)));
        end    
    
        fileName = get(handles.fileNameEdit,'String');
        imwrite(img_target,fileName,'TIF');
        close(saveImageGUI)


% --- Executes on selection change in openImageList.
function openImageList_Callback(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
       
    % Update img and bitdepth on selection
        imgList = get(handles.openImageList,'String');
        listVal = get(handles.openImageList,'Value');
        imgName = imgList{listVal};

        if isequal(imgName,'No Images Open')
            errordlg('No Images Selected','Save Image Error');
            return
        end
        
        set(handles.fileNameEdit,'String',[pwd '\' imgName]);        

        bitDepth = str2double(imgName(1:2));
        
        if bitDepth == 8
            set(handles.bitDepthList,'Value',1)
        elseif bitDepth == 12
            set(handles.bitDepthList,'Value',2)
        elseif bitDepth == 16
            set(handles.bitDepthList,'Value',3)
        end


% --- Executes during object creation, after setting all properties.
function openImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Get list of open images that can be saved
    ihandles = findobj('-regexp','Tag','^image');
    ilist = cell(0);
    
    for i=1:size(ihandles,1)
        ilist = [ilist;cellstr(get(ihandles(i),'Name'))];
    end
    
    if isempty(ilist)
        ilist = cellstr('No Images Open');
    else
        imgName = ilist{1};
        bitDepth = str2double(imgName(1:2));
    end
    set(hObject,'String',ilist)   

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bitDepthList.
function bitDepthList_Callback(hObject, eventdata, handles)
% hObject    handle to bitDepthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function bitDepthList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bitDepthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseButton.
function browseButton_Callback(hObject, eventdata, handles)
% hObject    handle to browseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Open user file select dialog
    [filename filepath] = uiputfile({'*.tif'},pwd);
    
    if isequal(filename,0)
        filename = 'IMAGE_NAME';
        filepath = [pwd '\'];
    end
    if (~isempty(filename))
        set(handles.xlsFilename,'String',[filepath filename]);
    end


function fileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of fileNameEdit as a double


% --- Executes during object creation, after setting all properties.
function fileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
