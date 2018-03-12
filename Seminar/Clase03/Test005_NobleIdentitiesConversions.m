%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%
%Down-sample an audio signal. First read in the audio signal into the variable x:
x = wavread('speech8kHz.wav');

%Listen to it as a comparison:
%sound(x,8000);

%Take a low pass FIR filter with impulse response
h = [0.5 1 1.1 0.6];
%Downsampling factor
N = 2;
%Polyphase components in time domain:
h0 = [0.5 1.1]
h1 = [1 0.6]
%Produce the 2 phases of a down-sampled input signal x:
x0 = x(1:2:end);
x1 = x(2:2:end);
%The filtered and down-sampled output y is:
y = filter(h0,1,x0) + filter(h1,1,x1);
%Observe that each of these 2 filters now works on a down-sampled signal, but the 
%result is identical to first filtering and then downsampling. 

figure(1)
set(gcf, 'name', 'Noble identites')
subplot(3,1,1)
plot(x)
title('Input signal')
subplot(3,1,2)
plot(y)
title('Output signal')

%Now listen to the resulting down-sampled signal:
%sound(y,4000);


%
%Up-sample the signal x by a factor of N=2 and low-pass filter it with the 
%filter 
h=[0.5 1 1 0.5];
%as in the previous example. Again we obtain the filters polyphase components as:
h0=[0.5 1];
h1=[1 0.5];
%Now we can use these polyphase components to filter at the lower sampling rate 
%to obtain the polyphase components of the filtered and upsampled signal y0 and y1:
y0=filter(h0,1,y);
y1=filter(h1,1,y);
%The complete up-sampling the signal is then obtained from its 2 polyphase 
%components, performing our de-blocking
L=max(size(y));
yu(1:2:(2*L))=y0;
yu(2:2:(2*L))=y1;
% Where now the signal yu is the same as if we had first up-sampled and then 
%filtered the signal!
figure(1)
subplot(3,1,3)
plot(yu)
title('Output signal')

%Now listen to the up-sampled signal:
%sound(yu,8000);