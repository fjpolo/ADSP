%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%Design a warped low pass filter with cutoff frequency of 0.05*pi (pi is the
%Nyquist frequency). This frequency is the end of passband, with frequency 
%warping close to the Bark scale of human hearing.
%First as a comparison: design an unwarped filter with 4 coefficients/taps with 
%these specifications
cunw=remez(3,[0 0.05, 0.05+0.05 1],[1 1 0 0],[1 100])
%cunw =
% 5.1365e-03
% 3.7423e-04
% 3.7423e-04
% 5.1365e-03
%impulse response:
figure(1)
set(gcf,'name','Filter impulse response')
plot(cunw)
%frequency response:
figure(2)
set(gcf,'name','Frequency response')
freqz(cunw,1);
%This is not a good filter. The passband is too wide (up to about 0.15), and 
%there is almost no stopband attenuation (in the range of 0.5 to 0.9). So this 
%filter is probably useless for our application.
%
%Now design the FIR low pass filter (4th order), which we then want to frequency 
%warp in the next step, with a warped cutoff frequency. First we have to compute 
%the allpass coefficient „a“ for our allpass filter which results in an
%approximate Bark warping, according to:
%
% alfa = {1,0674*{(2/Pi)*arctg[0,6583*f_s]}^0,5}-0,1916
%
%with f_s being the sample frequency in kHz
%Our warped design is then:
%warping allpass coefficient:
a=1.0674*(2/pi*atan(0.6583*32))^0.5 -0.1916
%ans = 0.85956
%with f_s=32 in kHz
%The warped cutoff frequency then is:
fcw=-warpingphase(0.05*pi,0.85956)
%fcw = 1.6120 in radiants
%filter design:
%cutoff frequency normalized to nyquist:
fcny=fcw/pi
%fcny = 0.51312
c=remez(3,[0 fcny, fcny+0.2 1],[1 1 0 0],[1 100]);
%The resulting Impulse Response:
figure(3)
set(gcf,'name','Soon-to-be warped filter impulse response')
plot(c);
%The resulting Frequency response:
figure(4)
set(gcf,'name','Soon-to-be warped filter frequency response')
freqz(c,1);
%Here we can see that in the warped domain, we obtain a reasonable low pass 
%filter. In the passband from 0 to somewhat above 0.5 it has a drop of about 
%10 dB, and in the stopband we obtain about -30 dB attenuation, which is
%much more than before (it might still not be enough for practical purposes though)
%
%Replace Delays in FIR filter with Allpass filter (in this way we go from 
%frequency response H(z) to H(A(z)):
%
%Warping Allpass filters:
B=[-a' 1];
A=[1 -a];
%Impulse with 80 zeros:
Imp=[1,zeros(1,80)];
x=Imp;
%Y1(z)=A(z), Y2(z)=A^2(z),...
%Warped delays:
y1=filter(B,A,x);
y2=filter(B,A,y1);
y3=filter(B,A,y2);
%Output of warped filter with impulse as input:
yout=c(1)*x+c(2)*y1+c(3)*y2+c(4)*y3;
%Impulse response:
figure(5);
set(gcf,'name','Warped filter impulse response')
plot(yout);
%This is the resulting impulse response of our warped filter. What is most 
%obvious is its length. Instead of just 4 samples, as our original unwarped 
%design, it easily reaches 80 significant samples, and in principle is infinite 
%in extend. This is also what makes it a much better filter than the unwarped
%original design!
%
%frequency response:
figure(6)
set(gcf,'name','Warped filter frequency response')
freqz(yout,1);
%Here we can now see the frequency response of our final warped low pass filter.
%We can see that again we have a drop of about 10 dB in the passband, now from 0
%to 0.05pi, and a stopband attenuation of about 30dB, which is somewhat
%reasonable.