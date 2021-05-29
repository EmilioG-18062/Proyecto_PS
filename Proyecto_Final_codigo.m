[file,path] = uigetfile({'*.mp3;*.wav','Audio Files (*.mp3;*.wav)';'*.*','All Files (*.*)'},...
    'Select a Audio File',...
    'C:\Users\emili\OneDrive\Documents\GitHub\Proyecto_PS\Audio_Prueba_2.wav');

if isequal(file,0)
   disp('User selected Cancel');
else
   Full_Path = fullfile(path,file);
   disp(['User selected ', Full_Path]);
end

[Audio_lines, Fs] = audioread(Full_Path);
player = audioplayer(Audio_lines, Fs);
%play(player);

%Separar canales
line_1 = Audio_lines(:,1);
line_2 = Audio_lines(:,2);

%VARIABLES FILTRO BPF IIR / PAGINA 273
BPF1_Fc = 500;
BPF1_K = tan((pi*BPF1_Fc)/Fs);
BPF1_Q = 0.2;
BPF1_delta = ((BPF1_K^2)*BPF1_Q)+BPF1_K+BPF1_Q;
BPF1_A0 = BPF1_K/BPF1_delta;
BPF1_A1 = 0;
BPF1_A2 = -BPF1_K/BPF1_delta;
BPF1_B1 = (2*BPF1_Q*((BPF1_K^2)-1))/BPF1_delta;
BPF1_B2 = (((BPF1_K^2)*BPF1_Q)-BPF1_K+BPF1_Q)/BPF1_delta;
BPF1_C0 = 1.0;
BPF1_D0 = 0.0;

%ECUACION DE DIFERENCIA / PAGINA 270
[size_m,size_n] = size(line_1);
for n=1:size_m
    if n == 1
        y1(n,:)= BPF1_D0*line_1(n)+BPF1_C0*(BPF1_A0*line_1(n));
    elseif n == 2
        y1(n,:)= BPF1_D0*line_1(n)+BPF1_C0*((BPF1_A0*line_1(n))+(BPF1_A1*line_1(n-1))-(BPF1_B1*y1(n-1)));
    else
        y1(n,:)= BPF1_D0*line_1(n)+BPF1_C0*((BPF1_A0*line_1(n))+(BPF1_A1*line_1(n-1))+(BPF1_A2*line_1(n-2))-(BPF1_B1*y1(n-1))-(BPF1_B2*y1(n-2)));
    end
end

soundsc(y1,Fs)

