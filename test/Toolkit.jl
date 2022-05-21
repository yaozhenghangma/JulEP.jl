using MatterEnv
using Test

@testset "Toolkit/smear.jl" begin
    @test 6.66448 <= gaussian(0.13, 0.1; σ=0.05) <= 6.66450
    @test 9.5492 <= lorentzian(0.11, 0.1; γ=0.03) <= 9.5494
end

@testset "Toolkit/dos.jl" begin
    bands = Bands(1, 10)
    bands[1].energy = Array(0:0.1:0.9)
    kpoints = [KPoint(0.1, zeros(3)) for _ in 1:10]
    projection = Projection(10, 1, 1,
        Array{ComplexF64, 4}(complex.(zeros(10, 1, 1, 9), zeros(10, 1, 1, 9))),
        Array{Float64, 4}(zeros(10, 1, 1, 9)))
    smear_function(x, x₀) = gaussian(x, x₀; σ=1.0)
    dos = generate_dos(bands, kpoints; smear=smear_function, energy_number=91)
    pdos = generate_dos(bands, kpoints, projection; smear=smear_function, energy_number=91,
        ions=[1], orbits=Array(1:9))
    @test dos.energy == Array(0:0.01:0.9)
    @test pdos.energy == Array(0:0.01:0.9)

    bandsw = BandsWithSpin(bands, bands)
    projectionw = ProjectionWithSpin(projection, projection)
    dos1, dos2 = generate_dos(bandsw, kpoints; smear=smear_function, energy_number=91)
    pdos1, pdos2 = generate_dos(bandsw, kpoints, projectionw; smear=smear_function,
        energy_number=91, ions=[1], orbits=1:9)
    @test dos1.energy == Array(0:0.01:0.9)
    @test pdos1.energy == Array(0:0.01:0.9)
end

@testset "Toolkit/projection.jl" begin
    projection_all = Projection(1,2,1, complex.(zeros(1,2,1,9)), zeros(1,2,1,9))
    projection_all.projection_square[1,1,1,1:9] .= 0.5
    projection_all.projection_square[1,2,1,1:9] .= 0.5
    projection_z = Projection(1,2,1, complex.(zeros(1,2,1,9)), zeros(1,2,1,9))
    projection_z.projection_square[1,1,1,1:9] .= 0.5
    projection_z.projection_square[1,2,1,1:9] .= -0.5
    bands = Bands(2,1)
    projection, bands = distinguish_spin(projection_all, projection_z, bands)
    @test projection.projection_up.projection_square[1,1,1,1] == 0.5
    @test projection.projection_down.projection_square[1,1,1,1] == 0.5
end

@testset "Toolkit/orbit.jl" begin
    projection = ProjectionWithSpin()
    projection.projection_up.projection = complex(ones(1, 1, 1, 9))
    projection.projection_down.projection = complex(ones(1, 1, 1, 9))
    transfer_matrix = [
        1   1   0   0   0
        1   1   0   0   0
        0   0   1   0   0
        0   0   0   1   0
        0   0   0   1   1
    ]
    projection_transformation!(projection, transfer_matrix)
    @test projection.projection_up.projection_square[1, 1, 1, 5] == 4
    @test projection.projection_up.projection_square[1, 1, 1, 6] == 4
    @test projection.projection_up.projection_square[1, 1, 1, 7] == 1
    @test projection.projection_up.projection_square[1, 1, 1, 8] == 1
    @test projection.projection_up.projection_square[1, 1, 1, 9] == 4
end

@testset "Toolkit/band.jl" begin
    bands = BandsWithSpin(10, 10)
    shift_energy!(bands, 1)
    shift_energy!(bands.bands_up, 1)
    shift_energy!(bands.bands_up[1], 1)
    @test bands.bands_up[1].energy[1] == 3
    @test bands.bands_up[2].energy[1] == 2
    @test bands.bands_down[1].energy[1] == 1
end
