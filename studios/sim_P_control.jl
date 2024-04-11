### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 23f890e2-b69e-11ec-0064-47d9404478d4
begin
	import Pkg; Pkg.activate()
	using Controlz, CairoMakie, PlutoUI
end

# ╔═╡ 7467bba0-55c9-4018-8720-5460da30f494
TableOfContents()

# ╔═╡ e90b1fcd-f617-4a27-81bd-b2f27d1e82bf
set_theme!(Controlz.cool_theme)

# ╔═╡ 3a2e1d4b-948e-4091-98ea-3c79c13da182
md"
# P-control of liquid level in a tank for disturbance rejection

_problem setup_. the goal is to control the liquid level $h$ [m] in a liquid hold-up tank via a feedback control scheme.

a level controller (LC) receives a measurement of the liquid level from a level transmitter (LT) and, via a control valve, adjusts the flow rate $u$ [m$^3$/min] of a liquid feed stream to maintain $h$ at a set point $h_{\rm sp}$ [m]. the disturbance here is an additional liquid feed stream into the tank that flows at a variable and unpredictable rate $d$ [m$^3$/min].
"

# ╔═╡ b7ed51a0-d254-47ab-8f10-6606ad95f3bd
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/liquid_level_control.png\" width=350>"

# ╔═╡ f11601e6-346f-4808-aee2-d52ca85ac2f2
md"_dynamic model_. a dynamic model for this process is:

```math
\begin{equation}
    A\frac{dh}{dt}=u(t) + d(t) - \frac{1}{R} h(t) \quad \text{for } t \geq 0 \text{ and } 0 \leq h < h_{\rm max}
\end{equation}
```
with (constant) parameters:
*  $A$ [m$^2$]: cross-sectional area of the cylindrical tank from a helicopter view
*  $R$ [min / m$^2$]: resistance to flow in exit line
*  $h_{\rm max}$ [m]: the height of the tank. (the model is invalid at the point where the tank overflows.)
the time $t$ has units: [min].
"

# ╔═╡ c7113d5a-3e62-4a8d-bd3f-b8bf219ac3e8
begin
	hₘₐₓ = 6.0   # tank height, m
	A = 4.0      # tank's cross-sectional area from helicopter view, m²
	R = 3.0      # resistance to flow in exit line, min / m²
end

# ╔═╡ 66483a0c-4b42-4d02-b69e-45f6c466b202
md"* the normal, steady state value for $d$ is $\bar{d}=0$, i.e., the second stream does not feed any liquid into the tank at normal, steady state conditions.
* we wish to maintain $h$ at $h_{\rm sp}=\bar{h}=4$ [m]. 
"

# ╔═╡ 2e6ef7d5-c0c6-4fd5-ace1-df334aeba379
begin
	d̄ = 0.0            # steady state value of disturbance stream flow rate, m³/min.
	h̄ = hₛₚ = 4.0      # steady state value of liquid level, m
end

# ╔═╡ 176b6fc0-49c1-4fdb-a35b-3bb8fc1566ad
md"🐌 given $\bar{d}=0$ m$^3$/min, at what value should we set $u$ to achieve $h_{sp}=\bar{h}=4$ m at steady state conditions? define it below as `ū` (the bias value for the P-controller)."

# ╔═╡ d50e7db1-5942-454e-9679-9e2b0d268c97
ū = h̄ / R

# ╔═╡ 24cf9452-b260-458d-8c9c-b3924dde01b9
md"a simplified block diagram modeling| the feedback control loop is below. 

!!! note
	we simplify by neglecting:
	* the current-to-pressure transducer
	* the sensor
	* the valve
	conceptually, the gains of each of these components are amalgamated into the gain in the control law $G_c(s)$.
"

# ╔═╡ 1d8c89f4-c17b-46c5-8b92-880ee2eccef8
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/liquid_level_control_block_diagram.png\" width=600>"

# ╔═╡ 0191d25d-da8c-4979-beb0-134b17975ce3
md"💡 for the feedback controller, we will employ a P-controller with controller gain $|K_c|=2$. we wish to simulate the closed-loop response to a disturbance and compare the liquid level to a situtation where we _didn't_ have the controller."

# ╔═╡ 70f0aeca-ed91-4e7c-91fe-9faaec8df94e
md"
✏ derive the transfer functions $G_u(s)$ and $G_d(s)$.

