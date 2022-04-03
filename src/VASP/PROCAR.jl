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

using Printf

include("../Atomic/kpoint.jl")
include("../Atomic/band.jl")
include("../Atomic/projection.jl")

function read_weight!(input, pro, phase)
    for i in 1:pro.number_kpoints
        readline(input)     #blank line
        split_line = split(strip(readline(input)))      #kpoint: coordinate and weight
        push!(pro.kpoints, KPoint(0.0, Array{Float64, 1}([0.0; 0.0; 0.0])))
        pro.kpoints[i].coordinate[1] = parse(Float64, split_line[4])
        pro.kpoints[i].coordinate[2] = parse(Float64, split_line[5])
        pro.kpoints[i].coordinate[3] = parse(Float64, split_line[6])
        pro.kpoints[i].weight = parse(Float64, split_line[9])
        readline(input)     #blank line
        for j in 1:pro.number_bands
            split_line = split(strip(readline(input)))     #band
            pro.bands[j].energy[i] = parse(Float64, split_line[5])
            pro.bands[j].occupancy = parse(Float64, split_line[8])
            readline(input)     #blank line
            readline(input)     #orbit
            for k in 1:pro.number_ions
                split_line = parse.(Float64, split(strip(readline(input))))     #projection
                pro.projection_square[i, j, k, 1:9] = split_line[2:10]
            end
            readline(input)     #sum of projection over ions
            if phase
                readline(input)     #orbit
                for k in 1:pro.number_ions
                    split_line = parse.(Float64, split(strip(readline(input))))  #projection
                    for l in 1:9
                        pro.projection[i, j, k, l] =
                            complex(split_line[2*l], split_line[2*l+1])
                    end
                end
                readline(input)     #sum over ions
            end
            readline(input)     #blank line
        end
    end
    return nothing
end


function allocate_space!(input, pro, phase)
    split_line = split(strip(readline(input)))      #k-points, bands and ions
    pro.number_kpoints = parse(Int32, split_line[4])
    pro.number_bands = parse(Int32, split_line[8])
    pro.number_ions = parse(Int32, split_line[12])
    if phase
        pro.projection = Array{ComplexF64, 4}(
            complex.(zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9),
            zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9)))
        pro.projection_square = Array{Float64, 4}(
            zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9))
    else
        pro.projection_square = Array{Float64, 4}(
            zeros(pro.number_kpoints, pro.number_bands, pro.number_ions, 9))
    end
    for j in 1:pro.number_bands
        push!(pro.bands, Band(0.0, Array{Float64, 1}(zeros(pro.number_kpoints))))
    end
    return nothing
end


"""
    load_procar(filename::String="PROCAR") -> Projection

Load projection of wave function ⟨Yₗₘ|ϕₙₖ⟩ from PROCAR file.

# Arguments
- `filename::String="PROCAR"`: name of input file
- `spin::Bool=false`: distingush spin up and spin down or not

# Returns
- `Projection`: Projection of wave function ⟨Yₗₘ|ϕₙₖ⟩
"""
function load_procar(filename::String="PROCAR", spin::Bool=false)
    input = open(filename, "r");

    phase = false
    split_line = split(strip(readline(input)))      #comment line
    for word in split_line
        if word == "phase"
            phase = true
            break
        end
    end

    if spin
        pro = ProjectionWithSpin()
        allocate_space!(input, pro.projection_up, phase)
        read_weight!(input, pro.projection_up, phase)
        readline(input)     #blank line
        allocate_space!(input, pro.projection_down, phase)
        read_weight!(input, pro.projection_down, phase)
    else
        pro = Projection()
        allocate_space!(input, pro, phase)
        read_weight!(input, pro, phase)
    end

    close(input)
    return pro
end


function write_projection(output, pro, squared_only)
    write(output, "$(@sprintf("# of k-points:\t%d\t# of bands:\t%d\t# of ions:\t%d\n",
        projection.number_kpoints,
        projection.number_bands,
        projection.number_ions))")

    for i in 1:projection.number_kpoints
        write(output, "$(@sprintf("\n k-point\t%d :\t%.7f %.7f %.7f\tweight = %.7f\n",
            i,
            projection.kpoints[i].coordinate[1],
            projection.kpoints[i].coordinate[2],
            projection.kpoints[i].coordinate[3],
            projection.kpoints[i].weight))")
        for j in 1:projection.number_bands
            write(output, "$(@sprintf("\nband\t%d # energy\t%.7f # occ.\t%.7f\n",
                j,
                projection.bands[j].energy[i],
                projection.bands[j].occupancy))")
            write(output, "\nion\t\ts\tpy\tpz\tpx\tdxy\tdyz\tdz2\tdxz\tx2-y2\ttot\n")
            for k in 1:projection.number_ions
                write(output, "$(@sprintf("\t%d\t", k))")
                for l in 1:9
                    write(output, "$(@sprintf("%.3f\t",
                        projection.projection_square[i, j, k, l]))")
                end
                write(output, "$(@sprintf("%.3f\n",
                    sum(projection.projection_square[i, j, k, :])))")
            end
            write(output, "tot\t\t")
            for l in 1:9
                write(output,"$(@sprintf("%.3f\t",
                    sum(projection.projection_square[i, j, :, l])))")
            end
            write(output, "$(@sprintf("%.3f\n",
                sum(projection.projection_square[i, j, :, :])))")
            #todo: write projection
        end
    end
    return nothing
end


"""
    save_procar(projection::Projection,
        filename::String="PROCAR";
        squared_only::Bool=true)
        output = open(filename, "w")

Save projection of wave function ⟨Yₗₘ|ϕₙₖ⟩ into PROCAR file.

# Arguments
- `projection::AbstractProjection`: projection of wave function
- `filename::String="PROCAR"`: name of output file
- `squared_only::Bool=true`: only output squared projection |⟨Yₗₘ|ϕₙₖ⟩|² or not
"""
function save_procar(projection::AbstractProjection,
    filename::String="PROCAR";
    squared_only::Bool=true)
    output = open(filename, "w")

    write(output, "PROCAR ", squared_only ? "lm decomposed\n" : "lm decomposed + phse\n")

    if typeof(projection) == ProjectionWithSpin
        write_projection(output, projection.projection_up, squared_only)
        write(output, "\n")     #blank line
        write_projection(output, projection.projection_down, squared_only)
    else
        write_projection(output, projection, squared_only)
    end

    close(output)
    return nothing
end
