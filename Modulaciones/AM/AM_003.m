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
%Read WAV
[speech, f_speech] = wavread('speech.wav');
%
index = 1:length(speech);
%
fc = 5;
A = 0.8;
ph = 0;
%
%trem = (ph*pi/180 + A * sin(2*pi*index*(fc/f_speech)));
trem = (1 + A * sin(2*pi*index*(fc/f_speech)));
trem2 = trem.';
%
speechAM = speech .* trem2;
%
%
% PLOT
%
figure(1)
subplot(3,1,1)
plot(speech)
subplot(3,1,2)
plot(trem2)
subplot(3,1,3)
plot(speechAM)
%Sound modulated signal
%sound(speechAM,f_speech)
%Frequency response
figure(2)
freqz(speechAM,1,2048,f_speech)