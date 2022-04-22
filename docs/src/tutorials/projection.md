# [Projected Wave Function Character](@id ProjectionTutorial)

The spd projected wave function character produced by VASP with `lorbit=12` tag can be used to
produce projected wave function character on arbitrary orbit, through a linear transformation.

For example, under trigonal crystal field, the degenerate d orbits split into $e_g^\sigma$, $e_g^\pi$ and
$a_{1g}$ orbits. In local coordinate $x\prime y\prime z\prime$, these orbits have the following form:

$\begin{aligned}
&\left|e_{g_{1}}^{\sigma}\right\rangle=\sqrt{\frac{1}{3}}\left|x^{\prime 2}-y^{\prime 2}\right\rangle+\sqrt{\frac{2}{3}}\left|x^{\prime} z^{\prime}\right\rangle \\
&\left|e_{g_{1}}^{\pi}\right\rangle=\sqrt{\frac{2}{3}}\left|x^{\prime 2}-y^{\prime 2}\right\rangle-\sqrt{\frac{1}{3}}\left|x^{\prime} z^{\prime}\right\rangle \\
&\left|e_{g_{2}}^{\sigma}\right\rangle=\sqrt{\frac{2}{3}}\left|y^{\prime} z^{\prime}\right\rangle-\sqrt{\frac{1}{3}}\left|x^{\prime} y^{\prime}\right\rangle \\
&\left|e_{g_{2}}^{\pi}\right\rangle=\sqrt{\frac{1}{3}}\left|y^{\prime} z^{\prime}\right\rangle+\sqrt{\frac{2}{3}}\left|x^{\prime} y^{\prime}\right\rangle \\
&\left|a_{1 g}\right\rangle=\left|3 z^{\prime 2}-r^{\prime 2}\right\rangle
\end{aligned}$

Considering the order of d orbits in PROCAR file, we can define the transformation matrix as

```julia
transformation_matrix =
[
    -1/√3   √2/√3   0       0       0;
    √2/√3   1/√3    0       0       0;
    0       0       1       0       0;
    0       0       0       √2/√3   1/√3;
    0       0       0       -1/√3   √2/√3;
]
```

and do the transformation on the projection read from PROCAR

```julia
using MatterEnv

projection, kpoints, bands = load_procar("PROCAR"; spin=true, noncollinear=false)
projection_transformation!(projection, transformation_matrix)
```

After transformation, in projection object the index 5 6 7 8 9 represent orbits $e_{g2}^\sigma$ $e_{g2}^\pi$ $a_{1g}$ $e_{g1}^\sigma$ $e_{g1}^\pi$ respectively.