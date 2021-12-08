# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::AbstractVector{<:PointOrGeometry}) =
  Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}}

function Makie.plot!(plot::Viz{<:Tuple{AbstractVector{<:PointOrGeometry}}})
  # retrieve items object
  items = plot[:object][]

  # fallback to collection recipe
  viz!(plot, Collection(items),
    color        = plot[:color],
    pointsize    = plot[:pointsize],
    facetcolor   = plot[:boundarycolor],
    showfacets   = plot[:showboundary],
    decimation   = plot[:decimation],
  )
end

Makie.plottype(::PointOrGeometry) = Viz{<:Tuple{PointOrGeometry}}

function Makie.plot!(plot::Viz{<:Tuple{PointOrGeometry}})
  # retrieve item object
  item = plot[:object][]

  # fallback to vector recipe
  viz!(plot, [item],
    color         = plot[:color],
    pointsize     = plot[:pointsize],
    boundarycolor = plot[:boundarycolor],
    showboundary  = plot[:showboundary],
    decimation    = plot[:decimation],
  )
end

Makie.plottype(::Domain) = Viz{<:Tuple{Domain}}

function Makie.plot!(plot::Viz{<:Tuple{Domain}})
  # retrieve domain object
  domain = plot[:object][]

  # fallback to vector recipe
  viz!(plot, collect(domain),
    color         = plot[:color],
    pointsize     = plot[:pointsize],
    boundarycolor = plot[:facetcolor],
    showboundary  = plot[:showfacets],
    decimation    = plot[:decimation],
  )
end
