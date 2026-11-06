clc;
clear all;
close all;
wp=4000;
ws=1000;
rp=0.1;
rs=40;
[n,wn]=buttord(wp,ws,rp,rs,'s');
[num,den]=butter(n,wn,'high','s');
[h1,w1]=freqs(num,den);
figure(1)
plot(w1,20*log10(abs(h1)));grid
title('Butterworth Analog Highpass Filter') 
ylabel('Gain in db'); xlabel('Frequency')
axis([0 10000 -80 0])
z2=tf(num,den);
figure(2)
pzmap(z2)
title('Pole Zero plot of Buttreworth Analog Highpass Filter')
