# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::AbstractVector{<:Geometry}) =
  Viz{<:Tuple{AbstractVector{<:Geometry}}}

function Makie.plot!(plot::Viz{<:Tuple{AbstractVector{<:Geometry}}})
  # retrieve geometries
  geoms = plot[:object]

  # fallback to geometry set recipe
  viz!(plot, (Makie.@lift GeometrySet($geoms)),
    color       = plot[:color],
    alpha       = plot[:alpha],
    colorscheme = plot[:colorscheme],
    facetcolor  = plot[:facetcolor],
    showfacets  = plot[:showfacets],
    pointsize   = plot[:pointsize],
    segmentsize = plot[:segmentsize]
  )
end

Makie.plottype(::Geometry) = Viz{<:Tuple{Geometry}}

function Makie.plot!(plot::Viz{<:Tuple{Geometry}})
  # retrieve geometry
  geom = plot[:object]

  # fallback to vector recipe
  viz!(plot, (Makie.@lift [$geom]),
    color       = plot[:color],
    alpha       = plot[:alpha],
    colorscheme = plot[:colorscheme],
    facetcolor  = plot[:facetcolor],
    showfacets  = plot[:showfacets],
    pointsize   = plot[:pointsize],
    segmentsize = plot[:segmentsize]
  )
end

Makie.plottype(::Domain) = Viz{<:Tuple{Domain}}

function Makie.plot!(plot::Viz{<:Tuple{Domain}})
  # retrieve domain object
  domain = plot[:object]

  # fallback to vector recipe
  viz!(plot, (Makie.@lift collect($domain)),
    color       = plot[:color],
    alpha       = plot[:alpha],
    colorscheme = plot[:colorscheme],
    facetcolor  = plot[:facetcolor],
    showfacets  = plot[:showfacets],
    pointsize   = plot[:pointsize],
    segmentsize = plot[:segmentsize]
  )
end
