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

include("../MatterBase/band.jl")
include("../MatterBase/kpoint.jl")


function allocate_band!(spin, number_kpoints, number_bands)
    if spin
        bands = BandsWithSpin(number_bands, number_kpoints)
    else
        bands = Bands(number_bands, number_kpoints)
    end

    return bands
end


function read_bands!(input, kpoints, bands, number_kpoints, number_bands, spin)
    for i in 1:number_kpoints
        readline(input)     #blank line
        split_line = parse.(Float64, split(strip(readline(input))))     #k-points
        kpoints[i].coordinate = split_line[1:3]
        kpoints[i].weight = split_line[4]
        for j in 1:number_bands
            split_line = parse.(Float64, split(strip(readline(input))))     #energy and occ.
            if spin
                bands.bands_up[j].energy[i] = split_line[2]
                bands.bands_down[j].energy[i] = split_line[3]
                bands.bands_up[j].occupancy = split_line[4]
                bands.bands_down[j].occupancy = split_line[5]
            else
                bands[j].energy[i] = split_line[2]
                bands[j].occupancy = split_line[3]
            end
        end
    end
    return nothing
end


"""
    load_eigenval(filename::String="EIGENVAL", spin::Bool=false) -> Bands, Kpoints

Load band structure from EIVENVAL file.

# Arguments
- `filename::String="EIGENVAL"`: name of input file
- `spin::Bool=false`: distingush spin up and spin down or not

# Returns
- `Bands`: Eigen-values of energy in each k-points
- `Array{KPoint, 1}`: K-points and weight
"""
function load_eigenval(filename::String="EIGENVAL", spin::Bool=false)
    input = open(filename, "r")

    readline(input)     #number of ions
    readline(input)
    readline(input)
    readline(input)
    readline(input)     #name
    split_line = parse.(Int, split(strip(readline(input))))     #number of bands and kpoints

    #allocate space for k-points
    kpoints = Array{KPoint, 1}([])
    for i in 1:split_line[2]
        push!(kpoints, KPoint())
    end

    #allocate space for bands
    bands = allocate_band!(spin, split_line[2], split_line[3])

    read_bands!(input, kpoints, bands, split_line[2], split_line[3], spin)

    close(input)
    return bands, kpoints
end
