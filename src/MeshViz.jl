# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module MeshViz

using Meshes
using Tables

using CategoricalArrays: CategoricalValue
using CategoricalArrays: levelcode

using Colors: Colorant, coloralpha
using Colors: distinguishable_colors
using ColorSchemes: colorschemes

import Makie

"""
    viz(object)

Visualize Meshes.jl `object` with various options:

* `size`          - size of points in point set
* `color`         - color of geometries or points
* `alpha`         - transparency channel in [0,1]
* `colorscheme`   - color scheme from ColorSchemes.jl
* `boundarycolor` - color of the boundary (e.g. segments)
* `facetcolor`    - color of the facets (e.g. edges)
* `showboundary`  - tells whether or not to show the boundary
* `showfacets`    - tells whether or not to show the facets
* `variable`      - informs which variable to visualize
* `decimation`    - decimation tolerance for polygons

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
  Makie.Attributes(;
    size          = Makie.theme(scene, :markersize),
    color         = :slategray3,
    alpha         = 1.0,
    colorscheme   = :viridis,
    boundarycolor = :gray30,
    facetcolor    = :gray30,
    showboundary  = true,
    showfacets    = false,
    variable      = nothing,
    decimation    = 0.0,
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

end
