from numpy import pi, rad2deg, deg2rad, divide, linspace, squeeze, asarray
from numpy import sin, arcsin, cos, arccos, tan, arctan, log, sqrt, real, imag
import numpy as np
from icecream import ic
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.axes_grid1 import make_axes_locatable

# Set default data type for output
np.set_printoptions(precision=18, 
                    formatter={'float_kind': lambda x: "{:.18f}".format(x)})
np.seterr(over='warn')

def sph2cart(sp):
    # Spherical to cartesian vector transformation
    vect = np.array([\
        sp[2]*cos(sp[1])*cos(sp[0]), \
         sp[2]*cos(sp[1])*sin(sp[0]),\
         sp[2]*sin(sp[1])], dtype=np.float128)
    return vect

def Rodri(k, ang):
    # Rodrigues rotation matrix
    K = np.array([ [ 0, -k[2], k[1] ],\
                 [ k[2], 0, -k[0] ],\
                 [ -k[1], k[0], 0 ] ], dtype=np.float128)

    Rv = np.eye(3) + sin(ang)*K + (1-cos(ang))*np.linalg.matrix_power(K,2);
    return Rv

def psi_c0(alpha, beta, zeta, gamma):
    psi_res = 1j*np.log((-np.sqrt(np.cos(alpha)**2*np.cos(beta)**2 -\
    2*np.cos(alpha)*np.cos(beta)*np.cos(gamma)*np.cos(zeta) +\
    np.cos(gamma)**2 + np.cos(zeta)**2 - 1 + 0j) +\
    np.cos(alpha)*np.cos(beta)*np.cos(zeta) -\
    np.cos(gamma))/((np.sin(alpha)*np.cos(beta) -\
    1j*np.sin(beta))*np.sin(zeta)), dtype=np.complex256)
    return np.real(psi_res)# + imag(psi_res)

#   def psi_r(alpha,beta,zeta,gamma,phi):
#       psi_res = np.arcsin((-(np.sin(gamma)*np.sin(phi)*np.cos(zeta) -\
#       np.sin(zeta)*np.cos(gamma))*np.sin(beta) +\
#       np.sin(alpha)*np.sin(gamma)*np.cos(beta)*np.cos(phi))/\
#       (np.sqrt(-np.cos(alpha)**2*np.cos(beta)**2 + 1)*\
#       np.sqrt((np.sin(gamma)*np.sin(phi)*np.cos(zeta) -\
#       np.sin(zeta)*np.cos(gamma))**2 +\
#       np.sin(gamma)**2*np.cos(phi)**2)) + 0j, dtype=np.complex256)
#       return np.real(psi_res)

def phi(alpha, beta, zeta, gamma):
    phi_res = np.arcsin((cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta)) + 0j, dtype=np.complex256)
    return real(phi_res)

def ang_err(psi_ang, phi_ang, x_v, w_v, p_v, l_v):
    res_p = np.matmul(Rodri(x_v, psi_ang),np.matmul(Rodri(w_v, phi_ang),p_v))
    dotslp = np.dot(l_v, res_p)/(np.linalg.norm(l_v)*np.linalg.norm(res_p))
    err_ang = np.arccos(dotslp - 2e-16, dtype=np.float128)
    return real(err_ang)


rzeta = np.float128(np.pi/2)
rgamma = np.float128(np.pi/2)
single_az = np.float128(0)
single_el = np.float128(np.pi/4)

x_v = np.array([1,0,0], dtype=np.float128)
p_v = sph2cart(np.array([rzeta, rgamma, 1], dtype=np.float128))
w_v = np.array([ cos(rzeta), sin(rzeta), 0 ], dtype=np.float128)

Rx_1 = Rodri(x_v, 1)
Rw_2 = Rodri(w_v, 2)

#   later_mat = np.matmul(Rw_2, np.matmul(Rx_1, p_v))
#   first_mat = np.matmul(np.matmul(Rw_2, Rx_1), p_v)
#   ic(later_mat)
#   ic(first_mat)

phi_res = phi(0, np.pi/4, rzeta, rgamma)
psi_res = psi_c0(0, np.pi/4, rzeta, rgamma)
l_v = sph2cart([0, np.pi/4, 1])
err = ang_err(psi_res, phi_res, x_v, w_v, p_v, l_v)

ic(rad2deg(phi_res))
ic(rad2deg(psi_res))
ic(l_v)
ic(rad2deg(real(err)))

input("Press Enter to Continue")

sim_res = 208

phase = np.pi/2
az_vals = np.linspace(-np.pi + phase, np.pi + phase, sim_res)
el_vals = np.linspace(-np.pi/2, np.pi/2, sim_res)

err_vals = np.zeros((len(el_vals), len(az_vals)), dtype=np.float128)
err_vals_real = np.zeros((len(el_vals), len(az_vals)), dtype=np.float128)
largest_error = 0
largest_error_pos = [0,0]
largest_error_real = 0
largest_error_real_pos = [0,0]
for i, rbeta in enumerate(el_vals):
    for j, ralpha in enumerate(az_vals):
        l_v = sph2cart([-ralpha, rbeta, 1])
        phi_res = phi(ralpha,rbeta, rzeta, rgamma)
        psi_comp_res = psi_c0(ralpha, rbeta, rzeta, rgamma)
        psi_real_res = psi_r(ralpha, rbeta, rzeta, rgamma, phi_res)
        ang_err_val = ang_err(psi_comp_res, phi_res,\
                x_v, w_v, p_v, l_v)
        ang_err_val_real = ang_err(psi_real_res, phi_res,\
                x_v, w_v, p_v, l_v)

        if largest_error < ang_err_val:
            largest_error = ang_err_val;
            largest_error_pos = [ralpha, rbeta]
        if largest_error_real < ang_err_val_real:
            largest_error_real = ang_err_val_real;
            largest_error_real_pos = [ralpha, rbeta]

        err_vals[i,j] = ang_err_val
        err_vals_real[i,j] = ang_err_val_real

ic(rad2deg(largest_error))
ic(rad2deg(largest_error_pos))
ic(rad2deg(largest_error_real))
ic(rad2deg(largest_error_real_pos))

plt.pcolormesh(az_vals, el_vals, np.abs(err_vals), shading='auto')
cbar = plt.colorbar()
cbar.set_label('Error (Rad)', rotation=270, labelpad=15)
plt.xlabel('Azimuth (Rad)')
plt.ylabel('Elevation (Rad)')
plt.title("Complex PSI")
plt.show()

plt.pcolormesh(real(az_vals), real(el_vals), np.abs(err_vals_real), shading='auto')
cbar = plt.colorbar()
cbar.set_label('Error (Rad)', rotation=270, labelpad=15)
plt.xlabel('Azimuth (Rad)')
plt.ylabel('Elevation (Rad)')
plt.title("Real PSI")
plt.show()

