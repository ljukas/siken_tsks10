clc;clear;close all;

% Read signal
[signal, fs] = audioread('signal-extra025.wav');
L = length(signal);

% Transform
freq_axis = fs/2*linspace(0, 1, L/2);
Y = fft(signal);

% Plot carrier frequencies
plot(freq_axis, abs(Y(1:L/2)));
title('Amp Spectrum');
xlabel('frequency (Hz)');
ylabel('magnitude (abs)');
pause;

% Carrier frequencies:
% 36, 83, 111, 150
% Now need to check what each of the signals contains
bandwidth = 20000;
fc1 = 36000;
fc2 = 83000;
fc3 = 111000;
fc4 = 150000;
t_axis = linspace(0, 19.5, L);


[B, A] = butter(10, [fc1 - bandwidth/2, fc1 + bandwidth/2]/(fs/2));
y1 = filter(B, A, signal);
[B, A] = butter(10, [fc2 - bandwidth/2, fc2 + bandwidth/2]/(fs/2));
y2 = filter(B, A, signal);
[B, A] = butter(10, [fc3 - bandwidth/2, fc3 + bandwidth/2]/(fs/2));
y3 = filter(B, A, signal);
[B, A] = butter(10, [fc4 - bandwidth/2, fc4 + bandwidth/2]/(fs/2));
y4 = filter(B, A, signal);

subplot(4, 1, 1);
plot(t_axis, y1);
title(['fc = ' num2str(fc1) 'Hz']);
subplot(4, 1, 2);
plot(t_axis, y2);
title(['fc = ' num2str(fc2) 'Hz']);
subplot(4, 1, 3);
plot(t_axis, y3);
title(['fc = ' num2str(fc3) 'Hz']);
subplot(4, 1, 4 );
plot(t_axis, y4);
title(['fc = ' num2str(fc4) 'Hz']);
pause;

% We can see that y1 contains two seperate halves of something
% whilst all other contain constant noice. Therefore our sought
% after fc is fc1 => 36000 hz

% I will use xcorr to get the time delay
[corr, lags] = xcorr(y1);
corr = corr(lags > 0);
lags = lags(lags > 0);
subplot(1, 1, 1);
plot(lags/fs, corr);
xlabel('time (s)');
title('Cross correlation');
pause;

% Plot gives us a time difference of 0.37s or 370ms
tau = 0.37;
delaySamples = (tau*fs); % Delay in samples

% Echo cancelate
y = zeros(size(y1));
y(1:delaySamples) = y1(1:delaySamples);

for i = (delaySamples+1:length(y1))
    y(i) = y1(i) - 0.9*y(i - delaySamples);
end

[corr, lags] = xcorr(y);
corr = corr(lags > 0);
lags = lags(lags > 0);
subplot(1, 1, 1);
plot(lags/fs, corr);
xlabel('time (s)');
title('Cross correlation echo fixed');
pause;

%%
% I-komponent
i_c = cos(2*pi*fc1*t_axis + 0.8)';
x_i = 2*y.*i_c;

f_xi = fft(x_i);
plot(freq_axis, abs(f_xi(1:L/2)))
xlabel('Frekvens');

%% MÅSTE FILTREAR BORT DEN HÖGA HÄR

%%
[B, A] = butter(10, 40000/(fs/2), 'low');
yi = filter(B, A, x_i);
i = decimate(yi, 4);
soundsc(i)
pause; 
clear sound;


%%
y_i = filter(B, A, 2*y.*i_carrier);

% play it
i = decimate(y_i, 4);
q = decimate(y_q, 4);
soundsc(i, fs/4);
pause;



