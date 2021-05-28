module MeshViz

using Meshes

import Makie

"""
    viz(object)

Visualize Meshes.jl `object` with various options:

* `elementcolor` - color of the elements (e.g. triangles)
* `facetcolor`   - color of the facets (e.g. edges)
* `vertexcolor`  - color of the vertices (i.e. points)
* `showfacets`   - tells whether or not to show the facets
"""
@Makie.recipe(Viz, obj) do scene
  Makie.Attributes(;
    elementcolor = :slategray3,
    facetcolor   = :gray30,
    vertexcolor  = :black,
    showfacets   = false,
  )
end

# -----------
# SimpleMesh
# -----------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  mesh = plot[:obj][]

  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # retrieve coordinates of vertices
  coords = reduce(hcat, coordinates.(verts))'

  # decompose n-gons into simplices by
  # fan triangulation (assumes convexity)
  # https://en.wikipedia.org/wiki/Fan_triangulation
  triangles = Vector{Int}[]
  for elem in elems
    inds = indices(elem)
    for i in 2:length(inds)-1
      push!(triangles, [inds[1], inds[i], inds[i+1]])
    end
  end
  faces = reduce(hcat, triangles)'

  # enable shading in 3D
  shading = embeddim(mesh) == 3

  Makie.mesh!(plot, coords, faces,
    color = plot[:elementcolor], shading = shading,
  )

  if plot[:showfacets][]
    # use a sophisticated data structure
    # to extract the edges from the n-gons
    t = convert(HalfEdgeTopology, topo)
    ∂ = Boundary{1,0}(t)
    d = embeddim(mesh)
    n = nvertices(mesh)

    # append indices of incident vertices
    # interleaved with a sentinel index
    inds = Int[]
    for i in 1:nfacets(t)
      append!(inds, ∂(i))
      push!(inds, n+1)
      push!(inds, n+1)
    end

    # fill sentinel index with NaN coordinates
    coords = [coords; fill(NaN, d)']

    # split coordinates to match signature
    xyz = [coords[inds,j] for j in 1:d]

    Makie.linesegments!(plot, xyz...,
      color = plot[:facetcolor],
    )
  end
end

# ---------
# PointSet
# ---------

Makie.plottype(::PointSet) = Viz{<:Tuple{PointSet}}

function Makie.plot!(plot::Viz{<:Tuple{PointSet}})
  pset = plot[:obj][]

  # retrieve coordinates of points
  coords = coordinates.(pset)

  Makie.scatter!(plot, coords,
    color = plot[:vertexcolor],
  )
end

end
