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

def PSI(alpha, beta, zeta, gamma):
    psi_res = 1j*np.log((-np.sqrt(np.cos(alpha)**2*np.cos(beta)**2 -\
    2*np.cos(alpha)*np.cos(beta)*np.cos(gamma)*np.cos(zeta) +\
    np.cos(gamma)**2 + np.cos(zeta)**2 - 1 + 0j) +\
    np.cos(alpha)*np.cos(beta)*np.cos(zeta) -\
    np.cos(gamma))/((np.sin(alpha)*np.cos(beta) -\
    1j*np.sin(beta))*np.sin(zeta)), dtype=np.complex256)
    return np.real(psi_res)# + imag(psi_res)

def PHI(alpha, beta, zeta, gamma):
    phi_res = np.arcsin((cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta)) + 0j, dtype=np.complex256)
    return real(phi_res)

def ang_err(psi_ang, phi_ang, x_v, w_v, p_v, l_v):
    res_p = np.matmul(Rodri(x_v, psi_ang),np.matmul(Rodri(w_v, phi_ang),p_v))
    dotslp = np.dot(l_v, res_p)/(np.linalg.norm(l_v)*np.linalg.norm(res_p))
    err_ang = np.arccos(dotslp - 2e-16, dtype=np.float128)
    return real(err_ang)


rzeta = np.float128(np.pi/2-0.1)
rgamma = np.float128(np.pi/2-0.1)
single_az = np.float128(0)
single_el = np.float128(np.pi/4)

x_v = np.array([1,0,0], dtype=np.float128)
p_v = sph2cart(np.array([rzeta, rgamma, 1], dtype=np.float128))
w_v = np.array([ cos(rzeta), sin(rzeta), 0 ], dtype=np.float128)

#################################### {alpha, beta} --> {phi, psi} Scalar field
grid_precision = 0.001

az_offset = np.pi/4
ab = [0 - az_offset, 2*np.pi - az_offset] # Azimuth boundaries
da = 1e-3
alpha_line = np.arange(ab[0], ab[1], da) 

bb = [-np.pi/2, np.pi/2] # Elevation boundaries
db = 1e-3
beta_line = np.arange(bb[0], bb[1], db)

# Scalar sqrt( phi^2 + psi^2 ) field
F = np.zeros((len(beta_line), len(alpha_line))) 
print(np.shape(F))

#   for i, az_rad in enumerate(alpha_line):
#       for j, el_rad in enumerate(beta_line):
#           phi0 = PHI(az_rad, el_rad, rzeta, rgamma)
#           psi0 = PSI(az_rad, el_rad, rzeta, rgamma)
#           F[j,i] = np.sqrt(phi0**2 + psi0**2)

ic(np.shape(alpha_line))
ic(np.shape(beta_line))

A, B = np.meshgrid(alpha_line, beta_line)

phi_arr = PHI(A, B, rzeta, rgamma); ic(np.shape(phi_arr))

psi_arr = PSI(A, B, rzeta, rgamma); ic(np.shape(psi_arr))

Z = np.sqrt(np.square(phi_arr) + np.square(psi_arr))

ic(np.shape(Z))

grad_a, grad_b = np.gradient(Z, beta_line, alpha_line)
normgrad = np.sqrt( np.square(grad_a) + np.square(grad_b) )

ic(np.shape(normgrad))

input("Press Enter to Continue")

#   plt.pcolormesh(alpha_line, beta_line, normgrad)
#   cbar = plt.colorbar()
#   cbar.set_label('Error (Rad)', rotation=270, labelpad=15)
#   plt.xlabel('Azimuth (Rad)')
#   plt.ylabel('Elevation (Rad)')
#   plt.title("Complex PSI")
#   plt.show()

# Create a 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the surface
surf = ax.plot_surface(A, B, normgrad, cmap='viridis')

# Add labels and a color bar
ax.set_xlabel('X-axis')
ax.set_ylabel('Y-axis')
ax.set_zlabel('Z-axis')
fig.colorbar(surf, ax=ax, shrink=0.5, aspect=10)

# Show the plot
plt.show()
