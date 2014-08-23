function varargout = makeHistGUI(varargin)
% MAKEHISTGUI M-file for makeHistGUI.fig
%      MAKEHISTGUI, by itself, creates a new MAKEHISTGUI or raises the existing
%      singleton*.
%
%      H = MAKEHISTGUI returns the handle to a new MAKEHISTGUI or the handle to
%      the existing singleton*.
%
%      MAKEHISTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAKEHISTGUI.M with the given input arguments.
%
%      MAKEHISTGUI('Property','Value',...) creates a new MAKEHISTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before makeHistGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to makeHistGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help makeHistGUI

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @makeHistGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @makeHistGUI_OutputFcn, ...
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


% --- Executes just before makeHistGUI is made visible.
function makeHistGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to makeHistGUI (see VARARGIN)

% Choose default command line output for makeHistGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes makeHistGUI wait for user response (see UIRESUME)
% uiwait(handles.makeHistGUI);


% --- Outputs from this function are returned to the command line.
function varargout = makeHistGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in makeHistButton.
function makeHistButton_Callback(hObject, eventdata, handles)
% hObject    handle to makeHistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get Raw Image Data from selected figure
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
    
% Generate Histogram Data
    histIndex = 0:2^bitDepth-1;
    bins = zeros(1,size(histIndex,2));
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    
    delete(makeHistGUI)
    
    figure('Name',[imgName ': Histogram'],...
            'NumberTitle','Off');
    bar(histIndex,bins)
    title([imgName ': Histogram'],'Interpreter','none');
    set(gca,'YLim',[0 max(bins(2:end))+100]);
    set(gca,'XLim',[0 2^bitDepth-1]);
    
    if bins(1) > max(bins(2:end)+100)
        warningmsg = ['Caution: the y-limit of this histogram is overflown by'...
            ' the zeroth bin. Adjust the limits if that bin is important'];
        errordlg(warningmsg,'Histogram Caution');
    end
    


% --- Executes on selection change in openImageList.
function openImageList_Callback(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns openImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from openImageList


% --- Executes during object creation, after setting all properties.
function openImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Search for 'image' type figures using tags
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
