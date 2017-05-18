classdef pid_nn<bp_nn
    properties
        %pid输出
        pid_output = zeros(1,3);
    end
    
    methods
        %% 构造函数
        function obj=pid_nn(input_dim,h1_dim,output_dim)
            obj = obj@bp_nn(input_dim,h1_dim,output_dim);
        end
        %% 前向
        
    end
end