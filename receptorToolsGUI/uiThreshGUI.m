function varargout = uiThreshGUI(varargin)
% UITHRESHGUI M-file for uiThreshGUI.fig
%      UITHRESHGUI, by itself, creates a new UITHRESHGUI or raises the existing
%      singleton*.
%
%      H = UITHRESHGUI returns the handle to a new UITHRESHGUI or the handle to
%      the existing singleton*.
%
%      UITHRESHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UITHRESHGUI.M with the given input arguments.
%
%      UITHRESHGUI('Property','Value',...) creates a new UITHRESHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uiThreshGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uiThreshGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uiThreshGUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uiThreshGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @uiThreshGUI_OutputFcn, ...
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


% --- Executes just before uiThreshGUI is made visible.
function uiThreshGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uiThreshGUI (see VARARGIN)

    handles.thresh = round(varargin{1});
    handles.img = varargin{2};
    handles.histIndex = varargin{3};
    thresh = handles.thresh;
    img = handles.img;
    bins = zeros(1,size(handles.histIndex,2));

    % Initialize Raw Image, Thresholded Image, Histogram, and Current Threshold
    set(handles.currentThreshEdit,'String',num2str(thresh));
    imshow(img>thresh,'Parent',handles.previewImageAxis);
    imshow(img,'Parent',handles.rawImageAxis);
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    bar(handles.previewHistAxis,handles.histIndex,bins)
    set(handles.previewHistAxis,'YLim',[0 max(bins(2:end))]);
    hold on
    ylim = get(handles.previewHistAxis,'YLim');
    line([thresh,thresh],[0,ylim(2)],'Parent',handles.previewHistAxis)
    hold off
    set(handles.previewHistAxis,'XLim',[0 max(handles.histIndex)])
    
% Choose default command line output for uiThreshGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uiThreshGUI wait for user response (see UIRESUME)
% uiwait(handles.uiThreshGUI);


% --- Outputs from this function are returned to the command line.
function varargout = uiThreshGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in acceptThreshButton.
function acceptThreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to acceptThreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global thresh
    global ackflag
    
    thresh = get(handles.currentThreshEdit,'String');
    thresh = round(str2double(thresh));
    ackflag = 1;
    close(handles.uiThreshGUI)


% --- Executes on button press in dwnThreshButton.
function dwnThreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to dwnThreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    thresh = get(handles.currentThreshEdit,'String');
    thresh = round(str2double(thresh))-1;
    set(handles.currentThreshEdit,'String',num2str(thresh));
    img = handles.img;
    bins = zeros(1,size(handles.histIndex,2));

    % Draw new Thresholded Image, Histogram, and Current Threshold
    set(handles.currentThreshEdit,'String',num2str(thresh));
    imshow(img>thresh,'Parent',handles.previewImageAxis);
    imshow(img,'Parent',handles.rawImageAxis);
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    bar(handles.previewHistAxis,handles.histIndex,bins)
    set(handles.previewHistAxis,'YLim',[0 max(bins(2:end))]);
    hold on
    ymax = get(handles.previewHistAxis,'YLim');
    line([thresh,thresh],[0,ymax(2)],'Parent',handles.previewHistAxis)
    hold off
    set(handles.previewHistAxis,'XLim',[0 max(handles.histIndex)])


% --- Executes on button press in upThreshButton.
function upThreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to upThreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    thresh = get(handles.currentThreshEdit,'String');
    thresh = round(str2double(thresh))+1;
    set(handles.currentThreshEdit,'String',num2str(thresh));
    img = handles.img;
    bins = zeros(1,size(handles.histIndex,2));

    % Initialize Raw Image, Thresholded Image, Histogram, and Current Threshold
    set(handles.currentThreshEdit,'String',num2str(thresh));
    imshow(img>thresh,'Parent',handles.previewImageAxis);
    imshow(img,'Parent',handles.rawImageAxis);
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    bar(handles.previewHistAxis,handles.histIndex,bins)
    set(handles.previewHistAxis,'YLim',[0 max(bins(2:end))]);
    hold on
    ymax = get(handles.previewHistAxis,'YLim');
    line([thresh,thresh],[0,ymax(2)],'Parent',handles.previewHistAxis)
    hold off
    set(handles.previewHistAxis,'XLim',[0 max(handles.histIndex)])

function currentThreshEdit_Callback(hObject, eventdata, handles)
% hObject    handle to currentThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    thresh = round(str2double(get(hObject,'String')));
    img = handles.img;
    bins = zeros(1,size(handles.histIndex,2));

    % Initialize Raw Image, Thresholded Image, Histogram, and Current Threshold
    set(handles.currentThreshEdit,'String',num2str(thresh));
    imshow(img>thresh,'Parent',handles.previewImageAxis);
    imshow(img,'Parent',handles.rawImageAxis);
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    bar(handles.previewHistAxis,handles.histIndex,bins)
    set(handles.previewHistAxis,'YLim',[0 max(bins(2:end))]);
    hold on
    ymax = get(handles.previewHistAxis,'YLim');
    line([thresh,thresh],[0,ymax(2)],'Parent',handles.previewHistAxis)
    hold off
    set(handles.previewHistAxis,'XLim',[0 max(handles.histIndex)])

% --- Executes during object creation, after setting all properties.
function currentThreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoThreshButton.
function autoThreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to autoThreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    thresh = handles.thresh;
    img = handles.img;
    bins = zeros(1,size(handles.histIndex,2));

    % Initialize Raw Image, Thresholded Image, Histogram, and Current Threshold
    set(handles.currentThreshEdit,'String',num2str(thresh));
    imshow(img>thresh,'Parent',handles.previewImageAxis);
    imshow(img,'Parent',handles.rawImageAxis);
    for i=1:size(img,1)
        for j=1:size(img,2)
            bins(img(i,j)+1) = bins(img(i,j)+1)+1;
        end
    end
    bar(handles.previewHistAxis,handles.histIndex,bins)
    hold on
    ymax = get(handles.previewHistAxis,'YLim');
    line([thresh,thresh],[0,ymax(2)],'Parent',handles.previewHistAxis)
    hold off
    set(handles.previewHistAxis,'XLim',[0 max(handles.histIndex)])


% --- Executes when user attempts to close uiThreshGUI.
function uiThreshGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to uiThreshGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);
