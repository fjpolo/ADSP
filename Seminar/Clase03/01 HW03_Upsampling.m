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
sound(speech,8000)
pause(7);
sound(speechUP,32000)
pause(7);
