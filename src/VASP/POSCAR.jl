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

using Printf

include("../Atomic/cell.jl")

"""
    load_poscar(filename::String="POSCAR") -> Cell

Load cell structure from POSCAR file.

# Arguments
- `filename::String="POSCAR"`: name of input file

# Returns
- `Cell`: structure of cell
"""
function load_poscar(filename::String="POSCAR")
    input = open(filename, "r");
    cell = Cell()

    cell.name = readline(input)     #comment line
    constant = parse(Float64, strip(readline(input)))       #lattice constant
    #lattice
    lattice_matrix = zeros(3, 3)
    for i in 1:3
        split_coordinate = split(strip(readline(input)))
        for j in 1:3
            lattice_matrix[i, j] = parse(Float64, split_coordinate[j]) * constant
        end
    end
    cell.lattice = Lattice(lattice_matrix)
    #chemical symbols and numbers of elements
    cell.symbols = split(strip(readline(input)))
    cell.numbers = parse.(Int32, split(strip(readline(input))))
    #coordinate
    line = strip(readline(input))
    direct_coordinate = (line[1] == 'D' || line[1] == 'd')
    if direct_coordinate
        for i in 1:length(cell.numbers), j in 1:cell.numbers[i]
            push!(cell.atoms, Atom(cell.symbols[i],
                                transpose(transpose(parse.(Float64,
                                split(strip(readline(input))))) * cell.lattice())))
        end
    else
        for i in 1:length(cell.numbers), j in 1:cell.numbers[i]
            push!(cell.atoms, Atom(cell.symbols[i],
                                parse.(Float64, split(strip(readline(input))))))
        end
    end
    close(input)
    return cell
end


"""
    save_poscar(cell::Cell, filename::String="POSCAR", direct::Bool=true)

Save cell structure into POSCAR file.

# Arguments
- `cell::Cell`: structure of cell
- `filename::String="POSCAR"`: name of output file
- `direct::Bool=true`: output direct coordinate or Certesian coordinate
"""
function save_poscar(cell::Cell, filename::String="POSCAR", direct::Bool=true)
    output = open(filename, "w")

    write(output, cell.name, "\n")
    write(output, "1.0\n")
    for i in 1:3
        write(output, "$(@sprintf(" %.7f\t %.7f\t %.7f\n",
                                    cell.lattice()[i, 1],
                                    cell.lattice()[i, 2],
                                    cell.lattice()[i, 3]))")
    end
    for symbol in cell.symbols
        write(output, symbol, " ")
    end
    write(output, "\n")
    for num in cell.numbers
        write(output, "$(@sprintf("%d ", num))")
    end
    if direct
        write(output, "\nDirect\n")
        inverse_lattice = inv(cell.lattice)
        for atom in cell.atoms
            direct_position = transpose(transpose(atom.position) * inverse_lattice)
            write(output, "$(@sprintf(" %.7f\t %.7f\t %.7f\n",
                                        direct_position[1],
                                        direct_position[2],
                                        direct_position[3]))")
        end
    else
        write(output, "\nCertesian\n")
        for atom in cell.atoms
            write(output, "$(@sprintf(" %.7f\t %.7f\t %.7f\n",
                                        atom.position[1],
                                        atom.position[2],
                                        atom.position[3]))")
        end
    end
    close(output)
    return nothing
end
