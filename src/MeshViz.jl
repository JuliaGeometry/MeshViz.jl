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

* `elementcolor`  - color of the elements (e.g. triangles)
* `boundarycolor` - color of the boundary (e.g. segments)
* `facetcolor`    - color of the facets (e.g. edges)
* `vertexcolor`   - color of the vertices (i.e. points)
* `showboundary`  - tells whether or not to show the boundary
* `showfacets`    - tells whether or not to show the facets
* `showvertices`  - tells whether or not to show the vertices
* `variable`      - informs which variable to visualize
* `decimation`    - decimation tolerance for polygons
"""
@Makie.recipe(Viz, object) do scene
  Makie.Attributes(;
    # generic attributes
    colormap      = Makie.theme(scene, :colormap),

    # Meshes.jl attributes
    pointsize     = Makie.theme(scene, :markersize),
    pointcolor    = :black,
    vertexsize    = Makie.theme(scene, :markersize),
    vertexcolor   = :black,
    elementcolor  = :slategray3,
    boundarycolor = :gray30,
    facetcolor    = :gray30,
    showboundary  = true,
    showfacets    = false,
    showvertices  = false,
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
