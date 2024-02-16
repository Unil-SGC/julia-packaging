"""
    module IceFlow

A Julia module for simulating and visualizing ice flow dynamics.

The `IceFlow` module provides a set of tools for modeling the dynamics of ice flow over a two-dimensional grid.
It includes functionality for defining the grid and ice flow parameters, performing numerical simulations, and visualizing the results.

# Exports
- `Grid`: A struct for defining the spatial grid properties.
- `Data`: A struct for encapsulating ice flow parameters and synthetic data generation.
- `solver`: A function for simulating ice flow dynamics.
- `visualise`: A function for visualizing simulation results.

# Usage
To use `IceFlow`, import the module and utilize its exported structs and functions to set up your simulation environment,
perform simulations, and visualize the results.

```julia
using IceFlow

# Define grid and data parameters
grid = Grid(lx, ly, resol, resol)
data = Data(β, c, a1, a2, grid)

# Define solver parameters
params = (nt, nout, ϵ, dt, ρg)

# Run a simulation
result = solver(data, grid, nt, dt, nout, ϵ)

# Visualize the results
visualise(result)
```
"""
module IceFlow

export Grid, Data
export solver, visualise
export s2yr, ρg

using Printf, UnPack
using GLMakie

# constants
const s2yr = 31557600     # seconds to years
const ρg   = 910.0 * 9.81 # ice density x gravity

include("grid_data.jl")
include("solvers.jl")
include("synthetic_data.jl")
include("utils.jl")

end # module IceFlow
