from sympy import *
from numpy import pi, rad2deg, deg2rad, divide, linspace, squeeze, asarray
import numpy as np
from icecream import ic
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.axes_grid1 import make_axes_locatable

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
    #   if(im(err_ang) > 1e-7):
    #       print("WARNING!: ERROR COMPLEX ", err_ang)
    #       print("l vector = ", l_v)
    #       print("p vector = ", p_v)
    #       print("w vector = ", w_v)
    #       print("PSI ANGLE = ", psi_ang)
    #       print("PHI ANGLE = ", phi_ang)
    #       err_ang = 100
    return float(re(err_ang))

rzeta = deg2rad(90);
rgamma = deg2rad(90);

x_v = Matrix([1,0,0])
p_v = sph2cart([rzeta, rgamma, 1])
w_v = Matrix([ cos(rzeta), sin(rzeta), 0 ])

sim_res = 104

phase = 90
az_vals = np.linspace(-180 + phase, 180 + phase, sim_res)
el_vals = np.linspace(-90, 90, sim_res)

err_vals = np.zeros((len(el_vals), len(az_vals)))

for i, dbeta in enumerate(el_vals):
    for j, dalpha in enumerate(az_vals):
        ralpha = deg2rad(dalpha)
        rbeta = deg2rad(dbeta)
        l_v = sph2cart([-ralpha, rbeta, 1])
        phi_res = re(phi(ralpha,rbeta, rzeta, rgamma))
        psi_comp_res = re(psi_c0(ralpha, rbeta, rzeta, rgamma))
        ang_err_val = ang_err(psi_comp_res, phi_res,\
                x_v, w_v, p_v, l_v)
        err_vals[i,j] = rad2deg(ang_err_val)

plt.pcolormesh(az_vals, el_vals, err_vals, shading='auto')
cbar = plt.colorbar()
cbar.set_label('Error (Deg)', rotation=270, labelpad=15)
plt.xlabel('Azimuth (Deg)')
plt.ylabel('Elevation (Deg)')
plt.show()

fig = plt.figure()
ax = fig.add_subplot(111,projection='3d')
surface = ax.plot_surface(*np.meshgrid(az_vals, el_vals), err_vals,
                                cmap='viridis')

fig.colorbar(surface, ax=ax, shrink=0.5, aspect=5, pad = 0.1)
ax.set_xlabel('Azimuth (Deg)')
ax.set_ylabel('Elevation (Deg)')
ax.set_zlabel('Position Err. (Deg)')
plt.show()
