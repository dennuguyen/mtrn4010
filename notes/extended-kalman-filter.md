# Extended Kalman Filter

The EKF is an algorithm used to filter noise to get accurate state values (and also lets us control the system with some input values!). It consists of two main steps:
1. Prediction: Predicts what the system's state would be in the next timestep.
1. Update: Tunes the prediction closer to its true values based on the error of an observation paired with its truth value.

## Design the State Vector

The state vector is used to keep track of the states of the system that we are interested in evaluating:
$$
x = \left(\begin{matrix}x_{1} \\ \vdots \\ x_{n} \end{matrix}\right) \text{ : state vector}
$$

But since this is not a perfect world, our state vector will have errors/noise that we need to model using covariance matrices:
$$
X = \left(
        \begin{matrix}
            \sigma_{x_{1}}\sigma_{x_{1}} & \dots & \sigma_{x_{1}}\sigma_{x_{n}} \\
            \vdots & \ddots & \vdots \\
            \sigma_{x_{n}}\sigma_{x_{1}} & \dots & \sigma_{x_{n}}\sigma_{x_{n}} \\
        \end{matrix}
    \right) \text{ : covariance matrix of state vector}
$$

## Consider the Input Vector

The input vector is a set of input variables which drives the system:
$$
u = \left(\begin{matrix} u_{1} \\ \vdots \\ u_{l} \end{matrix}\right) \text{ : input vector}
$$

## Design the Process Model

The process model, $f$, shows how the state vector is transformed between consecutive timesteps:
$$
x(k + 1) = f(x(k), u(k)) + w_{x}(k) \text{ : process model}
$$

- $f$ is the ($n \times 1$) state-space representation of the system.
- $w_{x}(k)$ is the process model noise at the next timestep.

> For robotics applications, the process model is as simple as a robot's kinematic model.

### Transforming State Covariance Matrix

It's easy to transform the state vector but how do we transform the state covariance matrix? Consider the Jacobian matrix of the process model with respect to the state variables:
$$
F_{x}(k + 1 | k) = \left. \frac{\partial f}{\partial x} \right|_{\hat{x}(k | k), u(k)} \text{ : Jacobian matrix of process model at state}
$$

> The notation $F(k + 1 | k)$ means the value of $F$ at time, $k + 1$, given conditions of $k$.

The state covariance matrix can then be transformed between timesteps:
$$
X(k + 1 | k) = F_{x}(k + 1 | k) \cdot X(k | k) \cdot F_{x}(k + 1 | k) \text{ : transforming state covariance matrix}
$$

### Process Model Noise

The covariance matrix of the process model noise has the form:
$$
W_{x}(k) = \left(
        \begin{matrix}
            \sigma_{x_{1}}\sigma_{x_{1}} & \dots & \sigma_{x_{1}}\sigma_{x_{n}} \\
            \vdots & \ddots & \vdots \\
            \sigma_{x_{n}}\sigma_{x_{1}} & \dots & \sigma_{x_{n}}\sigma_{x_{n}} \\
        \end{matrix}
    \right) \text{ : covariance matrix of process model noise}
$$

- $\sigma$ is the standard deviation.

Process model noise can come from multiple sources:
- Input noise aka measurement dynamics.
- Mismodelled system.
- Hidden state.
- Discretisation of time.

> It's better to think of the covariance matrix of the process model noise to be the sum of all covariance matrices of sources of noise.

The process model noise will affect the state vector and is additive with the state covariance matrix:
$$
X(k + 1 | k) = F_{x}(k + 1 | k) \cdot X(k | k) \cdot F_{x}(k + 1 | k)^{T} + W_{x}(k) \text{ : process model noise equation}
$$

### Input Noise as a Process Model Noise

Consider if input noise was not negligible and had to be modelled as part of the process model noise.
$$
W_{x}(k) = U(k + 1) \text{ : input noise covariance matrix}
$$

The covariance matrix of the input vector is:
$$
U = \left(
        \begin{matrix}
            \sigma_{u_{1}}\sigma_{u_{1}} & \dots & \sigma_{u_{1}}\sigma_{u_{l}} \\
            \vdots & \ddots & \vdots \\
            \sigma_{u_{l}}\sigma_{u_{1}} & \dots & \sigma_{u_{l}}\sigma_{u_{l}} \\
        \end{matrix}
    \right) \text{ : covariance matrix of input vector}
$$

However, $U$ is in the control-space and not the state-space. So, we need to transform, $U$, using the Jacobian matrix of the process model with respect to its inputs:
$$
\begin{aligned}
    F_{u}(k + 1 | k) &= \left. \frac{\partial f}{\partial u} \right|_{\hat{x}(k | k), u(k)} &\text{ : Jacobian matrix of process model at input} \\

    U_{\text{state}}(k + 1 | k) &= F_{u}(k + 1 | k) \cdot U_{\text{control}}(k) \cdot F_{u}^{T}(k + 1 | k) &\text{ : transforming input noise covariance matrix}
\end{aligned}
$$

## Consider the Observation Vector

The observation vector is used to keep track of predicted observations to compare with some truth observations:
$$
\hat{z} = \left(\begin{matrix} \hat{z}_{1} \\ \vdots \\ \hat{z}_{m} \end{matrix}\right) \text{ : predicted observation vector}
$$

> $\hat{}\;$ symbol is used to denote an estimated variable.

The truth observation vector will be denoted by:
$$
z = \left(\begin{matrix} z_{1} \\ \vdots \\ z_{m} \end{matrix}\right) \text{ : truth observation vector}
$$

