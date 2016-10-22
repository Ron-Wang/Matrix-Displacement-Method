%根据单元长度、EA、EI计算局部坐标系的单元刚度矩阵
function ke = to_ke(EA,EI,l)
gd1 = EA / l;
gd2 = 12 * EI / (l ^ 3);
gd3 = 6 * EI / (l ^ 2);
gd4 = 4 * EI / l;
ke = [gd1,0,0,-gd1,0,0;
    0,gd2,gd3,0,-gd2,gd3;
    0,gd3,gd4,0,-gd3,gd4 / 2;
    -gd1,0,0,gd1,0,0;
    0,-gd2,-gd3,0,gd2,-gd3;
    0,gd3,gd4 / 2,0,-gd3,gd4];