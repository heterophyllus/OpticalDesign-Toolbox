

function [x] = newton_raphson(f,df,x0)
    eps = 1e-8;

    k = 1;
    xk = x0;
    while 1
        delta = f(xk)/df(xk);
        if or((abs(delta) < eps),(k > 32))
            break;
        end
        xk = xk - delta;
        k = k+1;
    end
    x = xk;
end