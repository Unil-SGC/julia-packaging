using IceFlow

# physics
lx, ly = 250000, 200000  # domain size [m]
B0     = 3500            # mean height [m]
β      = 0.01            # mass-balance slope
c      = 2.0             # mass-balance limiter
ρg     = 910.0 * 9.81    # ice density x gravity
dt     = 0.1             # time step [yr]

# numerics
resol  = 256
nt     = 1e4             # number of time steps
nout   = 1e3             # visu and error checking interval
ϵ      = 1e-4            # steady state tolerance
grid   = Grid(lx, ly, resol, resol)
data   = Data(B0, β, c, grid)
params = (nt, nout, ϵ, dt, ρg)

# run and visualise the results
visualise(solver(data, grid, params...)...)
