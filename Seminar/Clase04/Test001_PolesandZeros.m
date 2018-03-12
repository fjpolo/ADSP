%
pkg load control;
pkg load signal;
clear all;
clc;
close all;
%If a=0.5, we obtain the pole/zero plot with Matlab/Octave,
a=0.5;
%the numerator polynomial of H_AP
B=[-a' 1];  
%the denominator polynomial      
A=[1 -a];         
%plot the pole/zero diagram
zplane(B,A);
%have equal aspect ratio
axis([-1.1 2.1 -1.1 1.1],'equal') 
%In this plot, the cross at 0.5 is the pole, and the circle at 2 is the zero.