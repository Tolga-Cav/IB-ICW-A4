l=length(data_out);
samples_per_window = 64;

%Create the windows
rect = rectwin(samples_per_window);
ham = hamming(samples_per_window);
han = hann(samples_per_window);
kais = kaiser(samples_per_window);
bart = bartlett(samples_per_window);

%create array of window functions
windows = [rect, ham, han, kais, bart];
window_names = ["No Window/Rectangular","Hamming", "Hanning", "Kaiser", "Bartlett"];

%Array of overlap percentages
overlaps = [0.0 , 0.25, 0.50, 0.75];

%List of data files
files = ["lab_data/sin_9_13.mat"]; %["lab_data/sin_10.mat", "lab_data/sin_9_13.mat", "lab_data/sin_3_9_13.mat", "lab_data/sin_random.mat"];
%Earthquake filenames
%files = ["earthquake_data/dataset1-small.mat",
%"earthquake_data/dataset2-moderate.mat", "earthquake_data/dataset3-large.mat"];

plot_names = ["One Sin Input","Two Sins Input","Three Sins Input", "Random Input"];
%plot_names = ["Small Earthquake", "Moderate Earthquake", "Large Earthquake"];

%Loop this for each input we gave it
for file_index = 1:length(files)
    load(files(file_index));

    %Cut the data to only have steady state 
    %If we show the evolution of the spectrum, we don't need to do this
    % data_ch1=data_ch1(l+1:l*2);
    % data_ch2=data_ch2(l+1:l*2);
    % t=t(l+1:l*2);
    
    %Possibly reduce the number of samples and values in time array to reduce
    %the sampling rate expost facto
    %We probably don't need to do this
    
    %Center the data at 0
    data_ch1=data_ch1-mean(data_ch1);
    data_ch2=data_ch2-mean(data_ch2);

    %For each type of window
    for window_index = 1:length(windows(1,:))
        window = windows(:,window_index);
        window_name = window_names(window_index);
        %For each overlap value
        for overlap_index = 1:length(overlaps)
            overlap = overlaps(overlap_index);
            
            %For speed if needed, make these empty arrays the size of max k
            transforms_1 = [];
            transforms_2 = [];

            figure
            hold on 
            %loop across the samples %FIX THIS HERE 
            for k = 0:(floor( (length(data_ch1)/samples_per_window)*( 1 / (1-overlap) ) ) - 1)
                
                samples_subset = (samples_per_window*k - overlap*samples_per_window*(k ~= 0)) + (1:samples_per_window);
                %Create the subset of samples of data
                selected_ch1 = data_ch1(samples_subset);
                selected_ch2 = data_ch2(samples_subset);
                
                %Create frequency domain values
                selected_t = t(samples_subset);
                selected_t = selected_t - min(selected_t);
                x = selected_t*real_rate/(selected_t(length(selected_t)));
               
                %apply window
                windowed_ch1 = selected_ch1.*window;
                windowed_ch2 = selected_ch2.*window;

                %take fourier transforms 
                f_ch1 = fourier(windowed_ch1);
                f_ch2 = fourier(windowed_ch2);
                
                %Add the transforms to the array
                transforms_1 = [transforms_1;f_ch1];
                transforms_2 = [transforms_2;f_ch2];
                
            end    
            %INSTEAD CREATE A WATERFALL? PLOT HERE
            
            %Create plots for ch 1 and 2
            plot(x,abs(f_ch1),x,abs(f_ch2));
            title( window_name + " " + k + " " + overlap) %CHANGE NAME OF THE PLOT TO BE BETTER
            %ADD NICE AXIS TITLES
            V = axis;
            axis([0 50 V(3) V(4)])

            hold off
        end
    end
end    




% figure
% hold on
% 
% subplot(1,2,1)
% plot(x,abs(f_ch1));
% title('Transform of channel 1')
% V = axis;
% axis([0 50 V(3) V(4)])
% 
% subplot(1,2,2)
% plot(x,abs(f_ch2));
% title('Transform of channel 2')
% V = axis;
% axis([0 50 V(3) V(4)])
% 
% hold off