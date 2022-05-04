# Calculus

## Jacobian Matrix

A few interpretations:
1. The derivative of $f$ at $x$ is equivalent to the Jacobian of $f$ at $x$ if $f$ and $x$ are multi-dimensional.

2. The Jacobian matrix is a generalisation of all of the first-order partial derivatives of a function, $f: \reals^{N} \rightarrow \reals^{M}$, with respect to a given point, $x$:
$$
J = \left( \frac{\partial f}{\partial x_{1}} \; ... \; \frac{\partial f}{\partial x_{n}} \right) =
\left(
    \begin{matrix}
        \frac{\partial f_{1}}{\partial x_{1}} & ... & \frac{\partial f_{1}}{\partial x_{n}} \\
        \vdots & \ddots & \vdots \\
        \frac{\partial f_{m}}{\partial x_{1}} & ... & \frac{\partial f_{m}}{\partial x_{n}}
    \end{matrix}
    \right)
$$

3. The Jacobian matrix can be visualised as a vector of gradients with respect to each dimension of $f$ at a point.

4. The Jacobian matrix represents the differential of $f$ at every point where $f$ is differentiable.

5. The Jacobian matrix describes an amount of "stretching", "rotating", or "transforming" of a function locally near a point.
