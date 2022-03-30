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

include("kpoint.jl")

"""
    Projection

Data type for projection of wave function.

# Fields
- `number_kpoints::Integer`: stores the number of k-points
- `number_bands::Integer`: stores the number of bands
- `number_ions::Integer`: stores the number of ions
- `kpoints::Array{KPoint, 1}`: stores the information of k-points
- `projection::Array{<:Complex, 4}`: stores the projection ⟨Yₗₘ|ϕₙₖ⟩. The index order is
    [kpoint number, band number, ion number, orbit number]
- `projection_square::Array{<:Real, 4}`: stores the squared projection |⟨Yₗₘ|ϕₙₖ⟩|². The
    index order is same as `projection`.
"""
mutable struct Projection
    number_kpoints::Integer
    number_bands::Integer
    number_ions::Integer
    kpoints::Array{KPoint, 1}
    projection::Array{<:Complex, 4}
    projection_square::Array{<:Real, 4}
end
