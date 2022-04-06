using MatterEnv
using Test

@testset "cell.jl" begin
    lattice1 = Lattice([2.0 0.0 0.0; 0.0 2.0 0.0; 0.0 0.0 1.0])
    lattice2 = Lattice()
    atom1 = Atom("H", [0.0; 0.0; 0.0])
    atom2 = Atom("H", [1.0; 1.0; 0.5])
    cell1 = Cell("H2",
            lattice1,
            [atom1, atom2],
            [2],
            ["H"])
    cell2 = Cell()
    @test cell1 != cell2
    @test atom1 != atom2
    @test lattice1 != lattice2
end

@testset "band.jl" begin
    bands = Bands(5, 10)
    bands_with_spin = BandsWithSpin(5, 10)
    @test bands[1].energy == zeros(10)
    @test bands_with_spin[1][1].occupancy == 0.0
end

@testset "kpoint.jl" begin
    kpoint1 = KPoint()
    kpoint2 = KPoint(0.0, [0.0, 0.0, 0.0])
    @test kpoint1 == kpoint2
end

@testset "projection.jl" begin
    projection1 = Projection()
    projection2 = ProjectionWithSpin()
    @test projection1.projection_square[1, 1, 1, 1] == 0.0
    @test projection2.projection_up.projection[1, 1, 1, 1] == 0.0 + 0.0im
end
