function varargout = receptorToolsGUI(varargin)
% RECEPTORTOOLSGUI M-file for receptorToolsGUI.fig
%      RECEPTORTOOLSGUI, by itself, creates a new RECEPTORTOOLSGUI or raises the existing
%      singleton*.
%
%      H = RECEPTORTOOLSGUI returns the handle to a new RECEPTORTOOLSGUI or the handle to
%      the existing singleton*.
%
%      RECEPTORTOOLSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECEPTORTOOLSGUI.M with the given input arguments.
%
%      RECEPTORTOOLSGUI('Property','Value',...) creates a new RECEPTORTOOLSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before receptorToolsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to receptorToolsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help receptorToolsGUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @receptorToolsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @receptorToolsGUI_OutputFcn, ...
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


% --- Executes just before receptorToolsGUI is made visible.
function receptorToolsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to receptorToolsGUI (see VARARGIN)

iptsetpref('ImshowBorder','tight')
handles.imageIndex = 1;     % For tracking figure tags.

% Choose default command line output for receptorToolsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes receptorToolsGUI wait for user response (see UIRESUME)
% uiwait(handles.receptorToolsGUI);


% --- Outputs from this function are returned to the command line.
function varargout = receptorToolsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_tools_mathOps_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_mathOps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_tools_filters_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_openImage_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_openImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
        global bitDepth     % for passing bitDepth to functions
        
        % Open user file select interface
        [filename pathname] = uigetfile({'*.tif'},'Open Image','C:\Work\myfile.tif');
        if ~isequal(filename,0)
            h = uigetBitDepth();    % Open bit depth select interface
            waitfor(h)
            [img map] = imread([pathname filename]);
            figure('Name',[num2str(bitDepth) ' Bit_' filename],'NumberTitle','Off',...
                'Tag',['image' num2str(handles.imageIndex)]);
            set(gcf,'UserData',img);

            %% Convert to 8-bit for display
            imgHi = 2^bitDepth-1;
            imgLo = 0;
            img_8 = uint8(255.*double((img-imgLo))./double((imgHi-imgLo)));

            imshow(imresize(img_8,.5));
            handles.imageIndex = handles.imageIndex+1;
        end
    catch exception
        if isequal(filename,0)  % User pushed Cancel
        else  
        errordlg(exception.message,'File Retrieve Error');
        end
    end
    
    guidata(hObject,handles)

% --------------------------------------------------------------------
function menu_file_closeAll_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_closeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close(findobj('-regexp','Tag','^image')); % Close all image figures


% --------------------------------------------------------------------
function menu_tools_filters_blobFinder_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_filters_blobFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiBlobFinderGUI()


% --------------------------------------------------------------------
function menu_tools_filters_3DblobFinder_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_filters_3DblobFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global bitDepth

    % Get file list and bit depth
        [filelist pathname] = uigetfile({'*.tif'},...
        'Open Image Sequence','C:\Work\myfile.tif','Multiselect','on');
        h = uigetBitDepth();
        waitfor(h)
        
    % Preview Images in Movie
        htemp = figure;
        imgHi = 2^bitDepth-1;
        imgLo = 0;
        for i=1:length(filelist)
            img = imread([pathname filelist{i}]);
            img_8 = uint8(255.*double((img-imgLo))./double((imgHi-imgLo)));            
            imshow(imresize(img_8,.5));
            text(10,10,filelist{i},'color','white','interpreter','none');
            pause(.4);
        end
        close(htemp)        
        
    % Create 3D structure
        [img map] = imread([pathname filelist{1}]);
        slice_size = size(img);
        img_matrix = img;
        for i=2:length(filelist)
            [img map] = imread([pathname filelist{i}]);
            if(isequal(size(img),slice_size))
                img_matrix = cat(3,img_matrix,img);
            else
                error('Images are not equal size')
            end
        end
        
    % Run 3D Blob Finder
        
        sphereFinderGUI(filelist,img_matrix,bitDepth);
        
% --- Executes when user attempts to close receptorToolsGUI.
function receptorToolsGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to receptorToolsGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
close all


% --------------------------------------------------------------------
function menu_tools_maths_removeRefMean_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_maths_removeRefMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    removeRefMeanGUI()


% --------------------------------------------------------------------
function menu_tools_histogram_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    makeHistGUI()    


% --------------------------------------------------------------------
function menu_tools_zproject_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools_zproject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global bitDepth

    % Get file list and bit depth
        [filelist pathname] = uigetfile({'*.tif'},...
        'Open Image Sequence','C:\Work\myfile.tif','Multiselect','on');
        h = uigetBitDepth();
        waitfor(h)
   % Perform Max Projection in Z
        [img map] = imread([pathname filelist{1}]);
        slice_size = size(img);
        zproject = img;
        for i=2:length(filelist)
            [img map] = imread([pathname filelist{i}]);
            if(isequal(size(img),slice_size))
                zproject = max(zproject,img);
            else
                error('Images are not equal size')
            end
        end
        
    % Store Zproject in raw form and show in 8 bit
    figure('Name',[num2str(bitDepth) '_Bit Z PROJECT_' filelist{1}],'NumberTitle','Off',...
        'Tag',['image' num2str(handles.imageIndex)]);
    set(gcf,'UserData',zproject);

    %% Convert to 8-bit for display
    imgHi = 2^bitDepth-1;
    imgLo = 0;
    zproject_8 = uint8(255.*double((zproject-imgLo))./double((imgHi-imgLo)));

    imshow(imresize(zproject_8,.5));
    handles.imageIndex = handles.imageIndex+1;
        


% --------------------------------------------------------------------
function menu_file_saveImage_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_saveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    saveImageGUI()
