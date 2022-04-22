# [VASP file I/O](@id VASPManual)

We have provided methods to load:

- POSCAR
- PROCAR
- PROOUT
- EIGENVAL

## [POSCAR](@id POSCARManual)


## [PROCAR](@id PROCARManual)

For normal LDA or GGA calculation, you can load PROCAR file using `load_procar` function without any keyword arguments.
And there are three values are returned, representing metadata of projection characters, bands and k-points, respectively.
```julia
projection, bands, kpoints = load_procar("PROCAR")
```

For LSDA or GGA+Spin calculation, you need set the keyword argument `spin` to be `true`.
And the returned values are still divided into these three pars.
```julia
projection, bands, kpoints = load_procar("PROCAR"; spin = true)
```

For non-collinear calculation, you need set the keyword argument `noncollinear` to be `true`.
The returned values are divided into five parts, representing total projection characters, projection characters of x-axis,
projection characters of y-axis, projection characters of z-axis, bands and k-points, respectively.
```julia
projection_all, projection_x, projection_y, projection_z, bands, kpoints =
    load_procar("PROCAR"; noncollinear = true)
```