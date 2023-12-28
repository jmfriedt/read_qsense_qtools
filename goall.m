clear all
close all
format long
graphics_toolkit('gnuplot'); % much nicer than fltk to edit in inkscape afterward

filename=dir("*.qsd");       % all QSense acquisition files in current directory
for filenum=1:length(filename)
  [t,f,d,l,ns]=read_qsd(filename(filenum).name);
  mylegend="";
  figure
  subplot(211)
  novertones=size(f)(2)/ns;  % should be integer, or something is wrong
  for k=1:size(f)(2)
      plot(t(1:l(k),k)/3600,f(1:l(k),k)-f(1,k))
      mylegend=[mylegend,",""overtone ",num2str(mod(k-1,novertones)*2+1),""""];
      hold on
  end
  ylim([-1000 100])
  grid
  xlabel('time (h)')
  ylabel('frequency shift (Hz)')
  eval(["legend(",mylegend(2:end),",'location','southwest');"]);
  
  subplot(212)
  for k=1:size(d)(2)
      plot(t(1:l(k),k)/3600,d(1:l(k),k)-d(1,k))
      hold on
  end
  grid
  xlabel('time (h)')
  ylabel('damping (x1e-6)')
end
