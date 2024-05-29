### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 35c82a7a-0bfc-11ef-0258-8d88fde37b4c
begin
	import Pkg; Pkg.activate()
	using Controlz, CairoMakie, PlutoUI, DataFrames, Printf
end

# ╔═╡ c0105efb-8389-4ea2-bf10-3618c06db3bb
set_theme!(Controlz.cool_theme); update_theme!(fontsize=20, size=(400, 400), linewidth=3, axis=(; titlefont=:regular))

# ╔═╡ b42875d5-6a2a-40eb-bd39-448c409e6ed4
TableOfContents()

# ╔═╡ e817a7c0-d3e8-4548-a70d-268876e3e752
md"# D-action

📗 learning objectives:
* understand how to eliminate derivative kick in response to set point changes
* practice block diagram algebra
* understand and explore the influence of D-action on the closed-loop response
* assess the performance of a feedback controller using various metrics
"

# ╔═╡ 85b3dbb7-b7fd-470b-8613-727a2156c26c
md"## the closed-loop control system

liquid flows into three tanks arranged in series. flow out of each tank is autonomous, driven by hydrostatic pressure. 

a PID feedback controller (LC = level controller) is set up to maintain the liquid level in the _third_ tank, $h(t)$ [m], at a set point $h_{sp}^*(t)$ [m] by manipulating the flow rate $q(t)$ [L/min] into the _first_ tank.
"

# ╔═╡ e5f10301-7688-453d-afaa-4d51ef2bcccf
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/three_tanks_control.png\" width=500>"

# ╔═╡ 9f7659bb-bcf7-4d17-989f-d5901098a0cd
md"a block diagram depicting the closed-loop designed for set point changes is below. the D-action is based on the _measurement_ of the liquid level instead of the error, to avoid derivative kick in response to set point changes."

# ╔═╡ 955b852b-3f23-4774-b8a7-df3361c5481f
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/Hsp_block_diagram.png\" width=800>"

# ╔═╡ 20090772-a121-44e1-b05a-aba1ca57e362
md"at steady-state conditions, the values of the liquid level in the third tank $\bar{h}$ [m] and flow rate into the first tank $\bar{q}$ [L/min] are listed below."

# ╔═╡ 384bd252-e139-47ff-a884-7975b4c5eca6
begin
	q̄ = 7.25  # [L/min]
	h̄ = 5.0   # [m]
end

# ╔═╡ 6fdf4c0f-cc05-460f-8ad5-03dcddf178a6
md"## process and sensor dynamics

our transfer function model for the process, i.e. for how the flow rate $q(t)$ into the first tank affects the liquid level in the third tank $h(t)$, is:
```math
G_q(s)=\frac{H^*(s)}{Q^*(s)}=\frac{2.4e^{-0.1s}}{(s+1)(2.5s+1)(3.2 s +1)}.
```

our transfer function model for the liquid level sensor is:
```math
G_s(s)=\frac{H_m^*(s)}{H^*(s)}=e^{-0.2s},
```
where $h_m(t)$ [m] is the measured liquid level.

🍉 code up the transfer functions `G_q` and `G_s` below.
"

# ╔═╡ 44e1b975-0030-414c-8357-e97b7103c05b


# ╔═╡ 0587077f-e29f-47d5-b496-7dedb5753af6


# ╔═╡ 7b2953f8-a299-498b-ac29-877da5212c9e
md"## PID controller

the settings for the PID controller are below. while the controller gain $K_c$ [L/(min⋅m)] and integral time constant $\tau_I$ [min] are set, we have a slider bar for the derivative time constant $\tau_D \in [0, 4]$ [min] to explore its effect on the closed-loop response.
"

# ╔═╡ 6ab3d542-0796-4b24-a64e-8a124a229c8c
Kc = 0.75 # [L / min] / m

# ╔═╡ 0547b70d-4402-49e0-b6aa-23c66ddc5ce8
τᵢ = 6.0 # min

# ╔═╡ 481ec6bd-5c53-4c8d-8b67-41c4c461e3b1
md"derivative time constant $\tau_D$ [min]: $(@bind τd PlutoUI.Slider(0.0:1.0:4.0))"

# ╔═╡ 23aa6939-50be-4147-bb1e-c95a11e48a1e
τd # min

# ╔═╡ 23c64c35-5057-4c8d-a333-13dc05f5c83c
md"## set point change

we consider a set point change of +10 m (i.e., a step) in the liquid level at $t=0$.

🍉 code-up the set point `Hₛₚ★` below (in the frequency domain).
"

# ╔═╡ d8f43c46-2ea5-442b-8bc6-8a38565f1b22
begin
	Δhₛₚ = +10.0 # m
end

# ╔═╡ ca6f47bc-842b-4fc2-b7ec-4205511db0dc
md"## closed loop response

🍉 simulate, for $t \in [0, 40.0]$ min the response of the closed-loop system to the set point change in the liquid level. simulate and plot in a two-panel plot (shared $t$-axis):
* the flow rate $q(t)$ [L/min]
* the measured liquid level $h_m(t)$ [m]

