function [z1_new,z2_new,z3_new] = eso3(z1_last,z2_last,z3_last, ...
                                        beta_01,beta_02,beta_03, ...
                                        input,b0,output,h,threshold)
        e = z1_last-output;
        fe = fal(e,0.5,threshold);
        fe1 = fal(e,0.25,threshold);
        z1_new = z1_last+h*(z2_last-beta_01*e);
        z2_new = z2_last + h*(z3_last-beta_02*fe+b0*input);
        z3_new = z3_last + h*(-beta_03*fe1);
end

function fe = fal(error,pow,threshold)
    if abs(error) > threshold
        fe = abs(error)^pow*sign(error);
    else
        fe = error/threshold^pow;
    end
end