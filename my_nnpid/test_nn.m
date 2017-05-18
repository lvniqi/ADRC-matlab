nn = bp_nn(2,4,3);
round_time = 1000;%运行次数
input_layer = rands(1,2)-0.5;
eval = input_layer*rands(2,3);
%eval = max(0,eval);
%eval = min(1,eval);
for k=1:1:round_time
    nn.train(input_layer,eval);
end
