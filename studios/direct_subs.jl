### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ c9b7b9d2-cc91-11ec-3145-9b557b81a06a
begin
	using Pkg; Pkg.activate()
	using Controlz, CairoMakie, Polynomials
end

# ╔═╡ 71bde5ab-f2b8-4c9f-aea1-ba298be87db2
set_theme!(Controlz.cool_theme)

# ╔═╡ f3740f48-2c10-4f3b-9886-33a04279f989
md"## the direct substitution method

💡 the direct substitution method aims to find the critical controller gain $K_c^\prime$ that makes a closed loop system marginally stable.

!!! note
	marginal stability is at the boundary of stability and instability---eg. the impulse response of a marginally stable system will present undamped (constant-amplitude) oscillations.

❓ why is knowing the critical controller gain $K_{c}^\prime$ important?
* we wish to avoid choosing too aggressive controller settings that make the closed loop unstable.
* some controller tuning methods, e.g. the Ziegler–Nichols tuning method, use (a) the critical gain $K_c^\prime$ and (b) the period $P=2\pi/\omega$ of the oscillations at marginal stability to set the parameters of a PID controller.

#### the control loop
below is the closed-loop control system---the focus of this studio---composed of:
* a second-order process
* a sensor with first-order dynamics
* a P-controller with to-be-determined gain $K_c$

![](https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2022/main/random/closed_loop_for_direct_subs.png)
"

# ╔═╡ 02873045-8df2-4099-9325-e7ec0654d549
md"🦖 assign the process and sensor transfer functions as variables `G_u`, `G_d`, and `G_s` below."

# ╔═╡ cab49729-5b76-4e9b-86c2-a2ba15e81c6c


# ╔═╡ 93f575a8-547a-4bfb-b724-af2cdcda769b


# ╔═╡ 5fae1407-aca3-434a-aab5-39a30e6019d0


# ╔═╡ 3ffc25d5-0fc0-487d-8e2f-c619a7ca3f7a
md"
#### the direct substitution method
✏ use the direct substitution method to (on pencil and paper) find:
1. the critical controller gain, $K_c^\prime$, that endows this closed loop with marginally stability.
2. the frequency $\omega$ and period $P$ of oscillations in the closed-loop response (to eg. an impulse in the disturbance variable) when the controller gain is set $K_c:=K_c^\prime$.

define them as variables `K_c′`, `ω`, and `P` below.
"

# ╔═╡ 4e093e9e-f90c-41bf-bcbe-e6436a147797


# ╔═╡ 9961c3d1-7192-4c88-a863-f94572b3ef56
# critical controller gain

# ╔═╡ 53e41cbf-8af9-497b-956f-af8d9d1f7a3a
# critical frequency ω

# ╔═╡ 39e4c7bc-ef6c-4be1-9a40-2b59def350ef
# critical period P

# ╔═╡ 6c79a25d-7ae8-46fc-8504-e4b3ae48a1f9
md"
#### confirming the direct substitution method via roots of the char. eqn.
🦖 suppose the gain of the P-controller is set at the critical gain, $K_c=K_{c}^\prime$. construct the controller transfer function `G_c`.
"

# ╔═╡ 6c2df4f7-0b36-4dea-864c-d38dcfc97c48


# ╔═╡ 140b4dcc-4c8f-4f6d-921b-eb054e3082f6
md"
🦖 now construct the open-loop transfer function and assign it as a variable `G_ol`. 
"

# ╔═╡ 93eee815-de9a-4c1f-84fa-0b935c2a6531


# ╔═╡ 008bf0bc-4132-4225-9bf8-d7c6622f2ed6
md"🦖 use `characteristic_polynomial` (see [here](https://simonensemble.github.io/Controlz.jl/dev/tfs/#Controlz.characteristic_polynomial)) to construct the characteristic polynomial of the closed loop when $K_c:=K_{c}^\prime$. assign it as a variable `char_poly`. does it agree with the one you derived on pencil and paper?"

# ╔═╡ 8dc8e3cb-9923-41a1-8902-df61bd9af160


# ╔═╡ 2c051e80-7aa8-4088-afe5-41bc257f8f56
md"🦖 use the `roots` function to compute the roots of the characteristic polynomial of the closed loop when $K_c:=K_c^\prime$. do the roots agree with your expectations? precisely, how so?

[... your answer here...]
"

# ╔═╡ cda5b1eb-53c9-4026-a1d8-776781057ac1


# ╔═╡ 1c8ea2f5-8094-4723-862a-f52a4e36d655
md"
#### confirming the direct substitution method via poles of the closed-loop transfer function

!!! note
    the roots of the characteristic equation are poles of the closed-loop transfer functions.

