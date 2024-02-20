using Printf, UnPack
using CairoMakie

# constants
const s2yr = 31557600     # seconds to years
const ρg   = 910.0 * 9.81 # ice density x gravity

struct Grid
    lx::Float64  # Length in x-direction
    ly::Float64  # Length in y-direction
    dx::Float64  # Grid spacing in x-direction
    dy::Float64  # Grid spacing in y-direction
    xc::Vector{Float64}  # x-coordinates of grid cell centers
    yc::Vector{Float64}  # y-coordinates of grid cell centers
    Xc::Matrix{Float64}  # Matrix of x-coordinates for grid centers
    Yc::Matrix{Float64}  # Matrix of y-coordinates for grid centers
end

function Grid(nx::Int, ny::Int)
    @assert nx > 0 && ny > 0 "Number of grid cells must be positive"

    lx, ly = 250000.0, 200000.0  # domain size [m]
    dx, dy = lx / nx, ly / ny
    xc = LinRange(-lx / 2 + dx / 2, lx / 2 - dx / 2, nx)
    yc = LinRange(-ly / 2 + dy / 2, ly / 2 - dy / 2, ny)
    Xc, Yc = [x for x = xc, _ = yc], [y for _ = xc, y = yc]
    Grid(lx, ly, dx, dy, xc, yc, Xc, Yc)
end

struct Data{T <: Real, G}
    β::T         # mass-balance slope
    c::T         # mass-balance limiter
    a1::T        # ice flow param 1
    a2::T        # ice flow param 2
    B::G         # Bedrock elevation
    ELA::G       # Equilibrium line altitude
    function Data(β::T, c::T, a1::T, a2::T, grid) where {T}
        B0  = 3500.0                          # mean height
        B   = bedrock_elevation(B0, grid)     # Bedrock - Assuming this returns type G
        ELA = equilibrium_line_altitude(grid) # ELA - Assuming this returns type G
        new{T, typeof(B)}(β, c, a1, a2, B, ELA)
    end
end

"Compute the bedrock elevation."
@inline function bedrock_elevation(B0, grid)
    return @. B0 * exp(-grid.Xc^2 / 1e10 - grid.Yc^2 / 1e9) +
              B0 * exp(-grid.Xc^2 / 1e9 - (grid.Yc - grid.ly / 8) * (grid.Yc - grid.ly / 8) / 1e10)
end

"Compute the equilibrium line altitude ELA."
equilibrium_line_altitude(grid) = @. 2150 + 900 * atan(grid.Yc / grid.ly)

"Compute the average of `A` in `x` and `y` dimension."
@views av(A) = 0.25 .* (A[1:end-1, 1:end-1] .+ A[1:end-1, 2:end] .+ A[2:end, 1:end-1] .+ A[2:end, 2:end])

"Compute the average of `A` in `x` dimension."
@views avx(A) = 0.5 .* (A[1:end-1, :] .+ A[2:end, :])

"Compute the average of `A` in `y` dimension."
@views avy(A) = 0.5 .* (A[:, 1:end-1] .+ A[:, 2:end])

"Compute the effective nonlinear diffusion coefficient `D` for SIA model."
@views function compute_D!(D, H, S, dSdx, dSdy, Snorm, a1, a2, dx, dy)
    dSdx  .= diff(S, dims=1) ./ dx
    dSdy  .= diff(S, dims=2) ./ dy
    Snorm .= ((avy(dSdx) .^ 2) .+ (avx(dSdy) .^ 2)) .^ 0.5
    D     .= ((a1 .* av(H) .^ 5) .+ (a2 .* av(H) .^ 3)) .* Snorm .^ 2
    return
end

@views function visualise(S, H, B, grid)
    S_v = fill(NaN, size(S))
    S_v .= S; S_v[H .<= 0.01] .= NaN
    fig = Figure(; size=(1000, 450), fontsize=20)
    axs = Axis3(fig[1, 1][1, 1]; xlabel="x [km]", ylabel="y [km]", zlabel="elevation [m]", zlabeloffset = 70, aspect=(4, 4, 1), azimuth=pi / 4)
    plt = (p1=surface!(axs, grid.xc ./ 1e3, grid.yc ./ 1e3, B, colormap=Reverse(:cork)),
           p2=surface!(axs, grid.xc ./ 1e3, grid.yc ./ 1e3, S_v, colormap=:davos),
    )
    subgrid = GridLayout(fig[1, 1][1, 2], tellheight=false)
    Label(subgrid[1, 1], "H ice [m]")
    Colorbar(subgrid[2, 1], plt.p2; halign=:center)
    resize_to_layout!(fig)
    return display(fig)
end

@views function solver(data, grid, nt, dt, nout, ϵ)
    @unpack β, c, a1, a2, B, ELA = data
    dx, dy = grid.dx, grid.dy
    nx, ny = size(B)
    # initialise
    S      = zeros(nx  , ny  )
    dSdx   = zeros(nx-1, ny  )
    dSdy   = zeros(nx  , ny-1)
    Snorm  = zeros(nx-1, ny-1)
    D      = zeros(nx-1, ny-1)
    qx     = zeros(nx-1, ny-2)
    qy     = zeros(nx-2, ny-1)
    H      = zeros(nx  , ny  )
    M      = zeros(nx  , ny  )
    H0     = zeros(nx  , ny  )
    # time loop
    for it = 1:nt
        H0 .= H
        S  .= B .+ H
        M  .= min.(β .* (S .- ELA), c)
        compute_D!(D, H, S, dSdx, dSdy, Snorm, a1, a2, dx, dy)
        qx .= avy(D) .* diff(S[:, 2:end-1], dims=1) ./ dx
        qy .= avx(D) .* diff(S[2:end-1, :], dims=2) ./ dy
        H[2:end-1, 2:end-1] .= max.(H[2:end-1, 2:end-1] .+ dt .* (diff(qx, dims=1) + diff(qy, dims=2) + M[2:end-1, 2:end-1]), 0.0)
        if mod(it, nout) == 0
            # error checking
            err = maximum(abs.(H .- H0))
            @printf("it = %d, err = %1.3e \n", it, err)
            (err < ϵ) && break
        end
    end
    return (S, H, B, grid)
end

function main()
    # physics
    β      = 0.01                  # mass-balance slope
    c      = 2.0                   # mass-balance limiter
    a1     = 1.9e-24 * ρg^3 * s2yr # ice flow parameter
    a2     = 5.7e-20 * ρg^3 * s2yr # ice flow parameter
    # numerics
    resol  = 256
    nt     = 1e4                 # number of time steps
    dt     = 0.1                 # time step [yr]
    nout   = 1e3                 # visu and error checking interval
    ϵ      = 1e-4                # steady state tolerance
    grid   = Grid(resol, resol)
    data   = Data(β, c, a1, a2, grid)
    # run and visualise the results
    visualise(solver(data, grid, nt, dt, nout, ϵ)...)
    return
end

main()
