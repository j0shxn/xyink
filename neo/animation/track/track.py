import numpy as np
from scipy.interpolate import CubicSpline
from icecream import ic
import matplotlib.pyplot as plt

def Sph2car(sp):
    # Spherical to cartesian vector transformation
    vect = np.array([\
        sp[2]*np.cos(sp[1])*np.cos(sp[0]), \
         sp[2]*np.cos(sp[1])*np.sin(sp[0]),\
         sp[2]*np.sin(sp[1])], dtype=np.float128)
    return vect

def AZELtoVEC(az, el):
    # Right handed AZEL to left handed cartesian vectors
    azrl = np.deg2rad(-az) # Left handed azimuth angle as radians
    elr = np.deg2rad(el)
    return Sph2car([azrl, elr, 1])

def Car2sph(vec):
    # Cartesian to spherical in radians
    R = np.linalg.norm(vec)
    uVec = vec/R
    theta = np.arcsin(uVec[2])
    phi = np.arctan2(uVec[1], uVec[0]);
    sph = np.array([phi, theta, R])
    return sph

def VECtoAZEL(vec):
    # Cartesian vector to right handed AZEL
    sph = Car2sph(vec)
    return -np.rad2deg(sph[0]), np.rad2deg(sph[1])

def Rodri(k, ang):
    # Rodrigues rotation matrix
    K = np.array([ [ 0, -k[2], k[1] ],\
                 [ k[2], 0, -k[0] ],\
                 [ -k[1], k[0], 0 ] ], dtype=np.float128)

    Rv = np.eye(3) + np.sin(ang)*K +\
            (1-np.cos(ang))*np.linalg.matrix_power(K,2);
    return Rv

def Psi(alpha, beta, zeta, gamma):
    # Inverse kinematics: X joint angle
    psi_res = 1j*np.log((-np.sqrt(np.cos(alpha)**2*np.cos(beta)**2 -\
    2*np.cos(alpha)*np.cos(beta)*np.cos(gamma)*np.cos(zeta) +\
    np.cos(gamma)**2 + np.cos(zeta)**2 - 1 + 0j) +\
    np.cos(alpha)*np.cos(beta)*np.cos(zeta) -\
    np.cos(gamma))/((np.sin(alpha)*np.cos(beta) -\
    1j*np.sin(beta))*np.sin(zeta)), dtype=np.complex256)
    return np.real(psi_res)

def Phi(alpha, beta, zeta, gamma):
    # Inverse kinematics: Y joint angle
    phi_res = np.arcsin((np.cos(alpha)*np.cos(beta) -\
        np.cos(gamma)*np.cos(zeta))/(np.sin(gamma)*np.sin(zeta)) + 0j,
                        dtype=np.complex256)
    return np.real(phi_res)

def AngErr(psi_ang, phi_ang, x_v, w_v, p_v, l_v):
    res_p = np.matmul(Rodri(x_v, psi_ang),np.matmul(Rodri(w_v, phi_ang),p_v))
    dotslp = np.dot(l_v, res_p)/(np.linalg.norm(l_v)*np.linalg.norm(res_p))
    err_ang = np.arccos(dotslp - 2e-16, dtype=np.float128)
    return np.real(err_ang)


def getAz(data_file):
    with open(data_file, 'r') as file:
        data = file.read()
    lines = data.strip().split('\n')

    azimuth_arr = np.zeros(len(lines))
 
    for ind, line in enumerate(lines):
        line_arr = line.split()
        azimuth_arr[ind] = float(line_arr[2])
    
    return azimuth_arr

def getEl(data_file):
    with open(data_file, 'r') as file:
        data = file.read()
    lines = data.strip().split('\n')

    elevation_arr = np.zeros(len(lines))
 
    for ind, line in enumerate(lines):
        line_arr = line.split()
        elevation_arr[ind] = float(line_arr[3])
    
    return elevation_arr

def getTime(data_file):
    with open(data_file, 'r') as file:
        data = file.read()
    lines = data.strip().split('\n')

    time_arr = np.zeros(len(lines))
    time_offset = 0
    for ind, line in enumerate(lines):
        # prepare the time, compensate if time jumps to the other day
        line_arr = line.split()
        time_line = (line_arr[1]).split(':')

        timesum = int(time_line[0])*3600 +\
                  int(time_line[1])*60 +\
                  int(time_line[2])
        if ind == 0:
            time_offset = timesum

        time_arr[ind] = timesum + (timesum < time_offset)*86400\
                        - time_offset
    
    return time_arr

