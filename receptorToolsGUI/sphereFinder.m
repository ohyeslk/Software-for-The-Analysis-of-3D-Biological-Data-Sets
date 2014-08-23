function [sphere_info mask img_8_z] = sphereFinder(img_matrix,settings,guiFlag,bitDepth)

size_floor = settings;

%% Convert to 8-bit
imgHi = 2^bitDepth-1;
imgLo = 0;

img_8_matrix = uint8(255.*double((img_matrix-imgLo))./double((imgHi-imgLo)));
 
%% Use Z-Project Image for set representation in 2D
img_8_z = img_8_matrix(:,:,1);
for k = 1:size(img_8_matrix,3)
    img = img_8_matrix(:,:,k);
    img_8_z = max(img_8_z,img);
end
        
%% Threshold

    global thresh
    global ackflag

    thresh = mean(img_8_z(:));
    std = sqrt(var(double(img_8_z(:))));
    
    if guiFlag
        histIndex = 0:(2^8-1);
        h = uiThreshGUI(thresh+std,img_8_z,histIndex);
        waitfor(h)
    else
        thresh = thresh+std;
    end
    
    if ~ackflag
        return
    end
    
    img_8_matrix_thresh = img_8_matrix;
    
    for i = 1:size(img_8_matrix,1)
        for j = 1:size(img_8_matrix,2)
            for k = 1:size(img_8_matrix,3)
                if img_8_matrix(i,j,k) >= thresh
                    img_8_matrix_thresh(i,j,k) = 1;
                else 
                    img_8_matrix_thresh(i,j,k) = 0;
                end
            end
        end
    end
    
%% Morphological Size Filtering
   
    ball1 = strel('ball',size_floor,size_floor,4);
    img_matrix_sizeRestricted = imerode(img_8_matrix_thresh,ball1);
    img_matrix_sizeRestricted = imdilate(img_matrix_sizeRestricted,ball1);
    
%% Create Label Mask Using Region Growing
    img_regions = uint8(img_matrix_sizeRestricted);
    mask = bwlabeln(img_regions);

%% Generate statistics for each region
    
    num_spheres = max(mask(:));
    sphere_info = zeros(3,num_spheres);  % [volumes ; total intensity ; avg intensity]

    for i=1:size(img_regions,1)
        for j=1:size(img_regions,2)
            for k=1:size(img_regions,3)
                if(mask(i,j,k) ~= 0)
                    sphere_info(1,mask(i,j,k)) = sphere_info(1,mask(i,j,k))+1;
                    sphere_info(2,mask(i,j,k)) = sphere_info(2,mask(i,j,k)) + double(img_8_matrix(i,j,k));
                end
            end
        end
    end
   
    for i=1:num_spheres
        sphere_info(3,i)  = sphere_info(2,i)./sphere_info(1,i);
    end
    