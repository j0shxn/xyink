#manim

from manim import *
import numpy as np

unit_length = 3
DEG = DEGREES


def s2c( psi, phi, r ):
    return np.array([ r * np.cos(phi) * np.cos(psi),\
             r * np.cos(phi) * np.sin(psi),\
             r * np.sin(phi) ])


class main(Scene):

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
        text0 = Tex(r"So we see that: a rotated $\hat p$ around $\hat w$ \\ \
                      must belong to to the conic set of $\hat x$.")

        basel0 = MathTex(r"R_{\hat w}(\phi) \hat p \
                           \in \mathbb{S}_{\hat x}(\hat l \cdot \hat x)")

        group0 = VGroup(text0, basel0).arrange(DOWN)
        self.play( Write(text0))
        self.wait(2)
        self.play(FadeIn(basel0, shift=DOWN))
        self.wait(1)
        self.play(FadeOut(text0))

        basel0_1 = MathTex(r"R_{\hat w}(\phi) \hat p \
                           \in \mathbb{S}_{\hat x}(\hat l \cdot \hat x)")

        #basel0_1.to_edge(UP)
        #self.add(basel0_1)
        #basel0_1.animate.to_edge(UP)

        basel1 = MathTex(r"\iff R_{\hat w} (\phi) \hat p \cdot \hat x = \
                           \hat l \cdot \hat x,")

        basel2 = MathTex(r" \rightarrow \phi = \sin^{-1} \left[\
                            \frac{ \cos\alpha \cos\beta -\
                            \cos\gamma \cos\lambda }{ \sin\gamma \
                            \sin\lambda } \right].")

        basel0_1.move_to(ORIGIN + np.array([0,1.5,0]))
        basel1.move_to(ORIGIN)
        basel2.move_to(ORIGIN - np.array([0,1.5,0]))

        self.play(Transform(basel0, basel0_1))
        self.wait(2)

        self.play(FadeIn(basel1, shift=DOWN))
        self.wait(3)

        self.play(FadeIn(basel2, shift=DOWN))
        self.wait(5)
        self.play(FadeOut(basel0_1), FadeOut(basel1), FadeOut(basel2))
        self.remove(basel0_1)
        self.remove(group0)
        self.remove(basel0)
        self.wait(1)

        text1 = Tex(r"Similarly for the X-Joint angle we observe that\\ \
                      an inverse rotation of $\hat l$ around $\hat x$ must\\ \
                      be an element of the set $\hat S_{\hat w}$")

        basel3 = MathTex(r"R_{\hat x}(-\psi) \hat l \
                           \in \mathbb{S}_{\hat w}(\hat p \cdot \hat w)")

        group0 = VGroup(text1, basel3).arrange(DOWN)

        self.play( Write(text1))
        self.wait(2)
        self.play(FadeIn(basel3, shift=DOWN))
        self.wait(1)

        basel3_1 = MathTex(r"R_{\hat x}(-\psi) \hat l \
                           \in \mathbb{S}_{\hat w}(\hat p \cdot \hat w)")

        basel4 = MathTex(r"\iff R_{\hat x}(-\psi) \hat l \cdot \
                           \hat w = \hat p \cdot \hat w")

        basel3_1.move_to(ORIGIN + np.array([0,0.5,0]))
        basel4.move_to(ORIGIN - np.array([0,0.5,0]))

        self.play(FadeOut(text1), Transform(basel3, basel3_1))
        self.wait(2)
        self.play(FadeIn(basel4, shift=DOWN))
        self.wait(3)
        self.clear()

        text2 = Tex(r"It produces the transcendental equation:")
        text2.move_to(ORIGIN + np.array([0,1,0]))

        self.remove(basel3_1)
        self.remove(basel3)
        self.play(Transform(basel3_1, text2), FadeOut(basel4))
        self.wait(2)

        basel5 = MathTex(r"\begin{split}\
                           \cos\psi \sin\alpha \cos\beta \sin\lambda +\
                           \sin\psi \sin\beta \sin\lambda \\ \
                           - \cos\alpha \cos\beta \cos\lambda +\
                           \cos \gamma = 0,\
                           \end{split} ")

        basel5.move_to(ORIGIN - np.array([0,1,0]))

        self.play(FadeIn(basel5, shift=DOWN))
        self.wait(2)
        self.play(FadeOut(text2))
        self.remove(text2)
        self.remove(basel3_1)

        basel6 = MathTex(r" \psi = i \log\left( \frac{ -(\cos^{2}{\alpha } \cos^{2}{\beta } - 2 \cos{\alpha } \cos{\beta } \cos{\gamma } \cos{\lambda } + \cos^{2}{\gamma } + \cos^{2}{\lambda } - 1)^{\frac{1}{2}} + \cos{\alpha } \cos{\beta } \cos{\lambda } - \cos{\gamma } } { (\sin{\alpha } \cos{\beta } - i \sin{\beta }) \sin{\lambda } } \right).")
        basel6.font_size = 28

        self.play(Transform(basel5, basel6))
        self.wait(5)



