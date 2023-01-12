function [ W1,W2,W3,W4 ] = weight_distrib( Kf,Kr,W,Wf,Wr,h1,hf,hr,sumFy,tf,tr,bool_left )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Mf = Kf*(sumFy*h1)/(Kf+Kr-W*h1) + hf*Wf/W*sumFy;
Mr = Kr*(sumFy*h1)/(Kf+Kr-W*h1) + hr*Wr/W*sumFy;

dFzf = Mf/tf;
dFzr = Mr/tr;


   W1 = Wf/2 - dFzf*bool_left;
   W2 = Wf/2 + dFzf*bool_left;
   
   W3 = Wr/2 - dFzr*bool_left;
   W4 = Wr/2 + dFzr*bool_left;




end

