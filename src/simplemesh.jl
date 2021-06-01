# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

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
  color = if elementcolor isa AbstractVector
    # map color to all vertices of elements
    colors = Vector{eltype(elementcolor)}(undef, n)
    for (e, elem) in Iterators.enumerate(elems)
      for i in indices(elem)
        colors[i] = elementcolor[e]
      end
    end
    colors
  else
    # default to single color
    elementcolor
  end

  Makie.mesh!(plot, coords, connec,
    colormap = plot[:colormap],
    shading = shading, 
    color = color,
  )


  if showvertices
    Makie.scatter!(plot, Vec{d}.(eachrow(coords)),
      markersize = plot[:markersize],
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
    end

    # fill sentinel index with NaN coordinates
    coords = [coords; fill(NaN, d)']

    # split coordinates to match signature
    xyz = [coords[inds,j] for j in 1:d]

    Makie.lines!(plot, xyz...,
      color = facetcolor,
    )
  end
end
