import os
from sympy import *
from numpy import pi, rad2deg, deg2rad, divide, linspace, squeeze, asarray
import matplotlib.pyplot as plt
from icecream import ic

os.system('clear')
init_printing()
print("Inverse Kinematics and Workspace Analysis of X-Y Pedestal\
     \nwith Joint and Pointing Misalignment - Python Script")
print("[Author: Bugra Coskun]")

# ------------------------------------------------------------------ FUNCTIONS

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

# Euler forms of sin and cos
euler_sin = lambda x : (exp(I*x) - exp(-I*x))/(I*2);
euler_cos = lambda x : (exp(I*x) + exp(-I*x))/2;


# ____________________________PRODUCE THE EQUATIONS___________________________

print("\n\n>> Producing the equations for X (PSI) and Y (PHI) angles...")

# ---------------------------------------------------------- SYMBOLIC VARIABLES
# Azimuth and elevation angles
alpha, beta = var('alpha, beta', real=True, positive=True)

# X and Y joint angles
psi, phi = var('psi, phi', real=True)

# Y joint and pointing angles (no misalignment -> pi/2)
zeta, gamma = var('zeta, gamma', real=True, positive=True)

x = Matrix([1, 0, 0])
p = sph2cart([zeta, gamma, 1])
w = Matrix([ cos(zeta), sin(zeta), 0 ])
l = sph2cart([-alpha, beta, 1])

# ------------------------------------------------------------------- FIND PHI
Rw = Rodri(w, phi)
y_eq = Eq( (Rw*p).dot(x) , l.dot(x) )
phi_eq = solve(y_eq.simplify(), phi)
print("\nPHI = \n")
pretty_print(phi_eq)

# --------------------------------------------------------- FIND PSI - COMPLEX
print("\n")

# The reverse rotation matrix to bring line of sight vector to the surface
# of the w axis.
Rx = Rodri(x, -psi)
x_eq = Eq( (Rx*l).dot(w) , p.dot(w) )
pprint(x_eq.simplify())

x_eq = x_eq.simplify()
# Euler forms of psi trigonometric functions
ecos_psi = euler_cos(psi)
esin_psi = euler_sin(psi)
esin_npsi = euler_sin(-psi)

# Substitute psi trigonometric functions for their Euler forms
x_eq_eu = x_eq.subs(cos(psi),ecos_psi)
x_eq_eu = x_eq_eu.subs(sin(psi),esin_psi)
x_eq_eu = x_eq_eu.subs(sin(-psi),esin_npsi)

psi_comp_eq = solve(x_eq_eu,psi)
psi_c0 = -psi_comp_eq[0].simplify() # Fixed with a negative

print("\nPSI_C0 = \n")
pprint(psi_c0)

input("Press Enter to continue...")

deq = diff(x_eq, alpha)
pprint(deq.simplify())
input("Press Enter to continue...")
dpsi_dalpha = diff(psi_c0, alpha)
pprint(dpsi_dalpha.simplify())
