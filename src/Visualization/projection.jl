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
    function plot_projection!(
        projection::Projection,
        kpoints::Array{KPoint, 1},
        bands::Bands;
        ion::Int = nothing,
        orbit::Int = nothing,
        color::Symbol = :red,
        magnify::Real = 10,
        tolerance::Real = 0)

Plot projections on current figure.

# Arguments
- `projection::Projection`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::Bands`: metadat of all bands
- `ion::Int = nothing`: projection of given ion
- `orbit::Int = nothing`: projection of given orbit
- `color::Symbol = :red`: marker color
- `magnify::Real = 10`: marker_size = magnify * projection_square
- `tolerance::Real = 0`: plot point if projection_square > tolerance
"""
function plot_projection!(
    projection::Projection,
    kpoints::Array{KPoint, 1},
    bands::Bands;
    ion::Int = nothing,
    orbit::Int = nothing,
    color::Symbol = :red,
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
                markerstrokealpha = 0,
                markerstrokecolor = color)
        end
    end
    return nothing
end


"""
    function plot_projection!(
        projection::ProjectionWithSpin,
        kpoints::Array{KPoint, 1},
        bands::BandsWithSpin;
        ion::Int = nothing,
        orbit::Int = nothing,
        color::Symbol = :red,
        magnify::Real = 10,
        tolerance::Real = 0

Plot projections on current figure.

# Arguments
- `projection::ProjectionWithSpin`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::BandsWithSpin`: metadat of all bands
- `ion::Int = nothing`: projection of given ion
- `orbit::Int = nothing`: projection of given orbit
- `color::Symbol = :red`: marker color
- `magnify::Real = 10`: marker_size = magnify * projection_square
- `tolerance::Real = 0`: plot point if projection_square > tolerance
"""
function plot_projection!(
    projection::ProjectionWithSpin,
    kpoints::Array{KPoint, 1},
    bands::BandsWithSpin;
    ion::Int = nothing,
    orbit::Int = nothing,
    color::Symbol = :red,
    magnify::Real = 10,
    max_size::Real = 5,
    tolerance::Real = 0)
    plot_projection!(projection.projection_up, kpoints, bands.bands_up;
        ion = ion, orbit = orbit, color = color,
        magnify = magnify, max_size = max_size, tolerance = tolerance)
    plot_projection!(projection.projection_down, kpoints, bands.bands_down;
        ion = ion, orbit = orbit, color = color,
        magnify = magnify, max_size = max_size, tolerance = tolerance)
    return nothing
end
