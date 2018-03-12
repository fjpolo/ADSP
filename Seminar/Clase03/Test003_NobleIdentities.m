%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%
%Simple average filter
B=[1,1];
%Signal
x=1:10;
%Upsampling factor
N=2;
%Now we would like to implement the first block diagram of the Noble Identities, 
%the downsampling (the pair on the first line, with outputs y1 and y2). First, 
%for y1, the down-sampling by a factor of N=2:
xd=x(1:N:end);          %xd=1,3,5,7,9
%Apply the filter.This yields the sum of each pair in xd:
y1=filter(B,1,xd);      %y1= 1,4,8,12,16
%
%
%
%Now we would like to implement the corresponding right-hand side block diagram 
%of the noble identity. Our filter is now up-sampled by N=2:
Bu(1:N:4)=B;            %Bu= 1,0,1
%Now filter the signal before down-sampling:
yu=filter(Bu,1,x);      %yu= 1, 2, 4, 6, 8, 10, 12, 14, 16, 18
%Now down-sample it:
y2=yu(1:N:end);         %y2= 1,4,8,12,16
%
%
%Here we can now see that indeed y1=y2!!!!
%
%
