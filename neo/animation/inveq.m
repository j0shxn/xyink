

function phi = phi_eq(alpha,beta,lambda,gamma)
    % Inverse kinematic equation for Y-Joint
    phi = asin( (cos(alpha) * cos(beta) - cos(gamma)*cos(lambda)) / ...
        (sin(gamma)*sin(lambda) ) )
end

function psi = psi_eq(alpha,beta,lambda,gamma)
    % Complex inverse kinematic equation for X-Joint
    psi = 1j*log((-sqrt(cos(alpha)^2*cos(beta)^2 -\
        2*cos(alpha)*cos(beta)*cos(gamma)*cos(lambda) +\
        cos(gamma)^2 + cos(lambda)^2 - 1) +\
        cos(alpha)*cos(beta)*cos(lambda) -\
        cos(gamma))/((sin(alpha)*cos(beta) -\
        1j*sin(beta))*sin(lambda)))
end

function psi_vec = psi_vec_eq(alpha,beta,lambda,gamma)
    % Vector analysis inverse kinematic equation for X-Joint
    psi_vec = asin((-(sin(gamma)*sin(phi)*cos(lambda) -...
        sin(lambda)*cos(gamma))*sin(beta) +...
        sin(alpha)*sin(gamma)*cos(beta)*cos(phi))/...
        (sqrt(-cos(alpha)^2*cos(beta)^2 + 1)*...
        sqrt((sin(gamma)*sin(phi)*cos(lambda) -...
        sin(lambda)*cos(gamma))^2 +...
        sin(gamma)^2*cos(phi)^2)))