def GetPass(data_file):
    # YES PUTTING THEM IN DIFFERENT FUNCTIONS SEEMS WEIRD AND UNOPTIMIZED
    # BUT THIS IS THE ONLY WAY TO PREVENT THE ARRAY OVERWRITING BUG THAT
    # I'VE FOUND RIGHT NOW
    azimuth_arr = getAz(data_file); ic(azimuth_arr)
    elevation_arr = getEl(data_file); ic(elevation_arr)
    time_arr = getTime(data_file); ic(time_arr)

    # Interpolate the inhomogenous values of azimuths and elevations
    time_index = np.arange(0,time_arr[-1]+1)

    az_spline = CubicSpline(time_arr, azimuth_arr)
    el_spline = CubicSpline(time_arr, elevation_arr)

    interp_azimuths = az_spline(time_index)
    interp_elevations = el_spline(time_index)

    ic(time_index)
    ic(interp_azimuths)
    ic(interp_elevations)

    return time_index, interp_azimuths, interp_elevations

def AZELinFrame(az, el, Rmat):
    # Pull the AZEL in NWU frame to the pedestal frame
    l_R = AZELtoVEC(az, el)
    hat_l = np.matmul(Rmat.T, l_R)
    azn, eln = VECtoAZEL(hat_l) # New azimuth and elevation angles
    return azn, eln

def XYtoAZEL(phi, psi, w_ax, p_ax):
    # Convert XY angles to AZEL angles in the pedestal frame
    Rw = Rodri(w_ax, phi)
    Rx = Rodri(np.array([1,0,0]), psi)
    p_m = np.matmul(Rw, p_ax)
    p_mm = np.matmul(Rx, p_m)
    az, el = VECtoAZEL(p_mm)
    return az, el

def AZELtoXY(alpha, beta, w_ax, p_ax, phi_offset):
    phi = Phi(alpha, beta, zeta, gamma) - phi_offset
    psi = Psi(alpha, beta, zeta, gamma)

def Tests():
    test_degs = np.array([45, 45])
    varsig = 1e-9
    l1 = AZELtoVEC(test_degs[0], test_degs[1])
    l2 = Sph2car([np.deg2rad(-test_degs[0]), np.deg2rad(test_degs[1]), 1])
    print("Equiv. >> AZELtoVEC == Sph2car : ", (l1 - l2) < varsig) 
    car2sph_res = np.rad2deg(Car2sph(l1)[0:2])
    car2sph_azel_res = [-car2sph_res[0], car2sph_res[1]]
    vectoazel_res = VECtoAZEL(l1)
    test_car2sph = test_degs - np.array(car2sph_azel_res)
    test_vectoazel_res = test_degs - np.array(vectoazel_res)

    print("Test >> Car2sph : ", test_car2sph < varsig) 
    print("Test >> VECtoAZEL : ", test_vectoazel_res < varsig) 
    test_R = Rodri(np.array([0,0,1]), np.deg2rad(45))
    faz, fel = AZELinFrame(test_degs[0], test_degs[1], test_R)
    ic(faz); ic(fel)
    print("Test >> AZELinFrame: ",
          ([faz, fel]  - np.array([90, 45]) < varsig ))


# Calculate x_R from spherical coordinates
theta_xa, theta_xe = np.deg2rad([10, -5]); ic(theta_xa, theta_xe)
x_R = Sph2car([theta_xa, theta_xe, 1]); ic(x_R)

# Calculate w_R from spherical coordinates
theta_wa, theta_we = np.deg2rad([95, 2]); ic(theta_wa, theta_we)
w_R = Sph2car([theta_wa, theta_we, 1]); ic(w_R)

# Calculate p_R from spherical coordinates
theta_pa, theta_pe = np.deg2rad([93, 88]); ic(theta_pa, theta_pe)
p_R = Sph2car([theta_pa, theta_pe, 1]); ic(p_R)

# Calculate and normalize the z_R basis
z_Rd = np.cross(x_R, w_R)
z_R = z_Rd / np.linalg.norm(z_Rd); ic(z_R)

# No need for normalizing y_R as z_R and x_R are orthonormal
y_R = np.cross(z_R, x_R); ic(np.linalg.norm(y_R))

# Concatenate the basis vectors to contruct the pedestal rotation matrix
R_R = np.concatenate(( x_R.reshape(-1,1),
                       y_R.reshape(-1,1),
                       z_R.reshape(-1,1) ), axis=1); ic(R_R)

# Construct the normal basis
hat_x = np.array([1,0,0], dtype=np.float128)
hat_y = np.array([0,1,0], dtype=np.float128)
hat_z = np.array([0,0,1], dtype=np.float128)

# Bring the y joint axis to the pedestal frame
hat_w = np.matmul(R_R.T, w_R)

# Bring the pointing vector to the pedestal frame
hat_p = np.matmul(R_R.T, p_R)

