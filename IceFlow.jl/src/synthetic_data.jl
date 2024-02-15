struct Data
    B0
    β
    c
    B
    ELA
end

"""
    Data(B0, β, c, grid)

Create a Data object returning synthetic bedrock `B` and equilibrium line altitude `ELA` fields.
"""
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
