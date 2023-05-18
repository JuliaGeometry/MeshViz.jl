# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Collection) = Viz{<:Tuple{Collection}}

function Makie.plot!(plot::Viz{<:Tuple{Collection}})
  collection   = plot[:object]
  color        = plot[:color]
  alpha        = plot[:alpha]
  colorscheme  = plot[:colorscheme]
  facetcolor   = plot[:facetcolor]
  showfacets   = plot[:showfacets]

  # process color spec into colorant
  colorant = Makie.@lift process($color, $colorscheme, $alpha)

  # decimate geometries if needed
  geoms = Makie.@lift collect($collection)

  # retrieve parametric dimension
  ranks = Makie.@lift paramdim.($geoms)

  if all(ranks[] .== 0)
    # visualize point set
    aes = plot[:aes0][]
    coords = Makie.@lift coordinates.($geoms)
    Makie.scatter!(plot, coords,
      color = colorant,
      markersize = aes.size,
    )
  elseif all(ranks[] .== 1)
    meshes = Makie.@lift discretize.($geoms)
    vizmany!(plot, meshes)
  elseif all(ranks[] .== 2)
    meshes = Makie.@lift discretize.($geoms)
    vizmany!(plot, meshes)
  elseif all(ranks[] .== 3)
    meshes = Makie.@lift discretize.(boundary.($geoms))
    vizmany!(plot, meshes)
  else # mixed dimension
    # visualize subsets of equal rank
    inds3 = Makie.@lift findall(g -> paramdim(g) == 3, $geoms)
    inds2 = Makie.@lift findall(g -> paramdim(g) == 2, $geoms)
    inds1 = Makie.@lift findall(g -> paramdim(g) == 1, $geoms)
    inds0 = Makie.@lift findall(g -> paramdim(g) == 0, $geoms)
    isempty(inds3[]) || viz!(plot, (Makie.@lift Collection($geoms[$inds3])))
    isempty(inds2[]) || viz!(plot, (Makie.@lift Collection($geoms[$inds2])))
    isempty(inds1[]) || viz!(plot, (Makie.@lift Collection($geoms[$inds1])))
    isempty(inds0[]) || viz!(plot, (Makie.@lift Collection($geoms[$inds0])))
  end

  if showfacets[]
    bounds = Makie.@lift filter(!isnothing, boundary.($geoms))
    if isempty(bounds[])
      # nothing to be done
    elseif all(ranks[] .== 1)
      # all boundaries are point sets
      points = Makie.@lift mapreduce(collect, vcat, $bounds)
      viz!(plot, (Makie.@lift Collection($points)),
        color = facetcolor,
        showfacets = false,
      )
    elseif all(ranks[] .== 2)
      # all boundaries are geometries
      viz!(plot, (Makie.@lift Collection($bounds)),
        color = facetcolor,
        showfacets = false,
      )
    elseif all(ranks[] .== 3)
      # we already visualized the boundaries because
      # that is all we can do with 3D geometries
    end
  end
end