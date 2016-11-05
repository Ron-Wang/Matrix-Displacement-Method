%»­³ö¼ôÁ¦Í¼
function to_jlt(dyhz,hzlx,hzdx,hzcd,l,f1,f2,x0,y0,cos,sin,r_jl)
if dyhz == 0 || hzlx == 3 || hzlx ==5 || hzlx == 6 || hzlx == 7
    X = [0,0,l,l];
    Y = [0,f1/r_jl,f2/r_jl,0];
    x = x0 + X * cos - Y * sin;
    y = y0 + X * sin + Y * cos;
    text((x(2)+x(3))/2,(y(2)+y(3))/2,num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
    plot(x,y,'red');
else
    if hzlx == 1
        X = [0,0,hzcd,l,l];
        Y = [0,f1/r_jl,f2/r_jl,f2/r_jl,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text((x(3)+x(4))/2,(y(3)+y(4))/2,num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    elseif hzlx == 2
        X = [0,0,hzcd,hzcd,l,l];
        Y = [0,f1/r_jl,f1/r_jl,f2/r_jl,f2/r_jl,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text((x(2)+x(3))/2,(y(2)+y(3))/2,num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text((x(4)+x(5))/2,(y(4)+y(5))/2,num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    else
        X0 = linspace(0,hzcd,100);
        Y0 = f1-hzdx/(2*hzcd)*X0.*X0;
        X = [0,X0,l,l];
        Y = [0,Y0/r_jl,f2/r_jl,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text((x(101)+x(102))/2,(y(101)+y(102))/2,num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    end  
end
    