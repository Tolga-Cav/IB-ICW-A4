figure
hold on

plot(t,window_1,t,data_ch2)
title('Time-domain plot')
xlabel('Time (seconds)')
ylabel('Signal (volts)')
legend('Generated Signal','Channel 1','Channel 2')

hold off
