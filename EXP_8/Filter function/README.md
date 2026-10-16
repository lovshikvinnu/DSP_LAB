# Comprehensive Guide: First-Order Recursive Systems & Stability (DSP Experiment 8)

---

## 1. The Core Equation & Physical Meaning

The system is defined by the first-order linear difference equation:

$$y(n) = b_1 y(n-1) + x(n)$$

This equation models a **recursive (Infinite Impulse Response - IIR) discrete-time filter with feedback**:

* **$x(n)$ (Current Input):** The excitation applied directly to the system at sample step $n$.
* **$y(n-1)$ (Previous Output):** The system's output state stored in unit-delay memory from the immediately preceding clock cycle $n-1$.
* **$b_1$ (Feedback Gain):** The scaling coefficient determining how much of the prior internal state recirculates back into the system.

> **Intuitive Model:** At every time instant, the current output is formed by taking whatever input sample just entered, plus a scaled memory of the previous output.

---

## 2. Chronological Impulse Propagation

When driven by a unit impulse input:

$$x(n) = \delta(n) = \begin{cases} 1, & n = 0 \\ 0, & n \neq 0 \end{cases}$$

Under the standard assumption of **initial rest** (zero initial state conditions prior to excitation, meaning $y(n) = 0$ for all $n < 0$):

1. **For $n < 0$:**
   $$\forall n < 0, \quad x(n) = 0, \quad y(n) = 0$$
   No excitation has entered; internal system memory is completely clear.

2. **At $n = 0$:**
   $$y(0) = b_1 \cdot y(-1) + x(0) = b_1(0) + 1 = 1$$
   The impulse charges the system state to an initial amplitude of $1$.

3. **At $n = 1$:**
   Since the impulse is momentary, $x(1) = 0$. The response is driven strictly by feedback:
   $$y(1) = b_1 \cdot y(0) + x(1) = b_1(1) + 0 = b_1$$

4. **At $n = 2$:**
   $$y(2) = b_1 \cdot y(1) + x(2) = b_1(b_1) + 0 = b_1^2$$

5. **Inductive Form for Any $n \ge 0$:**
   $$y(n) = (b_1)^n$$

Because the input applied was $\delta(n)$, the resulting output $y(n)$ is identically the **impulse response $h(n)$**:

$$h(n) = (b_1)^n u(n)$$

---

## 3. Z-Transform, Pole Dynamics & BIBO Stability

Applying the unilateral/bilateral Z-transform across the difference equation:

$$\mathcal{Z}\{y(n) - b_1 y(n-1)\} = \mathcal{Z}\{x(n)\}$$

$$Y(z) - b_1 z^{-1}Y(z) = X(z)$$

Factoring out $Y(z)$ yields the transfer function $H(z)$:

$$H(z) = \frac{Y(z)}{X(z)} = \frac{1}{1 - b_1 z^{-1}} = \frac{z}{z - b_1}$$

The system contains:
* A **trivial zero** at $z = 0$.
* A **single dominant pole** at $z = b_1$.

The stability criteria dictate that a causal LTI discrete system is **Bounded-Input Bounded-Output (BIBO) stable** if and only if all system poles lie strictly inside the complex unit circle ($\vert{}z\vert{} < 1$).

---

## 4. Comparative Case Breakdown

| Metric / Property | Case 1: $b_1 = 2$ | Case 2: $b_1 = 0.5$ |
| :--- | :--- | :--- |
| **Transfer Function $H(z)$** | $\displaystyle \frac{1}{1 - 2z^{-1}}$ | $\displaystyle \frac{1}{1 - 0.5z^{-1}}$ |
| **Pole Location** | $z = 2$ | $z = 0.5$ |
| **Unit Circle Position** | Outside unit circle ($\vert{}z\vert{} = 2 > 1$) | Inside unit circle ($\vert{}z\vert{} = 0.5 < 1$) |
| **Impulse Response $h(n)$** | $y(n) = 2^n u(n)$ | $y(n) = (0.5)^n u(n)$ |
| **Numeric Progression ($n=0 \to 10$)** | $1, 2, 4, 8, 16, \dots, 1024$ | $1, 0.5, 0.25, 0.125, \dots, 0.0009765$ |
| **Physical Manifestation** | Energy doubles every sample cycle; runaway positive feedback | Energy halves every sample cycle; exponential dissipation / damping |
| **System Stability Status** | **BIBO Unstable (Explosive)** | **BIBO Stable (Convergent)** |

---

## 5. How MATLAB Formulates `filter(b, a, x)`

MATLAB formats all linear discrete difference equations as:

$$\sum_{k=0}^{N} a(k+1) y(n-k) = \sum_{m=0}^{M} b(m+1) x(n-m)$$

Expanding the summation into explicit terms:

$$a(1)y(n) + a(2)y(n-1) + \dots + a(N+1)y(n-N) = b(1)x(n) + b(2)x(n-1) + \dots + b(M+1)x(n-M)$$

### Coefficient Mapping

To map $y(n) = b_1 y(n-1) + x(n)$ into MATLAB's convention, rearrange all terms involving output $y$ to the left-hand side:

$$1 \cdot y(n) - b_1 \cdot y(n-1) = 1 \cdot x(n) + 0 \cdot x(n-1)$$

Matching terms directly:
* **Numerator Vector `b` (Feedforward Weights):**
  $$\mathbf{b} = [b(1), b(2)] = [1, 0]$$
* **Denominator Vector `a` (Feedback Weights):**
  $$\mathbf{a} = [a(1), a(2)] = [1, -b_1]$$

> **The Sign Inversion Rule:**  
> In manual difference equations, feedback terms appear on the right with a **positive sign** ($+b_1 y(n-1)$). In MATLAB, these terms are shifted to the left-hand side ($y(n) - b_1 y(n-1)$), causing the coefficient in `a` to flip to **negative** ($-b_1$).

---

## 6. Equivalence of Iterative Calculation and `filter()`

* **Manual Iteration (`for` loop):** Directly evaluates the temporal difference equation sequentially index by index, fetching the previously calculated index `y(k-1)` from memory.
* **Built-in `filter()` Function:** Implements a compiled, hardware-optimized Direct Form II Transposed realization of the identical rational transfer function $H(z)$, assuming quiescent initial conditions.

Because both implementations evaluate the identical recurrence relationship:

$$y(n) = b_1 y(n-1) + \delta(n)$$

the output matrices are numerically identical across all points $n \in [-5, 10]$.
