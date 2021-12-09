# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Collection) = Viz{<:Tuple{Collection}}

function Makie.plot!(plot::Viz{<:Tuple{Collection}})
  # retrieve collection object
  collection = plot[:object][]

  size         = plot[:size][]
  color        = plot[:color][]
  colormap     = plot[:colormap][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]
  decimation   = plot[:decimation][]

  # decimate geometries if needed
  geoms = decimation > 0 ? decimate.(collection, decimation) : collection

  # retrieve parametric dimension
  ranks = paramdim.(geoms)

  if all(ranks .== 0)
    # visualize point set
    coords = coordinates.(geoms)
    Makie.scatter!(plot, coords,
      color = color,
      colormap = colormap,
      markersize = size,
    )
  elseif all(ranks .== 1)
    # split 1D geometries into line segments
    coords = geomsegments(geoms)
    Makie.lines!(plot, coords,
      color = color,
    )
  elseif all(ranks .== 2)
    # triangulate geometries
    meshes = triangulate.(geoms)
    colors = if color isa AbstractVector
      [color[e] for (e, mesh) in enumerate(meshes) for _ in 1:nelements(mesh)]
    else
      color
    end
    mesh = reduce(merge, meshes)
    viz!(plot, mesh,
      color = colors,
      colormap = colormap,
      showfacets = false,
    )
    if showfacets
      bounds = filter(!isnothing, boundary.(geoms))
      if !isempty(bounds)
        viz!(plot, Collection(bounds),
          color = facetcolor,
        )
      end
    end
  elseif all(ranks .== 3)
    meshes = boundary.(geoms)
    colors = if color isa AbstractVector
      [color[e] for (e, mesh) in enumerate(meshes) for _ in 1:nelements(mesh)]
    else
      color
    end
    mesh = reduce(merge, meshes)
    viz!(plot, mesh,
      color = colors,
      colormap = colormap,
      showfacets = false,
    )
  else # mixed dimension
    # visualize subsets of equal rank
    inds3 = findall(g -> paramdim(g) == 3, geoms)
    inds2 = findall(g -> paramdim(g) == 2, geoms)
    inds1 = findall(g -> paramdim(g) == 1, geoms)
    inds0 = findall(g -> paramdim(g) == 0, geoms)
    isempty(inds3) || viz!(plot, Collection(geoms[inds3]))
    isempty(inds2) || viz!(plot, Collection(geoms[inds2]))
    isempty(inds1) || viz!(plot, Collection(geoms[inds1]))
    isempty(inds0) || viz!(plot, Collection(geoms[inds0]))
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
