 %--------------------------------------------------------------------------
 %               Audio- / Videosignalverarbeitung
 %               TU Ilmenau
 %
 %               Polo, Franco
 %               Ribecky, Sebastian
 %
 %               2014
 %
 %               HW 03
 %               
 %--------------------------------------------------------------------------
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%commandwindow;


% read speech signal 
speech = wavread('speech8kHz.wav');
%*******************************************************************************
%% 1. Upsample the speech signal
%*******************************************************************************
speechUP = upsample(speech,4);
% a) plot the spectra of upsampled and original signal
figure(1)
set(gcf, 'name', 'Frequency response.Original 8[kHz] wave')
title('Speech 8kHz')
freqz(speech);
figure(2)
set(gcf, 'name', 'Frequency response.Upsampled 32[kHz] wave')
title('Speech 32kHz')
freqz(speechUP)

% b) listen to both signals
%sound(speech,8000)
%pause(7);
%sound(speechUP,32000)
%pause(7);

%*******************************************************************************
% 2. FIR lowpass filter
%*******************************************************************************
% a) implement the lowpass
%x(1)= n=0
%x(2)= n=1
%x(3)= n=2
%x(4)= n=3
%x(5)= n=4
n=0:50;
FIR_Filter = [0.3235 0.2665 0.2940 0.2655 0.3235];
% b) plot the impulse response
% ...
%[h,t]=dimpulse(1,FIR_Filter,length(n));  %Me parece q esto no esta bien
uimp = [1,zeros(1,50)];
h = filter (FIR_Filter,1, uimp);
%Plot
figure(3)
set(gcf, 'name', 'FIR impulse response')
stem(n,h)
grid on
title('FIR impulse response');
% c) plot the frequency response
figure(4)
set(gcf, 'name', 'FIR Frequency response')
freqz(h)
title('FIR frequency response');
% d) carry out lowpass filtering on the upsampled signal
speechUP_FIR = filter(FIR_Filter,1,speechUP);
%Plot
figure(5)
set(gcf, 'name', 'FIR filtered, downsampled speech.')
%plot(speechUP_FIR)
freqz(speechUP_FIR)

%Listen
sound(speech,8000)
pause(7);
speechDOWN_FIR= downsample (speechUP_FIR,4);
sound(speechDOWN_FIR)
pause(7);

