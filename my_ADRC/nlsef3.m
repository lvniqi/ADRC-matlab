function u0 = nlsef3(e1,e2,c,r,h1)
    u0 = -fhan(e1,c*e2,r,h1);
end

function fh = fhan(x1_last,x2_last,r,h0)
    d = r*h0;
    d0 = h0*d;
    x1_new = x1_last+h0*x2_last;
    a0 = sqrt(d^2+8*r*abs(x1_new));
    if abs(x1_new)>d0
        a=x2_last+(a0-d)/2*sign(x1_new);
    else
        a = x2_last+x1_new/h0;
    end
    fh = -r*sat(a,d);
end

function M=sat(x,delta)
    if abs(x)<=delta
        M=x/delta;
    else
        M=sign(x);
    end
end