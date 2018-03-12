function h = firpm(ty,a,sf,fp,fs)
% FIRPM Remez Parks-McCllelan FIR equiripple filter design.
%
%       H = FIRPM(TY,A,SF,FP,FS) Remez Parks-McCllelan optimal filter
%	TY can be 'lp', 'hp', 'bp', or 'bs',
%       A = [Ap As] = pass/stop band ATTENUATION in dB  BUT 
%	If BOTH ELEMENTS are < 1, A=[rp rs]= pass/stop band RIPPLE.
%       SF is the sampling frequency in HERTZ
%	FP and FS are the pass/stop band edge(s) in HERTZ
%	NOTE: FP and FS will have two elements for 'bp' and 'bs' filters.
%
%	H contains the NORMALIZED filter coefficients (so PEAK gain=1).
%
%       FIRPM (with no input arguments) invokes the following example:
%
%       >>hpm = firpm('bs',[3 50],100,[10 40],[20 30])

% Version 1.1
% Ashok Ambardar, EE Dept. MTU, Houghton, MI 49931, USA
% e-mail: akambard@mtu.edu
% Copyright (c) 1995

if nargin==0,help firpm,disp('Strike a key to see results of the example')
pause,hpm=firpm('bs',[3 50],100,[10 40],[20 30]),return,end

if exist('remez')<2,disp(' ')
disp('SORRY. This routine requires the Signal Processing Toolbox!')
return,end

%ERROR CHECK
ty=ty(1:2);if ty=='bp'|ty=='bs',if length(fp)~=2|length(fs)~=2
error('BP or BS filters require fp and fs as two elements'),return,end,end
e=0;if ty=='lp',if fp>fs,e=1;end
elseif ty=='hp',if fs>fp,e=1;end
elseif ty=='bp',pp=abs(diff(fp));ss=abs(diff(fs));if pp>ss,e=1;end
elseif ty=='bs',pp=abs(diff(fp));ss=abs(diff(fs));if ss>pp,e=1;end
else,error('Unknown type. Use lp hp bp or bs in single quotes'),return,end
if e==1,error('Passband and stopband switched'),return,end

%COMPUTE RIPPLES & PREPARE FOR REMEZ
if a(1)<1 & a(2)<1,
dp=a(1);ds=a(2);as=-20*log10(ds);
%ap=(10)^(0.05*ap)-1;ds=dp;
else,ap=a(1);as=a(2);
%dp=[(10)^(0.05*ap)-1]/[(10)^(0.05*ap)+1];ds=(10)^(-0.05*as);
dp=[1-(10)^(-0.05*ap)]/2;  % For measures from 0 dB
ds=(10)^(-0.05*as);
delt=1-dp;dp=dp/delt;ds=ds/delt;
end
k=ds/dp;
fp=fp/sf;fs=fs/sf;
odd=0;
ff=[fp fs];  % For use in plots

%%%%%% MAKE FREQUENCIES SYMMETRIC  %%%%%%%%%%%%%%%%%%%%%%%%
if ty=='lp'|ty=='hp',
fpp=fp;
fss=fs;
df=abs(fss-fpp);
else,
df1=abs(fp(1)-fs(1));
df2=abs(fs(2)-fp(2));
df=min(df1,df2);
fpp=0.5*abs(diff(fp));
fss=fpp+df;
if ty=='bp'
fs=[fp(1)-df fp(2)+df];  % New stopband
else
fs=[fp(1)+df fp(2)-df];  % New stopband
end
end

if ty=='lp',M=[1 1 0 0];F=2*[0 fp fs 0.5];W=[k 1];
elseif ty=='hp',odd=1;M=[0 0 1 1];F=2*[0 fs fp 0.5];W=[1 k];
elseif ty=='bp',M=[0 0 1 1 0 0];F=2*[0 fs(1) fp(1) fp(2) fs(2) 0.5];W=[1 k 1];
else,odd=1;M=[1 1 0 0 1 1];F=2*[0 fp(1) fs(1) fs(2) fp(2) 0.5];W=[k 1 k];end

%DETERMINE FILTER LENGTH N
if exist('remlpord')>0, %For compatibility with v3.5 
N=ceil(eval('remlpord(fpp,fss,dp,ds)'));
else
N=ceil(1-(10*log10(dp*ds)+13)/(2.324*2*pi*df));
end

if rem(N,2)==1,if odd==1,N=N-1;end;end,N=max(2,N);
clg,

%PICK FREQUENCY ARRAY
%f=0:1/400:0.5;

%REMEZ LOOP
k=0;rs=2*ds;rp=2*dp;while rs>ds | rp>dp
k=k+1;if odd==1,N=N+2;else,N=N+1;end
ns=num2str(N+1);clc,home,disp(['Selecting Filter length N = ' ns]); 
fac=max([4, fix(400/N)]);df=0.5/fac/N;f=0:df:0.5;
h=eval('remez(N,F,M,W)');
mag=abs(freqz(h,1,2*pi*f));

%mag=tfplot('z',h,1);
rp=max(mag)-1;
if ty=='lp',i=find(f>fs);
elseif ty=='hp',i=find(f<fs);
elseif ty=='bp',i=find(f<fs(1) | f>fs(2));
else,i=find(f>fs(1) & f<fs(2));end
rs=mag(i);rs=max(rs);
if k==1,if rs<=ds & rp<=dp,rs=2*ds;rp=2*dp;k=0;
if odd==1,N=N-4;else,N=N-3;end;end,end 
end

v=3;if exist('version')==5,v=4;end
disp(' '),disp('STRIKE A KEY BETWEEN PLOTS'),pause(1)

inp=1;while inp~=0
h=eval('remez(N,F,M,W)');ns=num2str(length(h));
fac=max([4, fix(400/N)]);df=0.5/fac/N;f=0:df:0.5;


mag=abs(freqz(h,1,2*pi*f));

%mag=tfplot('z',h,1);
rp=max(mag)-1;
if ty=='lp',i=find(f>fs);
elseif ty=='hp',i=find(f<fs);
elseif ty=='bp',i=find(f<fs(1) | f>fs(2));
else,i=find(f>fs(1) & f<fs(2));end
rs=mag(i);rs=max(rs);

%PLOTS
rip=[num2str(rp)];if length(a)>1,rip=[rip '   ' num2str(rs)];end
ff=sort(ff(:));FF=[0;ff;0.5];
g='Analog Frequency  [Hz]';plot(f*sf,mag,FF*sf,M,'-c3'),grid
title(['N = ' ns '  PB/SB Ripple: [' rip ']']),xlabel(g),pause,
ymin=-5*ceil(as/5)-20;ax=[0 0.5*sf ymin 0];if v==3,axis(ax);end
mmag=max(mag);plot(f*sf,20*log10(mag/mmag));grid,xlabel(g);
h=h/mmag;H=freqz(h,1,2*pi*ff);Ha=-20*log10(abs(H));Ha=sort(Ha(1:2));
att=[num2str(Ha(1)) '   ' num2str(Ha(2)) ' ']; 
title(['N = ' ns '   PB/SB Attn from  0dB = [ ' att ' ] dB'])
if  v==4,axis(ax),else,pause,end
disp(['N = ' ns '  PB/SB Attn from 0dB  = [' att ']dB'])
inp=input('enter new N or press ENTER to stop :');
hold off,if isempty(inp),break,else,
if rem(inp,2)==0 & odd==1,
disp('Length must be odd. Increasing by 1.'),inp=inp+1;end
N=inp-1;end
end
