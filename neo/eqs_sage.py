from sage.all import *

I3 = identity_matrix(RR, 3)

def sph2cart(sp):
    # Spherical to cartesian vector transformation
    vect = vector([\
        sp[2]*cos(sp[1])*cos(sp[0]), \
         sp[2]*cos(sp[1])*sin(sp[0]),\
         sp[2]*sin(sp[1])])
    return vect

def Rodri(k, ang):
    # Rodrigues rotation matrix
    K = Matrix([ [ 0, -k[2], k[1] ],\
                 [ k[2], 0, -k[0] ],\
                 [ -k[1], k[0], 0 ] ])

    Rv = I3 + sin(ang)*K + (1-cos(ang))*K**2;
    return Rv

euler_sin = lambda x : (exp(i*x) - exp(-i*x))/(i*2);
euler_cos = lambda x : (exp(i*x) + exp(-i*x))/2;

# Azimuth and elevation angles
alpha, beta = var('alpha, beta')
assume(alpha, beta, 'real')

# X and Y joint angles
psi, phi = var('psi, phi')
assume(psi, phi, 'real')

# Y joint and pointing angles (no misalignment -> pi/2)
zeta, gamma = var('zeta, gamma')
assume(zeta, gamma, 'real')
# Assume that misalignments can't be pi/2
assume(zeta > 0); assume(gamma > 0)

x = vector([1, 0, 0])
p = sph2cart([zeta, gamma, 1])
w = vector([ cos(zeta), sin(zeta), 0 ])
l = sph2cart([-alpha, beta, 1])

# ------------------------------------------------------------------- Find Phi
Rw = Rodri(w, phi)
y_eq = (Rw*p).dot_product(x) == l.dot_product(x)
phi_eq = solve(y_eq.full_simplify(), phi)
pretty_print(phi_eq[0].full_simplify())

# ------------------------------------------------------------------- Find Psi
#   #ldx = l.dot_product(x)
#   #rhea = var('rhea'); assume(rhea, 'real')
#   #p_star = vector([ ldx, sin(acos(ldx))*cos(rhea), sin(acos(ldx))*sin(rhea) ])
#   p_star = Rw*p
#
#   ps_cross_x = (p_star.cross_product(x)).normalized()
#   l_cross_x = (l.cross_product(x)).normalized()
#
#   psi_vec = ps_cross_x.cross_product(l_cross_x)
#
#   inner = (psi_vec.dot_product(x)).full_simplify()
#   psi_eq_cross = asin(inner)

# --------------------------------------------------------- Find Psi - Complex
Rx = Rodri(x, -psi)
x_eq = (Rx*l).dot_product(w) == p.dot_product(w)

ecos_psi = euler_cos(psi)
esin_psi = euler_sin(-psi)

x_eq_eu = cos(alpha)*cos(beta)*cos(zeta) -\
        (cos(beta)*ecos_psi*sin(alpha) -\
        sin(beta)*esin_psi)*sin(zeta) == cos(gamma)

psi_comp_eq = solve(x_eq_eu,psi)
