# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::GeometrySet) = Viz{<:Tuple{GeometrySet}}

function Makie.plot!(plot::Viz{<:Tuple{GeometrySet}})
  # retrieve point set object
  gset = plot[:object][]

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  vertexcolor  = plot[:vertexcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
  showfacets   = plot[:showfacets][]

  # helper functions
  decimate(geometry) = simplify(geometry, DouglasPeucker(0.05))
  triangulate(geometry) = discretize(geometry, FIST())

  # retrieve parametric dimension
  ranks = paramdim.(gset)
  if all(ranks .== 1)
    # split 1D geometries into line segments
    coords = geomsegments(gset)
    Makie.lines!(plot, coords,
      color = facetcolor,
    )
  elseif all(ranks .== 2)
    # split 2D geometries into triangles
    polygons = decimate.(gset)
    mesh = mapreduce(triangulate, merge, polygons)
    viz!(plot, mesh,
      elementcolor = elementcolor,
      showvertices = false,
      showfacets = false,
    )
    if showfacets
      polychains = mapreduce(chains, vcat, polygons)
      viz!(plot, GeometrySet(polychains),
        facetcolor = facetcolor,
      )
    end
  elseif all(ranks .== 3)
    throw(ErrorException("not implemented"))
  else # mixed dimension
    # visualize geometries in subsets of equal rank
    geoms = collect(gset)
    inds3 = findall(g -> paramdim(g) == 3, geoms)
    inds2 = findall(g -> paramdim(g) == 2, geoms)
    inds1 = findall(g -> paramdim(g) == 1, geoms)
    isempty(inds3) || viz!(plot, GeometrySet(geoms[inds3]))
    isempty(inds2) || viz!(plot, GeometrySet(geoms[inds2]))
    isempty(inds1) || viz!(plot, GeometrySet(geoms[inds1]))
  end
end

# helper function to split 1D geometries
# such as chains into line segments
function geomsegments(gset)
  chains = []
  for geom in gset
    if geom isa Multi
      append!(chains, vertices.(geom))
    else
      push!(chains, vertices(geom))
    end
  end

  Dim = embeddim(gset)
  nan = Vec(ntuple(i->NaN, Dim))
  coords = Vec{Dim,Float64}[]
  for chain in chains
    for point in chain
      push!(coords, coordinates(point))
    end
    push!(coords, nan)
  end
  coords
end