!!! hint
	this will take some algebra, to derive the closed-loop responses. two novelties: (1) the D-action operates on the measurement of the liquid level instead of the error. (2) you need to derive the closed-loop response of the manipulated variable in addition to the output. `Controlz.jl` docs are [here](https://simonensemble.github.io/Controlz.jl/dev/controls/#feedback-loops-with-time-delays). you'll need to use the `ClosedLoopTransferFunction` data structure to handle the time delays. 
"

# ╔═╡ bd98b53b-928c-44b1-ba9d-ef36674d4449
tf = 40.0 # min

# ╔═╡ d53f495b-4619-416f-9de6-b6fe4eab3352


# ╔═╡ 2bef3bc2-2d70-4780-ae04-7c0db551ecb2


# ╔═╡ 94691b43-b4a5-4441-be81-1ee505114637


# ╔═╡ a5b194f1-c66d-4025-9414-ca649904bc6d


# ╔═╡ 1355ea50-0960-4d23-be22-fcda7ee6aab4
begin
	fig = Figure(size=(600, 600))
	axs = [Axis(fig[i, 1], titlefont=:regular) for i = 1:2]
	linkxaxes!(axs...)

	# top panel (manipulated variable)
	axs[1].ylabel = "q [L/min]"
    # your code here

	# bottom panel (output)
	axs[2].xlabel = "time [min]"
	axs[2].ylabel = "hₘ [m]"
    # your code here
	fig
end

# ╔═╡ 1392fc72-1aaf-49ea-a024-652ef2381cd9
md"## performance metrics

🍉 based on the closed-loop response $h_m(t)$ [m], write code to compute three controller performance metrics:
* the overshoot
* the time to settle within ±1 m of the set point
* the integral of the absolute error
"

# ╔═╡ 1b679987-18b3-4067-9aa0-271af88090dc


# ╔═╡ 023f77bc-ccb3-48a0-ad1e-96d015a8c425


# ╔═╡ 16b654eb-8afb-42e6-839b-74a04a04010c


# ╔═╡ 8d602f16-cf0c-4659-9d22-b53440e859a7


# ╔═╡ 32dd054b-cb07-44ad-9e04-3f44546e394a
md"## impact of D-action
🍉 use the slider bar to change $\tau_D$ and fill out the table below.


| $\tau_D$ [min] | overshoot [m] | settling time [min] | IAE [m⋅min] |
| ---- | ---- | ---- | ---- |
| 0.0 | | | |
| 1.0 | | | |
| 2.0 | | | |
| 3.0 | | | |
| 4.0 | | | |
"

# ╔═╡ 4a891418-4462-4d89-bc2a-6fe51a140b80
md"🍉 (based on the pattern of the data in your table) regarding the influence of D-action on the closed-loop response to set point changes, what do you conclude? what is the best value of $\tau_D$?

[... 💬 ...]"

# ╔═╡ Cell order:
# ╠═35c82a7a-0bfc-11ef-0258-8d88fde37b4c
# ╠═c0105efb-8389-4ea2-bf10-3618c06db3bb
# ╠═b42875d5-6a2a-40eb-bd39-448c409e6ed4
# ╟─e817a7c0-d3e8-4548-a70d-268876e3e752
# ╟─85b3dbb7-b7fd-470b-8613-727a2156c26c
# ╟─e5f10301-7688-453d-afaa-4d51ef2bcccf
# ╟─9f7659bb-bcf7-4d17-989f-d5901098a0cd
# ╟─955b852b-3f23-4774-b8a7-df3361c5481f
# ╟─20090772-a121-44e1-b05a-aba1ca57e362
# ╠═384bd252-e139-47ff-a884-7975b4c5eca6
# ╟─6fdf4c0f-cc05-460f-8ad5-03dcddf178a6
# ╠═44e1b975-0030-414c-8357-e97b7103c05b
# ╠═0587077f-e29f-47d5-b496-7dedb5753af6
# ╟─7b2953f8-a299-498b-ac29-877da5212c9e
# ╠═6ab3d542-0796-4b24-a64e-8a124a229c8c
# ╠═0547b70d-4402-49e0-b6aa-23c66ddc5ce8
# ╟─481ec6bd-5c53-4c8d-8b67-41c4c461e3b1
# ╠═23aa6939-50be-4147-bb1e-c95a11e48a1e
# ╟─23c64c35-5057-4c8d-a333-13dc05f5c83c
# ╠═d8f43c46-2ea5-442b-8bc6-8a38565f1b22
# ╟─ca6f47bc-842b-4fc2-b7ec-4205511db0dc
# ╠═bd98b53b-928c-44b1-ba9d-ef36674d4449
# ╠═d53f495b-4619-416f-9de6-b6fe4eab3352
# ╠═2bef3bc2-2d70-4780-ae04-7c0db551ecb2
# ╠═94691b43-b4a5-4441-be81-1ee505114637
# ╠═a5b194f1-c66d-4025-9414-ca649904bc6d
# ╠═1355ea50-0960-4d23-be22-fcda7ee6aab4
# ╟─1392fc72-1aaf-49ea-a024-652ef2381cd9
# ╠═1b679987-18b3-4067-9aa0-271af88090dc
# ╠═023f77bc-ccb3-48a0-ad1e-96d015a8c425
# ╠═16b654eb-8afb-42e6-839b-74a04a04010c
# ╠═8d602f16-cf0c-4659-9d22-b53440e859a7
# ╟─32dd054b-cb07-44ad-9e04-3f44546e394a
# ╟─4a891418-4462-4d89-bc2a-6fe51a140b80
