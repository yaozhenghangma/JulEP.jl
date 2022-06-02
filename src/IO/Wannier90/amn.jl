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

function load_amn(filename::String)
    input = open(filename, "r")

    readline(input)     # comment line

    # basic info
    split_line = parse.(Int, split(strip(readline(input))))
    number_bands = split_line[1]
    number_kpoints = split_line[2]
    number_orbits = split_line[3]
    spin_state = (split_line[4] == 2)

    # allocate space
    if spin_state
    else
        projection = Projection()
        projection.number_kpoints = number_kpoints
        projection.number_bands = number_bands
        projection.number_ions = 1
        projection.projection = complex(zeros(
            projection.number_kpoints,
            projection.number_bands,
            projection.number_ions, number_orbits))
        projection.projection_square = zeros(projection.number_kpoints,
            projection.number_bands,
            projection.number_ions, number_orbits)
    end

    # projection
    for i in 1:number_kpoints, j in 1:number_orbits, k in 1:number_bands
        split_line = split(strip(readline(input)))
        projection.projection[i, k, 1, j] = parse(Float64, split_line[4]) +
            parse(Float64, split_line[5]) * im
        projection.projection_square[i, k, 1, j] = norm(projection.projection[i, k, 1, j])
    end

    close(input)
    return projection
end
