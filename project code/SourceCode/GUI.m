function varargout = GUI(varargin)
clc
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 04-Apr-2016 19:25:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)


i1 = imread('Gui_Images/main.jpg');
axes(handles.axes2);
imshow(i1);
i1 = imread('Gui_Images/regsample.jpg');
axes(handles.axes1);
imshow(i1);
axes(handles.axes3);
imshow(i1);
axes(handles.axes4);
imshow(i1);
axes(handles.axes5);
i1 = imread('Gui_Images/segsample.jpg');
imshow(i1);
fileID = fopen('Output/LicenseLog.txt','rt');
tScan = textscan(fileID, '%s','Delimiter','');

% formatting the read text to have a "tab" space between every string
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
% flipping the file to read bottom to top
newScan = flipud(newScan);

set(handles.listbox1,'String',newScan);
set(handles.listbox1,'FontName','FixedWidth');
fclose(fileID);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ProcessVideoButton.
function ProcessVideoButton_Callback(hObject, eventdata, handles)

% hObject    handle to ProcessVideoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    videoNameString=get(handles.video,'String');
    videoSource=VideoReader(videoNameString); % 2 4 5 6" 7 8 9 10 11 12
    
catch
    questdlg('Please enter a valid file name', ...
        'Error', ...
        'Ok','Ok');
        pause; % wait for next action
end



% timendate = datetime('now');        % getting date and time
% datetimeString = datestr(timendate);% converting to string
timeString =datestr(now, 'HH:MM');% Getting Time
timeString2 =datestr(now, 'HH.MM.SS');% Getting Time
dateString =datestr(date, 'dd-mmm-yyyy');% Getting Date



frameCount=videoSource.NumberOfFrames;    %#ok<VIDREAD> % The number of frames in the video file

% Reading a range of frames (numbered from 1)
videoFrameRange=[1 frameCount]; % frame range
capturedFrames=read(videoSource,videoFrameRange); %#ok<VIDREAD> % Reading frames


timeString
for i=10:15 % Processing frame range
    % file to write license plate number to
    fileID = fopen('Output/CurrentPlate.txt','w','A');
    frameLoopCount=i; % frame from array.
    singleFrame=capturedFrames(:,:,:,frameLoopCount); %  single frame from array
    % Call license plate detection function to locate  the license plate region
    [~,Number,Letter,~,licenseBox]=AreaOfInterest(singleFrame,handles);
    
    
    
    [~, b] = size(Number);
    [~, d] = size(Letter);
    % Formatting and printing results to a text file.
    if b>3 % if more than 3 characters in the license plate.
        for num = 1:2 % writing first 2 numbers
            fprintf(fileID,'%d',Number(num));
        end
        if d==2 % if there is two letters in the license plate
            fprintf(fileID,'-%s-',Letter);
            for num = 5:b % continue writing numbers from 5th position
                fprintf(fileID,'%d',Number(num));
            end
            fprintf(fileID,'\t%s\t%s\t',timeString, dateString);
        else %else if there is only one letter in the license plate
            fprintf(fileID,'-%s-',Letter);
            for num = 4:b % continue writing numbers from 4th position
                fprintf(fileID,'%d',Number(num));
            end
            % add time and date.
            fprintf(fileID,'\t%s\t%s\t',timeString, dateString);
        end
    else
        errStr = 'Error'; % if no numbers/letters found. Give error with time and date
        fprintf(fileID,'%s\t%s\t%s\t', errStr, timeString, dateString);
        
    end
    
    % Saving image of license plate
    imgLname = sprintf('LicensePlates/%s_%s.jpg',timeString2,dateString); % naming license plate image
    imwrite(licenseBox,imgLname);  % Saving license plate image
    
    % outputting the text file values to the GUI
    [regnum,readDate,readTime] = textread('Output/CurrentPlate.txt','%s %s %s');
    set(handles.edit2,'String',regnum);
    set(handles.edit3,'String',readDate);
    set(handles.edit4,'String',readTime);
    fclose(fileID);
    

    % Searching extracted license plate number against blacklisted vehicles
    regnum = char(regnum); % last license plate
    sSearch = fopen('Output/BlackList.txt', 'r'); % opening blacklists
    tScan = textscan(sSearch, '%s','Delimiter',''); % scanning text
    newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0); % formatting/converting text to string
    licenseP = ~cellfun(@isempty, strfind(newScan, regnum));    % searching text
    blackisted = max(licenseP); % searching for max value. if 1 then something is found. if 0 then nothing is found
    % Alert box
    if blackisted >=1
        bBoxmsg = sprintf('Blacklist ALERT: %s',regnum);
        BlackBox = questdlg(bBoxmsg, ...
            'BLACKLISTED', ...
            'Ok','Ok');
        % Handle response
        switch BlackBox
            case 'Yes'
                fileID = fopen('Output/BlackList.txt', 'A');
                bList=get(handles.bList,'String');
                fprintf(fileID,'\n%s',bList);
                fclose(fileID);
                fprintf('%s added to blacklist',bList);
        end
    end
    output = flipud(vertcat(newScan{licenseP}));
    set(handles.listbox1,'String',output);
    fclose(sSearch);
    
    % Copying output values to log file
    fInput = fopen('Output/LicenseLog.txt', 'A');
    fileID = fopen('Output/CurrentPlate.txt','r+');
    thisLine = fgetl(fileID);
    fprintf(fInput,'\n%s',thisLine);
    fclose(fInput);
    fclose(fileID);
    % updating the list in GUI with new values
    fInput = fopen('Output/LicenseLog.txt','rt');
    tScan = textscan(fInput, '%s','Delimiter','');
    
    % formatting the read text to have a "tab" space between every string
    newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
    % flipping the file to read bottom to top
    newScan = flipud(newScan);
    
    set(handles.listbox1,'String',newScan);
    set(handles.listbox1,'FontName','FixedWidth');
    fclose(fInput);

