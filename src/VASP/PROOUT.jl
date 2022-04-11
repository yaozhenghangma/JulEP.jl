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
    load_proout(filename::String="PROOUT") -> Projection

Load projection of wave function ⟨Yₗₘ|ϕₙₖ⟩ from PROOUT file.

# Arguments
- `filename::String="PROOUT"`: name of input file

# Returns
- `Projection`: Projection of wave function ⟨Yₗₘ|ϕₙₖ⟩
"""
function load_proout(filename::String="PROOUT")
    input = open(filename, "r")
    projection = Projection(0, 0, 0,
        Array{ComplexF64, 4}(complex.(zeros(1, 1, 1, 1), zeros(1, 1, 1, 1))),
        Array{Float64, 4}(zeros(1, 1, 1, 1)))

    readline(input)     #comment line
    split_line = split(strip(readline(input)))      #kpoints, bands and ions
    projection.number_kpoints = parse(Int, split_line[4])
    projection.number_bands = parse(Int, split_line[8])
    projection.number_ions = parse(Int, split_line[12])
    split_line = parse.(Int, split(strip(readline(input))))      #type and ions
    number_type = split_line[1]
    number_ions = Int.(zeros(number_type))
    for i in 1:number_type
        number_ions[i] = split_line[i+2]
    end

    #occupancy
    number_line = Int(ceil(projection.number_kpoints*projection.number_bands/9.0))
    for i in 1:number_line
        readline(input)
    end

    #soft part of projection
    projection.projection = Array{ComplexF64, 4}(
    complex.(
    zeros(projection.number_kpoints, projection.number_bands, projection.number_ions, 9),
    zeros(projection.number_kpoints, projection.number_bands, projection.number_ions, 9)))
    counted_ions = 0
    for i in 1:number_type
        for j in 1:projection.number_kpoints
            ion_number = counted_ions + 1
            for k in 1:number_ions[i]
                for l in 1:projection.number_bands
                    split_line = push!(parse.(Float64, split(strip(readline(input)))),
                        parse.(Float64, split(strip(readline(input))))...)
                    for m in 1:9
                        projection.projection[j, l, ion_number, m] =
                            complex(split_line[2m-1], split_line[2m])
                    end
                end
                ion_number += 1
            end
        end
        counted_ions += number_ions[i]
    end
    projection.projection_square = abs2.(projection.projection)

    #augmentation part

    close(input)
    return projection
end
