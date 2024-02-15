module IceFlow

export Grid, Data
export solver, visualise

using Printf, UnPack
using GLMakie
Makie.inline!(true)

const s2yr = 31557600

include("grid_data.jl")
include("solvers.jl")
include("synthetic_data.jl")
include("utils.jl")

end # module IceFlow
