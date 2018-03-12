%--------------------------------------------------------------------------
%               Audio- / Videosignalverarbeitung
%               TU Ilmenau
%
%               Polo, Franco
%               Ribecky, Sebastian
%
%               2014
%
%               HW 01
%               
%--------------------------------------------------------------------------

clear all;
close all;
commandwindow;
clc;

%alina.rubina@tu-ilmenau.de
%Helmholtbau, H3522
%Seminar: Sr K 2026 Donn 09.00-10.30


%--------------------------------------------------------------------------
%           Homework assignment 1/3
%           Signals generation
%--------------------------------------------------------------------------

f=100;
T =1*(1/f);
Fs = f/0.1;
%Fn=f/Fs=0.1;
dt = 1/Fs;
t = 0:dt:2*T;

%Full range Triangle wave
x1 = sawtooth(2*pi*f*t,0.5);
figure(1)
set(gcf, 'name', 'Waves')
subplot (5,1,1),
plot(t,x1)
title('Full range Triangle wave')

%20db under full range triangle wave
x2 = 0.1*sawtooth(2*pi*f*t, 0.5);
figure(1)
subplot (5,1,2),
plot(t,x2)
axis ([0,(2*T),-1,1])
title('20db under full range triangle wave')

%Full range sine wave
y1=sin(2*pi*f*t);
figure(1)
subplot (5,1,3),
plot(t,y1)
title('Full range sine wave')

%20db under full range sine wave
y2=0.1*sin(2*pi*f*t);
figure(1)
subplot (5,1,4),
plot(t,y2)
axis ([0,(2*T),-1,1])
title('20db under full range sine wave')

%Audio signal
[s, Fs] = wavread('Imperial March_12.wav');
for i=1:75000
    sh(i) = s(i);
end
figure(1)
subplot (5,1,5),
plot(s),axis tight,grid on
title('Audio signal')


%What is the difference between full and under full range signals?
%Less Amplitude (?)

%--------------------------------------------------------------------------
%           Homework assignment 2/3
%           Quantization and reconstruction
%--------------------------------------------------------------------------

%stepsize
q = (1-(-1))/(2^8);

%16 bit mid-rise quantizer

%quantized full range triangle wave
xq1a = floor (x1/q);

%decodified signal
x1a = xq1a*q;
figure(2)
set(gcf, 'name', 'Mid-Rise quantization')
subplot(5,1,1),
plot(t,x1a)
title('Dequantized full range triangle wave')
%quantization error
qex1a = x1a-x1;

%quantized 20dB below full range triangle wave
xq2a = floor (x2/q);

%decodified signal
x2a = xq2a*q;
figure(2)
subplot(5,1,2),
plot(t,x2a)
title('Dequantized 20dB below full range triangle wave')
%quantization error
qex2a = x2a-x2;

%quantized full range sine wave
yq1a = floor (y1/q);

%decodified signal
y1a = yq1a*q;
figure(2)
subplot(5,1,3),
plot(t,y1a)
title('Dequantized full range sine wave')
%quantization error
qey1a = y1a-y1;

%quantized 20dB below full range sine wave
yq2a = floor (y2/q);

%decodified signal
y2a = yq2a*q;
figure(2)
subplot(5,1,4),
plot(t,y2a)
title('Dequantized 20dB below full range sine wave')
%quantization error
qey2a = y2a-y2;

%quantized audio signal
sqa = floor (s/q);

%decodified signal
sa = sqa*q;
figure(2)
subplot(5,1,5),
plot(sa)
title('Dequantized audio signal')
%quantization error
qesa = sqa-s;



%16 bit mid-tread quantizer

%quantized full range triangle wave
xq1b = round (x1/q);

%decodified signal
x1b = xq1b*q;
figure(3)
set(gcf, 'name', 'Mid-Tread')
subplot(5,1,1),
plot(t,x1b)
title('Dequantized full range triangle wave')
%quantization error
qex1b = x1b-x1;

%quantized 20dB below full range triangle wave
xq2b = round (x2/q);
xq1b = round (x1/q);

%decodified signal
x2b = xq2b*q;
figure(3)
subplot(5,1,2),
plot(t,x2b)
title('Dequantized 20dB below full range triangle wave')
%quantization error
qex2b = x2b-x2;

%quantized full range sine wave
yq1b = round (y1/q);
xq1b = round (x1/q);

%decodified signal
y1b = yq1b*q;
figure(3)
subplot(5,1,3),
plot(t,y1b)
title('Dequantized full range sine wave')
%quantization error
qey1b = y1b-y1;

%quantized 20dB below full range sine wave
yq2b = round (y2/q);
xq1b = round (x1/q);

%decodified signal
y2b = yq2b*q;
figure(3)
subplot(5,1,4),
plot(t,y2b)
title('Dequantized 20dB below full range sine wave')
%quantization error
qey2b = y2b-y2;

%quantized audio signal
sqb = round (s/q);
xq1b = round (x1/q);
%decodified signal
sb = sqb*q;
figure(3)
subplot(5,1,5),
plot(sb)
title('Dequantized audio signal')
%quantization error
qesb = sqb-s;



