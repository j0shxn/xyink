from sympy import *

# Define symbols
phi, lambd, alpha, beta, p1, p2, p3 = symbols('phi lambd alpha beta p1 p2 p3', real=True)

alpha, beta = symbols('alpha, beta', real=True) # Azimuth and elevation
phi, psi = symbols('phi, psi', real=True) # Y and X angles

init_session()
init_printing(use_unicode=True)
# Define the equation
equation = Eq(\
    p1*(-(-exp(I*phi)/2 + 1 - exp(-I*phi)/2)*sin(lambd)**2 + 1) +
    p2*(-exp(I*phi)/2 + 1 - exp(-I*phi)/2)*sin(lambd)*cos(lambd) -
    I*p3*(exp(I*phi) - exp(-I*phi))*sin(lambd)/2,
    cos(alpha) * cos(beta)
)

# Solve for phi
solutions = solve(equation, phi)

# Display the solutions
print("Solutions for phi:")
for sol in solutions:
    print(sol.evalf())

