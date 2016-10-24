%--------NEURAL NETWORK DIGIT TRAINING--------
% Feed-forward neural network and back-propagation
% Feed-forward neural network because the neurons only flow forward and
% does not connect to itself or a previous layer.
% Feed-forward is a type of neural network and back-propagation is a way to
% train the neural network. This neural network has a weight matrix that
% forms the memory of how the neural network is going to actually function
% Training methods are automated by adjusting these weights so that the
% neural network will behave as expected to. This allows the neural network
% to learn anticipated behaviour and be able to handle cases that were not
% in the training set provided to the neural network.

% This is a three-layer neural network. The input layer, hidden layer and output layer.
% The input layer contains neurons encoding values of the input pixels. This neural network
% is using training data of 24x14 pixels and so the input layer contains 336 = 24x14 pixels.
% The input pixels are grayscale so they have a values of 0.0 = white, 1.0 = black and inbetween
% values representing gradually darkening shades of grey (0.1-0.9).
%
% The second layer is the hidden layer. We indicate the number of neurons in the hidden layer.
% This neural network is using 50 hidden layers.
%
% Finally the output layer, which will contain 10 neurons. If the first neuron fires, then that
% will indicate that the network thinks it a 0. If the second neuron fires then that will
% indicate that the network thinks the digit is 1., and so on.

close all
clear,clc

%----------------Reading images from files---------------
% Storing path of folders
folderPath1=fullfile('SameSizeNum/','0/');
folderPath2=fullfile('SameSizeNum/','1/');
folderPath3=fullfile('SameSizeNum/','2/');
folderPath4=fullfile('SameSizeNum/','3/');
folderPath5=fullfile('SameSizeNum/','4/');
folderPath6=fullfile('SameSizeNum/','5/');
folderPath7=fullfile('SameSizeNum/','6/');
folderPath8=fullfile('SameSizeNum/','7/');
folderPath9=fullfile('SameSizeNum/','8/');
folderPath10=fullfile('SameSizeNum/','9/');

N=90;           % The number of training images
M=10;           % Number of test samples

%----------------Target Images---------------
for i=1:N   % 1-90
    % Importing Training images
    fileName=sprintf('%d.bmp',i); % each file in every folder is named 1 - 100 .bmp
    % reading in individual image and storing it into variable
    num0=imread([folderPath1, fileName]);
    num1=imread([folderPath2, fileName]);
    num2=imread([folderPath3, fileName]);
    num3=imread([folderPath4, fileName]);
    num4=imread([folderPath5, fileName]);
    num5=imread([folderPath6, fileName]);
    num6=imread([folderPath7, fileName]);
    num7=imread([folderPath8, fileName]);
    num8=imread([folderPath9, fileName]);
    num9=imread([folderPath10, fileName]);
    
    % taking the 2D image (image 0-9) and storing it into the i'th
    % slice (plane) of a 3D image matrix
    im0(:,:,i)=num0;      % "0"
    im1(:,:,i)=num1;      % "1"
    im2(:,:,i)=num2;      % "2"
    im3(:,:,i)=num3;      % "3"
    im4(:,:,i)=num4;      % "4"
    im5(:,:,i)=num5;      % "5"
    im6(:,:,i)=num6;      % "6"
    im7(:,:,i)=num7;      % "7"
    im8(:,:,i)=num8;      % "8"
    im9(:,:,i)=num9;    % "9"
end

%----------------Test Images---------------
for i=1:M   % 1-10
    % importing Test samples
    fileName=sprintf('%d.bmp',i+N);% importing images 90-100
    % reading in individual image and storing it into variable
    num0t=imread([folderPath1, fileName]);
    num1t=imread([folderPath2, fileName]);
    num2t=imread([folderPath3, fileName]);
    num3t=imread([folderPath4, fileName]);
    num4t=imread([folderPath5, fileName]);
    num5t=imread([folderPath6, fileName]);
    num6t=imread([folderPath7, fileName]);
    num7t=imread([folderPath8, fileName]);
    num8t=imread([folderPath9, fileName]);
    num9t=imread([folderPath10, fileName]);
    
    % taking the 2D image (image 0-9) and storing it into the i'th
    % slice (plane) of a 3D image matrix
    im1t(:,:,i)=num0t;      % "0"
    im2t(:,:,i)=num1t;      % "1"
    im3t(:,:,i)=num2t;      % "2"
    im4t(:,:,i)=num3t;      % "3"
    im5t(:,:,i)=num4t;      % "4"
    im6t(:,:,i)=num5t;      % "5"
    im7t(:,:,i)=num6t;      % "6"
    im8t(:,:,i)=num7t;      % "7"
    im9t(:,:,i)=num8t;      % "8"
    im10t(:,:,i)=num9t;    % "9"
end

