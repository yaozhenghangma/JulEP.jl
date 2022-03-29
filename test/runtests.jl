using MatterEnv
using Test

@testset "POSCAR.jl" begin
    lattice = Lattice([2.0 0.0 0.0; 0.0 2.0 0.0; 0.0 0.0 1.0])
    atom1 = Atom("H", [0.0; 0.0; 0.0])
    atom2 = Atom("H", [1.0; 1.0; 0.5])
    cell = Cell("H2",
            lattice,
            [atom1, atom2],
            [2],
            ["H"])
    save_poscar(cell, "POSCAR1", true)
    save_poscar(cell, "POSCAR2", false)
    cell1 = load_poscar("POSCAR1")
    cell2 = load_poscar("POSCAR2")
    @test cell == cell1
    @test cell == cell2
    @test cell1 == cell2
end
