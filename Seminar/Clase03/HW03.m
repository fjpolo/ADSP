 %--------------------------------------------------------------------------
 %               Audio- / Videosignalverarbeitung
 %               TU Ilmenau
 %
 %               Polo, Franco
 %               Ribecky, Sebastian
 %
 %               2014
 %
 %               HW 03
 %               
 %--------------------------------------------------------------------------
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%commandwindow;


% read speech signal 
speech = wavread('speech8kHz.wav');
%*******************************************************************************
%% 1. Upsample the speech signal
%*******************************************************************************
speechUP = upsample(speech,4);
% a) plot the spectra of upsampled and original signal
figure(1)
set(gcf, 'name', 'Frequency response.Original 8[kHz] wave')
title('Speech 8kHz')
freqz(speech);
figure(2)
set(gcf, 'name', 'Frequency response.Upsampled 32[kHz] wave')
title('Speech 32kHz')
freqz(speechUP)

% b) listen to both signals
%sound(speech,8000)
%pause(7);
%sound(speechUP,32000)
%pause(7);

%*******************************************************************************
% 2. FIR lowpass filter
%*******************************************************************************
% a) implement the lowpass
%x(1)= n=0
%x(2)= n=1
%x(3)= n=2
%x(4)= n=3
%x(5)= n=4
n=0:50;
FIR_Filter = [0.3235 0.2665 0.2940 0.2655 0.3235];
% b) plot the impulse response
% ...
%[h,t]=dimpulse(1,FIR_Filter,length(n));  %Me parece q esto no esta bien
uimp = [1,zeros(1,50)];
h = filter (FIR_Filter,1, uimp);
%Plot
figure(3)
set(gcf, 'name', 'FIR impulse response')
stem(n,h)
grid on
title('FIR impulse response');
% c) plot the frequency response
figure(4)
set(gcf, 'name', 'FIR Frequency response')
freqz(h)
title('FIR frequency response');
% d) carry out lowpass filtering on the upsampled signal
speechUP_FIR = filter(FIR_Filter,1,speechUP);
%Plot
figure(5)
set(gcf, 'name', 'FIR filtered, downsampled speech.')
%plot(speechUP_FIR)
freqz(speechUP_FIR)

%Listen
%sound(speech,8000)
%pause(7);
%speechDOWN_FIR= downsample (speechUP_FIR,4);
%sound(speechDOWN_FIR)
%pause(7);
%*******************************************************************************
% 3. IIR lowpass filter
%*******************************************************************************
% a) implement the lowpass
IIR_FilterA = [1 -1.3547 0.6125];
IIR_FilterB = [0.256 0.0512 0.256];
% b) plot the impulse response
%[h2,t2]=dimpulse(IIR_FilterA,IIR_FilterB,length(n));
h2 = filter (IIR_FilterB, IIR_FilterA, uimp);
%Plot
figure(5)
set(gcf, 'name', 'IIR Impulse response')
stem(n,h2)
grid on
title('IIR impulse response');
% c) plot the frequency response
figure (6)
set(gcf, 'name', 'IIR frequency response')
freqz(h2)
title('IIR frequency response');
% d) carry out lowpass filtering on the upsampled signal
speechUP_IIR = filter(IIR_FilterB,IIR_FilterA,speechUP);
figure(7)
set(gcf, 'name', 'IIR filtered, upsampled speech')
freqz(speechUP_IIR)

%Listen
%sound(speech,8000)
%pause(7);
%speechDOWN_IIR= downsample (speechUP_IIR,4);
%sound(speechDOWN_IIR)
%pause(7);
%*******************************************************************************
% 4.  Downsample the speech signal
%*******************************************************************************
% a) filter speech signal with IIR filter
speech_IIR = filter(IIR_FilterB,IIR_FilterA,speech);
% b) downsample the speech signal 
speechDOWN_IIR= downsample(speech_IIR,2);
% c) plot the spectra of downsampled and original signal
figure(8)
set(gcf, 'name', 'Frequency responce.Original 8[kHz] wave')
title('Speech 8kHz')
freqz(speech);
figure(9)
set(gcf, 'name', 'Frequency responce.Downsampled 4[kHz] wave')
title('Speech 4kHz')
freqz(speechDOWN_IIR)

% d) listen to both signals
%sound(speech,8000)
%pause(7);
%sound(speechDOWN_IIR,4000)
%pause(7);

%*******************************************************************************
% 5. Noble Identites
%*******************************************************************************
% a) Reverse the order of upsampling and filtering according to the Noble
%    Identities (only FIR)

%First we separate the FIR filter into its polyphase components
FIR_Filter_p1 = [(FIR_Filter (1)) (FIR_Filter (5))];
FIR_Filter_p2 = FIR_Filter (2);
FIR_Filter_p3 = FIR_Filter (3);
FIR_Filter_p4 = FIR_Filter (4);
%We apply the polyphase components to filter the original signal to obtain
%the polyphased components of the filtered-upsampled signal
speechUP_FIR_p1 = filter (FIR_Filter_p1,1,speech);
speechUP_FIR_p2 = filter (FIR_Filter_p2,1,speech);
speechUP_FIR_p3 = filter (FIR_Filter_p3,1,speech);
speechUP_FIR_p4 = filter (FIR_Filter_p4,1,speech);
%We unite the polyphase components to obtain the final filtered-upsampled signal
L=max(size(speech)); 
speechUP_FIR2 ((1:4:(4*L)),1)= speechUP_FIR_p1;
speechUP_FIR2 ((2:4:(4*L)),1)= speechUP_FIR_p2;
speechUP_FIR2 ((3:4:(4*L)),1)= speechUP_FIR_p3;
speechUP_FIR2 ((4:4:(4*L)),1)= speechUP_FIR_p4;
%We compare both upsampled and FIR-filtered signals (should be the same)
figure(10)
set(gcf, 'name', 'upsampled and FIR-filtered signals')
subplot(2,1,1),
plot(speechUP_FIR)
subplot(2,1,2),
plot(speechUP_FIR2)
figure(11)
set(gcf, 'name', 'Spectra of upsampled and FIR-filtered signal 1')
freqz(speechUP_FIR)
figure(12)
set(gcf, 'name', 'Spectra of upsampled and FIR-filtered signal 2')
freqz(speechUP_FIR2)

%Listen
%sound(speechUP_FIR,32000)
%pause(7);
%sound(speechUP_FIR2,32000)
%pause(7);

%*******************************************************************************
% 6. Compare FIR and IIR lowpass filters
%*******************************************************************************
% --> compare your resulting signals from 2. and 3. 

%FIR filter vs IIR Filter
figure (12)
set(gcf, 'name', 'FIR filter vs IIR Filter')
subplot(2,1,1),
plot(speechUP_FIR)
title('FIR filtered Signal')
subplot(2,1,2),
plot(speechUP_IIR)
title('IIR filtered Signal')
figure(13)
set(gcf, 'name', 'Spectra of FIR-filtered signal')
freqz(speechUP_FIR)
figure(14)
set(gcf, 'name', 'Spectra of IIR-filtered signal')
freqz(speechUP_IIR)

%Listen
sound(speechUP_FIR,32000)
pause(2);
sound(speechUP_IIR,32000)
pause(2);

%The signal filtered with the IIR filter sounds better than the FIR filtered 
%signal, with less distortion.
%If we compare figures 13 and 14, we can see that the signal fitered with the
%FIR filter has a bit of aliasing, that creates the distortion