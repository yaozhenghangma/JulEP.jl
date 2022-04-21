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
    band_recipe(band::Band,
        kpoints::Array{KPoint, 1};
        critical_points = nothing)

Plots recipe for band structure.

# Arguments
- `band::Band`: metadata of band
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `critical_points = nothing`: name of critical points
    showed at x axis
"""
RecipesBase.@recipe function band_recipe(band::Band,
    kpoints::Array{KPoint, 1};
    critical_points = nothing)

    index, number = index_kpoints(kpoints)
    ticks_range = 1:(float(number-1)/(length(critical_points)-1)):number

    linecolor --> :black
    linestyle --> :solid
    label --> nothing
    if critical_points !== nothing
        xticks -->  (ticks_range, critical_points)
    end
    xlims --> (1, number)

    return index, band.energy
end


@doc raw"""
    bands_recipe(band::Bands,
        kpoints::Array{KPoint, 1};
        critical_points = nothing)

Plots recipe for band structure.

# Arguments
- `bands::Bands`: metadata of band
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `critical_points = nothing`: name of critical points
    showed at x axis
"""
RecipesBase.@recipe function bands_recipe(bands::Bands,
    kpoints::Array{KPoint, 1};
    critical_points = nothing)

    #plot every band
    for band in bands
        RecipesBase.@series begin
            critical_points --> critical_points
            return band, kpoints
        end
    end

    return nothing
end


@doc raw"""
    bands_recipe(band::BandsWithSpin,
        kpoints::Array{KPoint, 1};
        critical_points = nothing)

Plots recipe for band structure.

# Arguments
- `bands::BandsWithSpin`: metadata of band
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `critical_points = nothing`: name of critical points
    showed at x axis
- `colorlist = [:black, :gray]`: Color of lines for spin up and spin down
    default: black line for spin up and gray line for spin down
- `stylelist = [:solid, :dash]`: Style of lines for spin up and spin down
    default: solid line for spin up and dash line for spin down
"""
RecipesBase.@recipe function bands_recipe(bands::BandsWithSpin,
    kpoints::Array{KPoint, 1};
    critical_points = nothing,
    colorlist = [:black, :gray],
    stylelist = [:solid, :dash])

    RecipesBase.@series begin
        critical_points --> critical_points
        linecolor --> colorlist[1]
        linestyle --> stylelist[1]
        return bands.bands_up, kpoints
    end

    RecipesBase.@series begin
        critical_points --> critical_points
        linecolor --> colorlist[2]
        linestyle --> stylelist[2]
        return bands.bands_down, kpoints
    end

    return nothing
end
