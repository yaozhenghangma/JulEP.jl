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

abstract type AbstractBand end


"""
    Band <: AbstractBand

Data type for band structure.

# Fields
- `occupancy::Real`: stores the occupancy of the band
- `energy::Array{<:Real, 1}`: stores the energy values at each k-points
"""
mutable struct Band <: AbstractBand
    occupancy::Real
    energy::Array{<:Real, 1}
end

Band() = Band(0.0, Array{Float64, 1}([]))
Band(number_kpoints::Int) = Band(0.0, zeros(number_kpoints))

mutable struct BandWithSpin <: AbstractBand
    band_up::Band
    band_down::Band
end

BandWithSpin() = BandWithSpin(Band(), Band())
BandWithSpin(number_kpoints::Int) = BandWithSpin(Band(number_kpoints), Band(number_kpoints))
