function [Number,L1]=Segmentation(licenseBox,handles)
%----------------image binarization---------------

% % r=30;        % Radius
% % C=10;        % Constant(+threshold)
% % lenV=length(licenseBox(:,1));  % The vertical length of the image
% % lenG=length(licenseBox(1,:));  % The horizontal length of the image
% % figure(2),imshow(licenseBox),title('Binary License Plate'),pause % Binary image of license plate
% % for smV=1:lenV/r          % Vertical Offset
% %     for smG=1:lenG/r      % Horizontal offset
% %         % Convert region of radius r in a row
% %         smG
% %         for i=1:r
% %             for j=1:r
% %                 Obl((i-1)*r+j)=licenseBox(j+(smV*r-r),i+(smG*r-r));
% %             end
% %         end
% %         Obl;
% %         p=mean(Obl)+C;        % Threshold
% %         for i=1:r
% %             for j=1:r
% %                 if licenseBox(j+(smV*r-r),i+(smG*r-r)) > p
% %                     bw(j+(smV*r-r),i+(smG*r-r))=0;
% %                     disp('=0')
% %                 else bw(j+(smV*r-r),i+(smG*r-r))=1;
% %                     disp('=1')
% %                 end
% %             end
% %         end
% %     end
% % end
% % bw;

% binarizing the cropped image: Dividing into 30x30 square block sizes.
% Calculating the mean intensity of each block and using that as
% a threshold. Everything above the threshold is converted to black and
% everything else to white.
binaryPlate = blockproc(licenseBox, [45 45],@(b) b.data <= mean(b.data(:)) + 10); % Everything above put into one line
axes(handles.axes3);
imshow(binaryPlate);

%   figure(3),imshow(binaryPlate),pause % Binary image of license plate


%-----------------Search related regions-------------
% Looking for the binary image pixel areas that are connected objects and
% creates a matrix L(white = 0, black = 1);
%  L=logical(binaryPlate);
%    figure(2),vislabels(L),title('Each object labels') %Displaying the objects

% Getting the area and boundingbox from the binaryPlate matrix
blobValues=regionprops(binaryPlate,'Area', 'BoundingBox');
Length=length(blobValues);    % Number of objects

%       blobValues(7)
%       blobValues(6)
%       blobValues(5)



% converting the license plate image into a 3D matrix
imgOutlined(:,:,1)=licenseBox;
imgOutlined(:,:,2)=licenseBox;
imgOutlined(:,:,3)=licenseBox;


%------------Filtering to only select characters------------
counter=0;    % licenseBox for rows
for i = 1:Length
    areaL = blobValues(i).Area;         % Area of number/letters
    boxL = blobValues(i).BoundingBox;   % Frame objects
    
    % Selecting the number and letters blobs by only choosing the areas
    % where the Area and BoundingBox values are > and < than specified
    if areaL > 25 && areaL < 350 && boxL(4)>10 && boxL(3) ...
            >= 2 && boxL(3) < 25
        counter=counter+1; % incrementing the row of the array
        % Box is a 2D array that holds the rounded BoundingBox in every
        % row that is incremented
        bBox(counter,:)=round(blobValues(i).BoundingBox);
    end
end

%-------------Recognition of digits-----------------
% Sending the outlined images to recognition
Number=-1;
if counter>0
    for i=1:counter
        [imgOutlined,Number(i)]=NN_Digit_Recognition(imgOutlined,bBox(i,:),handles);
    end

elseif counter==0;
    Number=-1;
end

axes(handles.axes4);
imshow(imgOutlined);
%figure(5),imshow(imgOutlined),title('Final result');

% D=imresize(imgOutlined,5,'bilinear');   % Changing the image size
% figure,imshow(D),title('Uvelichennoe finalnoe izobragenie');


%-------------Recognition of letters numbers-----------------
if counter>2 
    [imgOutlined,Letters(1),L1]=NN_Letter_Recognition(imgOutlined,bBox(3,:));
    [imgOutlined,Letters(2),L2]=NN_Letter_Recognition(imgOutlined,bBox(4,:));
else Letters=0;
    L1='0';
    L2='0';
end
L1 = strcat(L1,L2); % concatenating the letters

%D=imresize(imgOutlined,5,'bilinear');   % Changing the image size
%figure,imshow(D),title('Uvelichennoe finalnoe izobragenie');

end
