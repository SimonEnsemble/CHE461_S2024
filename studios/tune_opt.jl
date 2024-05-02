### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ e548009a-faa1-11ee-1600-05d467db87e3
begin
	import Pkg; Pkg.activate()
	using Controlz, CairoMakie, Optim, DataFrames
end

# ╔═╡ 229b3d17-90fc-4db9-824d-4fe02c20a1ef
update_theme!(size=(400, 400), linewidth=3, fontsize=20)

# ╔═╡ 7b7476b8-598e-4d07-b576-a7438213d653
md"## tuning a PI controller via simulations of the closed-loop response

our task is to tune a PI controller for the closed loop below. we have:
* a model for the dynamics of the sensor, through $G_s(s)$
* a model for the dynamics of the output of the process $Y(s)$ in response to changes in
  * the manipulated variable $U^*(s)$, through $G_u(s)$
  * the disturbance variable $D^*(s)$, through $G_d(s)$

units of $s$: min$^{-1}$
"

# ╔═╡ 4a6bc087-bddf-44e2-b54e-6b70e0229355
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/closed_loop.jpg\" width=650>"

# ╔═╡ 502bde1d-e3e2-46ab-829d-8be29f6185d9
Gu = 4 * exp(-0.05 * s) / (3 * s + 1)

# ╔═╡ 6a513f76-5153-46eb-af06-437c647610ad
Gd = -2 / (5 * s + 1)

# ╔═╡ 0b58b6ed-1adf-4131-bb69-1b4f5563b087
Gs = exp(-0.25 * s) / (0.1 * s + 1)

# ╔═╡ b889c062-18d1-4a1a-a0d1-2196e2cb4fd2
md"
### predicting the closed-loop response under given controller settings
💡 with this process model, we can predict the closed-loop response to a disturbance or set point change.

e.g. consider a unit step input in the disturbance variable $D^*(s)$.

🍕 write a function `sim_closed_loop(K_c, τ_I, tf)` that simulates the closed-loop response for $t\in[0, 30]$ min and returns time series data characterizing the output $y^*(t)$.
* `K_c`: PI-controller gain
* `τ_I`: integral time constant

