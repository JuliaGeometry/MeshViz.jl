# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::AbstractVector{<:PointOrGeometry}) =
  Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}}

function Makie.plot!(plot::Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}})
  # retrieve items object
  items = plot[:object][]

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  vertexcolor  = plot[:vertexcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
  showfacets   = plot[:showfacets][]
  decimation   = plot[:decimation][]

  # fallback to collection recipe
  viz!(plot, Collection(items),
    elementcolor = elementcolor,
    vertexcolor  = vertexcolor,
    facetcolor   = facetcolor,
    showvertices = showvertices,
    showfacets   = showfacets,
    decimation   = decimation,
  )
end

Makie.plottype(::PointOrGeometry) = Viz{<:Tuple{PointOrGeometry}}

function Makie.plot!(plot::Viz{<:Tuple{PointOrGeometry}})
  # retrieve item object
  item = plot[:object][]

  # Meshes.jl attributes
  elementcolor = plot[:elementcolor][]
  vertexcolor  = plot[:vertexcolor][]
  facetcolor   = plot[:facetcolor][]
  showvertices = plot[:showvertices][]
  showfacets   = plot[:showfacets][]
  decimation   = plot[:decimation][]

  # fallback to vector recipe
  viz!(plot, [item],
    elementcolor = elementcolor,
    vertexcolor  = vertexcolor,
    facetcolor   = facetcolor,
    showvertices = showvertices,
    showfacets   = showfacets,
    decimation   = decimation,
  )
end
