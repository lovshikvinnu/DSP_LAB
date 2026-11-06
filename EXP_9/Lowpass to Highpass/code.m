clc;
clear all;
close all;
wp=1;
ws=4;
rp=0.1;
rs=40;
[n,wn]=buttord(wp,ws,rp,rs,'s');
[num,den]=butter(n,wn,'low','s')
[h,w]=freqs(num,den);
subplot(2,1,1)
plot(w,mag2db(abs(h)));grid
title('Frequency responce of Butterworth Lowpass filter')
ylabel('Gain in db'); xlabel('Frequency')
axis([0 10 -80 0])
[num1,den1]=lp2hp(num,den,4000);
[h1,w1]=freqs(num1,den1);
subplot(2,1,2)
plot(w1,mag2db(abs(h1)));grid
title('Frequency responce of Converted Butterworth Lowpass to Highpass filter')
ylabel('Gain in db'); xlabel('Frequency')
axis([0 10000 -80 0])
z2=tf(num1,den1);
figure(2)
pzmap(z2)
title('Pole Zero plot of Buttreworth Analog Highpass Filter')
