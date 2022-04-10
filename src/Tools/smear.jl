#   Copyright (C) 2022  Yaozhenghang Ma
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

@doc raw"""
    gaussian(x::Real, x₀::Real; σ::Real = 0.05)

Gaussian function: ``g(x, x_0; \sigma)=\frac{1}{\sigma \sqrt{2 \pi}} \exp \left(-\frac{1}{2}
    \frac{(x-x_0)^{2}}{\sigma^{2}}\right)``.
"""
function gaussian(x::Real, x₀::Real; σ::Real = 0.05)
    return 1.0/sqrt(2π * σ) * exp(-(x-x₀)^2 / (2σ^2))
end


@doc raw"""
    lorentzian(x::Real, x₀::Real; γ::Real = 0.03)

Lorentzian function: ``f\left(x, x_{0}; \gamma\right) =\frac{1}{\pi \gamma}
    \left[\frac{\gamma^{2}}{\left(x-x_{0}\right)^{2}+\gamma^{2}}\right]``
"""
function lorentzian(x::Real, x₀::Real; γ::Real = 0.03)
    return γ / π / ((x-x₀)^2 - γ^2)
end
