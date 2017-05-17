
%% test td
% %运行次数
% round_time = 5000;
% %步进
% step = 5;
% %时基
% ts = 0.01;
% %快速因子
% r = 10;
% %滤波因子
% h0 = 0.1;
% %位置
% pos = 1:1:round_time;
% %时间轴
% times = pos*ts;
% x1 = zeros(1,round_time);
% x2 = zeros(1,round_time);
% input = ones(1,round_time)+rand(1,round_time)/50;
% input_diff = diff(input,1)/ts;
% input_diff(round_time) = 0;
% 
% t2 = (input(step+1:round_time)-input(1:round_time-step))/(step*ts);
% for i=1:1:round_time-length(t2)
%     t2(length(t2)+1) = 0;
% end
% x1_last = 0;
% x2_last = 0;
% for i=pos
%     [x1_last,x2_last] = td3(x1_last,x2_last,input(i),r,ts,h0);
%     x1(i) = x1_last;
%     x2(i) = x2_last;
% end
% figure(1);
% plot(times,input,times,input_diff,times,t2,times,x2);
% figure(2);
% plot(times,input,times,x1);
% figure(3);
% plot(times,input,times,t2,times,x2);
% figure(4);
% plot(times(1:round_time-1),1/ts*diff(t2,1),times(1:round_time-1),1/ts*diff(x2,1))

%% 
% %% test eso
% %运行次数
% round_time = 5000;
% %步进
% step = 5;
% %时基
% ts = 0.01;
% %快速因子
% r = 10;
% %滤波因子
% h0 = 0.1;
% %位置
% pos = 1:1:round_time;
% %时间轴
% times = pos*ts;
% %β0
% beta_01 = 100;
% beta_02 = 300;
% beta_03 = 1000;
% z1 = zeros(1,round_time);
% z2 = zeros(1,round_time);
% z3 = zeros(1,round_time);
% input = zeros(1,round_time);
% output = zeros(1,round_time);
% sys=tf(1,[1,10,5]);  %建立被控对象传递函数
% %sys=tf(1,[1,2]);  %建立被控对象传递函数
% dsys = c2d(sys,ts,'z')
% [num,den] = tfdata(dsys,'v');
% input = sin(times)+rand(1,round_time)/100;
% for i=pos
%     if i > 2
%         output(i) = -den(2)*output(i-1)-den(3)*output(i-2)+num(2)*input(i)+num(3)*input(i-1);
%         %output(i) = output(i-1)*-den(2)+num(2)*input(i);
%     end
% end
% %output = output+rand(1,round_time)/100;
% %input = sin(times)+rand(1,round_time)/50;
% %input = ones(1,round_time)+rand(1,round_time)/50;
% 
% z1_last = 0;
% z2_last = 0;
% z3_last = 0;
% for i=pos
%     [z1_last,z2_last,z3_last] = eso3(z1_last,z2_last,z3_last, ...
%                                         beta_01,beta_02,beta_03, ...
%                                         output(i),ts,0.05);
%     z1(i) = z1_last;
%     z2(i) = z2_last;
%     z3(i) = z3_last;
% end
% figure(1);
% plot(times,output,times,z2,times,z3);
% figure(2);
% plot(times,output,times,z1);
% figure(3);
% plot(times,output-z1);

%% test nlsef
%运行次数
round_time = 5000;
%步进
step = 5;
%时基
ts = 0.01;
%快速因子
r = 1.0;
%滤波因子
h0 = 0.01;
%位置
pos = 1:1:round_time;
%时间轴
times = pos*ts;
%β0
beta_01 = 100;
beta_02 = 300;
beta_03 = 1000;
%eso b0因子
b0 = 1;
z1 = zeros(1,round_time);
z2 = zeros(1,round_time);
z3 = zeros(1,round_time);
x1 = zeros(1,round_time);
x2 = zeros(1,round_time);
e1 = zeros(1,round_time);
e2 = zeros(1,round_time);
u = zeros(1,round_time);
u0 = zeros(1,round_time);
input = zeros(1,round_time);
y = zeros(1,round_time);
output = zeros(1,round_time);
sys=tf(1,[1,0.5,0])  %建立被控对象传递函数
%sys=tf(1,[1,2]);  %建立被控对象传递函数
dsys = c2d(sys,ts,'z')
[num,den] = tfdata(dsys,'v');
%input = sin(times);
input = ones(1,round_time);
x1_last = 0;
x2_last = 0;
z1_last = 0;
z2_last = 0;
z3_last = 0;
for i=pos
    if i > 2
        %ts 模块 构造过渡过程
        [x1_last,x2_last] = td3(x1_last,x2_last,input(i),r,ts,h0);
        x1(i) = x1_last;
        x2(i) = x2_last;
        %产生误差
        e1(i) = x1(i) - z1(i-1);
        e2(i) = x2(i) - z2(i-1);
        %产生控制量
        u0(i) = nlsef3(e1(i),e2(i),0.3,5,0.03);
        %减去z3
        u(i) = u0(i) - z3(i-1)*1/b0;
        %过系统函数
        y(i) = -den(2)*y(i-1)-den(3)*y(i-2)+num(2)*u(i-1)+num(3)*u(i-2);
        output(i) = y(i)+(rand(1,1)-0.5)/500;
%         %eso 模块
%         [z1_last,z2_last,z3_last] = eso3(z1_last,z2_last,z3_last, ...
%                                     beta_01,beta_02,beta_03, ...
%                                     u(i),b0,output(i),ts,0.05);
        %线性eso模块
        [z1_last,z2_last,z3_last] = leso3(z1_last,z2_last,z3_last, ...
                                     20, ...
                                     u(i),b0,output(i),ts);
        z1(i) = z1_last;
        z2(i) = z2_last;
        z3(i) = z3_last;
    end
end

figure(1);
plot(times,input,times,output);
figure(2);
plot(times,x1,times,x2);