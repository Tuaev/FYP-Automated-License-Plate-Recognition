%--------NEURAL NETWORK LETTER TRAINING--------
clear,clc

%----------------Reading images from files---------------
FFolder1=fullfile('LettersSame_Size/','A/');
FFolder2=fullfile('LettersSame_Size/','D/');
FFolder3=fullfile('LettersSame_Size/','C/');
FFolder4=fullfile('LettersSame_Size/','E/');
FFolder5=fullfile('LettersSame_Size/','H/');
FFolder6=fullfile('LettersSame_Size/','K/');
FFolder7=fullfile('LettersSame_Size/','M/');
FFolder8=fullfile('LettersSame_Size/','O/');
FFolder9=fullfile('LettersSame_Size/','P/');
FFolder10=fullfile('LettersSame_Size/','T/');
FFolder11=fullfile('LettersSame_Size/','W/');
FFolder12=fullfile('LettersSame_Size/','Y/');

N=90;           % The number of training images (2 * N)
M=10;           % Number of test samples (2 * ML)

for i=1:N   % Training images
    FName=sprintf('%d.bmp',i);
    image1=imread([FFolder1, FName]);
    image2=imread([FFolder2, FName]);
    image3=imread([FFolder3, FName]);
    image4=imread([FFolder4, FName]);
    image5=imread([FFolder5, FName]);
    image6=imread([FFolder6, FName]);
    image7=imread([FFolder7, FName]);
    image8=imread([FFolder8, FName]);
    image9=imread([FFolder9, FName]);
    image10=imread([FFolder10, FName]);
    image11=imread([FFolder11, FName]);
    image12=imread([FFolder12, FName]);
    
    im1(:,:,i)=image1;      % "A"
    im2(:,:,i)=image2;      % "B"
    im3(:,:,i)=image3;      % "C" 
    im4(:,:,i)=image4;      % "E" 
    im5(:,:,i)=image5;      % "H" 
    im6(:,:,i)=image6;      % "K" 
    im7(:,:,i)=image7;      % "M" 
    im8(:,:,i)=image8;      % "O" 
    im9(:,:,i)=image9;      % "P" 
    im10(:,:,i)=image10;    % "T" 
    im11(:,:,i)=image11;    % "W" 
    im12(:,:,i)=image12;    % "Y" 
end

for i=1:M   % test samples  
    FName=sprintf('%d.bmp',i+N);
    image1t=imread([FFolder1, FName]);
    image2t=imread([FFolder2, FName]);
    image3t=imread([FFolder3, FName]);
    image4t=imread([FFolder4, FName]);
    image5t=imread([FFolder5, FName]);
    image6t=imread([FFolder6, FName]);
    image7t=imread([FFolder7, FName]);
    image8t=imread([FFolder8, FName]);
    image9t=imread([FFolder9, FName]);
    image10t=imread([FFolder10, FName]);
    image11t=imread([FFolder11, FName]);
    image12t=imread([FFolder12, FName]);
    
    im1t(:,:,i)=image1t;      % "A"
    im2t(:,:,i)=image2t;      % "B"
    im3t(:,:,i)=image3t;      % "C" 
    im4t(:,:,i)=image4t;      % "E" 
    im5t(:,:,i)=image5t;      % "H" 
    im6t(:,:,i)=image6t;      % "K" 
    im7t(:,:,i)=image7t;      % "M" 
    im8t(:,:,i)=image8t;      % "O" 
    im9t(:,:,i)=image9t;      % "P" 
    im10t(:,:,i)=image10t;    % "T" 
    im11t(:,:,i)=image11t;    % "W" 
    im12t(:,:,i)=image12t;    % "Y" 
end

% Record of training images in a matrix (in series)
for i=1:N   % Training images
    im(:,:,i)=im1(:,:,i);
    im(:,:,i+N)=im2(:,:,i);
    im(:,:,i+2*N)=im3(:,:,i);
    im(:,:,i+3*N)=im4(:,:,i);
    im(:,:,i+4*N)=im5(:,:,i);
    im(:,:,i+5*N)=im6(:,:,i);
    im(:,:,i+6*N)=im7(:,:,i);
    im(:,:,i+7*N)=im8(:,:,i);
    im(:,:,i+8*N)=im9(:,:,i);
    im(:,:,i+9*N)=im10(:,:,i);
    im(:,:,i+10*N)=im11(:,:,i);
    im(:,:,i+11*N)=im12(:,:,i);
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
    imt(:,:,i+10*M)=im11t(:,:,i);
    imt(:,:,i+11*M)=im12t(:,:,i);
end


%-----Presentation image array of class double---
    % The transition to values (0 1) of the range (0: 255)
for i=1:12*N   % Training images
    imd(:,:,i)=(im2double(im(:,:,i)));
end

for i=1:12*M   % test samples
    imdt(:,:,i)=(im2double(imt(:,:,i)));
end

%------------------Input and test images----------------
    % Convert 18x14 matrix in line 1x252
for s=1:12*N
    for i=1:14
        for j=1:24
            Xv(s,(i-1)*24+j)=imd(j,i,s);
        end
    end
end
sizeXv=size(Xv);

for s=1:12*M
    for i=1:14
        for j=1:24
            Xt(s,(i-1)*24+j)=imdt(j,i,s);
        end
    end
