%ª≠≥ˆ÷·¡¶Õº
function to_zlt(dyhz,hzlx,hzcd,l,f1,f2,x0,y0,cos,sin,r_zl)
if dyhz == 0 || hzlx == 1 || hzlx ==2 || hzlx == 3 || hzlx == 4 || hzlx == 7
    X = [0,0,l,l];
    Y = [0,f1/r_zl,f2/r_zl,0];
    x = x0 + X * cos - Y * sin;
    y = y0 + X * sin + Y * cos;
    text((x(2)+x(3))/2,(y(2)+y(3))/2,num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
    plot(x,y,'red');
else
    if hzlx == 5
        X = [0,0,hzcd,l,l];
        Y = [0,f1/r_zl,f2/r_zl,f2/r_zl,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text((x(3)+x(4))/2,(y(3)+y(4))/2,num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    else
        X = [0,0,hzcd,hzcd,l,l];
        Y = [0,f1/r_zl,f1/r_zl,f2/r_zl,f2/r_zl,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text((x(2)+x(3))/2,(y(2)+y(3))/2,num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text((x(4)+x(5))/2,(y(4)+y(5))/2,num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    end  
end
    