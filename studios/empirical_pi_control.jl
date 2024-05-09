### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 35c82a7a-0bfc-11ef-0258-8d88fde37b4c
begin
	import Pkg; Pkg.activate()
	using Controlz, CairoMakie, MultivariateStats, PlutoUI, DataFrames, CSV, Statistics, Dates
end

# ╔═╡ d444dfab-4d78-4821-8d7e-3ec5628c39ea
md"# empirical controller tuning"

# ╔═╡ c0105efb-8389-4ea2-bf10-3618c06db3bb
update_theme!(fontsize=20, size=(400, 400), linewidth=3)

# ╔═╡ b42875d5-6a2a-40eb-bd39-448c409e6ed4
TableOfContents()

# ╔═╡ 846ed565-06d5-4f2b-83f1-abe42fc35fe8
md"# the process

liquid flows into three tanks arranged in series. flow out of each tank is autonomous, driven by hydrostatic pressure.
* input: $q(t)$ [L/min] - the flow rate into the first tank
* output: $h_m(t)$ [m] - the measured liquid level in the last tank

our goal is to outfit this process with a PI controller to control the liquid level $h(t)$ in the _third_ tank by manipulating the flow rate $q(t)$ into the _first_ tank.

however, the dynamics of the process are unknown, precluding a model-based design of the PI controller. 
"

# ╔═╡ 138827b1-8767-4a00-b826-9dc1cb795772
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/three_tanks.png\" width=350>"

# ╔═╡ 85b3dbb7-b7fd-470b-8613-727a2156c26c
md"# the experiment

to gather information about the dynamics of the process, we conduct an experiment that produces process response data. specifically, the process begins at nominal steady-state conditions. the date of the experiment is April 29, 2024.
at time 2:22:00 in the afternoon, we suddenly dump $\Delta q =20$ L of liquid into the first tank and measure the liquid level in the third tank over time.
"

# ╔═╡ c42ec9b3-f281-443f-9903-ec1ff49f01ce


# ╔═╡ 384bd252-e139-47ff-a884-7975b4c5eca6
md"🦫 what is the input $q^*(t)$? write an equation."

# ╔═╡ b4c2b805-5308-479e-b7a8-e93ad53c3706
md"
```math
q^*(t) = ({\color{red} x^2 + 2 \text{ your answer here}})
```
"

# ╔═╡ eec0a022-7972-4da8-a9b0-e13d9d688c0b
md"🦫 the time series data characterizing the response of the process are present in `process_data.csv` located [here on Github](https://github.com/SimonEnsemble/CHE461_S2024/blob/main/data/process_data.csv). read in the process data as a `DataFrame`."

# ╔═╡ 290aff1c-594d-4359-9a60-916a827b8986


# ╔═╡ 4b7f7b46-3a34-491d-8540-3e98bc8e6488
md"
🦫 append a new column to the data frame, \"t [min]\" that lists the time in minutes, such that $t=0$ corresponds with the input at 2:22:00. (later, it is necessary to know the time $t$ in minutes after the input.)

