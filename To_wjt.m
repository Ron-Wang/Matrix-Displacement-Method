%画出弯矩图
function To_wjt(dyhz,hzlx,hzdx,hzcd,l,f,f1,f2,x0,y0,cos,sin,r_wj)
if dyhz == 0 || hzlx == 5 || hzlx ==6
    X = [0,0,l,l];
    Y = [0,f1/r_wj,f2/r_wj,0];
    x = x0 + X * cos - Y * sin;
    y = y0 + X * sin + Y * cos;
    text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
    text(x(3),y(3),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
    plot(x,y,'red');
else
    if hzlx == 1
        X1 = linspace(0,hzcd,100);
        Y1 = f1 + f * X1 + hzdx/2*X1.*X1;
        X2 = linspace(hzcd,l,100);
        Y2 = f1 + f * X2 + hzdx*hzcd*X2 - hzdx*hzcd*hzcd/2;
        X = [0,X1,X2,l];
        Y = [0,Y1/r_wj,Y2/r_wj,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text(x(101),y(101),num2str(round(Y1(100)*1000)/1000),'fontsize',8,'color','red');
        text(x(201),y(201),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    elseif hzlx == 2
        X1 = linspace(0,hzcd,100);
        Y1 = f1 + f * X1;
        X2 = linspace(hzcd,l,100);
        Y2 = f1 + f * X2 + hzdx*X2 - hzdx*hzcd;
        X = [0,X1,X2,l];
        Y = [0,Y1/r_wj,Y2/r_wj,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text(x(101),y(101),num2str(round(Y1(100)*1000)/1000),'fontsize',8,'color','red');
        text(x(201),y(201),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    elseif hzlx == 3
        X1 = linspace(0,hzcd,100);
        Y1 = f1 + f * X1;
        X2 = linspace(hzcd,l,100);
        Y2 = f1 + f * X2 - hzdx;
        X = [0,X1,X2,l];
        Y = [0,Y1/r_wj,Y2/r_wj,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text(x(101),y(101),num2str(round(Y1(100)*1000)/1000),'fontsize',8,'color','red');
        text(x(102),y(102),num2str(round(Y2(1)*1000)/1000),'fontsize',8,'color','red');
        text(x(201),y(201),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    elseif hzlx == 4
        X1 = linspace(0,hzcd,100);
        Y1 = f1 + f * X1 + hzdx/(6*hzcd)*X1.*X1.*X1;
        X2 = linspace(hzcd,l,100);
        Y2 = f1 + f * X2 + hzdx*hzcd/2*X2 - hzdx*hzcd*hzcd/3;
        X = [0,X1,X2,l];
        Y = [0,Y1/r_wj,Y2/r_wj,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text(x(101),y(101),num2str(round(Y1(100)*1000)/1000),'fontsize',8,'color','red');
        text(x(201),y(201),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    elseif hzlx == 7
        X1 = linspace(0,hzcd,100);
        Y1 = f1 + f * X1 - hzdx*X1;
        X2 = linspace(hzcd,l,100);
        Y2 = f1 + f * X2 - hzdx*hzcd;
        X = [0,X1,X2,l];
        Y = [0,Y1/r_wj,Y2/r_wj,0];
        x = x0 + X * cos - Y * sin;
        y = y0 + X * sin + Y * cos;
        text(x(2),y(2),num2str(round(f1*1000)/1000),'fontsize',8,'color','red');
        text(x(101),y(101),num2str(round(Y1(100)*1000)/1000),'fontsize',8,'color','red');
        text(x(201),y(201),num2str(round(f2*1000)/1000),'fontsize',8,'color','red');
        plot(x,y,'red');
    end  
end
    
