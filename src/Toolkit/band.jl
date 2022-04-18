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
    shift_energy!(band::Band, energy::Real)

Shift the energy value of band with given energy value.

# Arguments
- `band::Band`: metadata of band
- `energy::Real`: shift value
"""
function shift_energy!(band::Band, energy::Real)
    @. band.energy += energy
    return nothing
end


@doc raw"""
    shift_energy!(bands::Bands, energy::Real)

Shift the energy value of all bands with given energy value.

# Arguments
- `bands::Bands`: metadata of band
- `energy::Real`: shift value
"""
function shift_energy!(bands::Bands, energy::Real)
    for band in bands
        shift_energy!(band, energy)
    end
    return nothing
end


@doc raw"""
    shift_energy!(bands::BandsWithSpin, energy::Real)

Shift the energy value of all bands with given energy value.

# Arguments
- `bands::BandsWithSpin`: metadata of band
- `energy::Real`: shift value
"""
function shift_energy!(bands::BandsWithSpin, energy::Real)
    shift_energy!(bands.bands_up, energy)
    shift_energy!(bands.bands_down, energy)
    return nothing
end