# Calculate zeta (lambda in latex)
zeta = np.arccos(np.matmul(hat_w, hat_x)); ic(np.rad2deg(zeta))

# Calculate gamma
gamma = np.arccos(np.matmul(hat_p, hat_w)); ic(np.rad2deg(gamma))

# Calculate the phi offset, created if the pointing axis does not project
# fully onto w.
upd = np.cross(hat_p, hat_w)
pd = upd/np.linalg.norm(upd)
phi_offset = - np.pi/2 + np.arccos(np.matmul(pd, hat_z))

#   # Confirm the phi_offset is right ic(np.rad2deg(phi_offset))
#   Rwpd = Rodri(hat_w, phi_offset)
#   p_ = np.matmul(Rwpd, hat_p)
#   err = gamma - (np.pi/2 - np.arccos(np.matmul(p_, hat_z)))
#   ic(err)

time_data, az_data, el_data = GetPass('TERRA-28219.txt')
ic(len(time_data))
ic(len(az_data))

phi_data = np.zeros(len(time_data))
psi_data = np.zeros(len(time_data))
real_az = np.zeros(len(time_data))
real_el= np.zeros(len(time_data))
for indf in time_data: # As the time data is constructed as also an index
    ind = int(indf)

    # Bring the azimuth and elevation angles to pedestal frame
    azn, eln = AZELinFrame(az_data[ind], el_data[ind], R_R)

    # Calculate the XY angles, also offset the phi for the angled 0 position
    # of hat_p
    phi_data[ind] = Phi(np.deg2rad(azn), np.deg2rad(eln), zeta, gamma)\
                        + phi_offset
    psi_data[ind] = Psi(np.deg2rad(azn), np.deg2rad(eln), zeta, gamma)

    # Convert to AZEL and also bring it to the NWU frame
    paz_P, pel_P = XYtoAZEL(phi_data[ind], psi_data[ind], hat_w, hat_p)
    print((azn - paz_P) < 1e-9)
    real_az[ind], real_el[ind] = AZELinFrame(paz_P, pel_P, R_R.T)
    real_az[ind] = real_az[ind] + 360

Tests()

plt.subplot(2,1,1)

azhue = 0.5
plt.scatter(time_data, az_data, label='Reference AZ',\
            marker=',', alpha=0.5, color='gray')

plt.plot(time_data, real_az, label='Real AZ',\
         linestyle='-', color='black')

plt.plot(time_data, abs(az_data - real_az)*1e+15,
         label='|Error|*10^15', linestyle='-', color='red')

plt.legend(fontsize='9')
plt.title('Azimuth Angle of Satellite and Pedestal', fontsize='11')
plt.xlabel('Time (Seconds)')
plt.ylabel('Azimuth (Degrees)')
plt.grid(True, linestyle='--', color='#BBBBBB', linewidth='0.5')

plt.subplot(2,1,2)

plt.scatter(time_data, el_data, label='Reference EL',\
            marker=',', alpha=0.5, color='gray')

plt.plot(time_data, real_el, label='Real EL',\
         linestyle='-', color='black')

plt.plot(time_data, abs(el_data - real_el)*1e+15,
         label='|Error|*10^15', linestyle='-', color='red')

plt.legend(fontsize='9', loc='upper right')
plt.title('Elevation Angle of Satellite and Pedestal', fontsize='11')
plt.xlabel('Time (Seconds)')
plt.ylabel('Elevation (Degrees)')
plt.grid(True, linestyle='--', color='#BBBBBB', linewidth='0.5')

plt.tight_layout()
plt.show()

# Differentiate the XY joint angles to get the velocities, the delta_time
# is 1 so no need to divide by that

extended_phi = np.insert(phi_data, 0, phi_data[0])
extended_psi = np.insert(psi_data, 0, psi_data[0])

delta_phi = np.diff(extended_phi)
delta_psi = np.diff(extended_psi)

plt.subplot(2,1,1)
plt.plot(time_data, np.rad2deg(phi_data), linestyle='-', color='black')
plt.title('Y Joint Angle', fontsize='11')
plt.xlabel('Time (Seconds)')
plt.ylabel('Phi (Degrees)')
plt.grid(True, linestyle='--', color='#BBBBBB', linewidth='0.5')

plt.subplot(2,1,2)
plt.plot(time_data, np.rad2deg(psi_data), linestyle='-', color='black')
plt.title('X Joint Angle', fontsize='11')
plt.xlabel('Time (Seconds)')
plt.ylabel('Psi (Degrees)')
plt.grid(True, linestyle='--', color='#BBBBBB', linewidth='0.5')
plt.tight_layout()
plt.show()