🦖 derive the closed-loop transfer function $Y^*(s)/D^*(s)$ giving the closed-loop response to disturbances (when the set point is fixed) and assign it as a variable `G_reg` (reg = \"regulator\").
"


# ╔═╡ c870b365-a9ff-4a64-9698-115f41ed1bfa
# define the closed-loop transfer function

# ╔═╡ 0f31f8ec-cf2f-4d56-9e36-fa1cbdc71bc2
md"
🦖 use `viz_poles_and_zeros` (see [here](https://simonensemble.github.io/Controlz.jl/dev/viz/#poles-and-zeros-of-a-transfer-function)) to visualize the poles and zeros of the closed-loop transfer function `G_reg`. do some poles of `G_reg` lie in a particular location in the complex plane $\mathbb{C}$ that you'd expect given $K_c:=K_{c}^\prime$?

[... your observation here...]

"

# ╔═╡ dbbceebd-99be-4f5e-a0cf-0b5e0ed59d37
# visualize the poles and zeros of the closed-loop transfer function

# ╔═╡ 9fa6727b-6e59-4c2e-a72b-51358fe2443f
md"#### confirming the direct substitution method via simulation of the response to a disturbance
🦖 simulate the closed-loop response to a unit step input in the disturbance variable, where the P-controller has gain $K_c:=K_c^\prime$.
* construct `D★`
* construct `Y★`
* use `simulate` to simulate for $t\in[0, 125]$
* visualize the response e.g. via `viz_response`.

e.g. see [docs](https://simonensemble.github.io/Controlz.jl/dev/viz/#response-of-a-system-to-an-input).

🦖 does the unit step response conform to your expectations, given $K_c=K_{c}^\prime$? precisely, how so? mention the period $P$ you calculated above as well.

[...your answer here...]
"

# ╔═╡ 2bf4b201-df07-46a7-9de8-41144b35a4f8


# ╔═╡ 56f61118-c4c8-4209-b6bd-a423659d9724


# ╔═╡ b7027242-471b-4df4-a153-8f63c7c2adcb


# ╔═╡ 40297150-ed78-4631-915b-cc00381ebee2


# ╔═╡ a62cd94b-af78-4bcf-90cd-973787c39765
md"#### Ziegler–Nichols PID controller tuning method

now that we've determined the critical controller gain $K_{c}^\prime$ and associated oscillation period $P$, the Ziegler–Nichols (ZN) PID controller tuning method (see [here](https://en.wikipedia.org/wiki/Ziegler%E2%80%93Nichols_method)) provides a simple formula for how to set the parameters of a PID-controller for disturbance rejection. this is a widely used heuristic controller tuning method. (see [here](https://en.wikipedia.org/wiki/Heuristic) for the definition of \"heuristic\".)

🦖 use the ZN tuning rules to set $K_c$, $\tau_I$, and $\tau_D$ for a PID-controller for this closed loop.
"

# ╔═╡ 74a84e7e-f2de-4046-bd0b-ee2ae382a2a3


# ╔═╡ aeb0ace3-1bca-4076-a321-6166a1aa3606
md"🦖 now simulated the closed-loop response to a unit step in the disturbance variable using a PID controller with the $K_c$, $\tau_I$, and $\tau_D$ set via the ZN-tuning rules. does the controller reasonably perform, in comparison to no control as a baseline?

!!! hint
	see the `PIDController` helper function [here](https://simonensemble.github.io/Controlz.jl/dev/controls/#Controlz.PIDController).

[...your answer ...]
"

# ╔═╡ 5842a500-4094-41ed-97f6-60542baace4a


# ╔═╡ 6489b517-ded3-498b-9085-b64cabbf45ee
md"!!! note
	hopefully, this exercise illustrates the very practical value of analyzing the stability of closed-loop control systems: methods like the ZN-tuning rules specify how to determine good PID controller parameters, using the critical gain $K_c^\prime$ and associated oscillation period $P$!
"

# ╔═╡ Cell order:
# ╠═c9b7b9d2-cc91-11ec-3145-9b557b81a06a
# ╠═71bde5ab-f2b8-4c9f-aea1-ba298be87db2
# ╟─f3740f48-2c10-4f3b-9886-33a04279f989
# ╟─02873045-8df2-4099-9325-e7ec0654d549
# ╠═cab49729-5b76-4e9b-86c2-a2ba15e81c6c
# ╠═93f575a8-547a-4bfb-b724-af2cdcda769b
# ╠═5fae1407-aca3-434a-aab5-39a30e6019d0
# ╟─3ffc25d5-0fc0-487d-8e2f-c619a7ca3f7a
# ╠═4e093e9e-f90c-41bf-bcbe-e6436a147797
# ╠═9961c3d1-7192-4c88-a863-f94572b3ef56
# ╠═53e41cbf-8af9-497b-956f-af8d9d1f7a3a
# ╠═39e4c7bc-ef6c-4be1-9a40-2b59def350ef
# ╟─6c79a25d-7ae8-46fc-8504-e4b3ae48a1f9
# ╠═6c2df4f7-0b36-4dea-864c-d38dcfc97c48
# ╟─140b4dcc-4c8f-4f6d-921b-eb054e3082f6
# ╠═93eee815-de9a-4c1f-84fa-0b935c2a6531
# ╟─008bf0bc-4132-4225-9bf8-d7c6622f2ed6
# ╠═8dc8e3cb-9923-41a1-8902-df61bd9af160
# ╟─2c051e80-7aa8-4088-afe5-41bc257f8f56
# ╠═cda5b1eb-53c9-4026-a1d8-776781057ac1
# ╟─1c8ea2f5-8094-4723-862a-f52a4e36d655
# ╠═c870b365-a9ff-4a64-9698-115f41ed1bfa
# ╟─0f31f8ec-cf2f-4d56-9e36-fa1cbdc71bc2
# ╠═dbbceebd-99be-4f5e-a0cf-0b5e0ed59d37
# ╟─9fa6727b-6e59-4c2e-a72b-51358fe2443f
# ╠═2bf4b201-df07-46a7-9de8-41144b35a4f8
# ╠═56f61118-c4c8-4209-b6bd-a423659d9724
# ╠═b7027242-471b-4df4-a153-8f63c7c2adcb
# ╠═40297150-ed78-4631-915b-cc00381ebee2
# ╟─a62cd94b-af78-4bcf-90cd-973787c39765
# ╠═74a84e7e-f2de-4046-bd0b-ee2ae382a2a3
# ╟─aeb0ace3-1bca-4076-a321-6166a1aa3606
# ╠═5842a500-4094-41ed-97f6-60542baace4a
# ╟─6489b517-ded3-498b-9085-b64cabbf45ee
