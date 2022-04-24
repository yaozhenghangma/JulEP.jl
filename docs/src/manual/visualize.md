# [Visualization](@id VisualizeManual)

We have defined Plots recipes for band structure, projection character and DOS. The visualization can be done
by a unitary API provided by Plots.

## [Band Structure](@id VisualizeBandManual)

### Band structure for LDA
Since LDA or GGA calculation doesn't distinguish between major and minor spin, the type of band structure is `Bands`.
(You can check the data type using `typeof` method.) The `Bands` type can be visualized by
```julia
plot!(band, kpoints; critical_points = nothing)
```
You can set keyword argument `critical_points` to be an array of all critical points in k points, for example `["Γ", "M", "K", "Γ"]`. You can also
add other keyword arguments provided by Plots to change the style of the figure.

### Band structure for LSDA
For LSDA or GGA+Spin calculation, spins are labeled as major spin or minor spin. The type of band structure is `BandsWithSpin` and can be visualized by
```julia
plot!(bands, kpoints; critical_points = nothing, colorlist = [:black, :gray], stylelist = [:solid, :dash])
```
The additional keyword arguments `colorlist` and `stylelist` define the color and line style of band structure of major and minor spin.
The default values are black solid line for major spin and gray dash line for minor spin.

## [Projected Band Structure](@id VisualizePBandManual)
After plotting band structure, you can visualize projection character on these bands.
```julia
plot!(projection, kpoints, bands; ion=nothing, orbit=nothing, tolerance=0, max_size=5, magnify=10)
```
You need provide metadata of projection, kpoints and bands to draw this figure. There are 5 additional keyword arguments:
- `ion`: index of ion on which wavefunction is projected, for example `ions=1` for first ion
- `orbit`: index of orbit on which wavefunction is projected. The format is the same as `ion`'s.
- `tolerance`: points with projection character value below `tolerance` will not be plotted, default 0.
- `max_size`: maximum marker size of these points, default 5.
- `magnify`: marker_size = magnify * projection_character, default 10.

## [DOS](@id VisualizeDOSManual)
After generating DOS using [`generate_dos`](@ref DOSManual) method, you can use plot function to visualize it.
```julia
plot!(dos; shift = 0, max = 1, stretch_ratio = 1)
```
The `shift` arguments will shift all dos value. Default shift is 0.

The `max` argument will set maximum value of showed dos value. Default maximum is 1.

The `stretch_ratio` argument will set the ratio to stretch in y axis to beautify the graph.