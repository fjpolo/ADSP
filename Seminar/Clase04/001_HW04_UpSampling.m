 %--------------------------------------------------------------------------
 %               Audio- / Videosignalverarbeitung
 %               TU Ilmenau
 %
 %               Polo, Franco
 %               Ribecky, Sebastian
 %
 %               2014
 %
 %               HW 04
 %               
 %--------------------------------------------------------------------------
 %
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%Read speech signal 
speech = wavread('speech8kHz.wav');
%*******************************************************************************
%  1. Upsample the speech signal by the factor of N = 4, using Noble identities 
%  (polyphase decomposition)
%*******************************************************************************
%Upsampling factor
N = 4;
%Simple average filter
B=[1,1];
%
%
% HACER CON NOBLE IDENTITIES
%
%
%Allpass filter
h_ap = 1;
%Filter speech
speech0 = filter(h_ap,1,speech);
speech1 = filter(h_ap,1,speech);
speech2 = filter(h_ap,1,speech);
speech3 = filter(h_ap,1,speech);
%Upsample
L_up  = max(size(speech));
% Complete with block-70up
speech_up(1:4:(4*L_up))=speech0;
speech_up(2:4:(4*L_up))=speech1;
speech_up(3:4:(4*L_up))=speech2;
speech_up(4:4:(4*L_up))=speech3;
%Upsample
%speechUP = upsample(speech,N);
% Plot
figure(1)
set(gcf,'name', 'Time response')
subplot(2,1,1)
plot(speech);
title('Speech original')
subplot(2,1,2)
plot(speech_up)
title('Speech upsampled')
%Frequency plot
figure(2)
set(gcf,'name', 'Frequency response original speech')
freqz(speech)
%Upsampled
figure(3)
set(gcf,'name', 'Frequency response upsampled speech')
freqz(speech_up)


