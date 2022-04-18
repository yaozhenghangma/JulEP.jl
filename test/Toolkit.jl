using MatterEnv
using Test

@testset "smear.jl" begin
    @test 6.66448 <= gaussian(0.13, 0.1; σ=0.05) <= 6.66450
    @test 9.5492 <= lorentzian(0.11, 0.1; γ=0.03) <= 9.5494
end

@testset "dos.jl" begin
    bands = Bands(1, 10)
    bands[1].energy = Array(0:0.1:0.9)
    kpoints = [KPoint(0.1, zeros(3)) for _ in 1:10]
    projection = Projection(10, 1, 1,
        Array{ComplexF64, 4}(complex.(zeros(10, 1, 1, 9), zeros(10, 1, 1, 9))),
        Array{Float64, 4}(zeros(10, 1, 1, 9)))
    smear_function(x, x₀) = gaussian(x, x₀; σ=1.0)
    dos = generate_dos(bands, kpoints; smear=smear_function, energy_number=91)
    pdos = generate_pdos(bands, kpoints, projection; smear=smear_function, energy_number=91,
        ions=[1], orbits=Array(1:9))
    @test dos.energy == Array(0:0.01:0.9)
    @test pdos.energy == Array(0:0.01:0.9)

    bandsw = BandsWithSpin(bands, bands)
    projectionw = ProjectionWithSpin(projection, projection)
    dos1, dos2 = generate_dos(bandsw, kpoints; smear=smear_function, energy_number=91)
    pdos1, pdos2 = generate_pdos(bandsw, kpoints, projectionw; smear=smear_function,
        energy_number=91, ions=[1], orbits=Array(1:9))
    @test dos1.energy == Array(0:0.01:0.9)
    @test pdos1.energy == Array(0:0.01:0.9)
end

@testset "projection.jl" begin
    projection_all = Projection()
    projection_all.projection_square[1,1,1,1] = 0.5
    projection_z = Projection()
    projection_z.projection_square[1,1,1,1] = - 0.2
    sign_matrix = get_projection_sign(projection_z)
    new_projection_all = apply_projection_sign(projection_all, sign_matrix)
    @test sign_matrix[1,1,1,1] == -1
    @test new_projection_all.projection_square[1,1,1,1] == -0.5
end