!!! note
	see the `Controlz.jl` docs [here](https://simonensemble.github.io/Controlz.jl/dev/controls/#feedback-loops-with-time-delays). owing to the time delays, you need to construct the closed-loop transfer function using `ClosedLoopTransferFunction`.
"

# ╔═╡ 4bee5ec0-3ca1-40df-aa72-65b9aefb2556

# ╔═╡ 1a10f575-a836-4c2a-907e-93dec355bd40
md"🍕 simulate the closed-loop response for the following controller settings:
* no control ($K_c=0$)
*  $K_c=0.2$, $\tau_I=1.0$ min
*  $K_c=0.2$, $\tau_I=0.4$ min
*  $K_c=1.0$, $\tau_I=0.4$ min
and plot the closed-loop responses $y^*(t)$ in the same panel (different colors) for comparison. include a legend to indicate which response corresponds to which colored curve.

🤔 which controller settings do you think are \"best\"?
"

# ╔═╡ 26a9bd47-fe31-44d5-8c62-0e5cecc321f4
PI_controller_params = [
	(; K_c=0.0, τ_I=1.0), # no control
	(; K_c=0.2, τ_I=1.0),
	(; K_c=0.2, τ_I=0.4),
	(; K_c=1.0, τ_I=0.4)
]

# ╔═╡ cf0303df-d0f9-411b-8844-6f17dd580b13
PI_controller_params[2].K_c # to see how to unpack this.

# ╔═╡ 57c3d685-5a7a-4464-9414-0374dc561b1f
to_label(p) = rich("K", subscript("C"), "=$(p.K_c), τ", subscript("I"), "=$(p.τ_I)")

# ╔═╡ 55d91b4d-25a5-40fe-a221-4a8280e4cf8c

# ╔═╡ 7a8e8f7d-a72e-4e28-ac44-8dcb3dd3200c
md"
## scoring the quality of the closed-loop response under a particular controller setting
let's score the performance of a particular PI-controller setting for the closed-loop response to a step in the disturbance with the ITSE (integral of time-weighted squared error):
```math
ITSE(K_c, \tau_I) := \int_0^{30} t [e(t)]^2 dt
```
(ofc, we want a low ITSE.)

🍕 write a function `ITSE(data::DataFrame)` that computes the ITSE metric from time series data using a numerical integration routine.
"

# ╔═╡ 7ab2addb-f6ba-4a25-86b2-80f3424076c4

# ╔═╡ 5d8357fb-cc4e-4b0c-bcf8-b8f90a3de486
md"🍕 write a function `ITSE(K_c::Float64, τ_I::Float64)` that computes the ITSE of the closed-loop response to a unit step in the disturbance variable under PI-control with the controller gain and integral time constant passed in.

!!! hint
	this should be two lines of code. call your functions above.
"

# ╔═╡ 89ebf90c-60bc-4ab1-bead-5bc82d5424d8

# ╔═╡ ffdb3349-0477-4940-834d-00f0beab1720
md"🍕 for numerical integration to well-approximate the true integral, the spacing $\Delta t$ needs to be small. pass `nb_time_points=300` into your `simulate()` call in `sim_closed_loop` to ensure you have high resolution."

# ╔═╡ bae7610e-9bd0-49db-986d-3162a60fccfa
md"🍕 compute the ITSE for each PI-controller setting above. according to the ITSE, which controller setting is best?"

# ╔═╡ b4553613-3db2-4b4e-93f2-1a374ad5e0be

# ╔═╡ 3837e07d-0c00-4113-8c3f-e240d4139890

# ╔═╡ c25c7a9a-cd75-40d4-882f-9fca161d8f9a
md"
## controller design: minimize the ITSE
💡 a design principle is to choose $K_c$ and $\tau_I$ that minimize the ITSE metric.

🍕 for a 2D grid for $K_c\in[0, 5]$, $\tau_I \in [0.2, 4.0]$ draw a heatmap of the ITSE metric in the $(K_c, \tau_I)$ plane. include a colorbar to indicate the correspondence between color and the ITSE value. 

!!! note
	pass `colorrange=(0, 1.0)` to cap the colorbar to avoid large values of ITSE dominating the colormap and hiding the minimum.

!!! note
	see [this example](https://docs.makie.org/stable/reference/plots/heatmap/#colorbar_for_single_heatmap) in the `CairoMakie.jl` docs.
"

# ╔═╡ dd34c47f-2a00-4422-b278-c3a6d7aa83bf

# ╔═╡ b3b4e7df-8605-49d3-b457-aa026de0d464
md"🍕 though you could \"eyeball\" the optimal controller parameters from your heatmap, instead use `optimize` from `Optim.jl` to precisely compute the values of $K_c$ and $\tau_I$, `K_c_opt` and `τ_I_opt`, that minimize the ITSE of the closed-loop response to the step in the disturbance variable."

# ╔═╡ db923420-05e7-4828-a7ad-a10761de1da2

# ╔═╡ b9b0aa5a-1ded-44e1-bf96-fc530daf1d0f

# ╔═╡ 64adf9e1-9625-4536-bddb-0245d799755e
md"
## simulate closed-loop response under optimal control
🍕 now call `sim_closed_loop(K_c_opt, τ_I_opt, tf=30.0)` to simualte the closed-loop response to a disturbance under PI-control with the optimal parameters `K_c_opt` and `τ_I_opt`. plot the closed-loop response $y^*(t)$ along with the response without a PI-controller as a baseline. use a legend to show which curve corresponds to no control and which corresponds to optimal control.
"

# ╔═╡ 84845b26-f535-46a1-97ef-ddc25df18f12

# ╔═╡ 46e64900-a9f0-4e60-8396-df912e2905db

# ╔═╡ 33a39e68-45f6-4687-a7b8-9d7dab36ec36

# ╔═╡ 3e3f8360-0fbc-44cd-a94f-2908a14ce329
md"## generalization

💡 we designed our PI-controller to achieve the best closed-loop response to a unit step in the disturbance. however, does this good performance generalize to (i) other disturbances and (ii) set point changes?
"

# ╔═╡ e2474406-c985-447f-b0e4-93c81fa572f3

# ╔═╡ 6658df27-af10-4e67-8cb8-c18934e786ef

# ╔═╡ 0e534976-a258-4830-a4c6-8b0172354477
md"🍕 plot the closed-loop response to an impulse in the disturbance variable using the PI-controller settings `K_c_opt` and `τ_I_opt`. as a baseline, include the response under no control in the same plot.

🤔 do you think the optimal controller for a step disturbance is the same as for an impulse response?

!!! hint
	you can explore by dividing the optimal gain by 2 to make the controller less aggressive. does the response improve?

"

# ╔═╡ 37104952-f4e6-421b-8047-03ae2f9af062

# ╔═╡ fa91bcf2-5d53-4ee1-a9da-9c129be14f61
md"🍕 plot the response to a unit set point change under the PI-controller settings `K_c_opt` and `τ_I_opt`.

🤔 does the response to the set point seem appropriate? i.e., is the controller too aggressive or too sluggish? do you think the optimal controller for a step disturbance is the same as for a set point change?
"

# ╔═╡ 613a5851-7d14-47f9-b43d-81022cc3e44b

# ╔═╡ Cell order:
# ╠═e548009a-faa1-11ee-1600-05d467db87e3
# ╠═229b3d17-90fc-4db9-824d-4fe02c20a1ef
# ╟─7b7476b8-598e-4d07-b576-a7438213d653
# ╟─4a6bc087-bddf-44e2-b54e-6b70e0229355
# ╠═502bde1d-e3e2-46ab-829d-8be29f6185d9
# ╠═6a513f76-5153-46eb-af06-437c647610ad
# ╠═0b58b6ed-1adf-4131-bb69-1b4f5563b087
# ╟─b889c062-18d1-4a1a-a0d1-2196e2cb4fd2
# ╠═4bee5ec0-3ca1-40df-aa72-65b9aefb2556
# ╟─1a10f575-a836-4c2a-907e-93dec355bd40
# ╠═26a9bd47-fe31-44d5-8c62-0e5cecc321f4
# ╠═cf0303df-d0f9-411b-8844-6f17dd580b13
# ╠═57c3d685-5a7a-4464-9414-0374dc561b1f
# ╠═55d91b4d-25a5-40fe-a221-4a8280e4cf8c
# ╟─7a8e8f7d-a72e-4e28-ac44-8dcb3dd3200c
# ╠═7ab2addb-f6ba-4a25-86b2-80f3424076c4
# ╟─5d8357fb-cc4e-4b0c-bcf8-b8f90a3de486
# ╠═89ebf90c-60bc-4ab1-bead-5bc82d5424d8
# ╟─ffdb3349-0477-4940-834d-00f0beab1720
# ╟─bae7610e-9bd0-49db-986d-3162a60fccfa
# ╠═b4553613-3db2-4b4e-93f2-1a374ad5e0be
# ╠═3837e07d-0c00-4113-8c3f-e240d4139890
# ╟─c25c7a9a-cd75-40d4-882f-9fca161d8f9a
# ╠═dd34c47f-2a00-4422-b278-c3a6d7aa83bf
# ╟─b3b4e7df-8605-49d3-b457-aa026de0d464
# ╠═db923420-05e7-4828-a7ad-a10761de1da2
# ╠═b9b0aa5a-1ded-44e1-bf96-fc530daf1d0f
# ╟─64adf9e1-9625-4536-bddb-0245d799755e
# ╠═84845b26-f535-46a1-97ef-ddc25df18f12
# ╠═46e64900-a9f0-4e60-8396-df912e2905db
# ╠═33a39e68-45f6-4687-a7b8-9d7dab36ec36
# ╟─3e3f8360-0fbc-44cd-a94f-2908a14ce329
# ╠═e2474406-c985-447f-b0e4-93c81fa572f3
# ╠═6658df27-af10-4e67-8cb8-c18934e786ef
# ╟─0e534976-a258-4830-a4c6-8b0172354477
# ╠═37104952-f4e6-421b-8047-03ae2f9af062
# ╟─fa91bcf2-5d53-4ee1-a9da-9c129be14f61
# ╠═613a5851-7d14-47f9-b43d-81022cc3e44b
