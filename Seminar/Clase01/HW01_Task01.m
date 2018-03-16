%--------------------------------------------------------------------------
%               Audio- / Videosignalverarbeitung
%               TU Ilmenau
%
%               Polo, Franco
%               Ribecky, Sebastian
%
%               2014
%
%               HW 01
%               
%--------------------------------------------------------------------------

pkg load control;
pkg load signal;
clear all;
close all;
%commandwindow;
clc;

%alina.rubina@tu-ilmenau.de
%Helmholtbau, H3522
%Seminar: Sr K 2026 Donn 09.00-10.30


%--------------------------------------------------------------------------
%           Homework assignment 1/3
%           Signals generation
%--------------------------------------------------------------------------

% Frecuencies
f=100;
Fs = f/0.1;

%Time
T =1*(1/f);
dt = 1/Fs;
t = 0:dt:2*T;

%Full range Triangular wave
x1 = sawtooth(2*pi*f*t,0.5);
figure(1)
set(gcf, 'name', 'Waves')
subplot (5,1,1),
plot(t,x1)
title('Full range Triangle wave')

%20db under full range Triangular wave
x2 = 0.1*sawtooth(2*pi*f*t, 0.5);
figure(1)
subplot (5,1,2),
plot(t,x2)
title('20db under full range triangle wave')

%Full range sine wave
y1=sin(2*pi*f*t);
figure(1)
subplot (5,1,3),
plot(t,y1)
title('Full range sine wave')

%20db under full range sine wave
y2=0.1*sin(2*pi*f*t);
figure(1)
subplot (5,1,4),
plot(t,y2)
title('20db under full range sine wave')

%Audio signal
[s, Fs] = wavread('Imperial March_12.wav',150000);
for i=1:150000
    sh(i) = s(i);
end
figure(1)
subplot (5,1,5),
plot(s)
title('Audio signal')

%*****************************************************************
%What is the difference between full and under full range signals?
%*****************************************************************
%SNR is going to change. If we got 90dB of SNR for full range, then
%SNR for under range signal is going to be 70dB (90-20)	


