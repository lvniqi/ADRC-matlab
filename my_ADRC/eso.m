function [output,z1,z2] = eso()
    %运行次数
    round_time = 5000;
    %步进
    step = 5;
    %时基
    ts = 0.01;
    %快速因子
    r = 10;
    %滤波因子
    h0 = 0.1;
    %位置
    pos = 1:1:round_time;
    %时间轴
    times = pos*ts;
    %β0
    beta_01 = 100;
    beta_02 = 300;
    beta_03 = 1000;
    z1 = zeros(1,round_time);
    z2 = zeros(1,round_time);
    z3 = zeros(1,round_time);
    input = zeros(1,round_time);
    output = zeros(1,round_time);
    sys=tf(1,[1,10,5]);  %建立被控对象传递函数
    %sys=tf(1,[1,2]);  %建立被控对象传递函数
    dsys = c2d(sys,ts,'z')
    [num,den] = tfdata(dsys,'v');
    input = sin(times)+rand(1,round_time)/100;
    for i=pos
        if i > 2
            output(i) = -den(2)*output(i-1)-den(3)*output(i-2)+num(2)*input(i)+num(3)*input(i-1);
            %output(i) = output(i-1)*-den(2)+num(2)*input(i);
        end
    end
    %output = output+rand(1,round_time)/100;
    %input = sin(times)+rand(1,round_time)/50;
    %input = ones(1,round_time)+rand(1,round_time)/50;
    
    z1_start = 0;
    z2_start = 0;
    z3_start = 0;
    for i=pos
        e = z1_start-output(i);
        fe = fal(e,0.5,0.05);
        fe1 = fal(e,0.25,0.05);
        z1(i) = z1_start+ts*(z2_start-beta_01*e);
        %z2(i) = z2_start + ts*(z3_start-beta_02*fe+input(i));
        z2(i) = z2_start + ts*(z3_start-beta_02*fe);
        z3(i) = z3_start + ts*(-beta_03*fe1);
        z1_start = z1(i);
        z2_start = z2(i);
        z3_start = z3(i);
    end
    figure(1);
    plot(times,output,times,z2,times,z3);
    figure(2);
    plot(times,output,times,z1);
    figure(3);
    plot(times,output-z1);
end

function fe = fal(error,pow,threshold)
    if abs(error) > threshold
        fe = abs(error)^pow*sign(error);
    else
        fe = error/threshold^pow;
    end
end