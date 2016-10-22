#coding:utf-8
import numpy as np

#自定义符号
sin = np.sin
cos = np.cos
tan = np.tan
arcsin = np.arcsin
arctan = np.arctan

#参数的输入
psi1 = 45 * np.pi / 180
alpha1 = 115 * np.pi / 180
psi2 = 70 * np.pi / 180
alpha2 = 235 * np.pi / 180
psi3 = 12 * np.pi / 180
alpha3 = 195 * np.pi / 180
psi4 = 65 * np.pi / 180
alpha4 = 185 * np.pi / 180
psi5 = 70 * np.pi / 180
alpha5 = 165 * np.pi / 180
H1 = 30.48 * 3.2808399
L = 12.19 * 3.2808399
c1 = 23.9 * 20.8854351
phi1 = 20 * np.pi / 180
c2 = 47.8 * 20.8854351
phi2 = 30 * np.pi / 180
gamma = 2.56 * 62.427961
gammaw = 62.427961
T = 0
E = 0
eta = 1

#求各个面的单位法向量
[ax, ay, az] = [sin(psi1) * sin(alpha1), sin(psi1) * cos(alpha1), cos(psi1)]
[bx, by, bz] = [sin(psi2) * sin(alpha2), sin(psi2) * cos(alpha2), cos(psi2)]
[dx, dy, dz] = [sin(psi3) * sin(alpha3), sin(psi3) * cos(alpha3), cos(psi3)]
[fx, fy, fz] = [sin(psi4) * sin(alpha4), sin(psi4) * cos(alpha4), cos(psi4)]
[f5x, f5y, f5z] = [sin(psi5) * sin(alpha5), sin(psi5) * cos(alpha5), cos(psi5)]

#求交线的方向向量
[gx, gy, gz] = [fy * az - fz * ay, fz * ax - fx * az, fx * ay - fy * ax]
[g5x, g5y, g5z] = [f5y * az - f5z * ay, f5z * ax - f5x * az, f5x * ay - f5y * ax]
[ix, iy, iz] = [by * az - bz * ay, bz * ax - bx * az, bx * ay - by * ax]
[jx, jy, jz] = [fy * dz - fz * dy, fz * dx - fx * dz, fx * dy - fy * dx]
[j5x, j5y, j5z] = [f5y * dz - f5z * dy, f5z * dx - f5x * dz, f5x * dy - f5y * dx]
[kx, ky, kz] = [iy * bz - iz * by, iz * bx - ix * bz, ix * by - iy * bx]
[lx, ly, lz] = [ay * iz - az * iy, az * ix - ax * iz, ax * iy - ay * ix]

#相关系数的计算
m = gx * dx + gy * dy + gz * dz
m5 = g5x * dx + g5y * dy + g5z * dz
n = bx * jx + by * jy + bz * jz
n5 = bx * j5x + by * j5y + bz * j5z
p = ix * dx + iy * dy + iz * dz
q = bx * gx + by * gy + bz * gz
q5 = bx * g5x + by * g5y + bz * g5z
r = ax * bx + ay * by + az * bz
s5 = ax * f5x + ay * f5y + az * f5z
v5 = bx * f5x + by * f5y + bz * f5z
w5 = ix * f5x + iy * f5y + iz * f5z
lamda = ix * gx + iy * gy + iz * gz
lamda5 = ix * g5x + iy * g5y + iz * g5z
epsilon = fx * f5x + fy * f5y + fz * f5z

R = (1 - r ** 2) ** 0.5
rho = n * q / (R ** 2 * abs(n * q))
mu = m * q / (R ** 2 * abs(m * q))
upsilon = p / (R * abs(p))
G = gx ** 2 + gy ** 2 + gz ** 2
G5 = g5x ** 2 + g5y ** 2 + g5z ** 2
M = (G * p ** 2 - 2 * m * p * lamda + m ** 2 * R ** 2) ** 0.5
M5 = (G5 * p ** 2 - 2 * m5 * p * lamda5 + m5 ** 2 * R ** 2) ** 0.5
h = H1 / abs(gz)
h5 = (M * h - abs(p) * L) / M5
B = (tan(phi1) ** 2 + tan(phi2) ** 2 - 2 * (mu * r / rho) * tan(phi1) * tan(phi2)) / (R ** 2)

#计算楔形体的面积和重量
A1 = (abs(m * q) * h ** 2 - abs(m5 * q5) * h5 ** 2) / (2 * abs(p))
A2 = (abs(q / n) * m ** 2 * h ** 2 - abs(q5 / n5) * m5 ** 2 * h5 ** 2) / (2 * abs(p))
A5 = abs(m5 * q5) * h5 ** 2 / (2 * abs(n5))
W = gamma * (q ** 2 * m ** 2 *h ** 3 / abs(n) - q5 ** 2 * m5 ** 2 * h5 ** 3 / abs(n5)) / (6 * abs(p))

#分情况计算水压力，进而求出FS
def wet():
	u1 = u2 = u5 = gammaw * h5 * abs(m5) / (3 * dz)
	V = u5 * A5 * eta * epsilon / (abs(epsilon))
	N1 = rho * (W * kz + V * (r * v5 - s5)) - u1 * A1
	N2 = mu * (W * lz + V * (r * s5 - v5)) - u2 * A2
	S = upsilon * (W * iz - V * w5)
	Q = N1 *tan(phi1) + N2 * tan(phi2) + c1 * A1 + c2 * A2
	FS = Q / S
	return FS
	
def dry():
	u1 = u2 = u5 = 0
	V = u5 * A5 * eta * epsilon / (abs(epsilon))
	N1 = rho * (W * kz + V * (r * v5 - s5)) - u1 * A1
	N2 = mu * (W * lz + V * (r * s5 - v5)) - u2 * A2
	S = upsilon * (W * iz - V * w5)
	Q = N1 *tan(phi1) + N2 * tan(phi2) + c1 * A1 + c2 * A2
	FS3 = Q / S
	return FS3

#输出结果
FS = wet()
FS3 = dry()
print("wet:FS = ", FS)
print("dry:FS3 = ", FS3)