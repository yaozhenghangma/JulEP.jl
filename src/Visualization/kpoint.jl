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

function index_kpoints(kpoints)
    index = Array{Int, 1}([])
    ind = 1
    for i in 1:length(kpoints)-1
        push!(index, ind)
        if kpoints[i] != kpoints[i+1]
            ind += 1
        end
    end
    push!(index, ind)
    return index, ind
end

function kpath_distance(kpoints)
    distance = Array{Float64, 1}([0.0])
    critical_point_index = Array{Float64, 1}([0.0])
    for i in 2:length(kpoints)
        push!(distance, norm(kpoints[i].coordinate-kpoints[i-1].coordinate) + distance[i-1])
        if kpoints[i] == kpoints[i-1]
            push!(critical_point_index, distance[i])
        end
    end
    push!(critical_point_index, distance[i])
    return distance, critical_point_index
end
