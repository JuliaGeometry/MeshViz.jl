# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::AbstractVector{<:PointOrGeometry}) =
  Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}}

function Makie.plot!(plot::Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}})
  # retrieve items object
  items = plot[:object][]

  # Meshes.jl attributes
  elementcolor  = plot[:elementcolor][]
  boundarycolor = plot[:boundarycolor][]
  vertexcolor   = plot[:vertexcolor][]
  showboundary  = plot[:showboundary][]
  showvertices  = plot[:showvertices][]
  decimation    = plot[:decimation][]

  # fallback to collection recipe
  viz!(plot, Collection(items),
    markersize    = plot[:markersize],
    elementcolor  = elementcolor,
    facetcolor    = boundarycolor,
    vertexcolor   = vertexcolor,
    showfacets    = showboundary,
    showvertices  = showvertices,
    decimation    = decimation,
  )
end

Makie.plottype(::PointOrGeometry) = Viz{<:Tuple{PointOrGeometry}}

function Makie.plot!(plot::Viz{<:Tuple{PointOrGeometry}})
  # retrieve item object
  item = plot[:object][]

  # Meshes.jl attributes
  elementcolor  = plot[:elementcolor][]
  boundarycolor = plot[:boundarycolor][]
  vertexcolor   = plot[:vertexcolor][]
  showboundary  = plot[:showboundary][]
  showvertices  = plot[:showvertices][]
  decimation    = plot[:decimation][]

  # fallback to vector recipe
  viz!(plot, [item],
    markersize    = plot[:markersize],
    elementcolor  = elementcolor,
    boundarycolor = boundarycolor,
    vertexcolor   = vertexcolor,
    showboundary  = showboundary,
    showvertices  = showvertices,
    decimation    = decimation,
  )
end

Makie.plottype(::Domain) = Viz{<:Tuple{Domain}}

function Makie.plot!(plot::Viz{<:Tuple{Domain}})
  # retrieve domain object
  domain = plot[:object][]

  # Meshes.jl attributes
  elementcolor  = plot[:elementcolor][]
  facetcolor    = plot[:facetcolor][]
  vertexcolor   = plot[:vertexcolor][]
  showfacets    = plot[:showfacets][]
  showvertices  = plot[:showvertices][]
  decimation    = plot[:decimation][]

  # fallback to vector recipe
  viz!(plot, collect(domain),
    markersize    = plot[:markersize],
    elementcolor  = elementcolor,
    boundarycolor = facetcolor,
    vertexcolor   = vertexcolor,
    showboundary  = showfacets,
    showvertices  = showvertices,
    decimation    = decimation,
  )
end
