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
b = firls(20,[0 1],[1 1], [1], 'hilbert');
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
honeremez = delt+j*b;
% Ver valores
figure(5)
freqz(honeremez,1,128,'whole');
%Here we can see that we have less attenuation as before (only about -10 dB 
%in the stopband compared to the pass band!), more ripples in the passband,
%but we also have a narrower transition band at the high and low frequency 
%end of the spectrum, compared to the previous filter! Also again observe 
%the equi-ripple behaviour in the pass band and also the stop band. 
%Probably we obtain more practical filters, if we change the corner 
%frequecies to slightly above 0 and slightly below 1.
%
%
%
%We can now test our application example of measuring the Amplitude of a 
%sinusoid with our Hilbert transform design. We saw that the lower end for the 
%passband of our design is at normalized frequency of about 0.05. Hence we
%test a sinusoid of that frequency,
x = 2*sin(pi*0.05*(0:39));
figure(6)
plot(x)
%Now we can filter it with our filter which passes only positive frequencies â€œhoneâ€?,
xhone = conv(x,hone);
figure(7)
plot(real(xhone))
hold
plot(imag(xhone),'r')
%Here we can see that we get indeed a 90 degree phase shifted version, the 
%red curve, about between sample 15 and 45.
%
%Now we can compute the magnitude of this complex signal “xhone” to obtain 
%the amplitude of our sinusoidal signal,
hold off
figure(8)
plot(abs(xhone))
%We see that between about sample 15 and 45 we obtain the amplitude of our 
%sinusoidal signal with about 10% accuracy, which roughly corresponds to 
%the -20dB attenuation (corresponding to an attenuation factor of 0.1)
%that our filter “hone” provides. This also hints at the fact that we can 
%improve the magnitude estimation by having a filter with a higher
%attenuation at negative frequencies.