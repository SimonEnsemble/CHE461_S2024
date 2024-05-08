### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 35c82a7a-0bfc-11ef-0258-8d88fde37b4c
begin
	import Pkg; Pkg.activate()
	using Controlz, CairoMakie, MultivariateStats, PlutoUI
end

# ╔═╡ d444dfab-4d78-4821-8d7e-3ec5628c39ea
md"# empirical controller tuning"

# ╔═╡ c0105efb-8389-4ea2-bf10-3618c06db3bb
update_theme!(fontsize=20, size=(400, 400), linewidth=3)

# ╔═╡ b42875d5-6a2a-40eb-bd39-448c409e6ed4
TableOfContents()

# ╔═╡ 85b3dbb7-b7fd-470b-8613-727a2156c26c
md"## simulating the open-loop process response

[simulated] experiment: input step change of $\Delta q$ in $q(t)$, observe $h_m(t)$.
"

# ╔═╡ 384bd252-e139-47ff-a884-7975b4c5eca6
begin
	q̄ = 1.0 # steady-state value of q
	h̄ = 3.0 # steady-state value of h
end

# ╔═╡ 138827b1-8767-4a00-b826-9dc1cb795772
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/three_tanks.png\" width=350>"

# ╔═╡ 89fe3095-1588-44d9-aaad-f35475c01e4f
md"below is the transfer function $H_m^*(s)/Q^*(s)=G_q(s)$. 

!!! note
	in practice, $G_q(s)$ is not known. I'm just showing you how I'm generating realistic-ish process data. conceptually, think of doing the actual experiment on the real process!
"

# ╔═╡ 44e1b975-0030-414c-8357-e97b7103c05b
G_q = 6 / ((4 * s + 1) * (5 * s + 1) * (2 * s + 1)) # top secret

# ╔═╡ c25688ee-406a-43c1-964f-920fd49d0965
function simulate_step_response(G_q, Δq, h̄, tf=40.0, ϵ=0.25)
	# step input
	Q★ = Δq / s
	# open-loop response
	Hₘ★ = G_q * Q★
	# sim response
	data = simulate(Hₘ★, tf)
	# add noise and steady-state
	data[:, "output"] .+= h̄ .+ ϵ * randn(size(data)[1])
	return data
end

# ╔═╡ fe4d4b89-cfa1-4bc4-9460-cf71e1e0e93c
begin
	Δq = 5.0
	data = simulate_step_response(G_q, Δq, h̄)
end

# ╔═╡ 2cb8376b-e1b1-4d5b-af9c-795c3986e9f1
begin
	fig = Figure()
	ax_top = Axis(fig[1, 1], ylabel="q [L/min]")
	ax_bot = Axis(fig[2, 1], xlabel="time [min]", ylabel="hₘ [m]")
	scatter!(ax_bot, data[:, "t"], data[:, "output"])
	lines!(ax_top, [-2, 0, 0.0001, 40], [q̄, q̄, q̄+Δq, q̄+Δq])
	linkxaxes!(ax_top, ax_bot)
	hidexdecorations!(ax_top, grid=false)
	ylims!(ax_top, 0, nothing)
	ylims!(ax_bot, 0, nothing)
	fig
end

# ╔═╡ ebe09761-fefd-4805-a1fd-13d82824b9de
md"## use process data to obtain a rough FOPTD model approximation of the process"

# ╔═╡ 2f29fe72-179a-4b7f-8be7-7263e4316442
md"## design a PI controller for set point tracking"

# ╔═╡ e5f10301-7688-453d-afaa-4d51ef2bcccf
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE461_S2024/main/images/three_tanks_control.png\" width=350>"

# ╔═╡ 5ec8b7b4-ebe3-4fb8-b30b-e646b619a1bc
md"## test PI controller for making set point changes"

# ╔═╡ Cell order:
# ╟─d444dfab-4d78-4821-8d7e-3ec5628c39ea
# ╠═35c82a7a-0bfc-11ef-0258-8d88fde37b4c
# ╠═c0105efb-8389-4ea2-bf10-3618c06db3bb
# ╠═b42875d5-6a2a-40eb-bd39-448c409e6ed4
# ╟─85b3dbb7-b7fd-470b-8613-727a2156c26c
# ╠═384bd252-e139-47ff-a884-7975b4c5eca6
# ╟─138827b1-8767-4a00-b826-9dc1cb795772
# ╟─89fe3095-1588-44d9-aaad-f35475c01e4f
# ╠═44e1b975-0030-414c-8357-e97b7103c05b
# ╠═c25688ee-406a-43c1-964f-920fd49d0965
# ╠═fe4d4b89-cfa1-4bc4-9460-cf71e1e0e93c
# ╠═2cb8376b-e1b1-4d5b-af9c-795c3986e9f1
# ╟─ebe09761-fefd-4805-a1fd-13d82824b9de
# ╟─2f29fe72-179a-4b7f-8be7-7263e4316442
# ╟─e5f10301-7688-453d-afaa-4d51ef2bcccf
# ╟─5ec8b7b4-ebe3-4fb8-b30b-e646b619a1bc