🐌 define the transfer functions $G_u(s)$ and $G_d(s)$ for `Controlz.jl` as variables `G_u` and `G_d`, respectively. see [docs on defining transfer functions](https://simonensemble.github.io/Controlz.jl/dev/tfs/)."

# ╔═╡ 6e2e99a7-fcad-40fa-a316-99b5e9cbdf98

# ╔═╡ f1c688ef-4d39-4e0e-bc29-4f3bcba19e2b

# ╔═╡ e83d0a13-233e-4b0d-8abd-e087178edf34
md"### the disturbance input
now that we have our process model ($G_u(s)$ and $G_d(s)$), we will simulate the (i) open-loop and (ii) closed-loop response to a step input in the disturbance $d$, where at $t=0$, $d$ changes from $0$ to $1.2$ m$^3$/min. 
"

# ╔═╡ c0fcd8de-47fa-4252-94e3-40a55b35c46f
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/d.png\" width=300>"

# ╔═╡ caf3831e-143b-4d4b-b2f6-d98a298a1207
md"🐌 define the Laplace transform of $d(t)=d^*(t)$, $D^*(s):=\mathcal{L}[d^*(t)]$ as a variable `D★` below.
"

# ╔═╡ 3fa825ad-79dd-4f36-8d44-619f38f96750

# ╔═╡ 6801bb66-3d85-4b08-8143-1bf0b9d00cfd
md"🐌 we will run our simulations of the response for $t\in[0, 45]$ min. define `final_time` below."

# ╔═╡ 62f854e1-8c01-4359-9f78-2644916c1ce8

# ╔═╡ 5c4db380-e819-4df2-81fc-749b11687d6c
md"### the open-loop response (controller \"off\")
as a baseline to judge the quality of our feedback control system, let's first consider the *open-loop* response *without* an active level controller that adjusts $u$ based on the error signal $e(t)$.

i.e., let's simulate the open-loop response $h(t)$ to the step input in $d(t)$ when $u(t)$ is maintained at its steady state value $\bar{u}$, i.e. when no controller action is taken to counteract the disturbance.

🐌 define a variable `H_no_control★` as the Laplace transform of the step response $\mathcal{L}[h^*(t)]=H^*(s)$ when the controller is \"off\". 

!!! hint
	use the transfer functions you defined above. `Controlz.jl` can multiply transfer functions for you. see [docs](https://simonensemble.github.io/Controlz.jl/dev/tfs/#transfer-function-algebra).

"

# ╔═╡ e77ccc69-f7f2-4f53-a61e-ab074a72d654

# ╔═╡ 57884e09-97cb-4126-a6ac-97050530088f
md"🐌 simulate the response to the step in the disturbance variable (without control). assign the data table containing the output data as a variable `data_no_control`.

!!! hint
	see [docs on `simulate`](https://simonensemble.github.io/Controlz.jl/dev/sim/).
"

# ╔═╡ b5e6fb4c-2d38-4202-a35f-b66e15be0633

# ╔═╡ b7c0859e-2618-4566-ab21-0d9c27a6d706
md"### the closed-loop response (controller \"on\")

now, simulate the *closed-loop* response to the step change in the disturbance variable $d(t)$. ie., a level controller---a P-controller with controller gain $|K_c|=2.0$---is \"on\" and actively counteracting this disturbance.

🐌 define the control law `G_c` (a transfer function) as a variable below. 

!!! note 
	I only gave the magnitude of the controller gain, not whether it is positive or negative. think carefully about what sign ($+$ or $-$) the controller gain should be.
"

# ╔═╡ 316f807d-e09b-4096-9f57-d97ad77638de

# ╔═╡ 076fc636-f563-4e1c-884c-36f29a0177a2
md"✏ use your block diagram algebra skills to find $G_r(s):= H^*(s)/D^*(s)$, the transfer function that gives the closed-loop response $h^*(t)$ to changes in the disturbance $d(t)$ (while the set point is constant). 

!!! note
	the notation \"r\" in $G_r(s)$ indicates this transfer function describes the closed-loop **r**egulator response---the response to a disturbance. 

🐌 define the transfer function $G_r(s)$ as a variable `G_r` below. this will allow us to simulate the closed-loop response.

!!! hint
	use `Controlz.jl` to do the transfer function algebra for you, ie. to multiply and divide the transfer functions `G_u`, `G_c`, and `G_d` appropriately to define `G_r`.
"

# ╔═╡ b22bb250-50eb-4525-8135-66ac400fec58

# ╔═╡ 8d82e47c-6158-46ad-943f-08d3ab51d851
md"🐌 define `H_w_control★` as the closed-loop response $H^*(s)$ to the step in the disturbance $d(t)$, this time with the P-controller \"on\" (hence \"closed-loop\")."

# ╔═╡ 7950943f-20cd-4b98-aa8b-fa4d0f7e7816

# ╔═╡ e817237b-8aaa-4d90-bde2-28b9bb100364
md"🐌 finally, simulate the closed-loop response $h^*(t)$ and assign the data table containing the output as a variable `data_w_control`."

# ╔═╡ c3292620-b13e-48bc-a2cf-c39b5ec5f3b8

# ╔═╡ 4d522f60-9ff9-4b7f-bcd1-b2b44c76df09
md"
### visualize and compare open- and closed-loop response
🐌 on the same panel, plot:
* a curve giving the open-loop response $h(t)$ (not in deviation form)
* a curve giving the closed-loop response $h(t)$
* a horizontal, dashed line giving $h_{\rm sp}$
* a horizontal, dotted line giving $h_{\rm max}$

draw a legend labeling each curve as \"controller off\", \"controller on\", and \"set point\". include x- and y-axis labels.

!!! hint
	Makie docs [here](https://makie.juliaplots.org/stable/). see also my [Julia demo](https://simonensemble.github.io/CHE_361_W2023/demos/html/intro_to_julia.jl.html).
"

# ╔═╡ 2e66cef5-1b0c-49f1-8179-1ec1e2846778

# ╔═╡ c773634e-af0c-4fbe-82c3-77227682bba0
md"
🐌 compare the closed-loop response $h(t)$ to the open-loop response, to see the benefit of the P-controller.
* does the tank overflow without the P-controller?
* does the P-controller stop the tank from overflowing as a result of the disturbance?
* what is a clear deficiency of the closed-loop response? something about the closed-loop response should bother you... think about the objective of disturbance rejection.
"

# ╔═╡ 0cdba1f8-2963-4196-bc65-9a1eeb7f693b
md"
[...your answers here ...]
"

# ╔═╡ d879bb9d-0ce5-411c-8bef-ef4fb35c6000
md"🐌 what is the value of the steady state offset error? calculate it from the simulated data."

# ╔═╡ 59655850-9946-4686-b4d4-adec8e3410c2

# ╔═╡ Cell order:
# ╠═23f890e2-b69e-11ec-0064-47d9404478d4
# ╠═7467bba0-55c9-4018-8720-5460da30f494
# ╠═e90b1fcd-f617-4a27-81bd-b2f27d1e82bf
# ╟─3a2e1d4b-948e-4091-98ea-3c79c13da182
# ╟─b7ed51a0-d254-47ab-8f10-6606ad95f3bd
# ╟─f11601e6-346f-4808-aee2-d52ca85ac2f2
# ╠═c7113d5a-3e62-4a8d-bd3f-b8bf219ac3e8
# ╟─66483a0c-4b42-4d02-b69e-45f6c466b202
# ╠═2e6ef7d5-c0c6-4fd5-ace1-df334aeba379
# ╟─176b6fc0-49c1-4fdb-a35b-3bb8fc1566ad
# ╠═d50e7db1-5942-454e-9679-9e2b0d268c97
# ╟─24cf9452-b260-458d-8c9c-b3924dde01b9
# ╟─1d8c89f4-c17b-46c5-8b92-880ee2eccef8
# ╟─0191d25d-da8c-4979-beb0-134b17975ce3
# ╟─70f0aeca-ed91-4e7c-91fe-9faaec8df94e
# ╠═6e2e99a7-fcad-40fa-a316-99b5e9cbdf98
# ╠═f1c688ef-4d39-4e0e-bc29-4f3bcba19e2b
# ╟─e83d0a13-233e-4b0d-8abd-e087178edf34
# ╟─c0fcd8de-47fa-4252-94e3-40a55b35c46f
# ╟─caf3831e-143b-4d4b-b2f6-d98a298a1207
# ╠═3fa825ad-79dd-4f36-8d44-619f38f96750
# ╟─6801bb66-3d85-4b08-8143-1bf0b9d00cfd
# ╠═62f854e1-8c01-4359-9f78-2644916c1ce8
# ╟─5c4db380-e819-4df2-81fc-749b11687d6c
# ╠═e77ccc69-f7f2-4f53-a61e-ab074a72d654
# ╟─57884e09-97cb-4126-a6ac-97050530088f
# ╠═b5e6fb4c-2d38-4202-a35f-b66e15be0633
# ╟─b7c0859e-2618-4566-ab21-0d9c27a6d706
# ╠═316f807d-e09b-4096-9f57-d97ad77638de
# ╟─076fc636-f563-4e1c-884c-36f29a0177a2
# ╠═b22bb250-50eb-4525-8135-66ac400fec58
# ╟─8d82e47c-6158-46ad-943f-08d3ab51d851
# ╠═7950943f-20cd-4b98-aa8b-fa4d0f7e7816
# ╟─e817237b-8aaa-4d90-bde2-28b9bb100364
# ╠═c3292620-b13e-48bc-a2cf-c39b5ec5f3b8
# ╟─4d522f60-9ff9-4b7f-bcd1-b2b44c76df09
# ╠═2e66cef5-1b0c-49f1-8179-1ec1e2846778
# ╟─c773634e-af0c-4fbe-82c3-77227682bba0
# ╠═0cdba1f8-2963-4196-bc65-9a1eeb7f693b
# ╟─d879bb9d-0ce5-411c-8bef-ef4fb35c6000
# ╠═59655850-9946-4686-b4d4-adec8e3410c2