% Creating a 1 whole matrix for the training images
for i=1:N   % Training images
    % taking the previously created 3D image matrix and storing it in one
    % whole matrix like so: (0)1-90, (1)91-180, (2)181-270 etc
    im(:,:,i)=im0(:,:,i);
    im(:,:,i+N)=im1(:,:,i);
    im(:,:,i+2*N)=im2(:,:,i);
    im(:,:,i+3*N)=im3(:,:,i);
    im(:,:,i+4*N)=im4(:,:,i);
    im(:,:,i+5*N)=im5(:,:,i);
    im(:,:,i+6*N)=im6(:,:,i);
    im(:,:,i+7*N)=im7(:,:,i);
    im(:,:,i+8*N)=im8(:,:,i);
    im(:,:,i+9*N)=im9(:,:,i);
    
    %     fprintf('Now inserting planes %d, %d, and %d\n', i, i+N, i+2*N);
end

for i=1:M   % test samples
    imt(:,:,i)=im1t(:,:,i);
    imt(:,:,i+M)=im2t(:,:,i);
    imt(:,:,i+2*M)=im3t(:,:,i);
    imt(:,:,i+3*M)=im4t(:,:,i);
    imt(:,:,i+4*M)=im5t(:,:,i);
    imt(:,:,i+5*M)=im6t(:,:,i);
    imt(:,:,i+6*M)=im7t(:,:,i);
    imt(:,:,i+7*M)=im8t(:,:,i);
    imt(:,:,i+8*M)=im9t(:,:,i);
    imt(:,:,i+9*M)=im10t(:,:,i);
end


% The transition of values from (0:255) to (0:1.0)
for i=1:10*N   % Training images
    imd(:,:,i)=(im2double(im(:,:,i)));
end

for i=1:10*M   % test samples
    imdt(:,:,i)=(im2double(imt(:,:,i)));
end

%------------------Input and test images----------------
% Converting 24x14x900 matrix to a linear 1x336(900x336)
% 1 5 9  13  = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
% 2 6 10 14
% 3 7 11 15
% 4 8 12 16
for s=1:10*N % 0-900
    for i=1:14 % every column
        for j=1:24  % every row
            % taking every row(j) value in every column(i) 
            % and storing in a new single row
            Xv(s,(i-1)*24+j)=imd(j,i,s); 
        end
    end
end

sizeXv=size(Xv);
% Test images
for s=1:10*M % 0-100
    for i=1:14 % every column
        for j=1:24  % every row
            % taking every row(j) value in every column(i) 
            % and storing in a new single row
            Xt(s,(i-1)*24+j)=imdt(j,i,s); 
        end
    end
end
sizeXt=size(Xt);

%----------------------Classification-----------------------
% 10 dimensional column vector. For example, if a particular training image, x,
% depicts a 6, then y(x)=(0,0,0,0,0,0,1,0,0,0)T is the desired output
% from the network
T = 1:10;
for i=1:N
    T(i,:)=[1 0 0 0 0 0 0 0 0 0];
    T(i+N,:)=[0 1 0 0 0 0 0 0 0 0];
    T(i+2*N,:)=[0 0 1 0 0 0 0 0 0 0];
    T(i+3*N,:)=[0 0 0 1 0 0 0 0 0 0];
    T(i+4*N,:)=[0 0 0 0 1 0 0 0 0 0];
    T(i+5*N,:)=[0 0 0 0 0 1 0 0 0 0];
    T(i+6*N,:)=[0 0 0 0 0 0 1 0 0 0];
    T(i+7*N,:)=[0 0 0 0 0 0 0 1 0 0];
    T(i+8*N,:)=[0 0 0 0 0 0 0 0 1 0];
    T(i+9*N,:)=[0 0 0 0 0 0 0 0 0 1];
end
T;



inNeu=336;       % number of inputs
hidnNeu=50;      % The number of hidden neurons
outNeu=10;       % The number of output neurons
learnRate=0.5;   % The rate of learning
cycle=100;       % Number of teaching periods


%----------------Neural Network----------------

