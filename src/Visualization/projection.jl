#   Copyright (C) 2022  Yaozhenghang Ma
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""
    plot!(
        projection::Projection,
        kpoints::Array{KPoint, 1},
        bands::Bands;
        ion::Integer = nothing,
        orbit::Integer = nothing,
        color::Symbol = :red,
        magnify::Real = 10,
        tolerance::Real = 0)

Plot projections on current figure.

# Arguments
- `projection::Projection`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::Bands`: metadat of all bands
- `ion::Integer = nothing`: projection of given ion
- `orbit::Integer = nothing`: projection of given orbit
- `color::Symbol = :red`: marker color
- `alpha::Real = 0.5`: alpha value of marker
- `magnify::Real = 10`: marker_size = magnify * projection_square
- `tolerance::Real = 0`: plot point if projection_square > tolerance
"""
function plot!(
    projection::Projection,
    kpoints::Array{KPoint, 1},
    bands::Bands;
    ion::Integer = nothing,
    orbit::Integer = nothing,
    color::Symbol = :red,
    alpha::Real = 0.5,
    magnify::Real = 10,
    max_size::Real = 5,
    tolerance::Real = 0)

    index,  = index_kpoints(kpoints)
    for i in 1:projection.number_bands, j in 1:projection.number_kpoints
        if projection.projection_square[j, i, ion, orbit] > tolerance
            marker_size = magnify*projection.projection_square[j, i, ion, orbit]
            marker_size = (marker_size > max_size) ? max_size : marker_size
            plot!([index[j]], [bands[i].energy[j]],
                seriestype = :scatter,
                markercolor = color,
                markersize = marker_size,
                markeralpha = alpha;
                markerstrokealpha = 0,
                markerstrokecolor = color)
        end
    end
    return nothing
end


"""
    plot!(
        projection::ProjectionWithSpin,
        kpoints::Array{KPoint, 1},
        bands::BandsWithSpin;
        ion::Integer = nothing,
        orbit::Integer = nothing,
        color::Symbol = :red,
        magnify::Real = 10,
        tolerance::Real = 0

Plot projections on current figure.

# Arguments
- `projection::ProjectionWithSpin`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::BandsWithSpin`: metadat of all bands
- `ion::Integer = nothing`: projection of given ion
- `orbit::Integer = nothing`: projection of given orbit
- `color::Symbol = :red`: marker color
- `alpha::Real = 0.5`: alpha value of marker
- `magnify::Real = 10`: marker_size = magnify * projection_square
- `tolerance::Real = 0`: plot point if projection_square > tolerance
"""
function plot!(
    projection::ProjectionWithSpin,
    kpoints::Array{KPoint, 1},
    bands::BandsWithSpin;
    ion::Integer = nothing,
    orbit::Integer = nothing,
    alpha::Real = 0.5,
    color::Symbol = :red,
    magnify::Real = 10,
    max_size::Real = 5,
    tolerance::Real = 0)
    plot!(projection.projection_up, kpoints, bands.bands_up;
        ion = ion, orbit = orbit, color = color, alpha = alpha,
        magnify = magnify, max_size = max_size, tolerance = tolerance)
    plot!(projection.projection_down, kpoints, bands.bands_down;
        ion = ion, orbit = orbit, color = color, alpha = alpha,
        magnify = magnify, max_size = max_size, tolerance = tolerance)
    return nothing
end
