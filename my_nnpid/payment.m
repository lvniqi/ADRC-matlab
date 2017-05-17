%Create a class named payment, placed in file 'payment.m'
classdef payment
    properties
        rate;
        term;
        principle;
    end
    methods
        function obj = payment(r,t,p)
            obj.rate = r;
            obj.term = t;
            obj.principle = p;
            
            
        end
        function disp(obj)
            i = obj.rate/(12*100);
            payAmt = (obj.principle * i)/(1 - (1+i)^(-obj.term));
            s = sprintf('%s%.2f%s%4.2f%s%.2f%s%d%s',...
                'Payment per month on a loan of $', obj.principle,...
                ' at an annual interest rate of ', obj.rate,... Matlab÷–Œƒ¬€Ã≥
                '% is $', payAmt, ' for ', obj.term, ' months.');
            disp(s);
        end
    end
end