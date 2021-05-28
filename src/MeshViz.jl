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
    showfacets   = false,
    variable     = nothing,
  )
end

# -----------
# SimpleMesh
# -----------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  # retrieve mesh object
  mesh = plot[:object][]
  d = embeddim(mesh)
  n = nvertices(mesh)

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  vertexcolor  = plot[:vertexcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
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
  connec = reduce(hcat, tris)'

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

  Makie.mesh!(plot, coords, connec,
    colormap = plot[:colormap],
    shading = shading, 
    color = color,
  )


  if showvertices
    Makie.scatter!(plot, Vec{d}.(eachrow(coords)),
      color = vertexcolor,
    )
  end

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
  # retrieve point set object
  pset = plot[:object][]

  # Meshes.jl attributes
  vertexcolor = plot[:vertexcolor][]

  # retrieve coordinates of points
  coords = coordinates.(pset)

  Makie.scatter!(plot, coords,
    color = vertexcolor,
  )
end

# ----------
# Mesh data
# ----------

Makie.plottype(::MeshData) = Viz{<:Tuple{MeshData}}

function Makie.plot!(plot::Viz{<:Tuple{MeshData}})
  # retrieve data object
  data = plot[:object][]

  # Meshes.jl attributes
  variable = plot[:variable][]

  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  variables = Tables.columnnames(tab)

  # select variable to visualize
  var = isnothing(variable) ? first(variables) : variable

  # element color from variable column
  elementcolor = Tables.getcolumn(tab, var)

  # call existing recipe for underlying domain
  viz!(plot, dom,
    colormap = plot[:colormap],
    elementcolor = elementcolor,
    vertexcolor  = plot[:vertexcolor],
    facetcolor   = plot[:facetcolor],
    showvertices = plot[:showvertices],
    showfacets   = plot[:showfacets],
  )
end

end
