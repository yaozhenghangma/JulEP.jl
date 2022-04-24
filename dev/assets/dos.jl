using MatterEnv
using Plots
using LaTeXStrings

# load metadata from PROCAR
projection_all, _, _, projection_z, kpoints, bands = load_procar("PROCAR"; noncollinear=true)

# set Fermi energy to be zero
fermi_energy =  -3.0009
shift_energy!(bands, -fermi_energy)

# linear transformation for projected wave function
transformation_matrix1 =
[
    -1/√3   √2/√3   0       0       0;
    √2/√3   1/√3    0       0       0;
    0       0       1       0       0;
    0       0       0       √2/√3   1/√3;
    0       0       0       -1/√3   √2/√3;
]
transformation_matrix2 =
[
    1       0       0       0       0;
    0       1/√2    0       0       1/√2im;
    0       0       1       0       0;
    0       0       0       1       0;
    0       1/√2    0       0       -1/√2im;
]
projection_transformation!(projection_all, transformation_matrix1, transformation_matrix2)

# distinguish spin up and spin down, using the sign of projected wave function character
projection, bands = distinguish_spin(projection_all, projection_z, bands)

# generate projected dos using Gaussian smearing method
smear(x, x₀) = gaussian(x, x₀; σ=0.05)
pdos_up_0, pdos_down_0 = generate_dos(bands, kpoints, projection; smear=smear, ions=[2], orbits=[2,3,4])
pdos_up_1, pdos_down_1 = generate_dos(bands, kpoints, projection; smear=smear, ions=[1], orbits=[7])
pdos_up_2, pdos_down_2 = generate_dos(bands, kpoints, projection; smear=smear, ions=[1], orbits=[5, 8])
pdos_up_3, pdos_down_3 = generate_dos(bands, kpoints, projection; smear=smear, ions=[1], orbits=[6])
pdos_up_4, pdos_down_4 = generate_dos(bands, kpoints, projection; smear=smear, ions=[1], orbits=[9])

# some basic setting for the figure
plot(
    dpi = 300,
    size = (800, 600),
    framestyle = :box,
    fontfamily = "Times Roman",
    ylabel = "DOS (states/eV)",
    xlabel = "Energy (eV)",
    guidefontsize = 25,
    ylim = (0, 20),
    xlim = (-6.0, 6.0),
    legend = false,
    yticks = (0:4:20, ["0", "2", "4", "4", "4", "4"]),
    grid = :y,
    gridstyle = :solid,
    tick_direction = :in,
    tickfontsize = 23,
    bottom_margin = 1.2Plots.cm,
    left_margin = 1.0Plots.cm,
)

# plot projected dos, blue line for spin up and red line for spin down
plot!(pdos_up_0; shift = 0, max = 2, stretch_ratio = 2, linecolor = :blue)
plot!(pdos_up_1; shift = 4, max = 4, linecolor = :blue)
plot!(pdos_up_2; shift = 8, max = 4, linecolor = :blue)
plot!(pdos_up_3; shift = 12, max = 4, linecolor = :blue)
plot!(pdos_up_4; shift = 16, max = 4,linecolor = :blue)
plot!(pdos_down_0; shift = 0, max = 2, stretch_ratio = 2,linecolor = :red)
plot!(pdos_down_1; shift = 4, max = 4, linecolor = :red)
plot!(pdos_down_2; shift = 8, max = 4, linecolor = :red)
plot!(pdos_down_3; shift = 12, max = 4, linecolor = :red)
plot!(pdos_down_4; shift = 16, max = 4, linecolor = :red)

# annotation
annotate!(5, 2, (L"3p", 23))
annotate!(5, 6, (L"a_{1g}", 23))
annotate!(5, 10, (L"e_{g}^{\sigma}", 23))
annotate!(5, 14, (L"L_{z-}", 23))
annotate!(5, 18, (L"L_{z+}", 23))

# grid line
plot!([-6, 6], [4, 4], linecolor = :black)
plot!([-6, 6], [8, 8], linecolor = :black)
plot!([-6, 6], [12, 12], linecolor = :black)
plot!([-6, 6], [16, 16], linecolor = :black)
plot!([0, 0], [0, 20], linecolor = :black, linestyle = :dash)

savefig("dos.png")