end







function video_Callback(hObject, eventdata, handles)
% hObject    handle to video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of video as text
%        str2double(get(hObject,'String')) returns contents of video as a double


% --- Executes during object creation, after setting all properties.
function video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchBox_Callback(hObject, eventdata, handles)
% hObject    handle to searchBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchBox as text
%        str2double(get(hObject,'String')) returns contents of searchBox as a double


% --- Executes during object creation, after setting all properties.
function searchBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SearchLogButton. SEARCHING
function SearchLogButton_Callback(hObject, eventdata, handles)
% hObject    handle to SearchLogButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sSearch = fopen('Output/LicenseLog.txt', 'r');
tScan = textscan(sSearch, '%s','Delimiter','');
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
search=get(handles.searchBox,'String');
licenseP = ~cellfun(@isempty, strfind(newScan, search));


output = flipud(vertcat(newScan{licenseP}));
set(handles.listbox1,'String',output);
fclose(sSearch);



function logBox_Callback(hObject, eventdata, handles)
% hObject    handle to logBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of logBox as text
%        str2double(get(hObject,'String')) returns contents of logBox as a double


% --- Executes during object creation, after setting all properties.
function logBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ProcessImageButton. IMAGE PROCESSING.
function ProcessImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
inImage=get(handles.video,'String');
inImage=imread(inImage); % 2 4 5 6" 7 8 9 10 11 12
catch
    questdlg('Please enter a valid file name', ...
        'Error', ...
        'Ok','Ok');
        pause; % wait for next action
end
% file to write license plate number to
fileID = fopen('Output/CurrentPlate.txt','w','A');
% timendate = datetime('now');        % getting date and time
% datetimeString = datestr(timendate);% converting to string
timeString =datestr(now, 'HH:MM');% Getting Time
timeString2 =datestr(now, 'HH.MM.SS');% Getting Time
dateString =datestr(date, 'dd-mmm-yyyy');% Getting Date
timeString



%     Im1=imread('vib.jpg'); % testing image
    % Call Frame Detection function to find the license plate
    [~,Number,Letter,~,licenseBox]=AreaOfInterest(inImage,handles);
    %       figure(1),imshow(AOI)
    
    
    
    [~, b] = size(Number);
    [~, d] = size(Letter);
    % Formatting and printing results to a text file.
    if b>3
        for num = 1:2
            fprintf(fileID,'%d',Number(num));
        end
        if d==2
            fprintf(fileID,'-%s-',Letter);
            for num = 5:b
                fprintf(fileID,'%d',Number(num));
            end
            fprintf(fileID,'\t%s\t%s\t',timeString, dateString);
        else
            fprintf(fileID,'-%s-',Letter);
            for num = 4:b
                fprintf(fileID,'%d',Number(num));
            end
            fprintf(fileID,'\t%s\t%s\t',timeString, dateString);
        end
    else
        errStr = 'Error';
        fprintf(fileID,'%s\t%s\t%s\t', errStr, timeString, dateString);  
    end
    
    % Saving image of license plate
    imgLname = sprintf('LicensePlates/%s_%s.jpg',timeString2,dateString); % naming license plate image
    imwrite(licenseBox,imgLname);  % Saving license plate image
    

