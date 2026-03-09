l=length(data_out);
samples_per_window = 64;
%Create the windows
%RECTANGULAR WINDOW
ham = hamming(samples_per_window);
han = hann(samples_per_window);
% ...

%Array of overlap percentages
overlap = [0 , 25, 50, 75];

%create array of window functions
windows = [ham, han]; % ...



%Loop this for each input we gave it

%Cut the data to include transient
% data_ch1=data_ch1_1(1:l);
% data_ch2=data_ch2_1(1:l);


%Cut the data to only have steady state
data_ch1=data_ch1(l+1:l*2);
data_ch2=data_ch2(l+1:l*2);

%Possibly reduce the number of samples and values in time array to reduce
%the sampling rate expost facto

%Center the data at 0
data_ch1=data_ch1-mean(data_ch1);
data_ch2=data_ch2-mean(data_ch2);

%For each type of window
    %For each overlap value
        %loop across the samples
            %Create the subset of samples of data
            %.* that subset with relative window function
            %fourier that set of samples
            %add that as a subplot
        %display the plot of all these fourier transforms



f_ch1 = fourier(data_ch1);
f_ch2 = fourier(data_ch2);
x=t*real_rate/(t(length(t)));

figure
hold on

subplot(1,2,1)
plot(x,abs(f_ch1));
title('Transform of channel 1')
V = axis;
axis([0 50 V(3) V(4)])

subplot(1,2,2)
plot(x,abs(f_ch2));
title('Transform of channel 2')
V = axis;
axis([0 50 V(3) V(4)])

hold off