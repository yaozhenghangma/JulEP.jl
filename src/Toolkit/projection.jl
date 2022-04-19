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
    sign_matrix = deepcopy(projection.projection_square)
    sign_matrix[:,:,:,1] = sign.(sign_matrix[:,:,:,1])       #s orbit
    sign_matrix[:,:,:,2:4] .= sign.(sum(sign_matrix[:,:,:,2:4], dims=4))        #p orbit
    sign_matrix[:,:,:,5:9] .= sign.(sum(sign_matrix[:,:,:,5:9], dims=4))        #d orbit
    return sign_matrix
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


@doc raw"""
    distinguish_spin(projection_all::Projection,
        projection_axis::Projection,
        bands::Bands)

Distinguish projection of spin up and spin down. (Used in projection loaded from PROCAR)

# Arguments
- `projection_all::Projection`: total projected magnetization
- `projection_axis::Projection`: projected magnetization in x, y or z axis
- `bands::Bands`: metadata of bands

# Returnss
- `ProjectionWithSpin`: projection of spin up and spin down
- `BandsWithSpin`: metadata of bands of spin up and spin down
"""
function distinguish_spin(projection_all::Projection,
    projection_axis::Projection,
    bands::Bands)
    sign_matrix = get_projection_sign(projection_axis)
    projection_axis_new = apply_projection_sign(projection_all, sign_matrix)
    projection_up = deepcopy(projection_all)
    projection_down = deepcopy(projection_all)
    @. projection_up.projection_square =
        (projection_all.projection_square + projection_axis_new.projection_square)/2
    @. projection_down.projection_square =
        (projection_all.projection_square - projection_axis_new.projection_square)/2
    projection = ProjectionWithSpin(projection_up, projection_down)
    bands_new = BandsWithSpin(bands, bands)
    return projection, bands_new
end
