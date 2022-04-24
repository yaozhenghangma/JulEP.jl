# [VASP file I/O](@id VASPManual)

We have provided methods to load:

- POSCAR
- PROCAR
- PROOUT
- EIGENVAL

## [POSCAR](@id POSCARManual)


## [PROCAR](@id PROCARManual)

### PROCAR for LDA
For normal LDA or GGA calculation, you can load PROCAR file using `load_procar` function without any keyword arguments.
And there are three values are returned, representing metadata of projection characters, k-points and bands, respectively.
```julia
projection, kpoints, bands = load_procar("PROCAR")
```

### PROCAR for LSDA
For LSDA or GGA+Spin calculation, you need set the keyword argument `spin` to be `true`.
And the returned values are still divided into these three parts.
```julia
projection, kpoints, bands= load_procar("PROCAR"; spin = true)
```

### PROCAR for non-collinear calculation
For non-collinear calculation, you need set the keyword argument `noncollinear` to be `true`.
The returned values are divided into five parts, representing total projection characters, projection characters of x-axis,
projection characters of y-axis, projection characters of z-axis, k-points and bands, respectively.
```julia
projection_all, projection_x, projection_y, projection_z, kpoints, bands =
    load_procar("PROCAR"; noncollinear = true)
```

### [Trick to distinguish between major spin and minor spin](@id TrickManual)
In addition, non-collinear calculation in VASP doesn't distinguish between major and minor spin. But you can use a calculation trick
to distinguish between spins. For example, you can set the spin quantization axis to be z axis using `SAXIS` tag. Then, the only nonzero
projection character value is `projection_all` and `projection_z`. For negative projection character value, the spin is minor spin, otherwise
the spin is major spin. And we have defined a method `distinguish_spin` to do this job.
```julia
projection, bands = distinguish_spin(projection_all, projection_z, bands)
```
The metadata of projection character and band of major spin and minor spin have been stored in `projection` and `bands` with `ProjectionWithSpin` and
`BandsWithSpin` data type respectively.