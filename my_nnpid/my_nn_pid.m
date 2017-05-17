function my_nn_pid()
    %BP based PID Control
    clear all;
    close all;
    learning_rate=10;%学习速率
    alfta=0.05;%惯性系数
    round_time = 1000;%运行次数
    ts = 0.01;
    times = zeros(1,round_time);%时基
    w_2 = 1+rands(2,3);
    b_2 = [45,0.5,1000];
    gradient = 0;
    layer_2 = zeros(1,3);
    input_layer = zeros(1,2);
    pid_con = [45,0.5,1000];%pid 参数
    pid_m = zeros(1,3);%pid 乘积量
    singal_in = zeros(1,round_time);%信号输入
    
    pid_out = zeros(1,round_time);%pid输出
    singal_out = zeros(1,round_time);%信号输出
    error = zeros(1,round_time);%信号输入
    sys=tf(2.6126,[1,3.201,2.7225]);  %建立被控对象传递函数
    dsys=c2d(sys,ts,'z');   %把传递函数离散化
    [num,den]=tfdata(dsys,'v');  %离散化后提取分子、分母
    
    IN=3;H=5;Out=3;  %NN Structure
    wi=0.50*rands(H,IN);
    wo=0.50*rands(Out,H);
    x=[0,0,0];
    for k=1:1:round_time
        
        times(k)=k*ts;
        singal_in(k)=2.0;
        v = mod(k,314);
        if v<200
            singal_in(k) = sin(2*v/(pi*100));
        else
            singal_in(k) = 0.5*v^2;
        end
        if k > 3
            error(k) = singal_in(k)-singal_out(k-1);
            layer_out_gradient = (singal_out(k-1)-singal_in(k-1));
            layer_out_gradient = layer_out_gradient.*pid_m;
            gradient = gradient + relu_gradient(layer_2).*layer_out_gradient;
            if mod(k,5) == 0
                gradient
                [w_2,b_2] = neural_networks_back(learning_rate,input_layer,w_2,b_2,gradient);
                gradient = 0;
            end
            input_layer = [abs(error(k)),singal_in(k)];
            layer_2 = neural_networks_forward(input_layer,w_2,b_2,@relu);
            %pid_con = layer_2;
            pid_m=pid_param(error,k);
            pid_out(k) = pid_out(k-1)+pid_control(pid_con,pid_m);
            singal_out(k) = i_func_1(num,den,singal_out,pid_out,k);
       end
    end

    figure(1);
    plot(times,singal_in,'r',times,singal_out,'b');
    xlabel('time(s)');ylabel('in,out');
    %figure(1);
    %plot(times,a,'r');
    %c = neural_networks();
end
function pid_m = pid_param(error,k)
    pid_m = zeros(1,3);
    pid_m(1)=error(k)-error(k-1);
    pid_m(2)=error(k);
    pid_m(3)=error(k)-2*error(k-1)+error(k-2);
end
function out = pid_control(pid_con,pid_m)
    out = pid_con*pid_m';
end

function out=i_func_1(num,den,out_all,in_all,k)
    out = -den(2)*out_all(k-1)-den(3)*out_all(k-2)+ num(2)*in_all(k-1)+num(3)*in_all(k-2);
end

function out = neural_networks_forward(input,weights,bias,active_func)
    out_unactive = input*weights+bias;
    out = active_func(out_unactive);
end
function [weights_new,bias_new] = neural_networks_back(learning_rate,input_layer,weights,bias,gradient)
    bias_new = bias - learning_rate.*gradient;
    bias_new
    x_t = repmat(input_layer,3,1)';
    gradient_t = repmat(gradient,3,1);
    weights_new = zeros(2,3);
    %weights_new = weights - learning_rate*gradient_t*x_t;
    
end
function output = sigmoid(x)
output =1./(1+exp(-x));
end
function gradient = sigmoid_gradient(output)
gradient =output.*(1-output);
end
function output = relu(x)
    output = x;
     for k=1:1:length(output)
         if output(k) < 0
             output(k)=0;
         end
     end
end
function gradient = relu_gradient(output)
    gradient = ones(1,length(output));
      for k=1:1:length(output)
          if output(k)<=0
              gradient(k) = 0;
          end
      end
end