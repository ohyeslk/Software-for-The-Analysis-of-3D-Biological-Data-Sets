function varargout = sphereFinderGUI(varargin)
%SPHEREFINDERGUI M-file for sphereFinderGUI.fig
%      SPHEREFINDERGUI, by itself, creates a new SPHEREFINDERGUI or raises the existing
%      singleton*.
%
%      H = SPHEREFINDERGUI returns the handle to a new SPHEREFINDERGUI or the handle to
%      the existing singleton*.
%
%      SPHEREFINDERGUI('Property','Value',...) creates a new SPHEREFINDERGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to sphereFinderGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SPHEREFINDERGUI('CALLBACK') and SPHEREFINDERGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SPHEREFINDERGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sphereFinderGUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sphereFinderGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @sphereFinderGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before sphereFinderGUI is made visible.
function sphereFinderGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for sphereFinderGUI
handles.output = hObject;
handles.files = varargin{1};
handles.imgMatrix = varargin{2};
handles.bitDepth = varargin{3};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sphereFinderGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sphereFinderGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function sphereFinderGUI_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sphereFinderGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in imgList.
function imgList_Callback(hObject, eventdata, handles)
% hObject    handle to imgList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgList

    % Display list of images to be operated on if clicked.
    
    ilist = handles.files;
    for i=1:length(ilist)
        ilist{i} = ilist{i}(1:length(ilist{i})-4);
    end
    
    set(hObject,'String',ilist)

% --- Executes during object creation, after setting all properties.
function imgList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function minBlobRadiusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minBlobRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Update user specified min radius
    minRadius = round(str2double(get(hObject,'String')));
    if minRadius < 0
        minRadius = 0;
    end
    set(hObject,'String',num2str(minRadius));

