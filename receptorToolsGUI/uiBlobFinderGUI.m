function varargout = uiBlobFinderGUI(varargin)
% UIBLOBFINDERGUI M-file for uiBlobFinderGUI.fig
%      UIBLOBFINDERGUI, by itself, creates a new UIBLOBFINDERGUI or raises the existing
%      singleton*.
%
%      H = UIBLOBFINDERGUI returns the handle to a new UIBLOBFINDERGUI or the handle to
%      the existing singleton*.
%
%      UIBLOBFINDERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIBLOBFINDERGUI.M with the given input arguments.
%
%      UIBLOBFINDERGUI('Property','Value',...) creates a new UIBLOBFINDERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uiBlobFinderGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uiBlobFinderGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uiBlobFinderGUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uiBlobFinderGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @uiBlobFinderGUI_OutputFcn, ...
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


% --- Executes just before uiBlobFinderGUI is made visible.
function uiBlobFinderGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uiBlobFinderGUI (see VARARGIN)

% Choose default command line output for uiBlobFinderGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uiBlobFinderGUI wait for user response (see UIRESUME)
% uiwait(handles.uiBlobFinderGUI);


% --- Outputs from this function are returned to the command line.
function varargout = uiBlobFinderGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in XLSOutputCheck.
function XLSOutputCheck_Callback(hObject, eventdata, handles)
% hObject    handle to XLSOutputCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Setup default XLS file names
     if get(hObject, 'Value')
        filename = 'blobInfo.xls';
        filepath = [pwd '\'];
     else
        filename = 'XLS File Name';
        filepath = '';
     end

    set(handles.xlsFilename,'String',[filepath filename]);


% --- Executes on button press in getXLSFileButton.
function getXLSFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to getXLSFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Write to XLS
    [filename filepath] = uiputfile({'*.xls'},'C:\Work\blobInfo.xls');
    
    if isequal(filename,0)
        filename = 'blobInfo.xls';
        filepath = [pwd '\'];
    end
    if (~isempty(filename))
        set(handles.xlsFilename,'String',[filepath filename]);
    end
        
function xlsFilename_Callback(hObject, eventdata, handles)
% hObject    handle to xlsFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function xlsFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlsFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outWorkspaceCheck.
function outWorkspaceCheck_Callback(hObject, eventdata, handles)
% hObject    handle to outWorkspaceCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in runBlobFinder.
function runBlobFinder_Callback(hObject, eventdata, handles)
% hObject    handle to runBlobFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % Get raw image data from selected figure
    imgList = get(handles.openImageList,'String');
    listVal = get(handles.openImageList,'Value');
    imgName = imgList{listVal};
    
    if isequal(imgName,'No Images Open')
        errordlg('No Images Selected','BlobFinder Error');
        return
    end
    
    imgHandle = findobj('Name',imgName);
    img = get(imgHandle,'UserData');

    % Get values to pass to blobfinderGUI
    settings = str2double(get(handles.minBlobRadiusEdit,'String'));
    guiFlag = get(handles.threshGUIRadio,'Value');
    bitDepth = str2double(imgName(1:2));
    
    try
        [blob_info img_RGB img_sizeRestricted mask] = ...
        blobFinder(img,settings,guiFlag,bitDepth);
    catch
        return
    end

    % Display the selected Plots
    if ~get(handles.dispOriginalImageCheck,'Value')
        close(imgHandle)
    end
    if get(handles.dispSizeRestrictImageCheck,'Value')
        figure('Name',['BlobSize Restricted :' imgName],'NumberTitle','Off'); 
        imshow(img_sizeRestricted)
    end
    if get(handles.dispRGBOverlayImageCheck,'Value')
        figure('Name',['BlobFind Overlay :' imgName],'NumberTitle','Off'); 
        imshow(img_RGB)
    end      
    if get(handles.dispMaskCheck,'Value')
        figure('Name',['Blob Numbers:' imgName],'NumberTitle','Off'); 
        imshow(mask)
    end             
        
       
    % Write to XLS is desired
    if get(handles.XLSOutputCheck,'Value')
        xlsFileName = get(handles.xlsFilename,'String'); 
        try
            xlswrite(xlsFileName,{'Area','Total Intensity','Avg Intensity'},'Blob_Info','A1');
            xlswrite(xlsFileName,blob_info','Blob_Info','A2');
        catch exception
            errordlg(exception.message,'XLS Write Error');
        end
    end
    
    % Generate Plots if checked
    if get(handles.plotsCheck,'Value')
        
        % Screen info for organizing plot position
        screenSize = get(0,'ScreenSize');  
        margin = 80;
        default_wide = screenSize(3)/4;
        default_height = screenSize(4)/3;
        
        % Histograms
        figure('Position',[margin,margin+(screenSize(4)-2*margin)/2,...
            default_wide,default_height],...
            'Name',[imgName ': Blob Area Histogram'],'NumberTitle','Off');
        [n_area bins_area] = hist(blob_info(1,:),25);
        bar(bins_area,n_area)
        title([imgName ': Blob Area Histogram'],'Interpreter','none')
        xlabel('Area')
        ylabel('Number of Blobs')
        
        figure('Position',[margin,margin,default_wide,default_height]...
            ,'Name',[imgName ': Blob Avg Intensity Histogram'],...
            'NumberTitle','Off');
        [n_intensity bins_intensity] = hist(blob_info(3,:),25);
        bar(bins_intensity,n_intensity)
        title([imgName ':Blob Avg Intensity Histogram'],'Interpreter','none')
        xlabel('Average Intensity')
        ylabel('Number of Blobs')
        
        % Scatter
        figure('Position',[margin+(screenSize(3)-2*margin)/3,...
            margin+(screenSize(4)-2*margin)/3,default_wide,default_height]...
            ,'Name',[imgName ': Blob Scatter Plot'],'NumberTitle','Off');
        plot(blob_info(1,:),blob_info(3,:),'o')
        title([imgName ':Blob Scatter Plot'],'Interpreter','none')
        xlabel('Area')
        ylabel('Average Intensity')
        
        c_area = cumsum(n_area);
        c_intensity = cumsum(n_intensity);
        
        % Cumulative Histograms
        figure('Position',[margin+2*(screenSize(3)-2*margin)/3,margin+...
            (screenSize(4)-2*margin)/2,default_wide,default_height]...
            ,'Name',[imgName ': Blob Area Cumulative Histogram'],'NumberTitle','Off');
        bar(bins_area,c_area)
        title([imgName ':Blob Area Cumulative Histogram'],'Interpreter','none')
        xlabel('Area')
        ylabel('Cumulative Histogram')
        
        figure('Position',[margin+2*(screenSize(3)-2*margin)/3,margin...
            ,default_wide,default_height],'Name',...
            [imgName ': Blob Avg Intensity Cumulative Histogram'],'NumberTitle','Off');
        bar(bins_intensity,c_intensity)
        title([imgName ':Blob Avg Intensity Cumulative Histogram'],'Interpreter','none')
        xlabel('Intensity')
        ylabel('Cumulative Histogram')        
        
    end
        
    % Output to MATLAB workspace if checked
    if get(handles.outWorkspaceCheck,'Value')
        putvar(blob_info);
    end
    
    delete(handles.uiBlobFinderGUI)

% --- Executes on button press in dispOriginalImageCheck.
function dispOriginalImageCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dispOriginalImageCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in dispSizeRestrictImageCheck.
function dispSizeRestrictImageCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dispSizeRestrictImageCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in dispRGBOverlayImageCheck.
function dispRGBOverlayImageCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dispRGBOverlayImageCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in autoThreshRadio.
function autoThreshRadio_Callback(hObject, eventdata, handles)
% hObject    handle to autoThreshRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.threshGUIRadio,'Value',0);

% --- Executes on button press in threshGUIRadio.
function threshGUIRadio_Callback(hObject, eventdata, handles)
% hObject    handle to threshGUIRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.autoThreshRadio,'Value',0);

% --- Executes on selection change in openImageList.
function openImageList_Callback(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    

% --- Executes during object creation, after setting all properties.
function openImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to openImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Generate list of open images
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
    
function minBlobRadiusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minBlobRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Update user entered min radius value
    minRadius = str2double(get(hObject,'String'));
    if minRadius < 0
        minRadius = 0;
    end
    set(hObject,'String',num2str(minRadius));


% --- Executes during object creation, after setting all properties.
function minBlobRadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minBlobRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dispMaskCheck.
function dispMaskCheck_Callback(hObject, eventdata, handles)
% hObject    handle to dispMaskCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dispMaskCheck


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function uiBlobFinderGUI_WindowButtonDownFcn(hObject, eventdata, handles)


% --- Executes on button press in plotsCheck.
function plotsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to plotsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotsCheck
