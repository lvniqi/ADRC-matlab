function adrc()
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
    
end