% --- Executes during object creation, after setting all properties.
function minBlobRadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minBlobRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in XLSOutputCheck.
function XLSOutputCheck_Callback(hObject, eventdata, handles)
% hObject    handle to XLSOutputCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Set default values for xcel file
     if get(hObject, 'Value')
        filename = 'sphereInfo.xls';
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

    % Open user file select dialog
    [filename filepath] = uiputfile({'*.xls'},'C:\Work\sphereInfo.xls');
    
    if isequal(filename,0)
        filename = 'sphereInfo.xls';
        filepath = [pwd '\'];
    end
    if (~isempty(filename))
        set(handles.xlsFilename,'String',[filepath filename]);
    end

function xlsFilename_Callback(hObject, eventdata, handles)
% hObject    handle to xlsFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlsFilename as text
%        str2double(get(hObject,'String')) returns contents of xlsFilename as a double


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

% Hint: get(hObject,'Value') returns toggle state of outWorkspaceCheck


% --- Executes on button press in plotsCheck.
function plotsCheck_Callback(hObject, eventdata, handles)
% hObject    handle to plotsCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotsCheck


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over runSphereFinder.
function runSphereFinder_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to runSphereFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in runSphereFinder.
function runSphereFinder_Callback(hObject, eventdata, handles)
% hObject    handle to runSphereFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get image matrix from selected images that were input argument
    img_matrix = handles.imgMatrix;
    bitDepth = handles.bitDepth;
    imgName = cell2mat(handles.files(1));
    imgName = ['3DSet: ' imgName(1:end-4)];
    
    settings = str2double(get(handles.minBlobRadiusEdit,'String'));
    guiFlag = get(handles.threshGUIRadio,'Value');
    
    [sphere_info mask img_8_z] = sphereFinder(img_matrix,settings,guiFlag,bitDepth);        
       
    % Write to XLS if desired
    if get(handles.XLSOutputCheck,'Value')
        xlsFileName = get(handles.xlsFilename,'String'); 
        try
            xlswrite(xlsFileName,{'Volume','Total Intensity','Avg Intensity'},'Sphere_Info','A1');
            xlswrite(xlsFileName,sphere_info','Sphere_Info','A2');
        catch exception
            errordlg(exception.message,'XLS Write Error');
        end
    end
    
    % Create plots if desired
    if get(handles.plotsCheck,'Value')
        % Generate screen size values for spreading figures out
        screenSize = get(0,'ScreenSize');  
        margin = 80;
        default_wide = screenSize(3)/4;
        default_height = screenSize(4)/3;
        
        % Histograms
        figure('Position',[margin,margin+(screenSize(4)-2*margin)/2,...
            default_wide,default_height],...
            'Name',[imgName ': 3D Blob Vol Histogram'],'NumberTitle','Off');
        [n_vol bins_vol] = hist(sphere_info(1,:),25);
        bar(bins_vol,n_vol)
        title([imgName ': 3D Blob Vol Histogram'],'Interpreter','none')
        xlabel('Volume')
        ylabel('Number of 3D Blobs')
        
        figure('Position',[margin,margin,default_wide,default_height]...
            ,'Name',[imgName ': 3D Blob Avg Intensity Histogram'],...
            'NumberTitle','Off');
        [n_intensity bins_intensity] = hist(sphere_info(3,:),25);
        bar(bins_intensity,n_intensity)
        title([imgName ':3D Blob Avg Intensity Histogram'],'Interpreter','none')
        xlabel('Average Intensity')
        ylabel('Number of 3D Blobs')
        
        % Scatter
        figure('Position',[margin+(screenSize(3)-2*margin)/3,...
            margin+(screenSize(4)-2*margin)/3,default_wide,default_height]...
            ,'Name',[imgName ': 3D Blob Scatter Plot'],'NumberTitle','Off');
        plot(sphere_info(1,:),sphere_info(3,:),'o')
        title([imgName ':3D Blob Scatter Plot'],'Interpreter','none')
        xlabel('Volume')
        ylabel('Average Intensity')
        
        c_vol = cumsum(n_vol);
        c_intensity = cumsum(n_intensity);
        
        % Cumulative Histograms
        figure('Position',[margin+2*(screenSize(3)-2*margin)/3,margin+...
            (screenSize(4)-2*margin)/2,default_wide,default_height]...
            ,'Name',[imgName ': 3D Blob Vol Cumulative Histogram'],'NumberTitle','Off');
        bar(bins_vol,c_vol)
        title([imgName ':3D Blob Vol Cumulative Histogram'],'Interpreter','none')
        xlabel('Volume')
        ylabel('Cumulative Histogram')
        
        figure('Position',[margin+2*(screenSize(3)-2*margin)/3,margin...
            ,default_wide,default_height],'Name',...
            [imgName ': Blob Avg Intensity Cumulative Histogram'],'NumberTitle','Off');
        bar(bins_intensity,c_intensity)
        title([imgName ':Blob Avg Intensity Cumulative Histogram'],'Interpreter','none')
        xlabel('Intensity')
        ylabel('Cumulative Histogram')      
    end
        
    % Output to MATLAB workspace if needed
    if get(handles.outWorkspaceCheck,'Value')
        putvar(sphere_info);
    end    
    
    % Render 3D if desired
    if get(handles.threeViewCheck,'Value')
      
        % Use screensize to set size of display window
        screenSize = get(0,'ScreenSize');  
        margin = 80;
        default_wide = round(screenSize(3)*.75);
        default_height = round(screenSize(4).*.75);

        % Calculate Dimensional Aspect Ratio
        pixSize_xy = 91.55e-9;
        pixSize_z = 1.18e-6;
        zFactor = pixSize_z/(pixSize_xy*2);

        % Create Size limits for small/medium/large [smallLimit medLimit]
        sizeBin = [800 3000];

        temp_mask = zeros(size(mask,1)/2,size(mask,2)/2,size(mask,3));

        for i = 1:size(mask,3)
            temp_mask(:,:,i) = imresize(mask(:,:,i),.5,'nearest');
        end
        mask = temp_mask;

        % Setup 3D figure properties
        figure('Position',[margin,...
            margin,default_wide,default_height]...
            ,'Name',[imgName ': 3D Blob Viewer'],'NumberTitle','Off');
        a = axes;
        axis([1 size(mask,1) 1 size(mask,2) 1 size(mask,3)]);
        daspect([zFactor,zFactor,1]); view(3); hold on;
        axis tight; box on;
        [x,y,z] = meshgrid(1:size(mask,1),1:size(mask,2),1:size(mask,3));

        % Label the small/medium/large blobs
        for n = 1:3
            temp_mask = 0.*mask;
            for k = 1:size(mask,3)
                for j = 1:size(mask,2)
                    for i = 1:size(mask,1)
                        if mask(i,j,k) ~=0
                            if n== 1
                                if sphere_info(1,mask(i,j,k)) < sizeBin(n)
                                    temp_mask(i,j,k) = 2;
                                end
                            elseif n == 2
                                 if sphere_info(1,mask(i,j,k)) < sizeBin(n) &&...
                                     sphere_info(1,mask(i,j,k)) > sizeBin(1)
                                    temp_mask(i,j,k) = 2;
                                end
                            elseif n == 3
                                if sphere_info(1,mask(i,j,k)) > sizeBin(2)
                                    temp_mask(i,j,k) = 2;
                                end
                            end
                        end
                    end
                end
            end   

            % Create surface for each blob size... green == small, yellow
            % == medium, red == large
            fv = isosurface(x,y,z,temp_mask,1.95);
            if n == 1
                hIsoSurf = patch(fv,'CdataMapping','direct','FaceColor','green','EdgeColor','none');
            elseif n == 2
                hIsoSurf = patch(fv,'CdataMapping','direct','FaceColor','yellow','EdgeColor','none');
            elseif n == 3
                hIsoSurf = patch(fv,'CdataMapping','direct','FaceColor','red','EdgeColor','none');
            end
        end

        % Put z-project image on the floor of the plot
        surface('XData',[0 512; 0 512],'YData',[0 0; 512 512],...
            'ZData',[1 1; 1 1],'CData',img_8_z,...
            'FaceColor','texturemap','EdgeColor','none');

        view(3); colormap('gray');
        camlight; lighting gouraud;

        background = [211 211 211]./255;
        gridcolor = [186 85 211]./255;
        % graph annotation
        set(gca,'YGrid','on','XGrid','on','ZGrid','on','Color',background)
        set(gca,'YColor',gridcolor,'XColor',gridcolor,'ZColor',gridcolor)
        xlabel('x (pixels)','FontSize',16);
        ylabel('y (pixels)','FontSize',16);
        zlabel('z (pixels)','FontSize',16);
        title([imgName ': 3D Blob Viewer'],'Interpreter','none','FontSize',16);
        
    end
    
    delete(handles.sphereFinderGUI)

% --- Executes on button press in threeViewCheck.
function threeViewCheck_Callback(hObject, eventdata, handles)
% hObject    handle to threeViewCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
