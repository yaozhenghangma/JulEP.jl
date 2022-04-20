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
    dos_recipe(dos::DOS; shift = 0, max = 1)

Plots recipe for dos.

# Arguments
- `dos::DOS`: metadata of dos
- `shift=0`: shift of dos value, default 0
- `max=1`: maximum value of dos value, default 1
"""
RecipesBase.@recipe function dos_recipe(dos::DOS; shift = 0, max = 1)
    tmp_dos = deepcopy(dos)
    for i in 1:length(tmp_dos.dos)
        if tmp_dos.dos[i] > max
            tmp_dos.dos[i] = max + shift
        else
            tmp_dos.dos[i] += shift
        end
    end

    line --> :blue
    label --> nothing
    return tmp_dos.energy, tmp_dos.dos
end
