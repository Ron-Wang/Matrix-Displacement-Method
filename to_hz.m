%计算单元荷载的单元固端力
function Fe = to_hz(type,value,a,l)
if type == 1
    Fe = [0;-value*a*(1-a^2/l^2+a^3/(2*l^3));-value*a^2/12*(6-8*a/l+3*a^2/l^2);0;-value*a^3/l^2*(1-a/(2*l));value*a^3/(12*l)*(4-3*a/l)];
elseif type == 2
    Fe = [0;-value*(l-a)^2/l^2*(1+2*a/l);-value*a*(l-a)^2/l^2;0;-value*a^2/l^2*(1+2*(l-a)/l);value*a^2*(l-a)/l^2];
elseif type == 3
    Fe = [0;6*value*a*(l-a)/l^3;value*(l-a)/l*(2-3*(l-a)/l);0;-6*value*a*(l-a)/l^3;value*a/l*(2-3*a/l)];
elseif type == 4
    Fe = [0;-value*a/4*(2-3*a^2/l^2+1.6*a^3/l^3);-value*a^2/6*(2-3*a/l+1.2*a^2/l^2);0;-value/4*a^3/l^2*(3-1.6*a/l);value*a^3/(4*l)*(1-0.8*a/l)];
elseif type == 5
    Fe = [-value*a*(1-0.5*a/l);0;0;-0.5*value*a^2/l;0;0];
elseif type == 6
    Fe = [-value*(l-a)/l;0;0;-value*a/l;0;0];
elseif type == 7
    Fe = [0;value*a^2/l^2*(a/l+3*(l-a)/l);-value*(l-a)^2/l^2*a;0;-value*a^2/l^2*(a/l+3*(l-a)/l);value*a^2/l^2*(l-a)];
end
