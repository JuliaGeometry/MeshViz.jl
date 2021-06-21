# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::Data) = Viz{<:Tuple{Data}}

function Makie.plot!(plot::Viz{<:Tuple{Data}})
  # retrieve data object
  data = plot[:object][]

  # Meshes.jl attributes
  elementcolor  = plot[:elementcolor][]
  boundarycolor = plot[:boundarycolor][]
  facetcolor    = plot[:facetcolor][]
  vertexcolor   = plot[:vertexcolor][]
  showboundary  = plot[:showboundary][]
  showfacets    = plot[:showfacets][]
  showvertices  = plot[:showvertices][]
  variable      = plot[:variable][]
  decimation    = plot[:decimation][]

  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  variables = Tables.columnnames(tab)

  # select variable to visualize
  var = isnothing(variable) ? first(variables) : variable

  # element color from variable column
  c = Tables.getcolumn(tab, var)

  # handle categorical values
  elementcolor = eltype(c) <: CategoricalValue ? levelcode.(c) : c

  # call existing recipe for underlying domain
  viz!(plot, dom,
    colormap      = plot[:colormap],
    markersize    = plot[:markersize],
    elementcolor  = elementcolor,
    boundarycolor = boundarycolor,
    facetcolor    = facetcolor,
    vertexcolor   = vertexcolor,
    showboundary  = showboundary,
    showfacets    = showfacets,
    showvertices  = showvertices,
    decimation    = decimation
  )
end
