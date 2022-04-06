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
include("band.jl")

abstract type AbstractProjection end

"""
    Projection

Data type for projection of wave function.

# Fields
- `number_kpoints::Integer`: stores the number of k-points
- `number_bands::Integer`: stores the number of bands
- `number_ions::Integer`: stores the number of ions
- `projection::Array{<:Complex, 4}`: stores the projection ⟨Yₗₘ|ϕₙₖ⟩. The index order is
    [kpoint number, band number, ion number, orbit number]
- `projection_square::Array{<:Real, 4}`: stores the squared projection |⟨Yₗₘ|ϕₙₖ⟩|². The
    index order is same as `projection`.
"""
mutable struct Projection <: AbstractProjection
    number_kpoints::Integer
    number_bands::Integer
    number_ions::Integer
    projection::Array{<:Complex, 4}
    projection_square::Array{<:Real, 4}
end

Projection() = Projection(1, 1, 1,
    Array{ComplexF64, 4}(complex.(zeros(1, 1, 1, 1), zeros(1, 1, 1, 1))),
    Array{Float64, 4}(zeros(1, 1, 1, 1)))


"""
    Projection

Data type for projection of wave function.

# Fields
- `projection_up::Projection`: stores the projection of spin up electrons
- `projection_down::Projection`: stores the projection of spin down electrons
"""
mutable struct ProjectionWithSpin <: AbstractProjection
    projection_up::Projection
    projection_down::Projection
end

ProjectionWithSpin() = ProjectionWithSpin(Projection(), Projection())
