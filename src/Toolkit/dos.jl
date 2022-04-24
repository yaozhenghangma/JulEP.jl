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
    generate_dos(bands::Bands, kpoints::Array{KPoint, 1};
        smear::Function=gaussian, energy_number::Integer=10000)

Generate electronic density of states using bands and kpoints.

# Arguments
- `bands::Bands`: metadata of bands
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `smear::Function=gaussian`: smearing function, default: Gaussian smear
- `energy_number::Integer=10000`: number of energy points, default 10000

# Returns
- `dos::DOS`: metadata of dos
"""
function generate_dos(bands::Bands, kpoints::Array{KPoint, 1};
    smear::Function=gaussian, energy_number::Integer=10000)

    dos = DOS()
    energy = hcat([band.energy for band in bands]...)
    dos.energy = Array(range(minimum(energy), maximum(energy), energy_number))
    dos.dos = zeros(energy_number)

    number_kpoints = length(kpoints)
    number_bands = length(bands)

    for i in 1:number_kpoints, j in 1:number_bands
        dos.dos += smear.(dos.energy, bands[j].energy[i]) .* kpoints[i].weight
    end

    return dos
end


"""
    generate_dos(bands::BandsWithSpin, kpoints::Array{KPoint, 1};
        smear::Function=gaussian, energy_number::Integer=10000)

Generate electronic density of states using bands and kpoints.

# Arguments
- `bands::BandsWithSpin`: metadata of bands
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `smear::Function=gaussian`: smearing function, default: Gaussian smear
- `energy_number::Integer=10000`: number of energy points, default 10000

# Returns
- `dos1::DOS`: metadata of dos of spin up
- `dos2::DOS`: metadata of dos of spin down
"""
function generate_dos(bands::BandsWithSpin, kpoints::Array{KPoint, 1};
    smear::Function=gaussian, energy_number::Integer=10000)
    dos1 = generate_dos(bands.bands_up, kpoints; smear=smear, energy_number=energy_number)
    dos2 = generate_dos(bands.bands_down, kpoints; smear=smear, energy_number=energy_number)
    return dos1, dos2
end


"""
    generate_dos(bands::Bands, kpoints::Array{KPoint, 1},
        projection::Projection;
        smear::Function=gaussian, energy_number::Integer=10000,
        ions::Array{Integer, 1}=nothing, orbits::Array{Integer, 1}=nothing)

Generate projected electronic density of states using bands and kpoints.

# Arguments
- `bands::Bands`: metadata of bands
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `projection::Projection`: metadata of projection
- `smear::Function=gaussian`: smearing function, default: Gaussian smear
- `energy_number::Integer=10000`: number of energy points, default 10000
- `ions::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing`:
    index of ions which wavefunction is projected to
- `orbits::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing`:
    index of orbitss which wavefunction is projected to

# Returns
- `pdos::DOS`: metadata of projected dos
"""
function generate_dos(bands::Bands, kpoints::Array{KPoint, 1},
    projection::Projection;
    smear::Function=gaussian, energy_number::Integer=10000,
    ions::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing,
    orbits::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing)

    if ions === nothing
        ions = 1:projection.number_ions
    end

    if orbits === nothing
        orbits = 1:9
    end

    pdos = DOS()
    energy = hcat([band.energy for band in bands]...)
    pdos.energy = Array(range(minimum(energy), maximum(energy), energy_number))
    pdos.dos = zeros(energy_number)

    select_projection = projection.projection_square[:, :, ions, orbits]
    sum_select = dropdims(sum(select_projection, dims=(3, 4)), dims=(3, 4))

    for i in 1:projection.number_kpoints, j in 1:projection.number_bands
        pdos.dos +=
            smear.(pdos.energy, bands[j].energy[i]) .* kpoints[i].weight .* sum_select[i, j]
    end

    return pdos
end


"""
    generate_dos(bands::Bands, kpoints::Array{KPoint, 1},
        projection::Projection;
        smear::Function=gaussian, energy_number::Integer=10000,
        ions::Array{Integer, 1}=nothing, orbits::Array{Integer, 1}=nothing)

Generate projected electronic density of states using bands and kpoints.

# Arguments
- `bands::BandsWithSpin`: metadata of bands
- `kpoints::Array{KPoint, 1}`: metadata of k-points
- `projection::ProjectionWithSpin`: metadata of projection
- `smear::Function=gaussian`: smearing function, default: Gaussian smear
- `energy_number::Integer=10000`: number of energy points, default 10000
- `ions::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing`:
    index of ions which wavefunction is projected to
- `orbits::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing`:
    index of orbitss which wavefunction is projected to

# Returns
- `pdos1::DOS`: metadata of projected dos of spin up
- `pdos2::DOS`: metadata of projected dos of spin down
"""
function generate_dos(bands::BandsWithSpin, kpoints::Array{KPoint, 1},
    projection::ProjectionWithSpin;
    smear::Function=gaussian, energy_number::Integer=10000,
    ions::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing,
    orbits::Union{Array{<:Integer, 1}, UnitRange{<:Integer}, Nothing}=nothing)

    pdos1 = generate_dos(bands.bands_up, kpoints, projection.projection_up;
        smear=smear, energy_number=energy_number, ions=ions, orbits=orbits)
    pdos2 = generate_dos(bands.bands_down, kpoints, projection.projection_down;
        smear=smear, energy_number=energy_number, ions=ions, orbits=orbits)
    return pdos1, pdos2
end
