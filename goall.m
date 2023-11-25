clear all
close all
format long
graphics_toolkit('gnuplot');

Novertones=3 %  number of overtones above the fundamental mode, up to 6
filename=dir("*.qsd");

for filenum=1:length(filename)
  [t1,f1,d1,t3,f3,d3,t5,f5,d5,t7,f7,d7,t9,f9,d9,t11,f11,d11,t13,f13,d13]=read_qsd(filename(filenum).name,Novertones);

  figure
  subplot(211)
  plot(t1/3600,f1-f1(1))
  hold on
  if (!isempty(f3)) plot(t3/3600,f3-f3(1));end
  if (!isempty(f5)) plot(t5/3600,f5-f5(1));end
  if (!isempty(f7)) plot(t7/3600,f7-f7(1));end
  if (!isempty(f9)) plot(t9/3600,f9-f9(1));end
  if (!isempty(f11)) plot(t11/3600,f11-f11(1));end
  if (!isempty(f13)) plot(t13/3600,f13-f13(1));end
  ylim([-1000 100])
  grid
  xlabel('time (h)')
  ylabel('frequency shift (Hz)')
  legend('overtone 1','overtone 3','overtone 5','overtone 7','overtone 9','overtone 11','overtone 13','location','southwest')
  
  subplot(212)
  plot(t1/3600,d1)
  hold on
  if (!isempty(d3)) plot(t3/3600,d3);end
  if (!isempty(d5)) plot(t5/3600,d5);end
  if (!isempty(d7)) plot(t7/3600,d7);end
  if (!isempty(d9)) plot(t9/3600,d9);end
  if (!isempty(d11)) plot(t11/3600,d11);end
  if (!isempty(d13)) plot(t13/3600,d13);end
  grid
  xlabel('time (h)')
  ylabel('damping (x1e-6)')
end
