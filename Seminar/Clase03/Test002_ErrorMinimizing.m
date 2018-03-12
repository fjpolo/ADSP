%For FIR linear phase filters, Matlab and Octave have a specialized optimization
%in the function “firpm”, or “remez” which implements the so-called 
%Parks-McLellan algorithm, using the Chebyshev algorithm (see also the Book:
%Oppenheim, Schafer: “Discrete-Time Signal Processing”, Prentice Hall) .
%
%This is now also an example of the minimax error function. The algorithm 
%minimizes the maximum error in the pass band and the stop band (weighted in 
%comparison between the two), which leads to a so-called equi-ripple behaviour
%(all ripples have the same hight in the same band, e.g. stop band or pass band)
%of the filter in the frequency domain.
%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
% Example
N=7;
F=[0 0.4 0.5 1];
A=[1 1 0 0];
W= [1 100];
%We call
%hmin=firpm(N,F,A,W)
%or
hmin=remez(N,F,A,W)
%Now we obtain a nice impulse response or set
%of coefficients hmin:
figure(1)
plot(hmin)
figure(2)
freqz(hmin)