end
sizeXt=size(Xt);

%----------------------target images-----------------------
for i=1:N
    T(i,:)=[1 0 0 0 0 0 0 0 0 0 0 0];
    T(i+N,:)=[0 1 0 0 0 0 0 0 0 0 0 0];
    T(i+2*N,:)=[0 0 1 0 0 0 0 0 0 0 0 0];
    T(i+3*N,:)=[0 0 0 1 0 0 0 0 0 0 0 0];
    T(i+4*N,:)=[0 0 0 0 1 0 0 0 0 0 0 0];
    T(i+5*N,:)=[0 0 0 0 0 1 0 0 0 0 0 0];
    T(i+6*N,:)=[0 0 0 0 0 0 1 0 0 0 0 0];
    T(i+7*N,:)=[0 0 0 0 0 0 0 1 0 0 0 0];
    T(i+8*N,:)=[0 0 0 0 0 0 0 0 1 0 0 0];
    T(i+9*N,:)=[0 0 0 0 0 0 0 0 0 1 0 0];
    T(i+10*N,:)=[0 0 0 0 0 0 0 0 0 0 1 0];
    T(i+11*N,:)=[0 0 0 0 0 0 0 0 0 0 0 1];
end
T;



vh=336;                % number of inputs
n=50;                  % The number of hidden neurons
v=12;                  % The number of output neurons
h=0.5;                 % The rate of learning
E=100;                 % Number of teaching periods


%-------The algorithm reverse error propagation-------
w1=randint(vh+1,n,[-2,2])/10+rand(vh+1,n)/100;   % The weights in the range [-0.3 0.3]
w2=randint(n+1,v,[-2,2])/10+rand(n+1,v)/100;

for e=1:E          % Cycle for the passage of all ages
 for I=1:12*N         % The cycle for one era
    %----------------Forward run-------------------------
    x(1:vh)=Xv(I,:);
        %------------The output value of the hidden layer----
        net=zeros(1,n);
        o=zeros(1,n);
        for i=1:n
            xw=0;
            for j=1:vh
                xw=xw+(x(j)*w1(j+1,i));
            end    
            net(i)=(1*w1(1,i))+xw;
            o(i)=1/(1+exp(-net(i)));
        end

        %------------The output value of the output layer---
        netvih=zeros(1,v);
        ovih=zeros(1,v);
        for i=1:v
            ow=0;
            for j=1:n
                ow=ow+(o(j)*w2(j+1,i));
            end    
            netvih(i)=(1*w2(1,i))+ow;
            ovih(i)=1/(1+exp(-netvih(i)));
        end      
        
    %----------------reversal-------------------------
        %------------The values of output elements error---
        dvih=zeros(1,v);
        for i=1:v
            dvih(i)=(T(I,i)-ovih(i))*ovih(i)*(1-ovih(i));
            %to(i)=(T(I,i)-ovih(i));
        end
        Ep(I)=sum(dvih.^2);     % The error for the image p

        %------------The values of hidden items errors---
        d=zeros(1,n);
        for i=1:n
            dw=0;
            for j=1:v
                dw=dw+dvih(j)*w2(i+1,j);
            end
            d(i)=o(i)*(1-o(i))*dw;
        end

        %-----New weights for the output layer
        for i=1:v
            w2(1,i)=w2(1,i)+h*dvih(i)*1;
        end

        for i=1:v
            for j=1:n
                w2(j+1,i)=w2(j+1,i)+h*dvih(i)*o(j); 
            end    
        end 
       
        %-----New weights for the hidden layer
        for i=1:n
            w1(1,i)=w1(1,i)+h*d(i)*1;  
        end

        for i=1:n
            for j=1:vh
                w1(j+1,i)=w1(j+1,i)+h*d(i)*x(j); 
            end    
        end    
 end
 Epoch(e)=sqrt(sum(Ep)/N);   % mean-square error  
                            %(total error for all images)
end
figure(1),plot(Epoch),title('Root Mean Square Error (RMS Error)'),xlabel('N, epoch'),ylabel('RMS Error'),grid
Epoch=Epoch(E);


%-----------------Testing the network----------------------
K=0;              % Count the number of units
for I=1:12*M         % The cycle for one era
    %----------------Forward run-------------------------
    xi(1:vh)=Xt(I,:);
        %------------The output value of the hidden layer----
        net=zeros(1,n);
        o=zeros(1,n);
        for i=1:n
            xw=0;
            for j=1:vh
                xw=xw+(xi(j)*w1(j+1,i));
            end    
            net(i)=(1*w1(1,i))+xw;
            o(i)=1/(1+exp(-net(i)));
        end
        
        %------------The output value of the output layer---
        netvih=zeros(1,v);
        ovih=zeros(1,v);
        for i=1:v
            ow=0;
            for j=1:n
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
Vih
K
P=K/(N/100)/100     % The probability of identification (rough calculation)

S=zeros(1,v);
for i=1:v
    S(1,i)=sum(Vih((i-1)*5+1:(i-1)*5+5,i));    
end    
Ps=sum(S)/N         % The probability of identification (relaxed payment)

Epoch


% Record matrices of weighting coefficients in files
dlmwrite('w3.txt', w1, ',')
dlmwrite('w4.txt', w2, ',')