%Which quantization is better and why?
%The mid-rise can be seen as more accurate, because very small values are always quantized to half the
%quantization interval, so it reacts to very small input values, but the mid-tread can save bit-rate 
%because it always quantizes very small values to zero. 
%The expectation of the quantization error power for large signals stays the same for both types.



%uLaw quantization

A=1;
mu=255;

%Full range triangular wave
for i=1:length(x1)
   if x1(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   x1u(i)= sign (i)*((log(1+(255*abs(x1(i)/max(x1)))))/(log(1+255)));
  
end

index = round((2^8)*x1u);
x1ud = index / (2^8);

for i=1:length(x1)
   if x1(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   x1_mu (i)= sign(i)*((256^(abs(x1ud(i))))-1)*(max(x1)/255);
  
end

figure(4)
set(gcf, 'name', 'uLaw')
subplot(5,1,1),
plot(t,x1_mu)
title('De-Quantized full range triangle wave')

%20db under full range triangular wave
for i=1:length(x2)
   if x2(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   x2u(i)= sign (i)*((log(1+(255*abs(x2(i)/max(x2)))))/(log(1+255)));
  
end

index = round((2^8)*x2u);
x2ud = index/(2^8);

for i=1:length(x2)
   if x1(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   x2_mu (i)= sign(i)*((256^(abs(x2ud(i))))-1)*(max(x2)/255);
  
end

figure(4)
subplot(5,1,2),
plot(t,x2_mu)
title('De-Quantized 20 under full range triangle wave')

%Full range sine wave
for i=1:length(y1)
   if y1(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   y1u(i)= sign (i)*((log(1+(255*abs(y1(i)/max(y1)))))/(log(1+255)));
  
end

index = round((2^8)*y1u);
y1ud = index / (2^8);

for i=1:length(y1)
   if y1(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   y1_mu (i)= sign(i)*((256^(abs(y1ud(i))))-1)*(max(y1)/255);
  
end

figure(4)
set(gcf, 'name', 'uLaw')
subplot(5,1,3),
plot(t,y1_mu)
title('De-Quantized full range sine wave')


%20db under full range triangular wave
for i=1:length(y2)
   if y2(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   y2u(i)= sign (i)*((log(1+(255*abs(y2(i)/max(y2)))))/(log(1+255)));
  
end

index = round((2^8)*y2u);
y2ud = index/(2^8);

for i=1:length(y2)
   if y2(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   y2_mu (i)= sign(i)*((256^(abs(y2ud(i))))-1)*(max(y2)/255);
  
end

figure(4)
subplot(5,1,4),
plot(t,y2_mu)
title('De-Quantized 20 under full range sine wave')


%Audio
for i=1:length(sh)
   if sh(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   shu(i)= sign (i)*((log(1+(255*abs(sh(i)/max(sh)))))/(log(1+255)));
  
end

index = round((2^8)*shu);
shud = index/(2^8);

for i=1:length(sh)
   if sh(i) >= 0
    sign (i) = 1;
   else sign (i)= -1;
   end
   
   sh_mu (i)= sign(i)*((256^(abs(shud(i))))-1)*(max(sh)/255);
  
end

figure(4)
subplot(5,1,5),
plot(sh_mu)
title('De-Quantized audio wave')




%SNR for all Signals

%Mid-rise

%Full range triangular wave mid-rise
SNRx1a_db = 10*log((var(x1))/(var(qex1a)));

%20dB under full range triangular wave mid-rise
SNRx2a_db = 10*log((var(x2))/(var(qex2a)));

%Full range sine wave mid-rise
SNRy1a_db = 10*log((var(y1))/(var(qey1a)));

%20dB under full range sine wave mid-rise
SNRy2a_db = 10*log((var(y2))/(var(qey2a)));

%Audio mid-rise
SNRsa_db = 10*log((var(sa))/(var(qesa)));

%Mid-tread

%Full range triangular wave mid-tread
SNRx1b_db = 10*log((var(x1))/(var(qex1b)));

%20dB under full range triangular wave mid-tread
SNRx2b_db = 10*log((var(x2))/(var(qex2b)));

%Full range sine wave mid-tread
SNRy1b_db = 10*log((var(y1))/(var(qey1b)));

%20dB under full range sine wave mid-tread
SNRy2b_db = 10*log((var(y2))/(var(qey2b)));

%Audio mid-tread
SNRsb_db = 10*log((var(sb))/(var(qesb)));

%uLaw quantization

%Full range triangular wave
qex1u = x1_mu-x1;
SNRx1u_db = 10*log((var(x1))/(var(qex1u)));

%20dB under full range triangular wave
qex2u = x2_mu-x2;
SNRx2u_db = 10*log((var(x2))/(var(qex2u)));

%Full range sine wave
qey1u = y1_mu-y1;
SNRy1u_db = 10*log((var(y1))/(var(qey1u)));

%20dB under full range sine wave
qey2u = y2_mu-y2;
SNRy2u_db = 10*log((var(y2))/(var(qey2u)));

%Audio wave
qesu = sh_mu-sh;
SNRsu_db = 10*log((var(s))/(var(qesu)))