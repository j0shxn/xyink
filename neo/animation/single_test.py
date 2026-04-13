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
    #   if(im(phi_eval) > 1e-9):
    #       print("ERROR PHI OUT OF BOUND", phi_eval)
    #       print("at azimuth and elevation: ", rad2deg(alpha), rad2deg(beta))
    #       phi_res = re(phi_eval)
    #   else:
    #       phi_res = phi_eval
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

psi_comp_res = re(psi_c0(pi/4, pi/4, pi/2, pi/2))
print(psi_comp_res)
phi_res = re(phi(pi/4, pi/4, pi/2, pi/2))
print(phi_res)

input("press enter to continue")

rzeta = deg2rad(88);
rgamma = deg2rad(85);
#rzeta = deg2rad(85);
#rgamma = deg2rad(85);

x_v = Matrix([1,0,0])
p_v = sph2cart([rzeta, rgamma, 1])
w_v = Matrix([ cos(rzeta), sin(rzeta), 0 ])

sim_res = 24

# Reachability boundary angles
delta_p = rad2deg(rzeta - rgamma) + 1
delta_n = rad2deg(pi - rzeta - rgamma) + 1

# Positive reachability boundary
az_vals_p = np.linspace(-delta_p, delta_p, sim_res)
el_vals_p = np.linspace(-delta_p, delta_p, sim_res)

err_vals_p = np.zeros((len(el_vals_p), len(az_vals_p)))

for i, y in enumerate(el_vals_p):
    for j, x in enumerate(az_vals_p):
        ralpha = deg2rad(x);
        rbeta = deg2rad (y);
        l_v = sph2cart([-ralpha, rbeta, 1])
        phi_res = re(phi(ralpha,rbeta, rzeta, rgamma))
        psi_comp_res = re(psi_c0(ralpha, rbeta, rzeta, rgamma))
        ang_err_val = ang_err(psi_comp_res, phi_res,\
                x_v, w_v, p_v, l_v)
        err_vals_p[i,j] = rad2deg(ang_err_val)

fig = plt.figure()
ax = fig.add_subplot(111,projection='3d')
surface = ax.plot_surface(*np.meshgrid(az_vals_p, el_vals_p), err_vals_p,
                                cmap='viridis')

fig.colorbar(surface, ax=ax, shrink=0.5, aspect=5, pad = 0.1)
ax.set_xlabel('Azimuth (Deg)')
ax.set_ylabel('Elevation (Deg)')
ax.set_zlabel('Position Err. (Deg)')
plt.show()

# Negative reachability boundary
az_vals_n = np.linspace(180-delta_n, 180+delta_n, sim_res)
el_vals_n = np.linspace(-delta_n, delta_n, sim_res)

err_vals_n = np.zeros((len(el_vals_n), len(az_vals_n)))

for i, y in enumerate(el_vals_n):
    for j, x in enumerate(az_vals_n):
        ralpha = deg2rad(x);
        rbeta = deg2rad (y);
        l_v = sph2cart([-ralpha, rbeta, 1])
        phi_res = re(phi(ralpha,rbeta, rzeta, rgamma))
        psi_comp_res = re(psi_c0(ralpha, rbeta, rzeta, rgamma))
        ang_err_val = ang_err(psi_comp_res, phi_res,\
                x_v, w_v, p_v, l_v)
        err_vals_n[i,j] = rad2deg(ang_err_val)

#   # Create a 3D plot
#
#   psi_comp_res = re(psi_c0(ralpha, rbeta, rzeta, rgamma))
#   fig = plt.figure()
#   ax = fig.add_subplot(111, projection='3d')
#
#   # Create a meshgrid for x and y
#   x_mesh, y_mesh = np.meshgrid(x_values, y_values)
#
#   # Plot the surface
#   surface = ax.plot_surface(x_mesh, y_mesh, z_values, cmap='viridis')
#
#   # Add labels
#   ax.set_xlabel('Azimuth (Degrees)')
#   ax.set_ylabel('Elevation(Degrees)')
#   ax.set_zlabel('Angle (Degree) Error')
#   #ax.title("Angular Position Error")
#
#   # Add a colorbar
#   fig.colorbar(surface, ax=ax, shrink=0.5, aspect=10)
#
#   # Show the plot
#   plt.show()

axes[0].set_title('X-Positive Workspace Boundary')
# Create subplots with 1 row and 2 columns
fig, axes = plt.subplots(1, 2, figsize=(12, 5), subplot_kw={'projection':
                                                            '3d'})

# Plot the first surface
surface1 = axes[0].plot_surface(*np.meshgrid(az_vals_p, el_vals_p), err_vals_p,
                                cmap='viridis') 
axes[0].set_title('X-Positive Workspace Boundary')

# Plot the second surface
surface2 = axes[1].plot_surface(*np.meshgrid(az_vals_n, el_vals_n), err_vals_n,
                                cmap='viridis')
axes[1].set_title('X-Negative Workspace Boundary')

# Add labels to the subplots
for ax in axes:
    ax.set_xlabel('Az. (Deg)')
    ax.set_ylabel('El. (Deg)')
    ax.set_zlabel('Err. (Deg)')

# Adjust layout for better spacing, including space for the colorbar
plt.subplots_adjust(wspace=0.4)

# Create a single colorbar for both plots (horizontal)
# Add colorbars
cbar0 = fig.colorbar(surface1, ax=axes[0], shrink=0.5, aspect=10)
cbar1 = fig.colorbar(surface2, ax=axes[1], shrink=0.5, aspect=10)
cbar0.set_label('Error Value')
# Adjust layout for better spacing
plt.tight_layout()

# Show the plots
plt.show()
