# IceFlow.jl
Shallow Ice Approximation (SIA) ice flow solver

## Overview
`IceFlow.jl` is a Julia package for simulating and visualising ice flow dynamics. It offers tools for setting up grid-based simulations, running numerical solvers, and visualising the results.

## Features
- **Grid Setup**: Define spatial grids for simulations.
- **Data Handling**: Manage ice flow parameters and synthetic data.
- **Simulation**: Numerically simulate ice dynamics over a grid.
- **Visualization**: Visualise simulation results with 3D plots.

## Installation
To install `IceFlow.jl`, use the Julia package manager:
```julia
using Pkg
Pkg.add("https://github.com/Unil-SGC/IceFlow.jl")
```

## Usage
The [`run_example.jl`](run_example.jl) script provides an ex example on how to run `IceFlow.jl`:

```julia
using IceFlow
using GLMakie
Makie.inline!(true)

# physics
lx, ly = 250000.0, 200000.0  # domain size [m]
B0     = 3500.0              # mean height [m]
β      = 0.01                # mass-balance slope
c      = 2.0                 # mass-balance limiter
ρg     = 910.0 * 9.81        # ice density x gravity
dt     = 0.1                 # time step [yr]

# numerics
resol  = 256                 # number of grid points
nt     = 1e4                 # number of time steps
nout   = 1e3                 # visu and error checking interval
ϵ      = 1e-4                # steady state tolerance
grid   = Grid(lx, ly, resol, resol)
data   = Data(B0, β, c, grid)
params = (nt, nout, ϵ, dt, ρg)

# run and visualise the results
visualise(solver(data, grid, params...)...)
```

## Documentation
For more detailed documentation, query the help from with the REPL:
```julia-repl
julia> ?

help?> IceFlow

help?> IceFlow
search: IceFlow

  module IceFlow

  # [...]
```

## Contributing
Contributions to `IceFlow.jl` are welcome!

## License
`IceFlow.jl` is licensed under MIT License.

## Authors
- [Ludovic Räss](https://github.com/luraess)
