"""
    Data{T <: Real, G}(B0::T, β::T, c::T, grid) -> Data

Construct a `Data` object containing parameters related to ice flow modeling.

# Arguments
- `B0::T`: The mean height (of type `T`) of the bedrock elevation.
- `β::T`: The slope of the mass-balance (of type `T`).
- `c::T`: The mass-balance limiter (of type `T`).
- `grid`: The grid on which the bedrock elevation and equilibrium line altitude are calculated. The type of `grid` determines the type `G`.

# Returns
A `Data` object with fields `B` and `ELA` computed using the provided `grid` and parameters `B0`, `β`, `c`. The types of `B` and `ELA` are inferred from the return types of `bedrock_elevation` and `equilibrium_line_altitude` functions.
"""
struct Data{T <: Real, G}
    B0::T   # mean height
    β::T    # mass-balance slope
    c::T    # mass-balance limiter
    B::G    # Bedrock elevation
    ELA::G  # Equilibrium line altitude
    function Data(B0::T, β::T, c::T, grid) where {T}
        B = bedrock_elevation(B0, grid)       # Assuming this returns type G
        ELA = equilibrium_line_altitude(grid) # Assuming this returns type G
        new{T, typeof(B)}(B0, β, c, B, ELA)
    end
end

"Compute the bedrock elevation."
@inline function bedrock_elevation(B0, grid)
    return @. B0 * exp(-grid.Xc^2 / 1e10 - grid.Yc^2 / 1e9) +
              B0 * exp(-grid.Xc^2 / 1e9 - (grid.Yc - grid.ly / 8) * (grid.Yc - grid.ly / 8) / 1e10)
end

"Compute the equilibrium line altitude ELA."
equilibrium_line_altitude(grid) = @. 2150 + 900 * atan(grid.Yc / grid.ly)
