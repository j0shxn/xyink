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

# --------------------------------------------------------- FIND PHI - COMPLEX
Rw = Rodri(w, phi)
y_eq = Eq( (Rw*p).dot(x) , l.dot(x) )

y_comp = y_eq.subs(cos(phi), euler_cos(phi))
y_comp = y_comp.subs(sin(phi), euler_sin(phi))

phi_C = solve(y_comp.simplify(), phi)
phi_C0 = phi_C[0].simplify()
phi_C1 = phi_C[1].simplify()

print("\nPHI_COMP = \n")
pretty_print(phi_C0)

# ------------------------------------------------------------ FIND PHI - REAL
phi_R = solve(y_eq.simplify(), phi)
print("\nPHI_REAL = \n")
pretty_print(phi_R)

# --------------------------------------------------------- FIND PSI - COMPLEX
print("\n")

# The reverse rotation matrix to bring line of sight vector to the surface
# of the w axis.
Rx = Rodri(x, -psi)
x_eq = Eq( (Rx*l).dot(w) , p.dot(w) )

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
psi_ceq_0 = psi_comp_eq[0].simplify()
psi_ceq_1 = psi_comp_eq[1].simplify()

print("\nPSI_C0 = \n")
pprint(psi_ceq_0)

#print("\nPSI_C1 = \n")
#pretty_print(psi_ceq_1)

# -------------------------------------------------------- FIND PSI - VECTOR A.
print("\n>> Finding the PSI equation through vector analysis...\n")
p_s = Rw*p
pcx = p_s.cross(x)
lcx = l.cross(x)

psi_vec = (pcx/pcx.norm()).cross(lcx/lcx.norm())
psi_req = (asin(psi_vec.dot(x))).simplify()
print("PSI_R = \n")
pprint(psi_req)

input("Press Enter to continue...")
# _______________________________TEST EQUATIONS________________________________

print("\n\n>> Testing the produced equations...\n")

# Sweep through these values and compare the errors
AZ = linspace(1, 359, 10)
EL = linspace(-89, 89, 10)
jodeg = 85
podeg = 85

cnt = 0

Err_R = []; Err_C0 = []; Err_C1 = [];
Sqs_err_R = []; Sqs_err_C0 = []; Sqs_err_C1 = [];


for azdeg in AZ:
    for eldeg in EL:

        print(">> Run: \n", cnt)
        print("[ Azimuth: ", azdeg, end=' | ')
        print("Elevation: ", eldeg, end=' | ')
        print("Joint Angle: ", jodeg, end=' | ')
        print("Pointing Angle: ", podeg, end=' ]\n')

        ralpha = deg2rad(azdeg)
        rbeta = deg2rad(eldeg)
        rlambda = deg2rad(jodeg)
        rgamma = deg2rad(podeg)

# --------------------------------- Create functions from the solved equations

        #Phi real function
        phi_ref = lambdify([alpha, beta, zeta, gamma], phi_eq[1])

        #Psi real function
        psi_ref = lambdify([alpha, beta, zeta, gamma, phi], psi_req)

# --------------------------------- Create functions from the solved equations

        print('\n')
        phi_res = phi_ref(ralpha, rbeta, rlambda, rgamma)
        ic(phi_res)
        phi_deg = rad2deg(phi_res) # PHI result from real function
        print('PHI = ', phi_deg)

        psi_res_R = psi_ref(ralpha, rbeta, rlambda, rgamma, phi_deg)
        ic(psi_res_R)
        psi_deg_R = rad2deg(psi_res_R) # PSI result from real function
        print('PSI_R = ', psi_deg_R)

        psi_ceq_0_0 = psi_ceq_0.subs(alpha,ralpha)
        psi_ceq_0_1 = psi_ceq_0_0.subs(beta,rbeta)
        psi_ceq_0_2 = psi_ceq_0_1.subs(zeta,rlambda)
        psi_ceq_0_3 = psi_ceq_0_2.subs(gamma,rgamma)
        psi_res_C0 = (psi_ceq_0_3.simplify()).evalf()
        psi_res_C0_RE = float(re(psi_res_C0))
        psi_deg_C0 = rad2deg( psi_res_C0_RE ) # PSI result from complex 0
        print('PSI_C0 = ', psi_deg_C0)

        psi_ceq_1_0 = psi_ceq_1.subs(alpha,ralpha)
        psi_ceq_1_1 = psi_ceq_1_0.subs(beta,rbeta)
        psi_ceq_1_2 = psi_ceq_1_1.subs(zeta,rlambda)
        psi_ceq_1_3 = psi_ceq_1_2.subs(gamma,rgamma)
        psi_res_C1 = (psi_ceq_1_3.simplify()).evalf()
        psi_res_C1_RE = float(re(psi_res_C1))
        psi_deg_C1 = rad2deg( psi_res_C1_RE ) # PSI result from complex 1
        print('PSI_C1 = ', psi_deg_C1)

# ----------------------------------- Produce rotations and compare with l vec

        vl = l.subs(alpha,ralpha)
        vl = vl.subs(beta,rbeta)
        vl = vl.evalf()
        print('vl = ', end=''); pprint(vl.T)

        vp = p.subs(zeta, rlambda)
        vp = vp.subs(gamma, rgamma)
        vp = vp.evalf()
        print('vp = ', end=''); pprint(vp.T)

        vw = w.subs(zeta, rlambda)
        vw = vw.evalf()
        print('vw = ', end=''); pprint(vw.T)

        Rw = Rodri(vw, pi - phi_res)
        Rx_R = Rodri(x, psi_res_R)
        Rx_C0 = Rodri(x, -psi_res_C0_RE)
        Rx_C1 = Rodri(x, -psi_res_C1_RE)

        err_R = divide((vl - Rx_R*Rw*vp),vl) # Relative error
        Err_R.append( err_R );
        print('\nUsing PSI_R Error %: '); pprint(err_R)
        # Square and sum the errors and all axes
        err_R_arr = squeeze(asarray(err_R)) # Turn into array
        sqs_err_R = err_R_arr.dot(err_R_arr) # Squared some of relative error
        Sqs_err_R.append(sqs_err_R)

        err_C0 = divide((vl - Rx_C0*Rw*vp),vl) # Relative error
        Err_C0.append( err_C0 );
        print('\nUsing PSI_C0 Error %: '); pprint(err_C0)
        # Square and sum the errors and all axes
        err_C0_arr = squeeze(asarray(err_C0)) # Turn into array
        sqs_err_C0 = err_C0_arr.dot(err_C0_arr) # Squared sum of relative error
        Sqs_err_C0.append(sqs_err_C0)

        err_C1 = divide((vl - Rx_C1*Rw*vp),vl) # Relative error
        Err_C1.append( err_C1 );
        print('\nUsing PSI_C1 Error %: '); pprint(err_C1)
        # Square and sum the errors and all axes
        err_C1_arr = squeeze(asarray(err_C1)) # Turn into array
        sqs_err_C1 = err_C1_arr.dot(err_C1_arr) # Squared sum of relative error
        Sqs_err_C1.append(sqs_err_C1)

        cnt = cnt + 1

plt.plot(range(0,cnt), Sqs_err_R, 'r--', label='PSI_R')
plt.plot(range(0,cnt), Sqs_err_C0, 'black', label='PSI_C0')
plt.plot(range(0,cnt), Sqs_err_C1, 'blue', label='PSI_C1')
plt.legend()
plt.show()


