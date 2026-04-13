import matplotlib.pyplot as plt
import numpy as np
from icecream import ic

import numpy as np
import matplotlib.pyplot as plt

def scalar_function(x, y):
    # Define your scalar function here
    return x**2 + y**2

def gradient_vector(x, y):
    # Compute the gradient vector of the scalar function
    df_dx = 2 * x
    df_dy = 2 * y
    return np.array([df_dx, df_dy])

def plot_gradient_vectors(x_range, y_range, num_points=20):
    x_vals = np.linspace(x_range[0], x_range[1], num_points)
    y_vals = np.linspace(y_range[0], y_range[1], num_points)
    X, Y = np.meshgrid(x_vals, y_vals)

    Z = scalar_function(X, Y)

    U, V = gradient_vector(X, Y)

    plt.figure(figsize=(8, 8))
    plt.contour(X, Y, Z, levels=15, cmap='viridis')
    plt.quiver(X, Y, U, V, scale=20, color='red', width=0.007)
    plt.title('Gradient Vectors of Scalar Function')
    plt.xlabel('X-axis')
    plt.ylabel('Y-axis')
    plt.grid(True)
    plt.show()

# Define the range for x and y values
x_range = (-5, 5)
y_range = (-5, 5)

# Plot gradient vectors
plot_gradient_vectors(x_range, y_range)
