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
    DOS

Data type for density of states.

# Fields
- `energy::Array{<:Real, 1}`: energy value of each dos point
- `dos::Array{<:Real, 1}`: metadata of dos
"""
mutable struct DOS
    energy::Array{<:Real, 1}
    dos::Array{<:Real, 1}
end

DOS() = DOS(Array{Float64, 1}([]), Array{Float64, 1}([]))


function Base.:(==)(dos1::DOS, dos2::DOS)
    dos1.energy == dos2.energy || return false
    dos1.dos == dos2.dos || return false
    return true
end
