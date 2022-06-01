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
    projection_transformation!(projection::Projection,
        transfer_matrix::Matrix{<:Number}...;
        orbit::Symbol=:d)

Linear transformation of projection ⟨Yₗₘ|ϕₙₖ⟩.

# Arguments
- `projection::Projection`: projection of wavefunction
- `transfer_matrix::Matrix{<:Number}...`: transformation matrix M1, M2 ...
- `orbit::Symbol=:d`: orbits to be considered in transformation, default d orbits
"""
function projection_transformation!(projection::Projection,
    transfer_matrix::Matrix{<:Number}...;
    orbit::Symbol=:d)

    if orbit == :d
        for matrix in transfer_matrix
            for i in 1:projection.number_kpoints,
                j in 1:projection.number_bands,
                k in 1:projection.number_ions
                projection.projection[i, j, k, 5:9] =
                    matrix * projection.projection[i, j, k, 5:9]
            end
        end
    end

    projection.projection_square = abs2.(projection.projection)
    return nothing
end


@doc raw"""
    projection_transformation!(projection::ProjectionWithSpin,
        transfer_matrix::Matrix{<:Number}...;
        orbit::Symbol=:d)

Linear transformation of projection ⟨Yₗₘ|ϕₙₖ⟩.

# Arguments
- `projection::ProjectionWithSpin`: projection of wavefunction
- `transfer_matrix::Matrix{<:Number}...`: transformation matrix M1, M2 ...
- `orbit::Symbol=:d`: orbits to be considered in transformation, default d orbits
"""
function projection_transformation!(projection::ProjectionWithSpin,
    transfer_matrix::Matrix{<:Number}...;
    orbit::Symbol=:d)

    projection_transformation!(projection.projection_up, transfer_matrix...; orbit=orbit)
    projection_transformation!(projection.projection_down, transfer_matrix...; orbit=orbit)
    return nothing
end


function transform!(projection::ProjectionWithSpin,
    matrix::Matrix{<:Number};
    spin::Bool=false)

    if spin
        for i in 1:projection.projection_up.number_kpoints,
            j in 1:projection.projection_up.number_bands,
            k in 1:projection.projection_up.number_ions
            up_result = matrix[1:5, 1:5] * projection.projection_up.projection[i, j, k, 5:9]
                + matrix[1:5, 6:10] * projection.projection_down.projection[i, j, k, 5:9]
            down_result = matrix[6:10, 1:5] * projection.projection_up.projection[i,j,k,5:9]
                + matrix[6:10, 6:10] * projection.projection_down.projection[i, j, k, 5:9]
            projection.projection_up.projection[i, j, k, 5:9] = up_result
            projection.projection_down.projection[i, j, k, 5:9] = down_result
        end
    end
    return nothing
end
