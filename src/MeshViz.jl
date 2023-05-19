# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module MeshViz

using Meshes
using Tables

using ScientificTypes

using CategoricalArrays: CategoricalValue
using CategoricalArrays: levelcode

using Colors: Colorant
using Colors: protanopic, coloralpha
using Colors: distinguishable_colors
using ColorSchemes: colorschemes

import Makie

"""
    Aes(attr1=val1, attr2=val2, ...)

Defines aesthetic plot attributes of geometries.

Aesthetic attributes:
* `points` - show points
* `pointsize` - size of points
* `pointcolor` - color of points
* `segments` - show segments
* `segmentsize` - size (or "width") of segments
* `segmentcolor` - color of segments
"""
Base.@kwdef struct Aes
  points::Makie.Observable{Bool} = false
  pointsize::Makie.Observable{Float64} = 12
  pointcolor::Makie.Observable{Symbol} = :gray30
  segments::Makie.Observable{Bool} = false
  segmentsize::Makie.Observable{Float64} = 1.5
  segmentcolor::Makie.Observable{Symbol} = :gray30
end

"""
    viz(object)

Visualize Meshes.jl `object` with various options:

* `color`       - color of geometries or points
* `alpha`       - transparency channel in [0,1]
* `colorscheme` - color scheme from ColorSchemes.jl
* `aes`         - aesthetic attributes

The option `color` can be a single scalar or a vector
of scalars. For meshes, the length of the vector of
colors determines if the colors should be assigned to
vertices or elements.

## Examples

```julia
# vertex coloring (i.e. linear interpolation)
viz(mesh, color = 1:nvertices(mesh))

# element coloring (i.e. discrete colors)
viz(mesh, color = 1:nelements(mesh))
```
"""
Makie.@recipe(Viz, object) do scene
  Makie.Attributes(; color=:slategray3, alpha=1.0, colorscheme=nothing, aes=Aes())
end

# color handling
include("colors.jl")

# utilities
include("utils.jl")

# domain
include("simplemesh.jl")
include("cartesiangrid.jl")
include("collection.jl")
include("partition.jl")
include("fallbacks.jl")
include("optimized.jl")

# data
include("data.jl")

export Aes
export viewer

end
