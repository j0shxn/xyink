from sympy import *

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

def phi(alpha, beta, zeta, gamma):
    before_asin = (cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta))
    ic(before_asin)
    phi_res = asin((cos(alpha)*cos(beta) -\
        cos(gamma)*cos(zeta))/(sin(gamma)*sin(zeta)))
    evalv_phi = phi_res.evalf()
    print("PHI = ",end=''); pprint(evalv_phi)
    return float(evalv_phi)
