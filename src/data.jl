# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Data) = Viz{<:Tuple{Data}}

function Makie.plot!(plot::Viz{<:Tuple{Data}})
  # retrieve data and variable
  data     = plot[:object][]
  variable = plot[:variable][]

  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  variables = Tables.columnnames(tab)

  # select variable to visualize
  var = isnothing(variable) ? first(variables) : variable

  # element color from variable column
  c = Tables.getcolumn(tab, var)

  # handle categorical values
  color = eltype(c) <: CategoricalValue ? levelcode.(c) : c

  # call recipe for underlying domain
  viz!(plot, dom,
    size          = plot[:size],
    color         = color,
    colormap      = plot[:colormap],
    boundarycolor = plot[:boundarycolor],
    facetcolor    = plot[:facetcolor],
    showboundary  = plot[:showboundary],
    showfacets    = plot[:showfacets],
    decimation    = plot[:decimation],
  )
end