% reading the text file values to the GUI
[regnum,readDate,readTime] = textread('Output/CurrentPlate.txt','%s %s %s');
set(handles.edit2,'String',regnum);
set(handles.edit3,'String',readDate);
set(handles.edit4,'String',readTime);
fclose(fileID);

% Searching extracted license plate number against blacklisted vehicles
regnum = char(regnum); % last license plate
sSearch = fopen('Output/BlackList.txt', 'r'); % opening blacklists
tScan = textscan(sSearch, '%s','Delimiter',''); % scanning text
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0); % formatting/converting text to string
licenseP = ~cellfun(@isempty, strfind(newScan, regnum));    % searching text
blackisted = max(licenseP); % searching for max value. if 1 then something is found. if 0 then nothing is found
% Alert box
if blackisted >=1
    % writing number and time of alert.
    fileID = fopen('Output/BlackListAlerts.txt', 'A');
    fprintf(fileID,'\n%s\t%s\t%s',regnum,timeString2,dateString);
    fclose(fileID);
    bBoxmsg = sprintf('Blacklist ALERT: %s',regnum);
    BlackBox = questdlg(bBoxmsg, ...
        'BLACKLISTED', ...
        'Ok','Ok');
end
output = flipud(vertcat(newScan{licenseP}));
set(handles.listbox1,'String',output);
fclose(sSearch);

% Copying output values to log file 
fInput = fopen('Output/LicenseLog.txt', 'A');
fileID = fopen('Output/CurrentPlate.txt','r+');
thisLine = fgetl(fileID);
fprintf(fInput,'\n%s',thisLine);
fclose(fInput);
fclose(fileID);


% Updating list in GUI with new values
fInput = fopen('Output/LicenseLog.txt','rt');
tScan = textscan(fInput, '%s','Delimiter','');

% formatting the read text to have a "tab" space between every string
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
% flipping the file to read bottom to top
newScan = flipud(newScan);

set(handles.listbox1,'String',newScan);
set(handles.listbox1,'FontName','FixedWidth');
fclose(fInput);




function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bList_Callback(hObject, eventdata, handles)
% hObject    handle to bList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bList as text
%        str2double(get(hObject,'String')) returns contents of bList as a double


% --- Executes during object creation, after setting all properties.
function bList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BlacklistButton. BLACKLISTING
function BlacklistButton_Callback(hObject, eventdata, handles)
% hObject    handle to BlacklistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with three options

choice = questdlg('Confirm blacklist', ...
	'Blacklisting', ...
	'No','Yes','Yes');
% Handle response
switch choice
    case 'Yes'
        fileID = fopen('Output/BlackList.txt', 'A');
        bList=get(handles.bList,'String');
        fprintf(fileID,'\n%s',bList);
        fclose(fileID);
        fprintf('%s added to blacklist',bList);
    case 'No'
        disp('Not added');
end


% --- Executes on button press in ViewBlackButton. VIEW LOG
function ViewBlackButton_Callback(hObject, eventdata, handles)
% hObject    handle to ViewBlackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileID = fopen('Output/BlackList.txt','rt');
tScan = textscan(fileID, '%s','Delimiter','');

% formatting the read text to have a "tab" space between every string
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
% flipping the file to read bottom to top
newScan = flipud(newScan);

set(handles.listbox1,'String',newScan);
set(handles.listbox1,'FontName','FixedWidth');
fclose(fileID);

% --- Executes on button press in ViewLog. VIEW BLACKLIST
function ViewLog_Callback(hObject, eventdata, handles)
% hObject    handle to ViewLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileID = fopen('Output/LicenseLog.txt','rt');
tScan = textscan(fileID, '%s','Delimiter','');

% formatting the read text to have a "tab" space between every string
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
% flipping the file to read bottom to top
newScan = flipud(newScan);

set(handles.listbox1,'String',newScan);
set(handles.listbox1,'FontName','FixedWidth');
fclose(fileID);


% --- Executes on button press in bListAlert.
function bListAlert_Callback(hObject, eventdata, handles)
% hObject    handle to bListAlert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileID = fopen('Output/BlackListAlerts.txt','rt');
tScan = textscan(fileID, '%s','Delimiter','');

% formatting the read text to have a "tab" space between every string
newScan = cellfun(@(x)sprintf('%-15s', x{:}), regexp(tScan{1}, '\t+', 'split'), 'uni', 0);
% flipping the file to read bottom to top
newScan = flipud(newScan);

set(handles.listbox1,'String',newScan);
set(handles.listbox1,'FontName','FixedWidth');
fclose(fileID);
