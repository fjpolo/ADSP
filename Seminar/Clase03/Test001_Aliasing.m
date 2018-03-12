%Make a sine wave which at 44100 Hz
%sampling rate has a frequency of 400 Hz at 1
%second duration. Hence we need 44100
%samples, and 400 periods of our sinusoid in
%this second. Hence we can write our signal
%in Octave/Matlab as:
s=sin(2*pi*400*(0:1/44096:1));

%Listen to it:
%sound(s,44100)

%Now plot the first 1000 samples:
figure(1)
subplot(2,1,1)
plot(s(1:1000))
title("1000 samples")
%Next plot the first 100 samples:
figure(1)
subplot(2,1,2)
plot(s(1:100))
title("100 samples")
%Now we can multiply this sine tone signal
%With a unit pulse train, with N=8.
%We generate the unit impulse train,
unit(1:8:44101)=1;
figure(2)
plot(unit(1:100));
xlabel('n')
ylabel('unit(n)')

%Listen to it:
%sound(unit,44100);

%The multiplication with the unit impulse
%train:
sdu=s.*unit;
%(This multiplication is also called „frequency
%mixing“).
%Now plot the result, the first 100 samples:
figure(3)
title("Sampled signal")
plot(sdu(1:100))
%This is our signal still with the zeros in it.
%Now take a look at the spectrum of the
%original signal s:
figure(4)
freqz(s)
%The upper two plots show the magnitude of
%the frequency spectrum of our signal, the
%lowest plot is its phase. Observe that the
%frequency axis (horizontal) is a normalized
%frequency, normalized to the Nyquist
%frequency, in our case 22050 Hz. Hence our
%sinusoid should appear as a peak at
%normalized frequency 400/22050=0.018141,
%which we indeed see.
%The uppermost plot shows a magnification of
%the top part of the middle plot, which is
%often used to assess a pass band for filters.
%Now we can compare this to our signal with
%the zeros, sdu:
figure(5)
freqz(sdu);
%Here we can see the original line of our 400
%Hz tone, and now also the 7 new aliasing
%components. Observe that always 2 aliasing
%components are close together. This is
%because the original 400 Hz tone also has a
%spectral peak at the negative frequencies, at
%-400 Hz, or at normalized frequency -0.018
%(which is 400/22050).

%Now also listen to the signal with the zeros:
%sound(sdu,44100);

%Here you can hear that it sounds quite
%different from the original, because of the
%strong aliasing components!

%The final step of downsampling is now to
%omit the zeros between the samples, to
%obtain the lower sampling rate. Let's call the
%signal without the zeros
%y(m),
%where the time index m denotes the lower
%sampling rate (as opposed to n, which
%denotes the higher sampling rate).
%In our Matlab/Octave example this is:
sd=sdu(1:8:44100);
figure(6)
plot(sd(1:(100/8)));
%We can now take a look at the spectrum with
figure(7)
freqz(sd);
%Observe that the sine signal now appear at
%normalized frequency of 0.145, a factor of
%8 higher than before, with the zeros in it,
%because we reduced the sampling rate
%by 8. This is because we now have a new
%Nyquist frequency of 22050/8 now, hence
%our normalized frequency becomes 400/(22050*8) = 0,145

%This means removing
%the zeros scales or stretches our frequency
%axis.
%Observe that here we only have 100/8≈12
%samples left.