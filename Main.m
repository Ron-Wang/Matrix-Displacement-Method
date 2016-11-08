str1=input('请输入读取的文件名:\n','s');
str2=input('请输入输出的文件名:\n','s');
fidin = fopen(['.\data\',str1,'.txt'],'r');              
fidout_jd = fopen('jd.txt','w'); 
fidout_dy = fopen('dy.txt','w'); 
fidout_hz = fopen('hz.txt','w'); 
fidout = fopen(['.\outdata\',str2,'.txt'],'w');
while ~feof(fidin)              
    tline=fgetl(fidin);
    %判断空格，则跳过
    if isempty(tline)
        continue 
    else
        [~,n] = size(tline);
        %“jd:”后面的数组写入jd.txt中
        if(tline(1) == 'j'&&tline(2) == 'd'&&tline(3) == ':')
            for i = 4:n
                fprintf(fidout_jd,'%s',tline(i)); 
            end
            fprintf(fidout_jd,'\r\n');
        %“dy:”后面的数组写入dy.txt中
        elseif(tline(1) == 'd'&&tline(2) == 'y'&&tline(3) == ':')
            for i = 4:n
                fprintf(fidout_dy,'%s',tline(i)); 
            end
            fprintf(fidout_dy,'\r\n');
        %“hz:”后面的数组写入hz.txt中
        elseif(tline(1) == 'h'&&tline(2) == 'z'&&tline(3) == ':')
            for i = 4:n
                fprintf(fidout_hz,'%s',tline(i)); 
            end
            fprintf(fidout_hz,'\r\n');
        end
    end
end
%清空tline,n,i
clear tline n i ;
%关闭相关文件
fclose(fidin);
fclose(fidout_jd);
fclose(fidout_dy);
fclose(fidout_hz);

%将结点、单元、荷载信息读入数组
jd = load('jd.txt');
dy = load('dy.txt');
hz = load('hz.txt');
%删除jd.txt、dy.txt、hz.txt
delete ('jd.txt');
delete ('dy.txt');
delete ('hz.txt');
%由数组大小获得结点、单元、荷载数量
[jd_num,~] = size(jd);
[dy_num,~] = size(dy);
[hz_num,~] = size(hz);

wy_num = 0;%总体位移个数
%计算总体位移个数
for i = 1:jd_num
    for j = 3:5
        if wy_num < jd(i,j)
            wy_num = jd(i,j);
        end
    end
end

K = zeros(wy_num,wy_num);%总体刚度矩阵
P = zeros(wy_num,1);%整体等效节点荷载

dydw = zeros(6,dy_num);%单元定位向量
l = zeros(dy_num,1);%单元的长度
T = zeros(6,6,dy_num);%单元坐标转换矩阵
ke = zeros(6,6,dy_num);%局部坐标系的单元刚度矩阵
k = zeros(6,6,dy_num);%整体坐标系的单元刚度矩阵
x = zeros(6,dy_num);%整体坐标系的单元节点位移
F = zeros(6,dy_num);%整体坐标系的单元杆端内力
Fe = zeros(6,dy_num);%局部坐标系的单元杆端内力

Fpe = zeros(6,hz_num);%局部坐标系的单元固端力
p = zeros(6,hz_num);%整体坐标系的等效结点荷载

for i = 1:dy_num
    dydw(:,i) = [jd(dy(i,1),3),jd(dy(i,1),4),jd(dy(i,1),5),jd(dy(i,2),3),jd(dy(i,2),4),jd(dy(i,2),5)];%单元定位向量的生成
    [l(i),T(:,:,i)] = To_T(jd(dy(i,1),1),jd(dy(i,1),2),jd(dy(i,2),1),jd(dy(i,2),2));%计算单元长度和单元坐标转换矩阵
    ke(:,:,i) = To_ke(dy(i,3),dy(i,4),l(i));%计算局部坐标系的单元刚度矩阵
    k(:,:,i) = T(:,:,i)'*ke(:,:,i)*T(:,:,i);%计算整体坐标系的单元刚度矩阵
    %单元刚度矩阵向总体刚度矩阵集成
    for j = 1:6
        if dydw(j,i) ~= 0
            for n = 1:6
                if dydw(n,i) ~= 0
                    K(dydw(j,i),dydw(n,i)) = K(dydw(j,i),dydw(n,i)) + k(j,n,i);
                end
            end
        end
    end
end

for i = 1:hz_num
    if hz(i,1) == 1%判断荷载作用在结点
        if jd(hz(i,2),hz(i,3)+2) ~= 0%判断结点在荷载作用方向上有位移
            P(jd(hz(i,2),hz(i,3)+2),1) = P(jd(hz(i,2),hz(i,3)+2),1) + hz(i,4);
        end
    else
        Fpe(:,i) = To_hz(hz(i,3),hz(i,4),hz(i,5),l(hz(i,2)));%计算单元固端力
        p(:,i) = - T(:,:,hz(i,2))'*Fpe(:,i);%计算整体坐标系的单元等效结点荷载
        F(:,hz(i,2)) = F(:,hz(i,2)) + T(:,:,hz(i,2))' * Fpe(:,i);%先将整体坐标系的单元固端力加到整体坐标系的单元杆端内力
        %将单元等效结点荷载向总体集成
        for j = 1:6
            if dydw(j,hz(i,2)) ~= 0
                P(dydw(j,hz(i,2)),1) = P(dydw(j,hz(i,2)),1) + p(j,i);
            end
        end
    end
end
X = K\P;%求出整体坐标系下的位移

%求出整体坐标系下的单元杆端位移
for i = 1:dy_num
   for j = 1:6
       if dydw(j,i) ~= 0
           x(j,i) = X(dydw(j,i));
       end
   end
end

for i = 1:dy_num
    F(:,i) = F(:,i) + k(:,:,i) * x(:,i);%求出整体坐标系下的单元杆端内力
    Fe(:,i) = T(:,:,i)*F(:,i);%求出局部坐标系下的单元杆端内力
end
%把结果写入相应的文件中
fprintf(fidout,'%s','X:');
fprintf(fidout,'\r\n');
for i = 1:wy_num
    fprintf(fidout,'%8.3f',X(i));
    fprintf(fidout,'\r\n');
end
fprintf(fidout,'%s','Fe:');
fprintf(fidout,'\r\n');
for i = 1:6
    for j = 1:dy_num
        fprintf(fidout,'%8.3f',Fe(i,j));
        fprintf(fidout,'%s','  ');
    end
    fprintf(fidout,'\r\n');
end
fclose(fidout);
r_zl = max(max(abs(Fe(1,:))),max(abs(Fe(4,:))));
r_jl = max(max(abs(Fe(2,:))),max(abs(Fe(5,:))));
r_wj = max(max(abs(Fe(3,:))),max(abs(Fe(6,:))));
l_min = min(l);
r_zl = 2 * r_zl / l_min;
r_jl = 2 * r_jl / l_min;
r_wj = 2 * r_wj / l_min;
x_min = min(jd(:,1));
y_min = min(jd(:,2));
x_max = max(jd(:,1));
y_max = max(jd(:,2));

set (gcf,'Position',[200,50,750,600], 'color','w');%设置绘图空间
%绘轴力图
subplot(2,2,1)
hold on;
set(gca,'Xlim',[x_min - l_min/2,x_max + l_min/2]);
set(gca,'Ylim',[y_min - l_min/2,y_max + l_min/2]);
for i = 1:dy_num
    plot([jd(dy(i,1),1),jd(dy(i,2),1)],[jd(dy(i,1),2),jd(dy(i,2),2)],'black');
end
for i = 1:dy_num
    dyhz = 0;
    hzlx = 0;
    hzcd = 0;
    for j = 1:hz_num
        if hz(j,1) == 2
            if hz(j,2) == i
               dyhz = 1; 
               hzlx = hz(j,3);
               hzcd = hz(j,5);
            end
        end
    end
    To_zlt(dyhz,hzlx,hzcd,l(i),-Fe(1,i),Fe(4,i),jd(dy(i,1),1),jd(dy(i,1),2),T(1,1,i),T(2,1,i),r_zl);
end
title('轴力图');
axis off;

%绘剪力图
subplot(2,2,2)
hold on;
set(gca,'Xlim',[x_min - l_min/2,x_max + l_min/2]);
set(gca,'Ylim',[y_min - l_min/2,y_max + l_min/2]);
for i = 1:dy_num
    plot([jd(dy(i,1),1),jd(dy(i,2),1)],[jd(dy(i,1),2),jd(dy(i,2),2)],'black');
end
for i = 1:dy_num
    dyhz = 0;
    hzlx = 0;
    hzdx = 0;
    hzcd = 0;
    for j = 1:hz_num
        if hz(j,1) == 2
            if hz(j,2) == i
               dyhz = 1; 
               hzlx = hz(j,3);
               hzdx = hz(j,4);
               hzcd = hz(j,5);
            end
        end
    end
    To_jlt(dyhz,hzlx,hzdx,hzcd,l(i),-Fe(2,i),Fe(5,i),jd(dy(i,1),1),jd(dy(i,1),2),T(1,1,i),T(2,1,i),r_jl);
end
title('剪力图');
axis off;

%绘弯矩图
subplot(2,2,3)
hold on;
set(gca,'Xlim',[x_min - l_min/2,x_max + l_min/2]);
set(gca,'Ylim',[y_min - l_min/2,y_max + l_min/2]);
for i = 1:dy_num
    plot([jd(dy(i,1),1),jd(dy(i,2),1)],[jd(dy(i,1),2),jd(dy(i,2),2)],'black');
end
for i = 1:dy_num
    dyhz = 0;
    hzlx = 0;
    hzdx = 0;
    hzcd = 0;
    for j = 1:hz_num
        if hz(j,1) == 2
            if hz(j,2) == i
               dyhz = 1; 
               hzlx = hz(j,3);
               hzdx = hz(j,4);
               hzcd = hz(j,5);
            end
        end
    end
   To_wjt(dyhz,hzlx,hzdx,hzcd,l(i),Fe(2,i),-Fe(3,i),Fe(6,i),jd(dy(i,1),1),jd(dy(i,1),2),T(1,1,i),T(2,1,i),r_wj); 
end
title('弯矩图');
axis off;
 
