# Statistics

## Mean

$$
\bar{x} = \frac{1}{n}\sum_{i = 1}^{n}{x_{i}}
$$

## Median

$$
\tilde{x} =
    \begin{cases}
        x_{\frac{n + 1}{2}} & \text{ if odd} \\
        \frac{1}{2}\left(x_{\frac{n}{2}} + x_{\frac{n}{2} + 1}\right) & \text{ if even}
    \end{cases}
$$

## Random Variable


## Probability Density Function

$$
f(x) = F'(x)
$$

## Expectation

Expectation is the mean of a *large* number of outcomes of a random variable.

$$
\mu = E(X) = \overbrace{\sum_{x \in S_{x}}{xp(x)}}^{\text{discrete}} = \overbrace{\int_{x \in S_{x}}{xf(x)dx}}^{\text{continuous}}
$$

## Standard Deviation

$$
\sigma = \sqrt(\frac{1}{n - 1} \sum_{i = 1}^{n}{\left(x_{i} - \bar{x} \right)^2} )
$$

## Variance

$$
\begin{aligned}
    \sigma^2 = E\left((X - \mu)^{2} \right) = E(X)^{2} - \mu^{2}
\end{aligned}
$$

## Normal Distribution

<iframe src="https://www.desmos.com/calculator/cthhxvy5ac?embed" width="100%" height="300"></iframe>

Let $X$ be a random variable with a normal distribution:
$$
X \thicksim \mathcal{N}(\mu, \sigma^{2})
$$

The expectation is:
$$
E(X) = \mu
$$

The variance is:
$$
Var(X) = \sigma^{2}
$$

## Covariance

The covariance is a measure of direction of the relationship between two variables:

$$
cov(X, Y) = E\left( \left(X - E(X)\right) \left(Y - E(Y)\right) \right)
$$

## Covariance Matrix

The covariance matrix is a square matrix giving the covariances between each pair of elements of a single random vector.

Let $X$ be a random vector and the covariance of $X$ is:
$$
cov(X) = E\left( \left(X  - E(X)\right) \left(X  - E(X)\right)^{T} \right)
$$

Suppose the random vector, $X$, is linearly transformed into a random vector, $X$, by some matrix, $G$:
$$
Y = GX
$$

The covariance matrix of $Y$ is then:
$$
\begin{aligned}
cov(Y) &= E\left( \left(Y - E(Y)\right) \left(Y - E(Y)\right)^{T} \right) \\
&= E\left( \left(GX - E(GX)\right) \left(GX - E(GX)\right)^{T} \right) \\
&= E\left( G\left(X - E(X)\right) \left(X - E(X)\right)^{T}G^{T} \right) \\
&= G \cdot E\left( \left(X - E(X)\right) \left(X - E(X)\right)^{T} \right) \cdot G^{T} \\
&= G \cdot cov(X) \cdot G^{T} \\
\end{aligned}
$$

## Cross-Covariance Matrix

The cross-covariance matrix is the covariance between two random vectors i.e. the $(i, j)$ element of the cross-covariance matrix is the covariance of the $i^{th}$ element of a random vector and $j^{th}$ element of another random vector.

## Random Vector

A list of random variables:
$$
\vec{X} = \left(\begin{matrix} X_{1} \\ \vdots \\ X_{n} \end{matrix}\right)
$$

## Multivariate Probability Density Function

A random vector, $X$ of $k^{th}$ dimension, has a probability density function:
$$
\vec{X} \thicksim \mathcal{N}_{k}(\vec{\mu}, \vec{\Sigma})
$$

Where:
- $\vec{\mu}$ is the mean vector:
$$
    \vec{\mu} = E(\vec{X}) = \left(\begin{matrix} E(X_{1}) \\ \vdots \\ E(X_{k}) \end{matrix}\right)
$$

- $\vec{\Sigma}$ is the covariance matrix:
$$
    \vec{\Sigma}_{i, j} = Cov(X_{i}, X_{j})
$$

## White Noise

Whitenoise is a signal with:
$$
\begin{aligned}
    E(\epsilon(n)) &= 0 \\
    Var(\epsilon(n)) &= \sigma^{2} \neq 0 \\
    E(\epsilon(n) \epsilon(n - k)) &= 0,\; k > 0
\end{aligned}
$$
