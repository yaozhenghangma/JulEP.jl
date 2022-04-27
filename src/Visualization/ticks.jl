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

struct tickslength
    l::Real
end

struct xtickslength
    l::Real
end

struct ytickslength
    l::Real
end

RecipesBase.@recipe function ticks_recipe(length::tickslength)
    p = current()
    xticks, yticks = xticks(p)[1][1], yticks(p)[1][1]
    xl, yl = xlims(p), ylims(p)
    x1, y1 = zero(yticks) .+ xl[1], zero(xticks) .+ yl[1]
    sz = p.attr[:size]
    r = sz[1]/sz[2]
    dx, dy = length.l*(xl[2] - xl[1]), length.l*r*(yl[2] - yl[1])
    linecolor --> :black
    label --> nothing
    RecipesBase.@series begin
        return [xticks xticks]', [y1 y1 .+ dy]'
    end

    return [x1 x1 .+ dx]', [yticks yticks]'
end

RecipesBase.@recipe function ticks_recipe(length::xtickslength)
    p = current()
    xticks = xticks(p)[1][1]
    yl = ylims(p)
    y1 = zero(xticks) .+ yl[1]
    dy = length.l*(yl[2] - yl[1])
    linecolor --> :black
    label --> nothing
    return [xticks xticks]', [y1 y1 .+ dy]'
end

RecipesBase.@recipe function ticks_recipe(length::ytickslength)
    p = current()
    yticks = yticks(p)[1][1]
    xl= xlims(p)
    x1= zero(yticks) .+ xl[1]
    dx= length.l*(xl[2] - xl[1])
    linecolor --> :black
    label --> nothing
    return [x1 x1 .+ dx]', [yticks yticks]'
end
