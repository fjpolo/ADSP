pkg load control;
pkg load signal;
%
clear all;
clc;
close all;
%
%Plot the Hilbert transformer for n=-10 ..10:
h = zeros(1,20);
n = -9:2:10;
h(n+10) = 2./(pi*n);
%plot
figure(1)
stem(-9:10,h)
%frequency response
figure(2)
freqz(h);
axis([0 1 -180 0])
%
%construct a delayed impulse to implement the delay for the real part:
delt=[zeros(1,9),1,zeros(1,10)];
%Then we need to add our imaginary part as our Hilbert transform to obtain our 
%complex filter:
h = zeros(1,20);
n = -9:2:10;
h(n+10)=2./(pi*n);
hone = delt+j*h;
%hone =
%0.00000 - 0.07074i 
%0.00000 + 0.00000i 
%0.00000 - 0.09095i
%0.00000 + 0.00000i 
%0.00000 - 0.12732i 
%0.00000 + 0.00000i
%0.00000 - 0.21221i 
%0.00000 + 0.00000i 
%0.00000 - 0.63662i
%1.00000 + 0.00000i 
%0.00000 + 0.63662i 
%0.00000 + 0.00000i
%0.00000 + 0.21221i 
%0.00000 + 0.00000i 
%0.00000 + 0.12732i
%0.00000 + 0.00000i 
%0.00000 + 0.09095i 
%0.00000 + 0.00000i
%0.00000 + 0.07074i 
%0.00000 + 0.00000i
figure(3)
freqz(hone,1,128,'whole');
%
% Using REMEZ
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% NO FUNCIONA 
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%b = remez(20,[0 1],[1 1 ],'hilbert');
b = firls(20,[0 1],[1 1], 'hilbert');
figure(4)
freqz(b);
axis([0 1 -180 0]);
%This filter also fullfils the 90 degree phase shift requirement, but seems to 
%have much stronger ripples in the magnitude of the frequency response!
%
%But observe the equi-ripple behaviour in the passband, which is what we expect 
%from remez.
%
%
%
%Let's look at the whole frequency circle again
%Delay for the real part:
delt = [zeros(1,10),1,zeros(1,10)];
%delt =
%0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0
honeremez=delt+j*b