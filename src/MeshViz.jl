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
    # generic attributes
    colormap     = Makie.theme(scene, :colormap),

    # Meshes.jl attributes
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
  # retrieve mesh object
  mesh = plot[:obj][]
  d = embeddim(mesh)
  n = nvertices(mesh)

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]

  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # retrieve coordinates of vertices
  coords = reduce(hcat, coordinates.(verts))'

  # decompose n-gons into triangles by
  # fan triangulation (assumes convexity)
  # https://en.wikipedia.org/wiki/Fan_triangulation
  tris = Vector{Int}[]
  for elem in elems
    inds = indices(elem)
    for i in 2:length(inds)-1
      push!(tris, [inds[1], inds[i], inds[i+1]])
    end
  end
  faces = reduce(hcat, tris)'

  # enable shading in 3D
  shading = embeddim(mesh) == 3

  # set element color
  color = if elementcolor isa Symbol
    # default to single color
    elementcolor
  else
    # copy color to all vertices of elements
    colors = Vector{eltype(elementcolor)}(undef, n)
    for (e, elem) in Iterators.enumerate(elems)
      for i in indices(elem)
        colors[i] = elementcolor[e]
      end
    end
    colors
  end

  Makie.mesh!(plot, coords, faces,
    color = color, colormap = plot[:colormap],
    shading = shading, interpolate = false,
  )

  if showfacets
    # use a sophisticated data structure
    # to extract the edges from the n-gons
    t = convert(HalfEdgeTopology, topo)
    ∂ = Boundary{1,0}(t)

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
      color = facetcolor,
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
