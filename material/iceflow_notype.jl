using Printf, Statistics, LinearAlgebra, UnPack
using GLMakie
Makie.inline!(true)

const s2yr = 31557600

struct Grid
    lx
    ly
    dx
    dy
    xc
    yc
    Xc
    Yc
end

function Grid(lx, ly, nx, ny)
    dx, dy = lx / nx, ly / ny
    xc = LinRange(-lx / 2 + dx / 2, lx / 2 - dx / 2, nx)
    yc = LinRange(-ly / 2 + dy / 2, ly / 2 - dy / 2, ny)
    Xc, Yc = [x for x = xc, _ = yc], [y for _ = xc, y = yc]
    return Grid(lx, ly, dx, dy, xc, yc, Xc, Yc)
end

struct Data
    B0
    β
    c
    B
    ELA
end

function Data(B0, β, c, grid)
    B = bedrock_elevation(B0, grid)
    ELA = equilibrium_line_altitude(grid)
    return Data(B0, β, c, B, ELA)
end

function bedrock_elevation(B0, grid)
    return @. B0 * exp(-grid.Xc^2 / 1e10 - grid.Yc^2 / 1e9) +
              B0 * exp(-grid.Xc^2 / 1e9 - (grid.Yc - grid.ly / 8) * (grid.Yc - grid.ly / 8) / 1e10)
end

equilibrium_line_altitude(grid) = @. 2150 + 900 * atan(grid.Yc / grid.ly)

@views av(A) = 0.25 .* (A[1:end-1, 1:end-1] .+ A[1:end-1, 2:end] .+ A[2:end, 1:end-1] .+ A[2:end, 2:end])
@views avx(A) = 0.5 .* (A[1:end-1, :] .+ A[2:end, :])
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

@views function solver(data, grid, params...)
    @unpack B0, β, c, B, ELA = data
    dx, dy = grid.dx, grid.dy
    nt, nout, ϵ, dt, ρg = params
    nx, ny = size(B)
    # preprocess
    a1 = 1.9e-24 * ρg^3 * s2yr
    a2 = 5.7e-20 * ρg^3 * s2yr
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
    lx, ly = 250000.0, 200000.0  # domain size [m]
    B0     = 3500.0              # mean height [m]
    β      = 0.01                # mass-balance slope
    c      = 2.0                 # mass-balance limiter
    ρg     = 910.0 * 9.81        # ice density x gravity
    dt     = 0.1                 # time step [yr]
    # numerics
    resol  = 256
    nt     = 1e4                 # number of time steps
    nout   = 1e3                 # visu and error checking interval
    ϵ      = 1e-4                # steady state tolerance
    grid   = Grid(lx, ly, resol, resol)
    data   = Data(B0, β, c, grid)
    params = (nt, nout, ϵ, dt, ρg)
    # run and visualise the results
    visualise(solver(data, grid, params...)...)
    return
end

main()
