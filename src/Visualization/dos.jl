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
    plot!(dos::DOS; line=(:blue), shift::Real=0, max::Real=1)

Plot dos on current figure.

# Arguments
- `dos::DOS`: metadata of dos
- `line = (:blue)`: style of line (see document of Plots.jl)
- `shift::Real=0`: shift of dos value, default 0
- `max::Real=1`: maximum value of dos value, default 1
"""
function plot!(dos::DOS; line=(:blue), shift::Real=0, max::Real=1)
    tmp_dos = deepcopy(dos)
    for i in 1:length(tmp_dos.dos)
        if tmp_dos.dos[i] > max
            tmp_dos.dos[i] = max + shift
        else
            tmp_dos.dos[i] += shift
        end
    end
    Plots.plot!(tmp_dos.energy, tmp_dos.dos, line=line)
    Plots.plot!([tmp_dos.energy[1], tmp_dos.energy[end]], [max, max], line=(:black))
    Plots.plot!([0, 0], [shift, shift+max], line=(:black, :dash))
    return nothing
end


@doc raw"""
    plot!(dos::DOS...; line=(:blue), shift::Real=0, max::Real=1)

Plot dos on current figure.

# Arguments
- `dos::DOS...`: metadata of dos
- `line = (:blue)`: style of line (see document of Plots.jl)
- `shift::Real=0`: shift of dos value, default 0
- `max::Real=1`: maximum value of dos value, default 1
"""
function plot!(dos::DOS...; line=(:blue), shift::Real=0, max::Real=1)
    i = 0
    for d in dos
        plot!(d; line=line, shift=shift+i*max, max=max)
        i += 1
    end
    return nothing
end
