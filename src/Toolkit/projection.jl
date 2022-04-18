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

@doc raw"""
    get_projection_sign(projection::Projection)

Applied sign function to squared projection

# Arguments
- `projection::Projection`: projection of wavefunction

# Returns
- `Array{Float, 4}`: sign of each squared projection
"""
function get_projection_sign(projection::Projection)
    return sign.(projection.projection_square)
end


@doc raw"""
    apply_projection_sign(projection::Projection, sign_matrix::Array{<:Real, 4})

Applied sign of projection to projection.

# Arguments
- `projection::Projection`: projection of wavefunction
- `sign_matrix::Array{Integer, 4}`: sign returned from get_projection_sign function

# Returns
- `Projection`: new projection
"""
function apply_projection_sign(projection::Projection, sign_matrix::Array{<:Real, 4})
    new_projection = deepcopy(projection)
    new_projection.projection_square = new_projection.projection_square .* sign_matrix
    return new_projection
end
