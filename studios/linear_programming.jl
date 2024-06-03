### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ d0ea1620-1bc5-11ef-0988-0394597d4f32
begin
	import Pkg; Pkg.activate()
	using CairoMakie, JuMP, ColorSchemes, PlutoTeachingTools, PlutoUI
	import HiGHS
end

# ╔═╡ 5b53b7a7-af29-45f0-ada1-a4f94a664fe0
color = Dict(zip(["hops", "malt", "corn"], ColorSchemes.Accent_3))

# ╔═╡ 37cc8195-e3ba-47b5-9c76-e2dc8d4b2ac0
set_theme!(theme_minimal()); update_theme!(fontsize=20, linewidth=3)

# ╔═╡ fbd25cce-79de-4dca-8895-27bd2d3a63db
TableOfContents()

# ╔═╡ 56385e01-63db-47b3-b630-c7a05cfb888c
md"
# numerically solving a linear program in Julia

[learn by example!]

## 🍺 problem setup

we are a small brewery capable of producing both ale and lager.

we wish to determine the number of barrels of both ale and lager to produce in order to maximize our profit. producing then selling a barrel of ale gives us \$39 profit, while a barrel of lager gives us \$69 profit.

however, ale and lager require different resources to produce, and we are constrained in our resources. a barrel of ale requires 5 kg corn, 4 kg hops, and 35 kg of barley malt. a barrel of lager requires 15 kg corn, 4 kg hops, and 20 kg of malt. meanwhile, our brewery is in possession of only 480 kg corn, 160 kg hops, and 1190 kg of malt.
"

