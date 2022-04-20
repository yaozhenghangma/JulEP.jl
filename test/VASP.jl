using MatterEnv
using Test

@testset "VASP/EIGENVAL.jl" begin
    string = """
    1    1    1
    0.4923943E+02  0.3372146E-09  0.3372146E-09  0.1499999E-08  0.5000000E-15
    1.000000000000000E-004
    CAR
   unknown system
    1     1     1

    0.0000000E+00  0.0000000E+00  0.0000000E+00  1.0E+00
    1      -18.772517    -18.604417   1.000000   1.000000
    """
    output = open("test_EIGENVAL", "w")
    write(output, string)
    close(output)
    bands, kpoints = load_eigenval("test_EIGENVAL", true)
    @test bands.bands_up[1].energy[1] == -18.772517
end

@testset "VASP/POSCAR.jl" begin
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

@testset "VASP/PROCAR.jl" begin
    string = """
    PROCAR lm decomposed + phase
    # of k-points:   1         # of bands:   1         # of ions:    3

    k-point     1 :    0.00000000-0.00000000 0.00000000     weight = 0.03333333

    band     1 # energy  -18.77251697 # occ.  1.00000000

    ion      s     py     pz     px    dxy    dyz    dz2    dxz  x2-y2    tot
        1  0.059  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.060
        2  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
        3  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
    tot    0.752  0.000  0.007  0.000  0.000  0.000  0.000  0.000  0.000  0.760
    ion          s             py             pz             px             dxy            dyz            dz2            dxz          dx2-y2
        1 -0.037  0.235  -0.000  0.000  -0.000  0.000   0.000 -0.000  -0.000  0.000   0.000 -0.000   0.002 -0.014   0.000 -0.000   0.000 -0.000   0.057
        2 -0.092  0.581   0.000 -0.000  -0.009  0.058   0.000 -0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.350
        3 -0.092  0.581  -0.000  0.000   0.009 -0.058  -0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.350
    charge 0.749          0.000          0.007          0.000          0.000          0.000          0.000          0.000          0.000          0.756
    """
    output = open("test_PROCAR", "w")
    write(output, string)
    close(output)
    projection, kpoints, bands = load_procar("test_PROCAR")
    save_procar(projection, kpoints, bands, "test_save_PROCAR")
    @test projection.projection[1, 1, 1, 1] == -0.037+0.235im
end

@testset "VASP/PROCAR.jl for noncollinear" begin
    string = """
    PROCAR lm decomposed + phase
    # of k-points:   1         # of bands:   1         # of ions:    3

    k-point     1 :    0.00000000-0.00000000 0.00000000     weight = 0.03333333

    band     1 # energy  -18.77251697 # occ.  1.00000000

    ion      s     py     pz     px    dxy    dyz    dz2    dxz  x2-y2    tot
        1  0.059  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.060
        2  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
        3  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
    tot    0.752  0.000  0.007  0.000  0.000  0.000  0.000  0.000  0.000  0.760
        1  0.059  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.060
        2  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
        3  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
    tot    0.752  0.000  0.007  0.000  0.000  0.000  0.000  0.000  0.000  0.760
        1  0.059  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.060
        2  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
        3  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
    tot    0.752  0.000  0.007  0.000  0.000  0.000  0.000  0.000  0.000  0.760
        1  0.059  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.000  0.060
        2  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
        3  0.346  0.000  0.004  0.000  0.000  0.000  0.000  0.000  0.000  0.350
    tot    0.752  0.000  0.007  0.000  0.000  0.000  0.000  0.000  0.000  0.760
    ion          s             py             pz             px             dxy            dyz            dz2            dxz          dx2-y2
        1 -0.037  0.235  -0.000  0.000  -0.000  0.000   0.000 -0.000  -0.000  0.000   0.000 -0.000   0.002 -0.014   0.000 -0.000   0.000 -0.000   0.057
        2 -0.092  0.581   0.000 -0.000  -0.009  0.058   0.000 -0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.350
        3 -0.092  0.581  -0.000  0.000   0.009 -0.058  -0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.000  0.000   0.350
    charge 0.749          0.000          0.007          0.000          0.000          0.000          0.000          0.000          0.000          0.756
    """
    output = open("test_PROCAR2", "w")
    write(output, string)
    close(output)
    pall, px, py, pz, kpoints, bands = load_procar("test_PROCAR2"; noncollinear=true)
    @test pall.projection[1, 1, 1, 1] == -0.037+0.235im
    @test pall.projection_square[1, 1, 1, 1] == px.projection_square[1, 1, 1, 1] == 0.059
    @test py.projection_square[1, 1, 1, 1] == pz.projection_square[1, 1, 1, 1] == 0.059
end

@testset "VASP/PROOUT.jl" begin
    string = """
    PROOUT
    # of k-points:  1         # of bands:   1         # of ions:    1
       1   1   1
      1.000  1.000  1.000  1.000  1.000  1.000  1.000  1.000  1.000
      0.025336   -0.230682   -0.000000    0.000000    0.000000   -0.000001    0.000000   -0.000000    0.000000
      -0.000001   -0.000000    0.000000   -0.001458    0.013279   -0.000000    0.000000   -0.000000    0.000000
      augmentation part
      -0.005758   -0.000000    0.000000   -0.000000    0.000000    0.000000    0.000030    0.000000    0.000000
    """
    output = open("test_PROOUT", "w")
    write(output, string)
    close(output)
    projection = load_proout("test_PROOUT")
    @test length(projection.projection) == 9
end
