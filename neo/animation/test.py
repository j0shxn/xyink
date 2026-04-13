import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(projection='3d')

# Make data
az, el = np.mgrid[0:2*np.pi:20j, -np.pi/2:np.pi/2:10j]
x = np.cos(el)*np.cos(az)
y = np.cos(el)*np.sin(az)
z = np.sin(el)

print(np.shape(z))

# Plot the surface
ax.plot_surface(x, y, z)

# Set an equal aspect ratio
ax.set_aspect('equal')

plt.show()