## Design the Observation Model

The observation model, $h$, predicts the observation vector given a state vector.
$$
\hat{z}(k + 1) = h(X(k + 1 | k)) + w_{z}(k) \text{ : observation model}
$$

- $h$ is an $(m \times 1)$ vector.
- $w_{z}(k)$ is the observation model noise at the next timestep.

The Jacobian matrix of the observation model with respect to the state is:
$$
H(k + 1 | k) = \left. \frac{\partial h}{\partial x} \right|_{\hat{x}(k + 1 | k)} \text{ : Jacobian matrix of observation model}
$$

### Transforming State Space Noise to Observation Space

Since the observation model "projects" the state vector into the observation-space, the covariance matrix of the state vector needs to be transformed too. The covariance matrix of the state vector in observation space is:
$$
X_{\text{observation}}(k + 1) = H(k + 1) \cdot X_{\text{state}}(k + 1 | k) \cdot H(k + 1)^{T} \text{ : state covariance in observation space}
$$

### Observation Model Noise

The observation model will have some noise and the sources of noise are the same as the process model.

The covariance matrix of the observation model noise is:
$$
W_{z} =
\left(
    \begin{matrix}
        \sigma_{\hat{z}_{1}}\sigma_{\hat{z}_{1}} & \dots & \sigma_{\hat{z}_{1}}\sigma_{\hat{z}_{m}} \\
        \vdots & \ddots & \vdots \\
        \sigma_{\hat{z}_{m}}\sigma_{\hat{z}_{1}} & \dots & \sigma_{\hat{z}_{m}}\sigma_{\hat{z}_{m}} \\
    \end{matrix}
\right) \text{ : covariance matrix of observation model noise}
$$

With the addition of the state covariance matrix in observation space, the covariance matrix of the predicted observation vector is:
$$
\hat{Z}(k + 1) = X_{\text{observation}}(k + 1) + W_{z}(k) \text{ : predicted observation covariance matrix}
$$

## Get the Innovation

The innovation is the difference between the measured and truth observations:

$$
\hat{y}(k + 1) = z(k + 1) - \hat{z}(k + 1) \text{ : innovation}
$$

The innovation covariance is simply the sum of all the covariance matrices of the observation vectors but the covariance matrix of the truth observation vector is trivially a zero matrix:
$$
Y(k + 1) = \hat{Z}(k + 1) \text{ : innovation covariance}
$$

> Why do we need the innovation? Because it is used to tune the predicted state vector closer to its true value.

## Kalman Filter

The Kalman gain determines how much we need to correct our prediction of the states.
$$
K(k + 1) = X(k + 1 | k) \cdot H(k + 1)^{T} \cdot Y(k + 1)^{-1} \text{ : Kalman gain}
$$

With the Kalman gain, the updated state and covariance matrix of the state of the next step is:
$$
\begin{aligned}
x(k + 1 | k + 1) = x(k + 1 | k) + K(k + 1) \cdot \hat{y}(k + 1) &\text{ : updated state vector} \\
X(k + 1 | k + 1) = (I - K(k + 1) \cdot H(k + 1)) \cdot X(k + 1 | k) &\text{ : updated covariance matrix of state}
\end{aligned}
$$

The updated state and covariance matrix of the state is fed-back into the EKF algorithm to make the next prediction.

---

## Pseudocode

Summarising all the above, the EKF is:

$$
\begin{aligned}

\text{\bf{input }} &\; f,\; w(k),\; W(k),\; x(k | k),\; X(k | k),\; u(k),\\
                   &\; h,\; v(k + 1),\; V(k + 1),\; z(k + 1) \\
\\

\text{\bf{Prediction:}} \\

x(k + 1 | k) &= f(x(k | k), u(k)) + w_{x}(k) &\text{ : predict next state}\\
F(k + 1 | k) &= \left. \frac{\partial f}{\partial x} \right|_{\hat{x}(k | k), u(k)} &\text{ : calculate proces model Jacobian}\\
X(k + 1 | k) &= F_{x}(k + 1 | k)\cdot X(k | k)\cdot F_{x}(k + 1 | k)^{T} + W_{x}(k) &\text{ : predict next state covariance}\\
\\

\text{\bf{Update:}} \\
\hat{z}(k + 1) &= h(X(k + 1 | k)) + w_{z}(k) &\text{ : measure observation} \\
\hat{y}(k + 1) &= z(k + 1) - \hat{z}(k + 1) &\text{ : calculate innovation} \\
H(k + 1 | k) &= \left. \frac{\partial h}{\partial x} \right|_{\hat{x}(k + 1 | k)} &\text{ : calculate observation model Jacobian} \\
Y(k + 1) &= H(k + 1)X(k + 1 | k)H(k + 1)^{T} + W_{z}(k) &\text{ : calculate innovation covariance} \\
K(k + 1) &= X(k + 1 | k) \cdot H(k + 1)^{T} \cdot Y(k + 1)^{-1} &\text{ : calculate Kalman gain}\\
x(k + 1 | k + 1) &= x(k + 1 | k) + K(k + 1) \cdot \hat{y}(k + 1) &\text{ : update state vector} \\
X(k + 1 | k + 1) &= (I - K(k + 1) \cdot H(k + 1)) \cdot X(k + 1 | k) &\text{ : update state covariance matrix} \\
\\

\text{\bf{return }} &\; x(k + 1 | k + 1),\; X(k + 1 | k + 1)

\end{aligned}
$$
