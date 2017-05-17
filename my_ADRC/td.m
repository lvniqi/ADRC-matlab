function [input,x1,x2] = td()
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
    x1 = zeros(1,round_time);
    x2 = zeros(1,round_time);
    input = zeros(1,round_time);
%     sys=tf(1,[2,1]);  %建立被控对象传递函数
%     dsys = c2d(sys,ts,'z');
%     [num,den] = tfdata(dsys,'v');
%     s_1 = sin(times);
%     for i=pos
%         if i > 1
%             input(i) = input(i-1)*-den(2)+num(2)*s_1(i);
%         end
%     end
%     input = input+rand(1,round_time)/100;
    input = sin(times)+rand(1,round_time)/50;
    %input = ones(1,round_time)+rand(1,round_time)/50;
    input_diff = diff(input,1)/ts;
    input_diff(round_time) = 0;

    t2 = (input(step+1:round_time)-input(1:round_time-step))/(step*ts);
    for i=1:1:round_time-length(t2)
        t2(length(t2)+1) = 0;
    end
    x1_start = 0;
    x2_start = 0;
    for i=pos
        x1(i) = x1_start+ts*x2_start;
        x2(i) = x2_start+ts*fhan(x1_start-input(i),x2_start,r,h0);
        x1_start = x1(i);
        x2_start = x2(i);
    end
    figure(1);
    plot(times,input,times,input_diff,times,t2,times,x2);
    figure(2);
    plot(times,input,times,x1);
    figure(3);
    plot(times,input,times,t2,times,x2);
    figure(4);
    plot(times(1:round_time-1),1/ts*diff(t2,1),times(1:round_time-1),1/ts*diff(x2,1));
end
function fh = fhan(x1_last,x2_last,r,h0)
    d = r*h0;
    d0 = h0*d;
    x1_new = x1_last+h0*x2_last;
    a0 = sqrt(d^2+8*r*abs(x1_new));
    if abs(x1_new)>d0
        a=x2_last+(a0-d)/2*sign(x1_new);
    else
        a = x2_last+x1_new/h0;
    end
    fh = -r*sat(a,d);
end

function M=sat(x,delta)
    if abs(x)<=delta
        M=x/delta;
    else
        M=sign(x);
    end
end
function fs = fsg(x,d)
    fs = (sign(x+d)-sign(x-d))/2;
end