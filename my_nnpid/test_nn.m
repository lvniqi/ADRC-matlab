function [w_o,b_o,last_gradient] = test_nn()
    w_i = rands(2,4);
    b_i = rands(1,4);
    w_o = rands(4,3);
    b_o = rands(1,3);
    learning_rate = 0.1;
    gradient = 0;
    h_layer = zeros(1,4);
    round_time = 1000;%运行次数
    input_layer = rands(1,2)-0.5;
    t = rands(1,2);
    eval = input_layer*rands(2,3);
    eval = max(0,eval);
    eval = min(1,eval);
    for k=1:1:round_time
        h_layer = neural_networks_forward(input_layer,w_i,b_i,@sigmoid);
        out = neural_networks_forward(h_layer,w_o,b_o,@relu);
        gradient = out-eval;
        [w_o,b_o,last_gradient] = neural_networks_back(learning_rate,h_layer,out,w_o,b_o,gradient,@relu_gradient);
        [w_i,b_i,last_gradient] = neural_networks_back(learning_rate,input_layer,h_layer,w_i,b_i,last_gradient,@sigmoid_gradient);
        gradient
    end
end


function out = neural_networks_forward(input,weights,bias,active_func)
    out_unactive = input*weights+bias;
    out = active_func(out_unactive);
end
function [weights_new,bias_new,last_gradient] = neural_networks_back(learning_rate,input_layer,out,weights,bias,gradient,active_gradient_func)
    %激活函数求导
    gradient_new = active_gradient_func(out).*gradient;
    %更新偏置
    bias_new = bias - learning_rate.*gradient_new;
    %weights 的尺寸 input*output
    [w_h,w_w] = size(weights);
    
    %更新偏置
    x_t = repmat(input_layer',1,w_w);
    gradient_t = repmat(gradient_new,w_h,1);
    last_gradient = gradient_t.*weights;
    last_gradient = sum(last_gradient,2)';
    weights_new = weights - learning_rate*gradient_t.*x_t;
    
end

function output = relu(x)
    output = x;
     for k=1:1:length(output)
         if output(k) < 0
             output(k)=0.1*output(k);
         end
     end
end
function gradient = relu_gradient(output)
    gradient = ones(1,length(output));
       for k=1:1:length(output)
           if output(k)<=0
               gradient(k) = 0.1;
           end
       end
end
function output = sigmoid(x)
output =1./(1+exp(-x));
end
function gradient = sigmoid_gradient(output)
gradient =output.*(1-output);
end