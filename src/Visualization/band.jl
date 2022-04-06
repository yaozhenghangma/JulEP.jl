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

using Plots

include("../MatterBase/band.jl")
include("../MatterBase/kpoint.jl")
include("kpoint.jl")


"""
    function plot_band!(band::Band,
        kpoints::Array{KPoint, 1},
        xticks::Array{String, 1} = nothing;
        line_style = (:solid, :black))

Plot one band on current figure.

# Arguments
- `band::Band`: metadata of band
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `xticks::Array{String, 1}`: name of critical points showed at x axis
- `line_style = (:solid, :black)`: style of line (see document of Plots.jl)
"""
function plot_band!(band::Band,
    kpoints::Array{KPoint, 1},
    xticks::Array{String, 1} = nothing;
    line_style = (:solid, :black))

    index, number = index_kpoints(kpoints)
    ticks_range = 1:(float(number-1)/(length(xticks)-1)):number

    plot!(index, band.energy,
        label = nothing,
        line = line_style,
        xticks = (ticks_range, xticks),
        xlims = (1, number))
    return nothing
end


"""
    function plot_bands!(bands::Bands,
        kpoints::Array{KPoint, 1},
        xticks::Array{String, 1} = nothing;
        line_style = (:solid, :black))

Plot one band on current figure.

# Arguments
- `bands::Bands`: metadata of all bands
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `xticks::Array{String, 1}=nothing`: name of critical points showed at x axis
- `line_style = (:solid, :black)`: style of line (see document of Plots.jl)
"""
function plot_bands!(bands::Bands,
    kpoints::Array{KPoint, 1},
    xticks::Array{String, 1} = nothing;
    line_style = (:solid, :black))

    #plot every band
    for band in bands
        plot_band!(band, kpoints, xticks; line_style=line_style)
    end

    #add dash line at Fermi energy
    x = Array{Int, 1}(1:length(kpoints))
    y = zeros(length(kpoints))
    plot!(x, y, label=nothing, line_style=(:dash, :gray))
    return nothing
end


"""
    function plot_bands!(bands::BandsWithSpin,
        kpoints::Array{KPoint, 1},
        xticks::Array{String, 1} = nothing;
        line_style = (:solid, :black))

Plot one band on current figure.

# Arguments
- `bands::BandsWithSpin`: metadata of all bands (spin up and spin down)
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `xticks::Array{String, 1}=nothing`: name of critical points showed at x axis
- `line_style = [(:solid, :black),(:dash, :gray)]`: style of line (see document of Plots.jl)
"""
function plot_bands!(bands::BandsWithSpin,
    kpoints::Array{KPoint, 1},
    xticks::Array{String, 1} = nothing;
    line_style = [(:solid, :black), (:dash, :gray)])

    #plot every band
    for band in bands.bands_up
        plot_band!(band, kpoints, xticks; line_style=line_style[1])
    end

    for band in bands.bands_down
        plot_band!(band, kpoints, xticks; line_style=line_style[2])
    end

    #add dash line at Fermi energy
    x = Array{Int, 1}(1:length(kpoints))
    y = zeros(length(kpoints))
    plot!(x, y, label=nothing, line=(:dot, :gray))
    return nothing
end
