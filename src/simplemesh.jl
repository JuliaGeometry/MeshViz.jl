# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  # retrieve mesh object
  mesh = plot[:object][]

  # Meshes.jl attributes
  color        = plot[:color][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]

  # retrieve vertices + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)
  dim   = embeddim(mesh)
  nvert = nvertices(mesh)

  # coordinates of vertices
  coords = coordinates.(verts)

  # triangulate polygons
  tmesh  = triangulate(mesh)
  ttopo  = topology(tmesh)
  tris   = [collect(indices(Δ)) for Δ in elements(ttopo)]
  connec = reduce(hcat, tris) |> transpose

  # enable shading in 3D
  shading = dim == 3

  # set element color
  finalcolor = if color isa AbstractVector
    # map color to all vertices of elements
    colors = Vector{eltype(color)}(undef, nvert)
    for (e, elem) in Iterators.enumerate(elems)
      for i in indices(elem)
        colors[i] = color[e]
      end
    end
    colors
  else
    # default to single color
    color
  end

  Makie.mesh!(plot, coords, connec,
    color = finalcolor,
    colormap = plot[:colormap],
    shading = shading, 
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
      push!(inds, nvert+1)
    end

    # fill sentinel index with NaN coordinates
    push!(coords, Vec(ntuple(i->NaN, dim)))

    # extract incident vertices
    coords = coords[inds]

    # split coordinates to match signature
    xyz = [getindex.(coords, j) for j in 1:dim]

    Makie.lines!(plot, xyz...,
      color = facetcolor,
    )
  end
end
