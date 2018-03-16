 %--------------------------------------------------------------------------
 %               DSP Modulations
 %
 %               Polo, Franco
 %
 %               2017
 %
 %               AM - AMplitude Modulation
 %               
 %--------------------------------------------------------------------------
 %
%pkg load control;
%pkg load signal;
clear all;
clc;
close all;
%Modulation Index
m = 0.8;
%Amplitude of madulating signal
Am = 5;
%Frequency of the modulating signal
fa = 2000;
Ta = 1/fa;
%Time vector
t = 0:Ta/999:6*Ta;
%Modulating signal
ym = Am*sin(2*pi*fa*t);
%Plot
figure(1)
subplot(3,1,1);
plot(t,ym)
title('Modulating signal')
%Carrier signal
Ac = Am/m;
fc = fa*10;
Tc = 1/fc;
yc = Ac*sin(2*pi*fc*t);
subplot(3,1,2);
grid on;
plot(t,yc)
title('Carrier signal')
%
% Modulated signal
%
y = Ac+(1+m*sin(2*pi*fa*t)).*sin(2*pi*fc*t);
subplot(3,1,3)
plot(t,y)
title('AM signal')
%
%Frequency response
%
figure(2)
freqz(ym,2048,fa)
figure(3)
freqz(yc,2048,fc)
figure(4)
freqz(y)
