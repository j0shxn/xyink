#manim
from manim import *

class main(ThreeDScene):
    def construct(self):
        axes = ThreeDAxes()
        self.set_camera_orientation(phi=75 * DEGREES, theta=-45 * DEGREES)
        self.add(axes)
        text3d = Text("This is a 3D text")
        text3d.to_corner(UL)
        self.play(FadeIn(text3d))
        self.wait()
