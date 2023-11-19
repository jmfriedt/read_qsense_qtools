## -*- texinfo -*-
## @deftypefn {Function File} {} read_qsd (@var{filename}, @var{Novertones})
##
## Reads a QSD file generated by QSense's QTools software and returns time,
## frequency and damping for the fundamental mode and overtones.
## @end deftypefn

function [t1,f1,d1,t3,f3,d3,t5,f5,d5,t7,f7,d7,t9,f9,d9,t11,f11,d11,t13,f13,d13]=read_qsd(filename,Novertones)
  t1=[]; t3=[]; t5=[]; t7=[]; t9=[]; t11=[]; t13=[];
  f1=[]; f3=[]; f5=[]; f7=[]; f9=[]; f11=[]; f13=[];
  d1=[]; d3=[]; d5=[]; d7=[]; d9=[]; d11=[]; d13=[];
  f=fopen(filename);
  d=fread(f,"uint8");
  nmodes=strfind(char(d),"XtalDriveTimeFloat");
  pointeur=nmodes(end)+34;
  n=d(pointeur)+d(pointeur+1)*256
  d(pointeur)
  d(pointeur+1)
  pointeur=pointeur+6+8*6;
  %%%%%%%%%%%%%%%%% first mode
    val=typecast(uint8([d(pointeur:pointeur+n*8-1+8*1)]),"double");
    t1=(val-val(1))*86400;                             % seconds
    pointeur=pointeur+n*8-1+8*1+3;
    n=d(pointeur)+d(pointeur+1)*256+d(pointeur+2)*256*256+d(pointeur+3)*256*256*256;
    pointeur=pointeur+4;
    val=typecast(uint8([d(pointeur:pointeur+n*8-1)]),"double");
    f1=val;
    pointeur=pointeur+n*8-1;
    pointeur=pointeur+7;
    val=typecast(uint8([d(pointeur:pointeur+n*8-1)]),"double");
    d1=val;
    pointeur=pointeur+n*8-1;
  for m=1:Novertones
  %%%%%%%%%%%%%%%%% overtones
    m
    pointeur=pointeur+9;
    n=d(pointeur)+d(pointeur+1)*256+d(pointeur+2)*256*256+d(pointeur+3)*256*256*256;
    pointeur=pointeur-2;
    pointeur=pointeur+3*8;
    val=typecast(uint8([d(pointeur:pointeur+n*8-1)]),"double");
    eval(["t",num2str(m*2+1),"=(val-val(1))*86400;"]); % seconds
    pointeur=pointeur+n*8-1;
    pointeur=pointeur+3;
    n=d(pointeur)+d(pointeur+1)*256+d(pointeur+2)*256*256+d(pointeur+3)*256*256*256;
    pointeur=pointeur+4;
    val=typecast(uint8([d(pointeur:pointeur+n*8-1)]),"double");
    eval(["f",num2str(m*2+1),"=val;"]);
    pointeur=pointeur+n*8-1;
    pointeur=pointeur+7;
    val=typecast(uint8([d(pointeur:pointeur+n*8-1)]),"double");
    eval(["d",num2str(m*2+1),"=val;"]);
    pointeur=pointeur+n*8-1;
  end
 end 