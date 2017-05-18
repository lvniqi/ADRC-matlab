nn = bp_nn(2,5,3);
round_time = 100000;%运行次数
%eval = max(0,eval);
%eval = min(1,eval);
for k=1:1:round_time
    input_layer = (rands(1,2)-0.5)*10;
    eval = [input_layer(1)+input_layer(2),input_layer(1)-input_layer(2),1];
    nn.train(input_layer,eval);
end
