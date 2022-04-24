# [Generate DOS](@id DOSManual)

## DOS
Using metadata of bands and k-points, you can generate DOS with `generate_dos` method.
For bands returned by LDA or GGA calculation, the returned value is one DOS.
For bands returned by LSDA or GGA+Spin calculation, there are two returned DOS to distinguish between major spin and minor spin.
```julia
dos = generate_dos(bands, kpoints; smear=gaussian, energy_number=10000)
dos_up, dos_down = generate_dos(bands, kpoints; smear=gaussian, energy_number=10000)
```
The keyword argument `smear` defines the smearing function to use in generating DOS. The default smearing function is Gaussian function.

The keywork argument `energy_number` defines the number of points of energy value. The default number is 10000.

## Projected DOS
You can generate projected DOS using metadata of projection character, bands and k-points using `generate_dos` method.
```julia
pdos = generate_dos(bands, kpoints, projection; smear=gaussian, energy_number=10000, ions=nothing, orbits=nothing)
pdos_up, pdos_down = generate_dos(bands, kpoints, projection; smear=gaussian, energy_number=10000, ions=nothing, orbits=nothing)
```
The additional keyword argument `ions` defines the index of ions on which the DOS are projected. For example, you can use `ions=1` for single ion,
`ions=1:3` or `ions=[1,2,3]` for multi ions. If a `nothing` is provided, the `generate_dos` method will consider all ions.

The keyword argument `orbits` defines the index of orbits on which the DOS are projected. The format is the same as `ions`'s.

## Smearing Function
There are two smearing function available now.

- Gaussian distribution
- Cauchy-Lorentz distribution

See [API part](@ref SmearAPI) for more details.

For example, if you want a Gaussian distribution with standard deviation being 0.01 to generate a DOS. You can write the code as
```julia
smear(x, x₀) = gaussian(x, x₀; σ=0.01)
dos = generate_dos(bands, kpoints; smear=smear)
```

And you can define a new smearing function to generate DOS. For example
```julia
function my_smear(x, x₀)
    return (abs(x - x₀) + 0.01)^(-1)
end
dos = generate_dos(bands, kpoints; smear=my_smear)
```