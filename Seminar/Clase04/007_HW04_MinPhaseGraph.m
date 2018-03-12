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
% Complete with block-up
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
W = [1 100];
% FIR Filter
hmin=remez((Coef-1),F,A,W);
% uimp
uimp = uimp = [1,zeros(1,50)];
%Filter
hmin_filtered = filter (hmin,1, uimp);
% Plot impulse response
figure(4)
set(gcf, 'name', 'FIR Impulse respone')
plot(hmin_filtered)
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



%*******************************************************************************
%
%  3. Listen to and compare signals before and after upsampling and filtering
%
%*******************************************************************************
%Listen to original speech
%sound(speech, 8000)
%pause(2)
%Listen to upsampled speech
%sound(speech_up, 32000)
%pause(2)
%Filter original speech
%sound(yu, 32000)
%pause(2)



%*******************************************************************************
%
%  4. Design a frequency warped filter with the following parameters:
%     –Sampling frequency: 44.1 kHz
%     –Cutoff frequency: 0.15*pi
%     –No. of filter coefficients: 6
%
%*******************************************************************************
%
%Number of coefficients
coeff = 6;
%Sample frequency
f_s = 44.1;
%Warping allpass coefficient:
a = 1.0674*(2/pi*atan(0.6583*f_s))^0.5 -0.1916;         %a =  0.86404
%The warped cutoff frequency then is:
f_cw=-warpingphase(0.05*pi,a);                          %f_cw =  1.6467
%
%Filter design
%
%cutoff frequency normalized to nyquist:
%f_cny=f_cw/pi;                                          %f_cny =  0.52418
f_cny = 0.15*pi;                                         %f_cny =  0.47124           
%Filter coefficient
c = remez((coeff-1),[0 f_cny, f_cny+0.2 1],[1 1 0 0],[1 100]);
%Replace Delays in FIR filter with Allpass filter (in this way we go from 
%frequency response H(z) to H(A(z)):
%
%Warping Allpass filters:
B = [-a' 1];
A = [1 -a];
%Impulse with 80 zeros:
Imp = [1,zeros(1,80)];
x = Imp;
%Y1(z)=A(z), Y2(z)=A^2(z),...
%Warped delays:
y1 = filter(B,A,x);
y2 = filter(B,A,y1);
y3 = filter(B,A,y2);
%Output of warped filter with impulse as input:
yout = c(1)*x+c(2)*y1+c(3)*y2+c(4)*y3;


%*******************************************************************************
%
%  5. Plot the filter‘s:
%     a)impulse response
%     b)frequency response
%     c)z-plane (poles,zeroes)
%
%*******************************************************************************
%
%Impulse response
figure(7)
set(gcf,'name','Warped filter impulse response')
plot(yout);
%Frequency response
figure(8)
set(gcf,'name','Warped filter frequency response')
freqz(yout);
%Poles and zeros
figure(9)
set(gcf,'name','Poles and Zeros')
zplane(B,A);
axis([-1.1 2.1 -1.1 1.1],'equal')


%*******************************************************************************
%
%  6. Implement the minimum phase version of a linear phase filter
%       – Create a FIR filter with the help of remez() function with the passband 
%       of 0,25
%       – Make the minimum phase version out of it
%
%*******************************************************************************
%
N_minph=16;
F_minph=[0 0.25 0.3 1];
A_minph=[1 1 0 0];
W_minph= [1 100];
% Coefficients
hmin_minph = remez(N_minph,F_minph,A_minph,W_minph);
% Zeros
rt_minph = roots(hmin_minph);
% Absolute
rt_minph_abs = abs(roots(hmin_minph));
% Divide by 3.06133
[b, r] = deconv (hmin_minph, [1,-hmin_minph(1)]);
hmincmp = conv(b,[1,-1/hmin_minph(1)']);



%*******************************************************************************
%
%  7. Plot the minimum phase filter‘s:
%     a) impulse response
%     b) frequency response
%     c) z-plane
%
%*******************************************************************************
figure(10)
set(gcf,'name','Minimum phase filters impulse response')
plot(hmincmp)
%Observe that our filter now became non-symmetric, with the main peak at the
%beginning of the impulse response!
%The resulting frequency response is obtained with
figure(11)
set(gcf,'name','Minimum phase filters frequency response')
freqz(hmincmp)
%Now compare the above frequency response of our minimum phase filter with the 
%linear phase version, with 
figure(12)
set(gcf,'name','Zeros and Poles')
zplane(hmin_minph,1)
axis([-1.1 2.1 -1.1 1.1],'equal')