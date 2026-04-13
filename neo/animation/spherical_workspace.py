import matplotlib.pyplot as plt
from sympy import *
import numpy as np
from numpy import deg2rad, rad2deg
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import griddata

def sph2cart(sp):
    # Spherical to cartesian vector transformation
    vect = Matrix([\
        sp[2]*cos(sp[1])*cos(sp[0]), \
         sp[2]*cos(sp[1])*sin(sp[0]),\
         sp[2]*sin(sp[1])])
    return vect

def Rodri(k, ang):
    # Rodrigues rotation matrix
    K = Matrix([ [ 0, -k[2], k[1] ],\
                 [ k[2], 0, -k[0] ],\
                 [ -k[1], k[0], 0 ] ])

    Rv = eye(3) + sin(ang)*K + (1-cos(ang))*K**2;
    return Rv

def psi_r(alpha,beta,zeta,gamma,phi):
    psi_res = asin((-(sin(gamma)*sin(phi)*cos(zeta) -\
    sin(zeta)*cos(gamma))*sin(beta) +\
    sin(alpha)*sin(gamma)*cos(beta)*cos(phi))/\
    (sqrt(-cos(alpha)**2*cos(beta)**2 + 1)*\
    sqrt((sin(gamma)*sin(phi)*cos(zeta) -\
    sin(zeta)*cos(gamma))**2 +\
    sin(gamma)**2*cos(phi)**2)))
    return float(psi_res.evalf())

def psi_c0(alpha, beta, zeta, gamma):
    psi_res = I*log((-sqrt(cos(alpha)**2*cos(beta)**2 -\
    2*cos(alpha)*cos(beta)*cos(gamma)*cos(zeta) +\
    cos(gamma)**2 + cos(zeta)**2 - 1) +\
    cos(alpha)*cos(beta)*cos(zeta) -\
    cos(gamma))/((sin(alpha)*cos(beta) -\
    I*sin(beta))*sin(zeta)))
    evalv_psi = psi_res.evalf()
    #print("PSI = ",end=''); pprint(evalv_psi)
    return float(re(evalv_psi))

def phi(alpha, beta, zeta, gamma):
    phi_eq = asin((cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta)))
    phi_eval = phi_eq.evalf()
    phi_res = re(phi_eval)
    return float(phi_res)

def ang_err(psi_ang, phi_ang, x_v, w_v, p_v, l_v):
    res_p = Rodri(x_v, psi_ang)*Rodri(w_v, phi_ang)*p_v
    err_ang = (acos(l_v.dot(res_p))).evalf()
    return float(re(err_ang))

fig = plt.figure()
ax = fig.add_subplot(projection='3d')

# Make data
sim_res = 28
az = np.linspace(-np.pi, np.pi, sim_res)
el = np.linspace(-np.pi/2, np.pi/2, sim_res)
err_vals= np.zeros((len(el), len(az)))

rzeta = deg2rad(86);
rgamma = deg2rad(82);

x_v = Matrix([1,0,0])
p_v = sph2cart([rzeta, rgamma, 1])
w_v = Matrix([ cos(rzeta), sin(rzeta), 0 ])

for i, rbeta in enumerate(el):
    for j, ralpha in enumerate(az):
        l_v = sph2cart([-ralpha, rbeta, 1])
        phi_res = re(phi(ralpha,rbeta, rzeta, rgamma))
        psi_comp_res = re(psi_c0(ralpha, rbeta, rzeta, rgamma))
        ang_err_val = ang_err(psi_comp_res, phi_res,\
                x_v, w_v, p_v, l_v)
        err_vals[i,j] = 1 #exp(-ang_err_val*1e+3)


x = err_vals * np.cos(el) * np.cos(az)
y = err_vals * np.cos(el) * np.sin(az)
z = err_vals * np.sin(el)

surface = ax.plot_surface(x, y, z, cmap='viridis')
plt.show()
surface = ax.plot_surface(np.meshgrid(x, y), err_vals, cmap='viridis')
plt.show()

