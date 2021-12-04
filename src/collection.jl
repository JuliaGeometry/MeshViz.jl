# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Collection) = Viz{<:Tuple{Collection}}

function Makie.plot!(plot::Viz{<:Tuple{Collection}})
  # retrieve collection object
  collection = plot[:object][]

  # Meshes.jl attributes
  color        = plot[:color][]
  colormap     = plot[:colormap][]
  pointsize    = plot[:pointsize][]
  pointcolor   = plot[:pointcolor][]
  elementcolor = plot[:elementcolor][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]
  decimation   = plot[:decimation][]

  # choose attribute with point color
  pcolor = isnothing(color) ? pointcolor : color

  # choose attribute with element color
  ecolor = isnothing(color) ? elementcolor : color

  # helper function
  function mdecimate(geometry)
    if decimation > 0
      decimate(geometry, decimation)
    else
      geometry
    end
  end

  # retrieve parametric dimension
  ranks = paramdim.(collection)
  if all(ranks .== 0)
    # visualize point set
    coords = coordinates.(collection)
    Makie.scatter!(plot, coords,
      colormap = colormap,
      markersize = pointsize,
      color = pcolor,
    )
  elseif all(ranks .== 1)
    # split 1D geometries into line segments
    coords = geomsegments(collection)
    Makie.lines!(plot, coords,
      color = ecolor,
    )
  elseif all(ranks .== 2)
    # triangulate geometries
    geoms  = mdecimate.(collection)
    meshes = triangulate.(geoms)
    colors = if ecolor isa AbstractVector
      [ecolor[e] for (e, mesh) in enumerate(meshes) for _ in 1:nelements(mesh)]
    else
      ecolor
    end
    mesh = reduce(merge, meshes)
    viz!(plot, mesh,
      colormap = colormap,
      elementcolor = colors,
      showvertices = false,
      showfacets = false,
    )
    if showfacets
      bounds = filter(!isnothing, boundary.(geoms))
      if !isempty(bounds)
        viz!(plot, Collection(bounds),
          elementcolor = facetcolor,
        )
      end
    end
  elseif all(ranks .== 3)
    meshes = boundary.(collection)
    colors = if ecolor isa AbstractVector
      [ecolor[e] for (e, mesh) in enumerate(meshes) for _ in 1:nelements(mesh)]
    else
      ecolor
    end
    mesh = reduce(merge, meshes)
    viz!(plot, mesh,
      colormap = colormap,
      elementcolor = colors,
      showvertices = false,
      showfacets = false,
    )
  else # mixed dimension
    # visualize subsets of equal rank
    items = collect(collection)
    inds3 = findall(g -> paramdim(g) == 3, items)
    inds2 = findall(g -> paramdim(g) == 2, items)
    inds1 = findall(g -> paramdim(g) == 1, items)
    inds0 = findall(g -> paramdim(g) == 0, items)
    isempty(inds3) || viz!(plot, Collection(items[inds3]))
    isempty(inds2) || viz!(plot, Collection(items[inds2]))
    isempty(inds1) || viz!(plot, Collection(items[inds1]))
    isempty(inds0) || viz!(plot, Collection(items[inds0]))
  end
end

# helper function to split 1D geometries
# such as chains into line segments
function geomsegments(gset)
  chains = []
  for geom in gset
    if geom isa Multi
      for g in geom
        v = vertices(g)
        push!(chains, [v; first(v)])
      end
    else
      v = vertices(geom)
      push!(chains, [v; first(v)])
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
