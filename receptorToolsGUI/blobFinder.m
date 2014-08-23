function [blob_info img_RGB img_sizeRestricted mask] = ...
    blobFinder(img,settings,guiFlag,bitDepth)

size_floor = settings;

%% Convert to 8-bit
imgHi = 2^bitDepth-1;
imgLo = 0;

img_8 = uint8(255.*double((img-imgLo))./double((imgHi-imgLo)));
    
%% Threshold

    global thresh
    global ackflag

    ackflag = 0;
    thresh = mean(img_8(:));
    std = sqrt(var(double(img_8(:))));
    
    if guiFlag
        histIndex = 0:(2^8-1);
        h = uiThreshGUI(thresh+std,img_8,histIndex);
        waitfor(h)
    else
        thresh = thresh+std;
    end
    
    if ~ackflag
        return
    end
    
    img_8_thresh = img_8>(thresh);

%% Morphological Size Filtering
   
    circ1 = strel('disk',size_floor,4);
    img_sizeRestricted = imerode(img_8_thresh,circ1);
    img_sizeRestricted = imdilate(img_sizeRestricted,circ1);
    img_RGB = cat(3,img_8.*255.*uint8(img_sizeRestricted)...
        ,img_8-img_8.*255.*uint8(img_sizeRestricted)...
        ,img_8-img_8.*255.*uint8(img_sizeRestricted));
    
%% Create Label Mask Using Region Growing
    img_regions = uint8(img_sizeRestricted);
    mask = bwlabel(img_regions);

%% Generate statistics for each region
    
    num_blobs = max(mask(:));
    blob_info = zeros(3,num_blobs);  % [volumes ; total intensity ; avg intensity]

    for i=1:size(img_regions,1)
        for j=1:size(img_regions,2)
            if(mask(i,j) ~= 0)
                blob_info(1,mask(i,j)) = blob_info(1,mask(i,j))+1;
                blob_info(2,mask(i,j)) = blob_info(2,mask(i,j)) + double(img_8(i,j));
            end
        end
    end
   
    for i=1:num_blobs
        blob_info(3,i)  = blob_info(2,i)./blob_info(1,i);
    end
    