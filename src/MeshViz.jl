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
    viz(object)

Visualize Meshes.jl `object` with various options:

* `color`       - color of geometries or points
* `alpha`       - transparency channel in [0,1]
* `colorscheme` - color scheme from ColorSchemes.jl
* `facetcolor`  - color of the facets (e.g. edges)
* `showfacets`  - tells whether or not to show the facets
* `pointsize`   - size of points in point set
* `segmentsize` - size (or width) of segments

The option `color` can be a single scalar or a vector
of scalars. For meshes, the length of the vector of
colors determines if the colors should be assigned to
vertices or elements.

## Examples

```
# vertex coloring (i.e. linear interpolation)
viz(mesh, color = 1:nvertices(mesh))

# element coloring (i.e. discrete colors)
viz(mesh, color = 1:nelements(mesh))
```
"""
@Makie.recipe(Viz, object) do scene
  Makie.Attributes(
    color       = :slategray3,
    alpha       = 1.0,
    colorscheme = nothing,
    facetcolor  = :gray30,
    showfacets  = false,
    pointsize   = 12,
    segmentsize = 1.5
  )
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

export viewer

end
