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


%*******************************************************************************
%
%  2. Design filter for the anti-alias-filtering
%       –FIR with 32 filter coefficients
%       –Use: Parks-McClellan-Algorithm (remez filter design function)
%       –Plot impulse and frequency response
%
%     Reasonable filter design, i.e. consider:
%       •passband, stopband, transition band
%       •stopband attenuation
%       •weights
%       •normalization of frequency
%       •stopband should start where aliasing components appear
%
%*******************************************************************************
%Filter coefficients
Coef = 32;
%Band edges for passs, transition and stop
F=[0 0.25 0.3 1];
%Amplitude at given edges
A=[1 1 0 0];
%Weights
W= [1 100];
% FIR Filter
hmin=remez((Coef-1),F,A,W);
% uimp
uimp = uimp = [1,zeros(1,50)];
%Filter
hmin_filtered = filter (hmin,1, uimp);
% Plot impulse response
figure(4)
set(gcf, 'name', 'FIR Impulse respone')
stem(hmin_filtered)
figure(5)
set(gcf, 'name', 'FIR Frequency response')
freqz(hmin)

%
% NOBLE IDENTITIES 
%
%Polyphase components
h0 = hmin(1:N:length(hmin));
h1 = hmin(2:N:length(hmin));
h2 = hmin(3:N:length(hmin));
h3 = hmin(4:N:length(hmin));
% Filter
y0 = filter(h0,1,speech);
y1 = filter(h1,1,speech);
y2 = filter(h2,1,speech);
y3 = filter(h3,1,speech);
%The complete up-sampling the signal is then obtained from its 4 polyphase 
%components, performing our de-blocking
L=max(size(speech));
yu(1:4:(4*L))=y0;
yu(2:4:(4*L))=y1;
yu(3:4:(4*L))=y2;
yu(4:4:(4*L))=y3;
%Plot
figure(6)
set(gcf,'name', 'Filtered signal')
freqz(yu)


