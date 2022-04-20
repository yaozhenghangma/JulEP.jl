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

@doc raw"""
    projection_recipe(
        projection::Projection,
        kpoints::Array{KPoint, 1},
        bands::Bands;
        ion::Integer = nothing,
        orbit::Integer = nothing,
        magnify = 10,
        max_size = 5,
        tolerance = 0)

Plots recipe for projection.

# Arguments
- `projection::Projection`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::Bands`: metadat of all bands
- `ion = nothing`: projection of given ion
- `orbit = nothing`: projection of given orbit
- `magnify = 10`: marker_size = magnify * projection_square
- `max_size = 5`: max point size
- `tolerance= 0`: plot point if projection_square > tolerance
"""
RecipesBase.@recipe function projection_recipe(
    projection::Projection,
    kpoints::Array{KPoint, 1},
    bands::Bands;
    ion = nothing,
    orbit = nothing,
    magnify = 10,
    max_size = 5,
    tolerance = 0)

    index,  = index_kpoints(kpoints)
    label --> nothing
    for i in 1:projection.number_bands, j in 1:projection.number_kpoints
        if projection.projection_square[j, i, ion, orbit] > tolerance
            RecipesBase.@series begin
                marker_size = magnify*projection.projection_square[j, i, ion, orbit]
                marker_size = (marker_size > max_size) ? max_size : marker_size
                seriestype --> :scatter
                markercolor --> :red
                markersize --> marker_size
                markeralpha --> 0.5
                markerstrokealpha := 0
                markerstrokecolor --> :red

                return [index[j]], [bands[i].energy[j]]
            end
        end
    end
    return nothing
end


@doc raw"""
    projection_recipe(
        projection::ProjectionWithSpin,
        kpoints::Array{KPoint, 1},
        bands::Bands;
        ion::Integer = nothing,
        orbit::Integer = nothing,
        magnify = 10,
        max_size = 5,
        tolerance = 0)

Plots recipe for projection.

# Arguments
- `projection::ProjectionWithSpin`: metadata of projection
- `kpoints::Array{KPoint, 1}`: metadata of all k-points
- `bands::BandsWithSpin`: metadat of all bands
- `ion = nothing`: projection of given ion
- `orbit = nothing`: projection of given orbit
- `magnify = 10`: marker_size = magnify * projection_square
- `max_size = 5`: max point size
- `tolerance= 0`: plot point if projection_square > tolerance
"""
RecipesBase.@recipe function projection_recipe(
    projection::ProjectionWithSpin,
    kpoints::Array{KPoint, 1},
    bands::BandsWithSpin;
    ion = nothing,
    orbit = nothing,
    magnify = 10,
    max_size = 5,
    tolerance = 0)

    RecipesBase.@series begin
        ion --> ion
        orbit --> orbit
        magnify --> magnify
        max_size --> max_size
        tolerance --> tolerance
        return projection.projection_up, kpoints, bands.bands_up
    end

    RecipesBase.@series begin
        ion --> ion
        orbit --> orbit
        magnify --> magnify
        max_size --> max_size
        tolerance --> tolerance
        return projection.projection_down, kpoints, bands.bands_down
    end
    return nothing
end
