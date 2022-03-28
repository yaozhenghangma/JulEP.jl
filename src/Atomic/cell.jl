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
    Atom

Data type for single atom.

# Fields
- `symbol::String`: stores the chemical symbol of the atom
- `position::Array{T, 1}`: stores the Certesian coordinate of the atom
"""
struct Atom{T <: Real}
    symbol::String
    position::Array{T, 1}
end

function (atom::Atom)()
    return atom.symbol, atom.position
end

function Base.:(==)(atom1::Atom, atom2::Atom)
    atom1.symbol == atom2.symbol || return false
    atom1.position == atom2.position || return false
    return true
end

function Base.show(io::IO, atom::Atom)
    print(io, atom.symbol, "\t", atom.position)
end


"""
    Lattice

Data type of lattice.

# Fields
- `lattice::Array{T, 2}`: stores 3×3 matrix for the lattice
- `a:Array{T, 1}`: stores basis of axis a
- `b:Array{T, 1}`: stores basis of axis b
- `c:Array{T, 1}`: stores basis of axis c
"""
struct Lattice{T}
    lattice::Array{T, 2}
    a::Array{T, 1}
    b::Array{T, 1}
    c::Array{T, 1}

    function Lattice(lattice::Array{T, 2}) where T<:Real
        a = lattice[1, 1:3]
        b = lattice[2, 1:3]
        c = lattice[3, 1:3]
        return new{T}(lattice, a, b, c)
    end
end

function (lattice::Lattice)()
    return lattice.lattice
end

function Base.:(==)(lattice1::Lattice, lattice2::Lattice)
    lattice1.lattice == lattice2.lattice || return false
    return true
end

function Base.show(io::IO, lattice::Lattice)
    print(io, lattice())
end


"""
    Cell

Data type for cell.

# Fields
- `name::String`: stores the name of the cell.
- `lattice::Lattice{T}`: stores metadata about the lattice
- `atoms::Array{Atom{T}, 1}`: stroes metadata of all atoms in the cell
- `numbers::Array{W, 1} where W <: Integer`: stroes the numbers of atoms of elements
- `symbols::Array{String, 1}`: stores the chemical symbols of atoms of elements
"""
mutable struct Cell{T <: Real}
    name::String
    lattice::Lattice{T}
    atoms::Array{Atom{T}, 1}
    numbers::Array{W, 1} where W <: Integer
    symbols::Array{String, 1}
end

function (cell::Cell)()
    return cell.name, cell.lattice()
end

function Base.:(==)(cell1::Cell, cell2::Cell)
    cell1.lattice == cell2.lattice || return false
    cell1.atoms == cell1.atoms || return false
    return true
end

function Base.show(io::IO, cell::Cell)
    print(io, cell.name, "\n",
        cell.lattice(), "\n",
        cell.symbols, "\n",
        cell.numbers, "\n",
        cell.atoms)
end
