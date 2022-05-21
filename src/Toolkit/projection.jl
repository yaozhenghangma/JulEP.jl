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
    sign_matrix = sign.(sum(projection.projection_square, dims=[1,3,4]))
    up_index = findall(sign_matrix[1, :, 1, 1] .== 1)
    down_index = findall(sign_matrix[1, :, 1, 1] .== -1)
    return up_index, down_index
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
    up_index, down_index = get_projection_sign(projection_axis)
    projection_up = Projection()
    projection_down = Projection()
    bands_up = Bands()
    bands_down = Bands()

    # Projection for spin up
    projection_up.number_bands = length(up_index)
    projection_up.number_ions = projection_all.number_ions
    projection_up.number_kpoints = projection_all.number_kpoints
    projection_up.projection = deepcopy(projection_all.projection[:,up_index,:,:])
    projection_up.projection_square =
        deepcopy(projection_all.projection_square[:,up_index,:,:])

    # Projection for spin down
    projection_down.number_bands = length(down_index)
    projection_down.number_ions = projection_all.number_ions
    projection_down.number_kpoints = projection_all.number_kpoints
    projection_down.projection = deepcopy(projection_all.projection[:,down_index,:,:])
    projection_down.projection_square =
        deepcopy(projection_all.projection_square[:,down_index,:,:])

    # Bands for spin up
    bands_up.bands = deepcopy(bands.bands[up_index])

    # Bands for spin down
    bands_down.bands = deepcopy(bands.bands[down_index])

    return ProjectionWithSpin(projection_up, projection_down),
        BandsWithSpin(bands_up, bands_down)
end
