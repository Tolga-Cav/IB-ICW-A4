samples_per_window = 2000;

%Create the windows
rect = rectwin(samples_per_window);
ham = hamming(samples_per_window);
han = hann(samples_per_window);
kais = kaiser(samples_per_window);
bart = bartlett(samples_per_window);

%create array of window functions
windows = [rect, ham, han, kais, bart];
window_names = ["Rectangular","Hamming", "Hanning", "Kaiser", "Bartlett"];

%Array of overlap percentages
overlaps = [0.0 , 0.25, 0.50, 0.75, 0.9];

%List of data files
%files = ["lab_data/sin_random.mat"]; %["lab_data/sin_10.mat", "lab_data/sin_9_13.mat", "lab_data/sin_3_9_13.mat", "lab_data/sin_random.mat"];

%Earthquake filenames
files = ["earthquake_data/dataset1-small.mat", "earthquake_data/dataset2-moderate.mat", "earthquake_data/dataset3-large.mat"];

% plot_names =["Three Sins Input"];% ["One Sin Input","Two Sins Input","Three Sins Input", "Random Input"];
plot_names = ["Small Earthquake", "Moderate Earthquake", "Large Earthquake"];

%Loop this for each input we gave it
for file_index = 1:length(files)
    load(files(file_index));
    
    % Earthquake
    data = f0;
    data = data - mean(data);
    t = (1:length(f0))/500;
    t = t';
    real_rate = 500;

    % % Model
    % l=length(data_out);
    % % Cut the data to only have steady state 
    % data_ch1=data_ch1(l+1:l*2);
    % data_ch2=data_ch2(l+1:l*2);
    % t=t(l+1:l*2);
    % 
    % % Center the data at 0
    % data_ch1=data_ch1-mean(data_ch1);
    % data_ch2=data_ch2-mean(data_ch2);

    %For each type of window
    for window_index = 1:length(windows(1,:))
        window = windows(:,window_index);
        window_name = window_names(window_index);
        %For each overlap value
        for overlap_index = 1:length(overlaps)
            overlap = overlaps(overlap_index);
            
            % Earthquake
            transforms = [];

            % % Model
            % % For speed if needed, make these empty arrays the size of max k
            % transforms_1 = [];
            % transforms_2 = [];

            %loop across the samples
            for k = 0:floor( ((length(t)-samples_per_window) / ((1-overlap)*samples_per_window)) )
                
                samples_subset = (samples_per_window - overlap*samples_per_window*(k ~= 0))*k + (1:samples_per_window);
                samples_subset = floor(samples_subset);
                % Earthquake
                selected_data = data(samples_subset);

                % % Models
                % % Create the subset of samples of data
                % selected_ch1 = data_ch1(samples_subset);
                % selected_ch2 = data_ch2(samples_subset);
                
                %Create frequency domain values
                selected_t = t(samples_subset);
                selected_t = selected_t - min(selected_t);
                x = selected_t*real_rate/(selected_t(length(selected_t)));
               
                %apply window

                % Earthquake
                windowed_data = selected_data.*window;

                % % Model
                % windowed_ch1 = selected_ch1.*window;
                % windowed_ch2 = selected_ch2.*window;
                
                %take fourier transforms

                % Earthquake
                f = fourier(windowed_data);

                % % Model
                % f_ch1 = fourier(windowed_ch1);
                % f_ch2 = fourier(windowed_ch2);
                
                % Add the transforms to the array

                % Earthquake
                transforms = [transforms,abs(f)];

                % Model
                % transforms_1 = [transforms_1,abs(f_ch1)];
                % transforms_2 = [transforms_2,abs(f_ch2)];

                
                % %Plotting individual transforms
                % if k==5 & overlap==0
                %     figure
                %     hold on
                %     plot(x,abs(f_ch2));
                %     title('Transform of Channel 2 with' + " a " + window_name + " Window")
                %     V = axis;
                %     axis([0 30 V(3) V(4)])
                %     xlabel('Frequency (Hz)');
                %     ylabel('Amplitude (V/Hz)');
                %     hold off
                %     saveas(gcf, "transform"+window_name+".png");
                % end
                % 
                % %Plotting the window functions
                % if k==5 & overlap==0
                %     figure
                %     hold on
                %     plot(window);
                %     title("A " + window_name + " Window")
                %     xlabel("Sample #");
                %     ylabel("Scale factor")
                %     hold off
                %     saveas(gcf, window_name+".png");
                % end                
            end
            figure
            hold on 

            % Create axes
            xMat = repmat(x, 1, k+1);
            y = (1:k+1);
            yMat = repmat(y, numel(x), 1);

            title(plot_names(file_index) + " " + window_name + " Window " + overlap*100 + "% Overlap")

            % Color
            s = pcolor(xMat, yMat, transforms);
            shading flat;
            % s.FaceColor = 'interp';
            xlim([0 30]);
            ylim([1 k]);
            xlabel('Frequency'); ylabel('Window #');
            cb = colorbar;
            ylabel(cb, 'Amplitude')

            %3d
            % plot3(xMat, yMat, transforms_2, 'b');
            % xlim([0 20]);
            % grid;
            % xlabel('Frequency'); ylabel('Window #'); zlabel('');
            % view(57,44); %Adjust viewing angle so you can clearly see data
            % % CHANGE THIS

            hold off
            if window_name == "Hamming"
                saveas(gcf, plot_names(file_index)+"_"+window_name+"_"+(overlap*100)+".png");
            end
        end
    end
end    
