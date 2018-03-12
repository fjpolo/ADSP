%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%
%
%
%frequency range:
w=(0:0.01:pi);
a=0.5*(1+i)
wyy=(warpingphase(warpingphase(w,a),-a'));
figure(1)
plot(w,wyy)
xlabel('Normalized Frequency')
ylabel('Phase Angle')
%
%
%
%What is the frequency response of an example allpass filter? For a=0.5, we can 
%use freqz.
%Looking at the z-transform we get our coefficient vectors to
a=0.5;
B=[-a' 1];
A=[1 -a];
%observe that for freqz the higher exponents of z^-1 appear to the right
%Now plot the frequency response and impulse response:
figure(2)
freqz(B,A);
%To obtain the impulse response, we can use the function “filter”, and input a 
%unit impulse into it.
Imp=[1,zeros(1,20)];
h=filter(B,A,Imp);
figure(3)
plot(h);
%Here we can see that we have the first, nondelayed, sample not at zero, but at 
%-0.5. This can also be seen by plotting the first 4 elements of our impulse 
%response:
h(1:4);
figure(4)
plot(h(1:4))
%The second element corresponds to the delay of 1 sample, our z−1 , with a 
%factor of 0.75. But then there are more samples, going back into the past, 
%exponentially decaying. This means, not only the past samples goes into our 
%filtering calculation, but also more past samples, and even the non-delayed 
%sample, with a factor of -0.5. This is actually a problem for the so-called
%frequency warping (next section), if we want to use frequency warping in IIR 
%filters, because here we would get delay-less loops, which are difficult to 
%implement! (With FIR filters this is no problem though)