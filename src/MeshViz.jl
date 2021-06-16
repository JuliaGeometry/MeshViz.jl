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

* `elementcolor` - color of the elements (e.g. triangles)
* `facetcolor`   - color of the facets (e.g. edges)
* `vertexcolor`  - color of the vertices (i.e. points)
* `showvertices` - tells whether or not to show the vertices
* `showfacets`   - tells whether or not to show the facets
* `variable`     - informs which variable to visualize
* `decimation`   - decimation tolerance for polygons
"""
@Makie.recipe(Viz, object) do scene
  Makie.Attributes(;
    # generic attributes
    colormap     = Makie.theme(scene, :colormap),
    markersize   = Makie.theme(scene, :markersize),

    # Meshes.jl attributes
    elementcolor = :slategray3,
    facetcolor   = :gray30,
    vertexcolor  = :black,
    showvertices = false,
    showfacets   = false,
    variable     = nothing,
    decimation   = 0.0,
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
