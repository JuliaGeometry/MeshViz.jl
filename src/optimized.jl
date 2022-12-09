# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# ----------------------------------
# recipes optimized for performance
# ----------------------------------

const GridView{Dim,T} = DomainView{Dim,T,<:CartesianGrid{Dim,T}}

Makie.plottype(::GridView) = Viz{<:Tuple{GridView}}

function Makie.plot!(plot::Viz{<:Tuple{GridView}})
  # retrieve grid view object
  gridview = plot[:object][]

  color        = plot[:color]
  alpha        = plot[:alpha][]
  colorscheme  = plot[:colorscheme][]
  facetcolor   = plot[:facetcolor][]
  showfacets   = plot[:showfacets][]

  # process color spec into colorant
  colorant = Makie.@lift process($color, colorscheme, alpha)

  # retrieve underlying grid
  grid, _ = unview(gridview)
  dims    = embeddim(grid)
  sp      = spacing(grid)

  # enable shading in 3D
  shading = dims == 3

  # all geometries are equal, use mesh scatter
  coord(e) = coordinates(centroid(e))
  coords = [coord(e) .+ sp./2 for e in gridview]
  Makie.meshscatter!(plot, coords,
    marker = Makie.Rect{dims}(-1 .* sp, sp),
    markersize = 1,
    color = colorant,
    shading = shading,
  )

  if showfacets
    # TODO
  end
end