# ╔═╡ 633ae1e9-d65b-4561-bed5-8dc5eb87039c
Foldable(
	"references",
	md"this linear programming problem originates from \"Robert Bland, Allocation of Resources by Linear Programming, _Scientific American_, Vol. 244, No. 6, June 1981\".
	it was covered in class notes [here](https://dmi.unibas.ch/fileadmin/user_upload/dmi/Studium/Computer_Science/Vorlesung_HS20/Main_Lecture_Scientific_Computing/CompSci20-Chapter03.pdf) and [here](https://www.cs.princeton.edu/courses/archive/spring03/cs226/lectures/lp-4up.pdf).
	"
)

# ╔═╡ 69ed26e0-4c02-4d6a-85e3-54af0e3bc9f3
md"🍺 let's define some variables that contain this data for later use."

# ╔═╡ d95c0541-047f-4ece-bb12-43cc825d6a3d
# list of resources

# ╔═╡ 0f41fca8-fffc-41a2-8bf6-f07894a9c00c
# list of brews

# ╔═╡ b35a803a-e611-43e2-a46e-153c0a3af8fd
# amount of resources we have

# ╔═╡ 4768889e-12f1-4506-a8fb-9206d110fd68
# resource requirements for producing ale and lager

# ╔═╡ 6b59850d-01ea-44f2-86bc-578866d5efc2
# profits from producing ale and lager

# ╔═╡ 48d41db7-bf31-4dd5-860a-0862b4282227
md"## two extremes: all lagers or all ales"

# ╔═╡ f14b1ccf-4ca8-4444-b0c5-f1181d26173e
md"🍺 if our brewery were to devote all of its resources to ale production, how much profit would we make? how much corn, hops, and malt would we have leftover?"

# ╔═╡ 374ab60d-59be-4971-81e5-1087eff2a1d4


# ╔═╡ a253e1ae-8675-476f-80ee-4bed4d36c199


# ╔═╡ 0a598144-b530-4780-8558-9fdd06a3d053


# ╔═╡ 044ed606-f86e-4f5d-a421-e8588355b885
md"💡 devoting all of our resources to ale, we'd produce X barrels of ale and make \$X. we'd have x kg corn, x kg hops, x kg malt leftover.
"

# ╔═╡ 6d69d2d9-e470-4b1c-bc7b-b07319b0dac4
md"🍺 if our brewery were to devote all of its resources to beer production, how much profit would we make? how much corn, hops, and malt would we have leftover?"

# ╔═╡ 3af1729f-1d00-4c33-87c8-76a65444b534


# ╔═╡ 1e54fd15-6ba2-4521-b563-8cbb7f161bce


# ╔═╡ cc477979-e09f-4586-96f3-ce3e8b34a35e


# ╔═╡ 04839e76-7c22-45b8-b4cd-e003ed1fc20f
md"💡 devoting all of our resources to lager, we'd produce X barrels of lager and make \$X. we'd have x kg corn, x kg hops, x kg malt leftover.
"

# ╔═╡ 358daf8d-bb21-4d19-a98a-404ea7c764e5
md"## feasibility of solutions"

# ╔═╡ 13f00426-1ed3-4919-bf5a-0f32c367245e
md"🍺 one employee uses their 'gut feeling' to propose we produce 10 ales and 40 lagers to make a profit of \$3150. explain the reason(s) why this proposed solution is _infeasible_.
"

# ╔═╡ 50abaf4b-1cbf-48ae-9650-6d4cf700c157


# ╔═╡ 7a9e35f5-ea86-42a8-b4a1-c074dcf0055a


# ╔═╡ 31f21065-6d83-4180-8382-b26af53a50c3


# ╔═╡ 2b345f5b-9b3b-46df-a220-bfa2e64bf2fb
md"## numerically solve the linear program

let's use `JuMP.jl`, an optimization library in Julia, to numerically solve this linear program.

!!! note \"JuMP.jl docs on linear programs\"
	see the `JuMP.jl` docs on linear programming with several examples [here](https://jump.dev/JuMP.jl/stable/tutorials/linear/introduction/).
"

# ╔═╡ 9537f6c9-5c28-48d5-81c5-3d908172e4d1
md"🍺 create a `JuMP.jl` optimization model with the `HiGHS` optimizer (open-source software that can solve linear programming programs)."

# ╔═╡ d37cb850-0eb5-4c36-8832-4d05c6960eb7


# ╔═╡ 90a1c7db-aaf0-43b8-a185-bcef96a2e69b
md"🍺 tell `JuMP.jl` about your decision variables."

# ╔═╡ 2eaaee47-aaab-4a4f-8967-232e2a3d52ca


# ╔═╡ 2b74698b-5202-4ee8-a74a-9d66b778b014
md"🍺 tell `JuMP.jl` about your objective function."

# ╔═╡ a9aa7b20-6f63-4cb8-a0a5-8c9672e7bbce


# ╔═╡ ebf3cc2a-2a43-4985-822e-4a164db20513
md"🍺 tell `JuMP.jl` about your constraints."

# ╔═╡ 12a9f5b9-ab35-4453-b00f-fc7d7585294e


# ╔═╡ dc6725f0-a7f4-48b1-bda8-bc61d866c5cf
md"🍺 ask `JuMP.jl` to display your linear program in mathematical form using `latex_formulation`."

# ╔═╡ 49819512-018c-4b06-8e2d-118c05f0b9ee


# ╔═╡ 17ab7aff-a6a9-4914-82ae-301266a5fe53
md"🍺 ask `JuMP.jl` to search for and find the optimal solution."

# ╔═╡ b372aa05-5a36-4c17-bf2e-9ba8bc2f4f28


# ╔═╡ 323c4baa-6afb-4002-bd05-edbd97eb947b
md"🍺 check with `JuMP.jl` that your linear program is actually feasible and that it has been successfully solved."

# ╔═╡ 32a4a7eb-d46e-480f-8c83-5969c2888cd0


# ╔═╡ 33ce18b0-ab90-43d5-9592-788f849f36eb
md"🍺 for the optimal solution,
* how many barrels of ale and lager should we produce to maximize profit?
* what is the profit we will make? [check that this profit improves upon the all-ale and all-lager strategy]
* how much corn, hops, and barley will be leftover?
"

# ╔═╡ e5874d3e-f89e-4ca6-b97b-9391adef8615


# ╔═╡ 984ca36e-ae08-492f-9e62-257a00cdeafc


# ╔═╡ e1dc7caa-9ad5-4ca3-a90e-80d90e54fe82


# ╔═╡ 7a0afd38-dc35-4b42-bf53-a539d478263e
md"🎆 the optimal solution is to produce x barrels of ale and x barrels of lager, which gives us \$x profit. this leaves us with x kg corn, x kg hops, and x kg malt."

# ╔═╡ 4ac7625d-9cda-48ed-bf46-c94d453ac01f
md"## visualization of the feasible set of solutions
since this linear program involves only two decision variables, we can visualize the constraints and the solution in the decision variable space.

🍺 plot, in decision variable space, the three constraints (lines + shaded regions of feasibility) and the optimal solution.
"

# ╔═╡ 929802a9-d2a0-4df1-8368-02118961378e
begin
	fig = Figure()
	ax = Axis(
		fig[1, 1], 
		xlabel="ale [# barrels]", 
		ylabel="lager [# barrels]",
		aspect=DataAspect()
	)
	
	xlims!(0, nothing)
	ylims!(0, nothing)
	fig
end

# ╔═╡ 29d219d9-5ddd-496b-a23d-e5ab9f61c3aa
md"## sensitivity analysis

the profit we'll make from producing ale and lager is subject to uncertainty because the prices fluctuate in the market. hence, our objective function is subject to uncertainty.

🍺 by how much can the profit we'd make on a barrel of lager _increase_ and _decrease_ (keeping the profit on ale fixed) before our optimal solution would change?

🍺 by how much can the profit we'd make on a barrel of ale _increase_ and _decrease_ (keeping the profit on lager fixed) before our optimal solution would change?

!!! note
	the `lp_sensitivity_report` in `JuMP.jl` gives us this information. see [the docs](https://jump.dev/JuMP.jl/stable/tutorials/linear/lp_sensitivity/).
"

# ╔═╡ 790f2d5d-d5d5-4c26-81a1-4dee94c7cf11


# ╔═╡ 9ae79a41-8269-4ef9-9014-ffa586a23302


# ╔═╡ 8998715d-ef1f-4393-b695-9beaaa498208


# ╔═╡ 42b5a04f-5d18-44ff-850a-3a67ab6a860d


# ╔═╡ 8abd6c4c-69c9-45e4-a5b4-88d8a31cde8a


# ╔═╡ Cell order:
# ╠═d0ea1620-1bc5-11ef-0988-0394597d4f32
# ╠═5b53b7a7-af29-45f0-ada1-a4f94a664fe0
# ╠═37cc8195-e3ba-47b5-9c76-e2dc8d4b2ac0
# ╠═fbd25cce-79de-4dca-8895-27bd2d3a63db
# ╟─56385e01-63db-47b3-b630-c7a05cfb888c
# ╟─633ae1e9-d65b-4561-bed5-8dc5eb87039c
# ╟─69ed26e0-4c02-4d6a-85e3-54af0e3bc9f3
# ╠═d95c0541-047f-4ece-bb12-43cc825d6a3d
# ╠═0f41fca8-fffc-41a2-8bf6-f07894a9c00c
# ╠═b35a803a-e611-43e2-a46e-153c0a3af8fd
# ╠═4768889e-12f1-4506-a8fb-9206d110fd68
# ╠═6b59850d-01ea-44f2-86bc-578866d5efc2
# ╟─48d41db7-bf31-4dd5-860a-0862b4282227
# ╟─f14b1ccf-4ca8-4444-b0c5-f1181d26173e
# ╠═374ab60d-59be-4971-81e5-1087eff2a1d4
# ╠═a253e1ae-8675-476f-80ee-4bed4d36c199
# ╠═0a598144-b530-4780-8558-9fdd06a3d053
# ╟─044ed606-f86e-4f5d-a421-e8588355b885
# ╟─6d69d2d9-e470-4b1c-bc7b-b07319b0dac4
# ╠═3af1729f-1d00-4c33-87c8-76a65444b534
# ╠═1e54fd15-6ba2-4521-b563-8cbb7f161bce
# ╠═cc477979-e09f-4586-96f3-ce3e8b34a35e
# ╟─04839e76-7c22-45b8-b4cd-e003ed1fc20f
# ╟─358daf8d-bb21-4d19-a98a-404ea7c764e5
# ╟─13f00426-1ed3-4919-bf5a-0f32c367245e
# ╠═50abaf4b-1cbf-48ae-9650-6d4cf700c157
# ╠═7a9e35f5-ea86-42a8-b4a1-c074dcf0055a
# ╠═31f21065-6d83-4180-8382-b26af53a50c3
# ╟─2b345f5b-9b3b-46df-a220-bfa2e64bf2fb
# ╟─9537f6c9-5c28-48d5-81c5-3d908172e4d1
# ╠═d37cb850-0eb5-4c36-8832-4d05c6960eb7
# ╟─90a1c7db-aaf0-43b8-a185-bcef96a2e69b
# ╠═2eaaee47-aaab-4a4f-8967-232e2a3d52ca
# ╟─2b74698b-5202-4ee8-a74a-9d66b778b014
# ╠═a9aa7b20-6f63-4cb8-a0a5-8c9672e7bbce
# ╟─ebf3cc2a-2a43-4985-822e-4a164db20513
# ╠═12a9f5b9-ab35-4453-b00f-fc7d7585294e
# ╟─dc6725f0-a7f4-48b1-bda8-bc61d866c5cf
# ╠═49819512-018c-4b06-8e2d-118c05f0b9ee
# ╟─17ab7aff-a6a9-4914-82ae-301266a5fe53
# ╠═b372aa05-5a36-4c17-bf2e-9ba8bc2f4f28
# ╟─323c4baa-6afb-4002-bd05-edbd97eb947b
# ╠═32a4a7eb-d46e-480f-8c83-5969c2888cd0
# ╟─33ce18b0-ab90-43d5-9592-788f849f36eb
# ╠═e5874d3e-f89e-4ca6-b97b-9391adef8615
# ╠═984ca36e-ae08-492f-9e62-257a00cdeafc
# ╠═e1dc7caa-9ad5-4ca3-a90e-80d90e54fe82
# ╟─7a0afd38-dc35-4b42-bf53-a539d478263e
# ╟─4ac7625d-9cda-48ed-bf46-c94d453ac01f
# ╠═929802a9-d2a0-4df1-8368-02118961378e
# ╟─29d219d9-5ddd-496b-a23d-e5ab9f61c3aa
# ╠═790f2d5d-d5d5-4c26-81a1-4dee94c7cf11
# ╠═9ae79a41-8269-4ef9-9014-ffa586a23302
# ╠═8998715d-ef1f-4393-b695-9beaaa498208
# ╟─42b5a04f-5d18-44ff-850a-3a67ab6a860d
# ╟─8abd6c4c-69c9-45e4-a5b4-88d8a31cde8a
