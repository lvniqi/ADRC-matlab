function [z1_new,z2_new,z3_new] = leso3(z1_last,z2_last,z3_last, ...
                                        w, ...
                                        input,b0,output,h)
        beta_01 = 3*w;
        beta_02 = 3*w^2;
        beta_03 = w^3;
        e = z1_last-output;
        z1_new = z1_last+h*(z2_last-beta_01*e);
        z2_new = z2_last + h*(z3_last-beta_02*e+b0*input);
        z3_new = z3_last + h*(-beta_03*e);
end