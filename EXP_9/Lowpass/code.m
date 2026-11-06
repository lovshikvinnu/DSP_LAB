clc;
clear all;
close all;

% Specifications for Lowpass Filter (wp < ws)
wp = 20;          % Passband edge frequency (rad/s)
ws = 30;          % Stopband edge frequency (rad/s)
rp = 0.1;           % Passband ripple in dB
rs = 40;            % Stopband attenuation in dB

% Calculate filter order (n) and cutoff frequency (wn)
[n, wn] = buttord(wp, ws, rp, rs, 's');

% Design analog lowpass Butterworth filter
[num, den] = butter(n, wn, 'low', 's');

% Frequency response
[h1, w1] = freqs(num, den);

% Plot magnitude response
figure(1)
plot(w1, 20*log10(abs(h1))); grid on;
title('Butterworth Analog Lowpass Filter');
ylabel('Gain in dB'); 
xlabel('Frequency (rad/s)');
axis([0 5000 -80 5]);

% Pole-Zero Map
z2 = tf(num, den);
figure(2)
pzmap(z2);
title('Pole-Zero Plot of Butterworth Analog Lowpass Filter');
