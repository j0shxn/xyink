import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

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
    ax.set_title('Wireframe Half Sphere')

    set_box_aspect(ax, aspect_ratio)  # Adjust the aspect ratio

def plotVec(ax, x_v, y_v, z_v, the_color):
    ax.quiver(0, 0, 0, x_v, y_v, z_v, color=the_color,\
            label='Vector', arrow_length_ratio=0.1)


# Adjust the radius, num_samples, and aspect_ratio as needed
plot_wireframe_half_sphere(ax, radius=1, num_samples=100, aspect_ratio=0.25)
plotVec(ax,0,0,1,'r')
plotVec(ax,1,0,0,'r')
plt.show()
