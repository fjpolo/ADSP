%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
% Minimum phase filter using sinc function
hsinc = sinc(-2:0.4:2);
%hsinc
%-3.8980e-017  
%-1.8921e-001  
%-1.5591e-001  
%2.3387e-001  
%7.5683e-001  
%1.0000e+000  
%7.5683e-001  
%2.3387e-001  
%-1.5591e-001  
%-1.8921e-001  
%-3.8980e-017
%
%Plot
figure(1)
set(gcf,'name','Sinc function')
plot(hsinc)
%Poles and zeros
figure(2)
set(gcf,'name','Poles and zeros')
zplane(hsinc,1)
axis([-1.1 2.1 -1.1 1.1],'equal')
%values
abs(roots(hsinc));
%4.8539e+015
%1.9309e+000
%1.0000e+000
%1.0000e+000
%1.0000e+000
%1.0000e+000
%1.0000e+000
%1.0000e+000
%5.1789e-001
%2.0602e-016
%
%We compute the zeros:
rt = roots(hsinc);
%-4.8539e+015 + 0.0000e+000i
%1.9309e+000 + 0.0000e+000i
%-9.5370e-001 + 3.0077e-001i
%-9.5370e-001 - 3.0077e-001i
%-6.1157e-001 + 7.9119e-001i
%-6.1157e-001 - 7.9119e-001i
%-7.1160e-002 + 9.9746e-001i
%-7.1160e-002 - 9.9746e-001i
%5.1789e-001 + 0.0000e+000i
%-2.0602e-016 + 0.0000e+000i
%
%We see the zero at 1.93 which we need to mirror in. To achieve this, we first 
%take the z-domain polynomial of the impulse response, and cancel that zero by 
%dividing through the polynomial with only that zero, 1−1.93*z−1
[b, r] = deconv (hsinc, [1,-rt(2)]);
%b =
%-3.8980e-017  
%-1.8921e-001  
%-5.2126e-001  
%-7.7264e-001  
%-7.3509e-001  
%-4.1941e-001  
%-5.3021e-002  
%1.3149e-001  
%9.7988e-002  
%4.8430e-007
%
%r =
%0.0000e+000  
%0.0000e+000  
%0.0000e+000  
%-5.5511e-017  
%0.0000e+000  
%0.0000e+000  
%0.0000e+000  
%0.0000e+000  
%0.0000e+000  
%0.0000e+000  
%9.3514e-007
%
%Here, r is the remainder. In our case it is practically zero, which means we can
%ndeed divide our polynomial without any remainder.
%After that we can multiply the obtained polynomial b with the zero inside the unit
%circle, at position 1/1.93, by multiplying it with the polynomial with only that 
%zero:
%1−1/1.93⋅z−1
hsincmp = conv(b,[1,-1/rt(2)']);
%hsincmp =
%-3.8980e-17 
%1.8921e-01 
%-4.2327e-01 
%-5.0269e-01
%-3.3495e-01 
%-3.8715e-02
%1.6418e-01 
%1.5895e-01 
%2.9889e-02 
%-5.0746e-02
%4.6242e-09
%
%This hsincmp is now our minimum phase version of our filter! Now we can take a 
%look at the impulse response:
figure(3)
set(gcf,'name','Minimum phase filters impulse response')
plot(hsincmp)
%Observe that our filter now became non-symmetric, with the main peak at the
%beginning of the impulse response!
%The resulting frequency response is obtained with
figure(4)
set(gcf,'name','Minimum phase filters frequency response')
freqz(hsincmp)
%Now compare the above frequency response of our minimum phase filter with the 
%linear phase version, with 
figure(5)
set(gcf,'name','Linear phase filters frequency response')
freqz(hsinc)