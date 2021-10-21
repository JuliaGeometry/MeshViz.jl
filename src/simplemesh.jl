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
  color        = plot[:color][]
  vertexsize   = plot[:vertexsize][]
  vertexcolor  = plot[:vertexcolor][]
  elementcolor = plot[:elementcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
  showfacets   = plot[:showfacets][]

  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # retrieve coordinates of vertices
  coords = coordinates.(verts)

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

  # choose attribute with element color
  ecolor = isnothing(color) ? elementcolor : color

  # set element color
  finalcolor = if ecolor isa AbstractVector
    # map color to all vertices of elements
    colors = Vector{eltype(ecolor)}(undef, n)
    for (e, elem) in Iterators.enumerate(elems)
      for i in indices(elem)
        colors[i] = ecolor[e]
      end
    end
    colors
  else
    # default to single color
    ecolor
  end

  Makie.mesh!(plot, coords, connec,
    colormap = plot[:colormap],
    shading = shading, 
    color = finalcolor,
  )


  if showvertices
    Makie.scatter!(plot, coords,
      markersize = vertexsize,
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
    push!(coords, Vec(ntuple(i->NaN, d)))

    # extract incident vertices
    coords = coords[inds]

    # split coordinates to match signature
    xyz = [getindex.(coords, j) for j in 1:d]

    Makie.lines!(plot, xyz...,
      color = facetcolor,
    )
  end
end
