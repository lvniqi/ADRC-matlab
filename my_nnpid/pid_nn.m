classdef pid_nn<bp_nn
    properties
        %pid输出
        pid_output = zeros(1,3);
    end
    
    methods
        %% 构造函数
        function obj=pid_nn(input_dim,h1_dim,output_dim)
            obj = obj@bp_nn(input_dim,h1_dim,output_dim);
            obj.learning_rate = 0.0001;
        end
        %% 前向传播
        function pid_output = forward(obj,input,pid_param)
            obj.h_layer_1 = obj.neural_networks_forward(input,obj.w_i,obj.b_i,@obj.lrelu);
            obj.output = obj.neural_networks_forward(obj.h_layer_1,obj.w_o,obj.b_o,@obj.lrelu);
            %obj.output
            pid_output = obj.pid_control(obj.output,pid_param);
            obj.pid_output = pid_output;
            %pid_output
        end
    end
    methods(Static)
        function out = pid_control(pid_con,pid_param)
            out = pid_con*pid_param';
        end
    end
end