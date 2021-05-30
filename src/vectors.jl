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

  viz!(plot, Collection(items),
    elementcolor = elementcolor,
    vertexcolor  = vertexcolor,
    facetcolor   = facetcolor,
    showvertices = showvertices,
    showfacets   = showfacets
  )
end
