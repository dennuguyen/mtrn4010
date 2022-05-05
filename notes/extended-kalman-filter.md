# Extended Kalman Filter

The EKF is an algorithm used to filter noise to get accurate state values.

## Definitions

### State Vector

The state vector is used to keep track of the states of the system that we are interested in evaluating:
$$
x = \left(\begin{matrix}x_{1} \\ \vdots \\ x_{n} \end{matrix}\right) \text{ : state vector}
$$

The covariance matrix of the state vector:
$$
X = \left(
        \begin{matrix}
            sd_{x_{1, 1}}^{2} & \dots & sd_{x_{1, n}}^{2} \\
            \vdots & \ddots & \vdots \\
            sd_{x_{n, 1}}^{2} & \dots & sd_{x_{n, n}}^{2} \\
        \end{matrix}
    \right) \text{ : covariance matrix of state vector}
$$

- $sd_{x_{i, j}}$ is the standard deviation of the $i^{th}$ and $j^{th}$ elements of the state vector.

> Note that $sd_{x_{i, i}}$ is just the standard deviation of the $i^{th}$ element.

### Input Vector

The input vector is a set of input variables which drives the system:
$$
u = \left(\begin{matrix} u_{1} \\ \vdots \\ u_{l} \end{matrix}\right) \text{ : input vector}
$$

The covariance matrix of the input vector:
$$
U = \left(
        \begin{matrix}
            sd_{u_{1, 1}}^{2} & \dots & sd_{u_{1, l}}^{2} \\
            \vdots & \ddots & \vdots \\
            sd_{u_{l, 1}}^{2} & \dots & sd_{u_{l, l}}^{2} \\
        \end{matrix}
    \right) \text{ : covariance matrix of input vector}
$$

### Process Model

The process model, $f$, shows how the state vector is transformed between consecutive time steps:
$$
x(k + 1) = f(x(k), u(k)) + w(k + 1) \text{ : process model}
$$

- $f$ is the ($n \times 1$) state-space representation of the system.
- $w(k)$ is the next process model noise.

The covariance matrix of the process model noise is:
$$
W = \left(
        \begin{matrix}
            sd_{x}^{2} & \dots & sd_{}^{2} \\
            \vdots & \ddots & \vdots \\
            sd_{}^{2} & \dots & sd_{}^{2} \\
        \end{matrix}
    \right) \text{ : covariance matrix of process model noise}
$$

The state is easily transformed using the process model but the covariances need to be transformed using the Jacobian matrix of the process model. The Jacobian matrix of the process model is:
$$
F(k + 1 | k) = \left. \frac{\partial f}{\partial x} \right|_{\hat{x}(k | k), u(k)} \text{ : Jacobian matrix of process model}
$$

> Note that the process model is differentiated at both of its function arguments.

### Observation Vector

The observation vector is used to keep track of predicted observations to compare with some truth observations:
$$
\hat{z} = \left(\begin{matrix} \hat{z}_{1} \\ \vdots \\ \hat{z}_{m} \end{matrix}\right) \text{ : predicted observation vector}
$$

> $\hat{}\;$ symbol is used to denote an estimated variable.

The truth observation vector will be denoted by:
$$
z = \left(\begin{matrix} z_{1} \\ \vdots \\ z_{m} \end{matrix}\right) \text{ : truth observation vector}
$$

### Observation Model

The observation model, $h$, predicts the observation vector given a state vector.
$$
\hat{z}(k + 1) = h(X(k + 1 | k)) + v(k + 1) \text{ : observation model}
$$

- $h$ is an $m \times 1$ vector.
- $v(k + 1)$ is the next observation model noise.

The covariance matrix of the observation model noise is:
$$
V =
\left(
    \begin{matrix}
        sd_{\hat{z}_{1, 1}}^{2} & \dots & sd_{\hat{z}_{1, m}}^{2} \\
        \vdots & \ddots & \vdots \\
        sd_{\hat{z}_{m, 1}}^{2} & \dots & sd_{\hat{z}_{m, m}}^{2} \\
    \end{matrix}
\right) \text{ : covariance matrix of observation model noise}
$$

The Jacobian matrix of the observation model is:
$$
H(k + 1 | k) = \left. \frac{\partial h}{\partial x} \right|_{\hat{x}(k + 1 | k)} \text{ : Jacobian matrix of observation model}
$$

### Innovation

The innovation is the difference between the measured and truth observations:

$$
\hat{y}(k + 1) = z(k + 1) - \hat{z}(k + 1) \text{ : innovation}
$$

The innovation covariance is:
$$
Y(k + 1) = H(k + 1)X(k + 1 | k)H(k + 1)^{T} + V(k + 1) \text{ : innovation covariance}
$$

> Why do we need the innovation? Because it is used to tune the predicted state vector closer to its true value.

### Kalman Gain

The Kalman gain determines how much we need to correct our prediction of the states.
$$
K(k + 1) = X(k + 1 | k) \cdot H(k + 1)^{T} \cdot Y(k + 1)^{-1} \text{ : Kalman gain}
$$

## Pseudocode

Now with all the definitions, the EKF is simply:

$$
\begin{aligned}

\text{\bf{input }} &\; f,\; w(k),\; W(k),\; x(k | k),\; X(k | k),\; u(k),\\
                   &\; h,\; v(k + 1),\; V(k + 1),\; z(k + 1) \\
\\

\text{\bf{Prediction:}} \\

x(k + 1 | k) &= f(x(k | k), u(k)) + w(k) &\text{ : predict next state}\\
F(k + 1 | k) &= \left. \frac{\partial f}{\partial x} \right|_{\hat{x}(k | k), u(k)} &\text{ : calculate proces model Jacobian}\\
X(k + 1 | k) &= F(k + 1 | k)\cdot X(k | k)\cdot F(k + 1 | k)^{T} + W(k) &\text{ : predict next state covariance}\\
\\

\text{\bf{Update:}} \\
\hat{z}(k + 1) &= h(X(k + 1 | k)) + v(k + 1) &\text{ : measure observation} \\
\hat{y}(k + 1) &= z(k + 1) - \hat{z}(k + 1) &\text{ : calculate innovation} \\
H(k + 1 | k) &= \left. \frac{\partial h}{\partial x} \right|_{\hat{x}(k + 1 | k)} &\text{ : calculate observation model Jacobian} \\
Y(k + 1) &= H(k + 1)X(k + 1 | k)H(k + 1)^{T} + V(k + 1) &\text{ : calculate innovation covariance} \\
K(k + 1) &= X(k + 1 | k) \cdot H(k + 1)^{T} \cdot Y(k + 1)^{-1} &\text{ : calculate Kalman gain}\\
x(k + 1 | k + 1) &= x(k + 1 | k) + K(k + 1) \cdot \hat{y}(k + 1) &\text{ : update state vector} \\
X(k + 1 | k + 1) &= (I - K(k + 1) \cdot H(k + 1)) \cdot X(k + 1 | k) &\text{ : update state covariance matrix} \\
\\

\text{\bf{return }} &\; x(k + 1 | k + 1),\; X(k + 1 | k + 1)

\end{aligned}
$$