% Randomising the weight matrix. (Extra row added that it
% can multiply against the threshold value and not modify the threshold.
% We simply want the threshold value added with the
% other values.
w1=randint(inNeu+1,hidnNeu,[-2,2])/10+rand(inNeu+1,hidnNeu)/100;   % The weights in the range [-0.3 0.3]
w2=randint(hidnNeu+1,outNeu,[-2,2])/10+rand(hidnNeu+1,outNeu)/100;

for e=1:cycle          % Cycle for cycle for all epoch(100)
    for I=1:10*N      % The cycle one epoch (900)
        % Feed forward
        x(1:inNeu)=Xv(I,:); % Passing single row (image)
        %------------The output value of the hidden layer----
        % preallocating [1 50] zeros to store the output value of the hidden layer
        net=zeros(1,hidnNeu);
        o=zeros(1,hidnNeu);
        for i=1:hidnNeu
            xw=0;
            for j=1:inNeu
                % Connection weights
                % multiplying every column of x(image I) by every
                % row+1 of the w1 matrix to create a hidden layer connection weight
                xw=xw+(x(j)*w1(j+1,i));
            end
            % Pre-activation
            % The total net inputs of the hidden layer
            net(i)=(1*w1(1,i))+xw;
 
            % Logistic activation function: squahes the neurons
            % pre-activation between 0 and 1
            % Creating the sum output weight of the hidden layer by getting the
            % exponential of net. The activation function compressing
            % values in the range 0-1
            o(i)=1/(1+exp(-net(i)));
        end
        
        %------------The output value of the output layer---
        % preallocating [1 10] zeros to store the output value of the output layer
        netvih=zeros(1,outNeu);
        ovih=zeros(1,outNeu);
        for i=1:outNeu
            ow=0;
            for j=1:hidnNeu
                % Connection weights
                % multiplying every column of o(Hidden layers) by every
                % row+1 of the w2 matrix to create an output layer connection weight
                ow=ow+(o(j)*w2(j+1,i));
            end
            % Pre-activation
            % The total net inputs of the output layer
            netvih(i)=(1*w2(1,i))+ow;
            % Logistic activation function: squahes the neurons
            % pre-activation between 0 and 1
            % Creating the sum output weight of the output layer by getting the
            % exponential of netvih. The activation function compressing
            % values in the range 0-1
            ovih(i)=1/(1+exp(-netvih(i)));
        end
        
        %------------Back propagation - Calucluating total error------------
        % The goal of backpropagation is to optimize the weights so that 
        % the neural network can learn how to correctly map arbitrary inputs to outputs.
        % Calculating the error of the output value by difference
        % between the output value and the expected output value.
        % The difference between what was expected and what was produced.
        % we want to minimus this. Basically we are maximizing the
        % probability of 0-9 to fall into the correct classification
        
        %------------output layer error------------
        dvih=zeros(1,outNeu); % [1 10] matrix
        for i=1:outNeu 
            dvih(i)=(T(I,i)-ovih(i))*ovih(i)*(1-ovih(i));
        end
        %------------hidden layer error------------
        d=zeros(1,hidnNeu); % [1 50] matrix
        for i=1:hidnNeu
            dw=0;
            for j=1:outNeu
                dw=dw+dvih(j)*w2(i+1,j);
            end
            d(i)=o(i)*(1-o(i))*dw;

        end
        %-----Updating weight matrix for the output layer
        for i=1:outNeu
            w2(1,i)=w2(1,i)+learnRate*dvih(i)*1;
        end
        
        for i=1:outNeu
            for j=1:hidnNeu
                w2(j+1,i)=w2(j+1,i)+learnRate*dvih(i)*o(j);
            end
        end 
        %-----updating weight matrix for the hidden layer
        for i=1:hidnNeu
            w1(1,i)=w1(1,i)+learnRate*d(i)*1;
        end
        
        for i=1:hidnNeu
            for j=1:inNeu
                w1(j+1,i)=w1(j+1,i)+learnRate*d(i)*x(j);
            end
        end
    end
    % The total error for the neural network
    Ep(I)=sum(dvih.^2);     % The error for the image 
    Epoch(e)=sqrt(sum(Ep)/N);   % mean-square error
    
%     Epoch
end
figure(1),plot(Epoch),title('Root Mean Square Error (RMS Error)'),xlabel('N, epoch'),ylabel('RMS Error'),grid
Epoch=Epoch(cycle);


%-----------------Testing the network----------------------
K=0;              % Count the number of units
for I=1:10*M         % The cycle for one era
    %----------------Forward run-------------------------
    xi(1:inNeu)=Xt(I,:);
    %------------The output value of the hidden layer----
    net=zeros(1,hidnNeu);
    o=zeros(1,hidnNeu);
    for i=1:hidnNeu
        xw=0;
        for j=1:inNeu
            xw=xw+(xi(j)*w1(j+1,i));
        end
        net(i)=(1*w1(1,i))+xw;
        o(i)=1/(1+exp(-net(i)));
    end
    
    %------------The output value of the output layer---
    netvih=zeros(1,outNeu);
    ovih=zeros(1,outNeu);
    for i=1:outNeu
        ow=0;
        for j=1:hidnNeu
            ow=ow+(o(j)*w2(j+1,i));
        end
        netvih(i)=(1*w2(1,i))+ow;
        ovih(i)=1/(1+exp(-netvih(i)));
        if ovih(i)<0.1
            vih(i)=0;
        elseif ovih(i)>0.9
            vih(i)=1;
            K=K+1;
        else vih(i)=ovih(i);
        end
    end
    %ovih
    %N=I-1
    vih;
    Vih(I,:)=vih;
end

S=zeros(1,outNeu);
for i=1:outNeu
    S(1,i)=sum(Vih((i-1)*5+1:(i-1)*5+5,i));
end
Ps=sum(S)/N         % The probability of identification (relaxed payment)

% Record matrices of weighting coefficients in files
dlmwrite('w1.txt', w1, ',')
dlmwrite('w2.txt', w2, ',')