!!! note
	see [the docs](https://docs.julialang.org/en/v1/stdlib/Dates/#Dates) for the `Dates` module in Julia.
"

# ╔═╡ 50a8c83f-8c49-445e-b09d-b745852aa593


# ╔═╡ c4188d01-5039-4a29-9e72-ecd0ec509d2b


# ╔═╡ 89fe3095-1588-44d9-aaad-f35475c01e4f
md"🦫 plot the time series data characterizing the response $h_m(t)$ with $t$ in minutes. include x- and y-axis labels with units indicated. make the minimum y-axis limit zero so we have perspective for when the tank is empty.
"

# ╔═╡ 2cb8376b-e1b1-4d5b-af9c-795c3986e9f1


# ╔═╡ 52a2ba6a-021d-4f8d-9614-33e55f60af68
md"## approximate FOPTD model

🦫 compute the best estimate of $\bar{h}$, the nominal steady-state value of the liquid level.
"

# ╔═╡ 40717750-7398-49d0-9ab5-0a0f832a2f94


# ╔═╡ 6e7f1f85-71ca-4195-bfde-c6de5c4b2230


# ╔═╡ 075cd5f6-3344-4348-97c7-46089180a7b9
md"🦫 estimate the gain $K$, time constant $\tau$, and time delay $\theta$ that best approximates the process, based on this process response data.

```math
\frac{H_m^*(s)}{Q^*(s)} = \frac{Ke^{-\theta s}}{\tau s+1}
```
"

# ╔═╡ 511df08c-537b-42a4-93b9-af8ddce5ba18


# ╔═╡ 70509cf5-4782-4822-bf70-776b4d38b9ab


# ╔═╡ 95f6a769-9274-4c7d-8767-195635cd78c9


# ╔═╡ eba0ac52-6242-40a1-b77f-aea19682c65b


# ╔═╡ 12f9bd60-76c7-4d1e-8cb1-4eefe7d3f61c


# ╔═╡ 9550c6ee-a7c9-47e3-bceb-d1a808356df4


# ╔═╡ 7db647e6-f5e4-4951-8195-e1f1e9aca212


# ╔═╡ c87bbf4b-6583-43ab-abbc-039a40f2b7a9


# ╔═╡ 52826173-29f0-47d4-9b42-f8afc42cd7b8


# ╔═╡ 81cb2f42-df28-437b-8914-4dff797e198c


# ╔═╡ 75ca3764-e0bc-4112-95bc-7ef2edcf55d6


# ╔═╡ b0ac5e2f-4900-462d-812c-e44ba17928f7


# ╔═╡ 2f68a1f0-948e-4311-a667-1a103d15b6ac
md"## check fit of FOPTD model
🦫 simulate the response of your approximate FOPTD model of the process to the same input $q^*(t)$ in the experiment. plot the simulated response with the actual process response data, in the same panel. is the fit reasonable for determining PI control parameters? if not, adjust accordingly.
"

# ╔═╡ 3cc17724-3684-4fad-bbab-3cb2ec288472


# ╔═╡ 487917c5-13e7-4fa3-92d8-2a0b548ae43e


# ╔═╡ b041a229-43fc-4801-aaaf-25e0ef4b96ee


# ╔═╡ 27e8bffc-48de-4043-ae8d-8ac95cbb65a5
md"## PI controller tuning
now, we outfit the process with a PI controller.
"

# ╔═╡ 7f94789e-69a5-425f-a24d-540de890a8f5
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/three_tanks_control.png\" width=350>"

# ╔═╡ 439ada08-39f7-42e8-a29e-02bd46b3ef1e
md"
🦫 apply the minimum ITAE empirical tuning rules to determine good PI controller settings for making set point changes. include units for both $K_c$ and $\tau_I$. this constitues your controller design.

recall, the PI control law is:
```math
 q^*(t) = K_c\left[e(t)+\frac{1}{\tau_I}\int_0^t e(\xi)d\xi\right]
```
with error signal $e(t):=h_{sp}(t)-h_m(t)$.
"

# ╔═╡ beddbabd-5dc5-4fb4-a648-c283d7aada49


# ╔═╡ 7e49d811-62e7-48e6-9fb1-96637e184c6d


# ╔═╡ a364dc7a-8c41-4839-8154-42293ee277cf
md"🦫 submit your $K_c$ and $\tau_I$ to Cory for the competition.
teams will be judged by the integral of the time-weighted absolute error during a set point change of +10.0 m.
"

# ╔═╡ Cell order:
# ╟─d444dfab-4d78-4821-8d7e-3ec5628c39ea
# ╠═35c82a7a-0bfc-11ef-0258-8d88fde37b4c
# ╠═c0105efb-8389-4ea2-bf10-3618c06db3bb
# ╠═b42875d5-6a2a-40eb-bd39-448c409e6ed4
# ╟─846ed565-06d5-4f2b-83f1-abe42fc35fe8
# ╟─138827b1-8767-4a00-b826-9dc1cb795772
# ╟─85b3dbb7-b7fd-470b-8613-727a2156c26c
# ╠═c42ec9b3-f281-443f-9903-ec1ff49f01ce
# ╟─384bd252-e139-47ff-a884-7975b4c5eca6
# ╠═b4c2b805-5308-479e-b7a8-e93ad53c3706
# ╟─eec0a022-7972-4da8-a9b0-e13d9d688c0b
# ╠═290aff1c-594d-4359-9a60-916a827b8986
# ╟─4b7f7b46-3a34-491d-8540-3e98bc8e6488
# ╠═50a8c83f-8c49-445e-b09d-b745852aa593
# ╠═c4188d01-5039-4a29-9e72-ecd0ec509d2b
# ╟─89fe3095-1588-44d9-aaad-f35475c01e4f
# ╠═2cb8376b-e1b1-4d5b-af9c-795c3986e9f1
# ╟─52a2ba6a-021d-4f8d-9614-33e55f60af68
# ╠═40717750-7398-49d0-9ab5-0a0f832a2f94
# ╠═6e7f1f85-71ca-4195-bfde-c6de5c4b2230
# ╟─075cd5f6-3344-4348-97c7-46089180a7b9
# ╠═511df08c-537b-42a4-93b9-af8ddce5ba18
# ╠═70509cf5-4782-4822-bf70-776b4d38b9ab
# ╠═95f6a769-9274-4c7d-8767-195635cd78c9
# ╠═eba0ac52-6242-40a1-b77f-aea19682c65b
# ╠═12f9bd60-76c7-4d1e-8cb1-4eefe7d3f61c
# ╠═9550c6ee-a7c9-47e3-bceb-d1a808356df4
# ╠═7db647e6-f5e4-4951-8195-e1f1e9aca212
# ╠═c87bbf4b-6583-43ab-abbc-039a40f2b7a9
# ╠═52826173-29f0-47d4-9b42-f8afc42cd7b8
# ╠═81cb2f42-df28-437b-8914-4dff797e198c
# ╠═75ca3764-e0bc-4112-95bc-7ef2edcf55d6
# ╠═b0ac5e2f-4900-462d-812c-e44ba17928f7
# ╟─2f68a1f0-948e-4311-a667-1a103d15b6ac
# ╠═3cc17724-3684-4fad-bbab-3cb2ec288472
# ╠═487917c5-13e7-4fa3-92d8-2a0b548ae43e
# ╠═b041a229-43fc-4801-aaaf-25e0ef4b96ee
# ╟─27e8bffc-48de-4043-ae8d-8ac95cbb65a5
# ╟─7f94789e-69a5-425f-a24d-540de890a8f5
# ╟─439ada08-39f7-42e8-a29e-02bd46b3ef1e
# ╠═beddbabd-5dc5-4fb4-a648-c283d7aada49
# ╠═7e49d811-62e7-48e6-9fb1-96637e184c6d
# ╟─a364dc7a-8c41-4839-8154-42293ee277cf
