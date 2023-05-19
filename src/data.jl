# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    viewer(data)

Basic scientific viewer with menus, checkboxes, and other interactive
elements for spatial `data` exploration.
"""
function viewer(data::Data)
  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  cols = Tables.columns(tab)
  vars = Tables.columnnames(cols)

  # list of plottable variables
  plottable = filter(vars) do var
    v = Tables.getcolumn(cols, var)
    isplottable(elscitype(v))
  end

  # throw error if there are no plottable variables
  if isempty(plottable)
    throw(AssertionError("""
      Could not find plottable variables.
      Please make sure that the scientific type of columns is correct.
      A common mistake is to try to plot a textual column `col` directly.
      The textual column must be coerced to `Multiclass` or `OrderedFactor`.
      For example, `table |> Coerce(:col => Multiclass)`.
      """))
  end

  # initialize figure and menu
  fig = Makie.Figure()
  label = Makie.Label(fig[1, 1], "VARIABLE")
  menu = Makie.Menu(fig[1, 2], options=collect(plottable))

  # select plottable variable
  var = menu.selection
  vals = Makie.@lift Tables.getcolumn(cols, $var)
  cmap = Makie.@lift defaultscheme($vals)

  # initialize visualization
  viz(fig[2, :], dom; color=vals)
  Makie.Colorbar(fig[2, 3], colormap=cmap)

  # update visualization if necessary
  Makie.on(menu.selection) do var
    vals[] = Tables.getcolumn(cols, var)
    cmap[] = defaultscheme(vals[])
  end

  fig
end

isplottable(::Type) = false
isplottable(::Type{<:Finite}) = true
isplottable(::Type{<:Infinite}) = true
isplottable(::Type{<:Unknown}) = true
