# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module MeshViz

using Meshes
using Tables

using CategoricalArrays: CategoricalValue
using CategoricalArrays: levelcode

import Makie

"""
    viz(object)

Visualize Meshes.jl `object` with various options:

* `size`          - size of points in point set
* `color`         - color of geometries or points
* `colormap`      - colormap used for colors
* `boundarycolor` - color of the boundary (e.g. segments)
* `facetcolor`    - color of the facets (e.g. edges)
* `showboundary`  - tells whether or not to show the boundary
* `showfacets`    - tells whether or not to show the facets
* `variable`      - informs which variable to visualize
* `decimation`    - decimation tolerance for polygons
"""
@Makie.recipe(Viz, object) do scene
  Makie.Attributes(;
    size          = Makie.theme(scene, :markersize),
    color         = :slategray3,
    colormap      = :viridis,
    boundarycolor = :gray30,
    facetcolor    = :gray30,
    showboundary  = true,
    showfacets    = false,
    variable      = nothing,
    decimation    = 0.0,
  )
end

# domain
include("simplemesh.jl")
include("cartesiangrid.jl")
include("collection.jl")
include("fallbacks.jl")

# data
include("data.jl")

end
