function wy=warpingphase(w,a);
%produces phase wy for an allpass filter
%w: input vector of normlized frequencies (0..pi)
%a: allpass coefficient
%phase of allpass zero/pole :
theta=angle(a);
%magnitude of allpass zero/pole :
r=abs(a);
wy=-w-2*atan((r*sin(w-theta))./(1-r*cos(w-theta)));
