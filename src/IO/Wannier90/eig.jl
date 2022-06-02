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

function load_eig(filename::String, number_bands::Integer, number_kpoints::Integer)
    input = open(filename, "r")

    bands = Bands(number_bands, number_kpoints)
    for i in 1:number_kpoints, j in 1:number_bands
        split_line = split(strip(readline(input)))
        bands.bands[j].energy[i] = parse(Float64, split_line[3])
    end

    close(input)
    return bands
end
