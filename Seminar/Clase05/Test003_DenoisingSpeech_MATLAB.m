%
clear all;
clc;
close all;
%
x = wavread('speech.wav');
sound(x,8000);
pause
%additive zero mean white noise (for-1<x<1):
y=x+0.1*(rand(size(x))-0.5); %column vector
size(y);
sound(y,8000);
pause
%we assume 10 coefficients for our Wiener filter.
%10 to 12 is a good number for speech signals.
A=zeros(60000,10);
for m=1:60000,
A(m,:)=y((m-1)+(1:10))';
end;
%Our matrix has 60000 rows and 10 colums:
size(A)
%ans =
%60000 10
%Compute Wiener Filter:
%Trick: allow (flipped) filter delay of 5
%samples to get better working denoising.
%The desired signal hence is x(6:100005):
h=inv(A'*A) * A' * x(6:60005)
figure(1)
plot(flipud(h))
%Observe that for this non-flipped impulse response we see a delay of 4 
%samples, since the first sample corresponds to a delay of zero, and the 
%location of biggest sample, which corresponds to the signal delay, is at 
%delay 5-1=4.
%Its frequency response is
figure(2)
freqz(flipud(h))
%Here we can see that the resulting filter has a somewhat low pass 
%characteristic, because our speech signal has energy mostly at low
%frequencies. At high frequencies we have mostly noise, hence it makes 
%sense to have more attenuation there! This attenuation curve of this 
%Wiener filter also has some similarity to the speech spectrum on can 
%observe with freqz(x). If we look at the spectrum of the white noise with 
%freqz(0.1*(rand(size(x))-0.5)), then we see that at low frequencies speech 
%is dominating, and at high frequencies, noise is dominating, and we need 
%to remove or attenuate that latter part of the spectrum.
%We can plot the spectra of the speech and the noise together with:
Hspeech=freqz(x);
Hnoise=freqz(0.1*(rand(size(x))-0.5));
Hw=freqz(flipud(h));
plot((0:511)/512,20*log10(abs(Hspeech)));
hold
plot((0:511)/512,20*log10(abs(Hnoise)),'r');
plot((0:511)/512,20*log10(abs(Hw)),'g');
%The speech spectrum is blue, the noise spectrum is red, and as a comparison 
%the Wiener filter transfer function is green. Here we see that speech 
%dominates the spectrum only at low and middle frequencies, noise at the 
%other frequencies, hence it makes sense to suppress those noisy frequencies.
%Now we can filter and listen to it:
xw=filter(flipud(h),1,y);
sound(xw,8000)
pause
%We can hear that the signal now sounds more “muffled”, the higher 
%frequencies are indeed attenuated, which reduces the influence of the
%noise. But it is still a question if it actually “sounds” better to the 
%human ear.
%Let's compare the mean quadratic error. For the noisy signal it is:
size(x)
%ans = 
%60246           1
sum((y(1:60000)-x(1:60000)).^ 2)/60000;
%ans =
%8.2989e-04
%
%For the Wiener filtered signal it is (taking into account 4 samples delay 
%from our filter (5 from the end from flipping), beginning to peak).
sum((xw(4+(1:60000))-x(1:60000)).^2)/60000
%ans =
%2.8890e-04
%Let's take a look at the matrix A^T?A which we used in the computation:
A'*A
%ans =
%  388.9709  321.1624  281.9605  236.0617  183.5587  124.9089   61.7309    3.2452  -42.2186  -78.4340
%  321.1624  388.9710  321.1634  281.9606  236.0619  183.5585  124.9104   61.7307    3.2451  -42.2185
%  281.9605  321.1634  388.9724  321.1652  281.9590  236.0600  183.5600  124.9098   61.7293    3.2467
%  236.0617  281.9606  321.1652  388.9723  321.1657  281.9587  236.0626  183.5598  124.9098   61.7294
%  183.5587  236.0619  281.9590  321.1657  388.9716  321.1656  281.9564  236.0627  183.5595  124.9100
%  124.9089  183.5585  236.0600  281.9587  321.1656  388.9722  321.1630  281.9567  236.0630  183.5592
%   61.7309  124.9104  183.5600  236.0626  281.9564  321.1630  388.9737  321.1622  281.9547  236.0652
%    3.2452   61.7307  124.9098  183.5598  236.0627  281.9567  321.1622  388.9738  321.1624  281.9546
%  -42.2186    3.2451   61.7293  124.9098  183.5595  236.0630  281.9547  321.1624  388.9739  321.1623
%  -78.4340  -42.2185    3.2467   61.7294  124.9100  183.5592  236.0652  281.9546  321.1623  388.9740
%
%We can see that it is a 10x10 matrix in our example for a Wiener filter 
%with 10 filter taps. In this matrix, the next row looks almost like
%the previous line, but (circularly) shifted by 1 sample to the right.
%
