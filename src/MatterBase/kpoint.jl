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
    KPoint

Data type for k-point.

# Fields
- `weight::Real`: stores the weight of k-point
- `coordinate::Array{<:Real, 1}`: stores the coordinate of k-point
"""
mutable struct KPoint
    weight::Real
    coordinate::Array{<:Real, 1}
end

KPoint() = KPoint(0.0, zeros(3))


function Base.:(==)(kpoint1::KPoint, kpoint2::KPoint)
    kpoint1.weight == kpoint2.weight || return false
    kpoint1.coordinate == kpoint2.coordinate || return false
    return true
end
