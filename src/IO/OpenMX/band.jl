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

function read_bands!(input, bands::Bands, kpoints::Array{KPoint, 1},
    number_kpath, number_kpoints, reciprocal_lattice, fermi_energy, unit)
    k_number = 1
    for i in 1:number_kpath
        for j in 1:number_kpoints[i]
            split_line = split(strip(readline(input)))
            number_bands = parse(Int, split_line[1])
            kpoints[k_number].coordinate =
                transpose(reciprocal_lattice) * parse.(Float64, split_line[2:4])
            split_line = parse.(Float64, split(strip(readline(input))))
            for k in 1:number_bands
                bands.bands[k].energy[k_number] = (split_line[k] - fermi_energy) * unit
            end
            k_number += 1
        end
    end
    return nothing
end

function read_bands!(input, band::BandsWithSpin, kpoint::Array{KPoint, 1},
    number_kpath, number_kpoints, reciprocal_lattice, fermi_energy, unit)
end


"""
    load_openmx_band(filename::String) -> Bands, Kpoints

Load band structure from band file of OpenMX.

# Arguments
- `filename::String``: name of input file

# Returns
- `Bands`: Eigen-values of energy in each k-points
- `Array{KPoint, 1}`: K-points and weight
"""
function load_openmx_band!(filename::String)
    unit = 27.2113845       # from Hatree defined in OpenMX to eV
    input = open(filename, "r")

    # basic info
    split_line = split(strip(readline(input)))
    number_bands = parse(Int, split_line[1])
    spin_state = (parse(Int, split_line[2]) == 1)
    fermi_energy = parse(Float64, split_line[3])

    # reciprocal lattice
    split_line = parse.(Float64, split(strip(readline(input))))
    reciprocal_lattice = Matrix(transpose(reshape(split_line, 3, 3)))

    # k path info
    number_kpath = parse(Int, split(strip(readline(input)))[1])
    number_kpoints = zeros(number_kpath)
    for i in 1:number_kpath
        split_line = split(strip(readline(input)))
        number_kpoints[i] = parse(Int, split_line[1])
    end

    # allocate space
    kpoints = Array{KPoint, 1}([])
    for i in 1:sum(number_kpoints)
        push!(kpoints, KPoint())
    end
    if spin_state
        bands = BandsWithSpin(number_bands, Int(sum(number_kpoints)))
    else
        bands = Bands(number_bands, Int(sum(number_kpoints)))
    end

    # band structure
    read_bands!(input, bands, kpoints,
        number_kpath, number_kpoints, reciprocal_lattice, fermi_energy, unit)

    close(input)
    return bands, kpoints
end
