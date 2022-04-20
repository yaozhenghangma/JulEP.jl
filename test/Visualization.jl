using MatterEnv
using Plots
using Test

@testset "Visualization/band.jl" begin
    bands = BandsWithSpin(2,2)
    kpoints = [KPoint(0.5, [0, 0, 0]), KPoint(0.5, [1.0, 1.0, 1.0])]
    plot(bands, kpoints; critical_points=["Γ"], label="test")
    @test true
end

@testset "Visualization/projection.jl" begin
    projection = ProjectionWithSpin()
    bands = BandsWithSpin(2,2)
    kpoints = [KPoint(0.5, [0, 0, 0]), KPoint(0.5, [1.0, 1.0, 1.0])]
    projection.projection_up.projection_square = ones(1,1,1,9)
    projection.projection_down.projection_square = zeros(1,1,1,9)
    plot(projection, kpoints, bands, ion=1, orbit=7)
    @test true
end

@testset "Visualization/dos.jl" begin
    dos = DOS(Array(-5:0.1:5), Array(0:0.01:1))
    plot(dos, shfit= 3, max = 10)
    @test true
end
