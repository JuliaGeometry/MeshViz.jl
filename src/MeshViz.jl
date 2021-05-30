# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module MeshViz

using Meshes
using Tables

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
* `isovalue`     - isosurface value to extract from 3D grid
* `isorange`     - tolerance around the isosurface value
"""
@Makie.recipe(Viz, object) do scene
  Makie.Attributes(;
    # generic attributes
    colormap     = Makie.theme(scene, :colormap),

    # Meshes.jl attributes
    elementcolor = :slategray3,
    facetcolor   = :gray30,
    vertexcolor  = :black,
    showvertices = false,
    showfacets   = true,
    variable     = nothing,
    isovalue     = 0.0,
    isorange     = 0.05,
  )
end

# domain
include("pointset.jl")
include("geometryset.jl")
include("simplemesh.jl")
include("cartesiangrid.jl")

# data
include("data.jl")

end
