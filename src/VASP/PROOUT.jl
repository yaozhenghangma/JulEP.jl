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

include("../MatterBase/kpoint.jl")
include("../MatterBase/band.jl")
include("../MatterBase/projection.jl")

function load_proout(filename::String="PROOUT")
    input = open(filename, "r")
    pro = Projection(0, 0, 0,
        Array{KPoint, 1}([]),
        Array{Band, 1}([]),
        Array{ComplexF64, 4}(complex.(zeros(1, 1, 1, 1), zeros(1, 1, 1, 1))),
        Array{Float64, 4}(zeros(1, 1, 1, 1)))

    readline(input)     #comment line
    split_line = split(strip(readline(input)))      #kpoints, bands and ions
    pro.number_kpoints = parse(Int, split_line[4])
    pro.number_bands = parse(Int, split_line[8])
    pro.number_ions = parse(Int, split_line[12])
    split_line = parse.(Int, split(strip(readline(input))))      #type and ions
    number_type = split_line[1]
    number_ions = Int.(zeros(number_type))
    for i in 1:number_type
        number_ions[i] = split_line[i+2]
    end

    #occupancy
    number_line = Int(ceil(pro.number_kpoints*pro.number_bands/9.0))
    for i in 1:number_line
        readline(input)
    end

    #soft part of projection
    pro.projection = Array{ComplexF64, 4}(
        complex.(zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9),
            zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9)))
    counted_ions = 0
    for i in 1:number_type
        for j in 1:pro.number_kpoints
            ion_number = counted_ions + 1
            for k in 1:number_ions[i]
                for l in 1:pro.number_bands
                    split_line = push!(parse.(Float64, split(strip(readline(input)))),
                        parse.(Float64, split(strip(readline(input))))...)
                    for m in 1:9
                        pro.projection[j, l, ion_number, m] =
                            complex(split_line[2m-1], split_line[2m])
                    end
                end
                ion_number += 1
            end
        end
        counted_ions += number_ions[i]
    end
    pro.projection_square = abs2.(pro.projection)

    #augmentation part

    close(input)
    return pro
end
