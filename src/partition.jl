# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Partition) = Viz{<:Tuple{Partition}}

function Makie.plot!(plot::Viz{<:Tuple{Partition}})
  # retrieve partition object
  partition = plot[:object][]

  colors = distinguishable_colors(length(partition))

  for (i, subset) in Iterators.enumerate(partition)
    # fallback to collection recipe
    viz!(plot, subset,
      size         = plot[:size],
      color        = colors[i],
      alpha        = plot[:alpha],
      facetcolor   = plot[:facetcolor],
      showfacets   = plot[:showfacets],
      decimation   = plot[:decimation],
    )
  end
end
