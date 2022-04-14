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

Generate density of states using bands and kpoints.

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
    dos.energy = Array(range(minimum(bands.energy), maximum(bands.energy), energy_number))
    dos.dos = zeros(energy_number)

    for i in 1:projection.number_kpoints, j in 1:projection.number_bands
        dos.dos += smear.(dos.energy, bands[j].energy[i]) .* kpoints[i].weight
    end

    return dos
end


"""
    generate_dos(bands::BandsWithSpin, kpoints::Array{KPoint, 1};
        smear::Function=gaussian, energy_number::Integer=10000)

Generate density of states using bands and kpoints.

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
    dos2.dos = - dos2.dos
    return dos1, dos2
end
