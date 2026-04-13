#manim

from manim import *
import numpy as np

unit_length = 3
DEG = DEGREES


def s2c( psi, phi, r ):
    return np.array([ r * np.cos(phi) * np.cos(psi),\
             r * np.cos(phi) * np.sin(psi),\
             r * np.sin(phi) ])


class main(ThreeDScene):

    CONFIG = {
        "x_axis_label": "$x$",
        "y_axis_label": "$y$",
        "basis_i_color": GREEN,
        "basis_j_color": RED,
        "basis_k_color": GOLD
    }

    def conscone(self, axis, vec):
        # Construct a cone using an axis np.array and vec np.array
        apex_angle = np.arccos( 
            np.inner(axis, vec)/(np.linalg.norm(axis)*np.linalg.norm(vec)))

        height = np.inner(axis, vec)/np.linalg.norm(axis)
        print(height)
        base_radius = np.linalg.norm(vec)*np.sin(apex_angle)
        print(base_radius)

        thecone = Cone(direction = -axis,
                    u_min = 0,
                    height = height,
                    base_radius = base_radius)

        return thecone
                               

    def construct(self):

        text0 = Tex(r"Rotating a vector around another\\ vector preserves their\
                    inner product.")

        self.play(Write(text0))
        self.wait()
        self.play(FadeOut(text0))

        text1 = Tex(r"As such the conical set of vectors\
                      for an axis is defined as:")

        basel1 = MathTex(r"c \in (-1,1),\; \mathbb{S}_{\hat k}(c) =\
                         \{ \hat v : \hat v \cdot \hat k = c \}.")
        group1 = VGroup(text1, basel1).arrange(DOWN)
        self.play(Write(group1))
        self.wait(5)

        self.remove(group1)

#       basel1_1 = MathTex(r"c \in (-1,1), \ \\ \mathbb{S}_{\hat k}(c) =\
#                   \{ \hat v : \hat v \cdot \hat k = c \}.")
#       basel1_1.font_size = 36
#       group1_1 = VGroup(basel1_1)
#       group1_1 = VGroup(text1_1, basel1_1).arrange(DOWN)
#       group1_1.to_corner(UL)
#       self.add_fixed_in_frame_mobjects(group1_1)
#       #self.play(Transform(group1, group1_1))
#
#       #k_axis = Arrow(np.array([3,0,0]), np.array([-0.8,-0.8,-1.8]))
#       #self.add(k_axis)

        axes = ThreeDAxes()
        axes.set_color(GRAY)
        axes.add(axes.get_axis_labels())

        w_axis_coords = s2c(80 * DEG, 0, unit_length)
        w_axis = Vector(w_axis_coords)
        w_label = Text("w").next_to(w_axis, w_axis.get_center() +\
                np.array([0,0,1]))
        w_label.font_size = 24


        p_vec_coords = s2c(80 * DEG, 70 * DEG, unit_length)
        p_vec = Vector(p_vec_coords, color=GREEN)
        p_label = Text("p").next_to(p_vec, p_vec.get_center() +\
                np.array([0,0,1]))
        p_label.font_size = 24

        basel1_1 = MathTex(r"\mathbb{S}_{\hat w}(\hat p \cdot \hat w) =\
                         \{ \hat v : \hat v \cdot \hat w = \hat p \cdot \hat w \}.")
        basel1_1.font_size = 36

        #cone = Cone(direction=-5*X_AXIS, resolution=12)
        #cone.height = 5

        self.add(axes)
        self.add(w_axis)
        self.add(p_vec)

        self.add_fixed_in_frame_mobjects(basel1_1)
        self.add_fixed_orientation_mobjects(w_label)
        self.add_fixed_orientation_mobjects(p_label)
        basel1_1.to_corner(UP + RIGHT)

        self.set_camera_orientation(phi=60 * DEG, theta=10 * DEG, focal_distance = 15)
        self.begin_ambient_camera_rotation(rate=0.05)

        self.play( GrowArrow(w_axis),
                   GrowArrow(p_vec),
                   Write(basel1_1) )

        #self.move_camera(phi=75 * DEGREES, theta=-30 * DEGREES)
        self.wait(3)

        w_joint_cone = self.conscone(w_axis_coords, p_vec_coords)
        w_joint_cone.fill_opacity = 0.1

        self.add(w_joint_cone)
        self.play( GrowFromCenter(w_joint_cone))
        self.wait(10)
        
        # ----------------------- Add the target vector and x axis

        x_axis_coords = s2c(0, 0, unit_length)
        x_axis = Vector(x_axis_coords)
        x_label = Text("x").next_to(x_axis, x_axis.get_center() +\
                np.array([0,0,1]))
        x_label.font_size = 24

        l_vec_coords = s2c(-30 * DEG, 45 * DEG, unit_length)
        l_vec = Vector(l_vec_coords,color=RED)
        l_label = Text("l").next_to(l_vec, l_vec.get_center() +\
                np.array([0,0,1]))
        l_label.font_size = 24

        self.move_camera(phi=60 * DEGREES, theta=0 * DEGREES)


        basel_x = MathTex(r"\mathbb{S}_{\hat x}(\hat l \cdot \hat x) =\
                         \{ \hat v : \hat v \cdot \hat x = \hat l \cdot \hat x \}.")
        basel_x.font_size = 36

        self.add_fixed_in_frame_mobjects(basel_x)
        basel_x.to_corner(UP + LEFT)

        self.play( GrowArrow(x_axis),
                   GrowArrow(l_vec),
                   Write(basel_x) )

        self.add_fixed_orientation_mobjects(x_label)
        self.add_fixed_orientation_mobjects(l_label)

        #self.move_camera(phi=75 * DEGREES, theta=-30 * DEGREES)
        self.wait(3)

        x_joint_cone = self.conscone(x_axis_coords, l_vec_coords)
        x_joint_cone.fill_opacity = 0.1
        x_joint_cone.fill_color = GRAY
        self.add(x_joint_cone)
        self.play( GrowFromCenter(x_joint_cone))
        
        self.wait(10)

#       self.play(
#           Transform(text0,text1),
#           FadeIn(basel1, shift=DOWN)
#       )
#       #
#       self.play( ReplacementTransform(text0, text1) )
#
#       text1_1 = Tex(r"As such the conical set of vectors \
#                       \\for an axis is defined as:")
#
#       text1_1.to_corner(UP+LEFT)
#
#       basel1_1 = MathTex(r"c \in (-1,1), \
#                   \\ \mathbb{S}_{\hat k}(c) =\
#                   \{ \hat v : \hat v \cdot \hat k = c \}.")
#       basel1_1.to_corner(UP+LEFT)
#
#       VGroup(text1_1, basel1_1).arrange(DOWN)
#
#       self.play(
#           Transform(text1, text1_1),
#           Transform(basel1, basel1_1)
#       )
#       self.wait()
#       
#       self.play( ReplacementTransform(group1, text1_1) )
#       self.wait()
#
