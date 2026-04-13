#from numpy import cos, sin, arcsin, log, sqrt, array, eye, real, dot, norm
from sympy import *
from numpy import pi, rad2deg, deg2rad, divide, linspace, squeeze, asarray
from icecream import ic
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

# --------------------------------------------------------------- CALCULATIONS

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

#   def psi(alpha, beta, zeta, gamma):
#       psi_res = -1j*log((sqrt(cos(alpha)**2*cos(beta)**2 -\
#           2*cos(alpha)*cos(beta)*cos(gamma)*cos(zeta) +\
#           cos(gamma)**2 + cos(zeta)**2 - 1 + 0j) +\
#           cos(alpha)*cos(beta)*cos(zeta) -\
#           cos(gamma))/( (sin(alpha)*cos(beta) -\
#           1j*sin(beta))*sin(zeta)))
#
#       return float(re(psi_res.evalf()))

def psi_c0(alpha, beta, zeta, gamma):
    psi_res = I*log((-sqrt(cos(alpha)**2*cos(beta)**2 -\
    2*cos(alpha)*cos(beta)*cos(gamma)*cos(zeta) +\
    cos(gamma)**2 + cos(zeta)**2 - 1) +\
    cos(alpha)*cos(beta)*cos(zeta) -\
    cos(gamma))/((sin(alpha)*cos(beta) -\
    I*sin(beta))*sin(zeta)))
    evalv_psi = psi_res.evalf()
    print("PSI = ",end=''); pprint(evalv_psi)
    return float(re(evalv_psi))

def psi_r(alpha,beta,zeta,gamma,phi):
    psi_res = asin((-(sin(gamma)*sin(phi)*cos(zeta) -\
    sin(zeta)*cos(gamma))*sin(beta) +\
    sin(alpha)*sin(gamma)*cos(beta)*cos(phi))/\
    (sqrt(-cos(alpha)**2*cos(beta)**2 + 1)*\
    sqrt((sin(gamma)*sin(phi)*cos(zeta) -\
    sin(zeta)*cos(gamma))**2 +\
    sin(gamma)**2*cos(phi)**2)))
    return float(psi_res.evalf())

def phi(alpha, beta, zeta, gamma):
    before_asin = (cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta))
    ic(before_asin)
    phi_res = asin((cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta)))
    evalv_phi = phi_res.evalf()
    print("PHI = ",end=''); pprint(evalv_phi)
    return float(evalv_phi)

# ----------------------------------------------------------------- ANIMATIONS


def set_box_aspect(ax, aspect_ratio):
    # Set the aspect ratio of the plot box
    xmin, xmax = ax.get_xlim3d()
    ymin, ymax = ax.get_ylim3d()
    zmin, zmax = ax.get_zlim3d()

    ax.set_box_aspect([1, 1, aspect_ratio * (xmax - xmin) / (zmax - zmin)])

def plot_wireframe_half_sphere(ax, radius=1,\
        num_samples=100, aspect_ratio=1.0):

    phi = np.linspace(0, np.pi/2, num_samples)
    theta = np.linspace(0, 2 * np.pi, num_samples)

    phi, theta = np.meshgrid(phi, theta)

    x = radius * np.sin(phi) * np.cos(theta)
    y = radius * np.sin(phi) * np.sin(theta)
    z = radius * np.cos(phi)

    ax.plot_wireframe(x, y, z, color='gray', linewidth=0.3)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_title('X-Y Pedestal Kinematics')

    set_box_aspect(ax, aspect_ratio)  # Adjust the aspect ratio

def plotVec(ax, x_v, y_v, z_v, the_color, lw=1, ratio=0.1):
    ax.quiver(0, 0, 0, x_v, y_v, z_v, color=the_color, linewidth=lw,\
            label='Vector', arrow_length_ratio=ratio)

def showWorkspace(zeta, gamma, ax, space_res=100):

    plot_wireframe_half_sphere(ax, radius=1, num_samples=100,\
            aspect_ratio=0.25)

    x_v = Matrix([1,0,0])
    p_v = sph2cart([zeta, gamma, 1])
    w_v = Matrix([ cos(zeta), sin(zeta), 0 ])

    plotVec(ax, 0, 1, 0, 'black', 1, 0) # Y basis
    plotVec(ax, 0, 0, 1, 'black', 1, 0) # Z basis
    plotVec(ax, x_v[0], x_v[1], x_v[2], 'black', 2, 0.2) # X basis/joint vector
    plotVec(ax, p_v[0], p_v[1], p_v[2], 'black') # Pointing vector
    plotVec(ax, w_v[0], w_v[1], w_v[2], 'black') # Y joint vector

    psi_vals = np.linspace(-pi, pi, space_res)
    phi_vals = np.linspace(-pi, pi, space_res)
    phi_vals = np.array([-pi/2, pi/2])

    for i, rpsi in enumerate(psi_vals):
        Rx = Rodri(x_v, rpsi)
        for i, rphi in enumerate(phi_vals):
            Rw = Rodri(w_v, rphi)
            p_star = Rw * p_v
            p_res = Rx * p_star
            plotVec(ax, p_res[0], p_res[1], p_res[2], 'red', 1, 0)
            #ax.scatter(p_res[0], p_res[1], p_res[2])
            

    plt.show()


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

rzeta = deg2rad(88)
rgamma = deg2rad(85)

showWorkspace(rzeta, rgamma, ax, space_res=50)
