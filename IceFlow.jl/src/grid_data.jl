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

"""
    Grid(lx, ly, nx, ny)

Create a Grid object for specified domain extent `lx, ly` and grid resolution `nx, ny`.
"""
function Grid(lx, ly, nx, ny)
    dx, dy = lx / nx, ly / ny
    xc = LinRange(-lx / 2 + dx / 2, lx / 2 - dx / 2, nx)
    yc = LinRange(-ly / 2 + dy / 2, ly / 2 - dy / 2, ny)
    Xc, Yc = [x for x = xc, _ = yc], [y for _ = xc, y = yc]
    return Grid(lx, ly, dx, dy, xc, yc, Xc, Yc)
end
