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
    @test atom1() == ("H", [0.0; 0.0; 0.0])
    @test cell1() == ("H2", [2.0 0.0 0.0; 0.0 2.0 0.0; 0.0 0.0 1.0])
    @test cell1.atoms[1] == atom1

    io = IOBuffer()
    show(io, atom1)
    @test String(take!(io)) == "H\t[0.0, 0.0, 0.0]"

    io = IOBuffer()
    show(io, lattice1)
    @test String(take!(io)) == "[2.0, 0.0, 0.0]\n[0.0, 2.0, 0.0]\n[0.0, 0.0, 1.0]"

    io = IOBuffer()
    show(io, cell1)
    @test String(take!(io)) == "H2\n[2.0, 0.0, 0.0]\n[0.0, 2.0, 0.0]\n[0.0, 0.0, 1.0]\n[\"H\
        \"]\n[2]\nH\t[0.0, 0.0, 0.0]\nH\t[1.0, 1.0, 0.5]\n"
end

@testset "band.jl" begin
    bands = Bands(5, 10)
    bands2 = Bands()
    bands[1] = Band(1.0, ones(10))
    bands_with_spin = BandsWithSpin(5, 10)
    bands_with_spin2 = BandsWithSpin()
    bands_with_spin3 = BandsWithSpin(3)
    @test bands[1].energy == ones(10)
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

@testset "dos.jl" begin
    dos1 = DOS()
    dos2 = DOS(ones(10), ones(10))
    @test dos1 != dos2
end
