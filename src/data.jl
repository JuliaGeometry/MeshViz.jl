# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function viewer(data::Data; kwargs...)
  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  cols = Tables.columns(tab)
  vars = Tables.columnnames(cols)

  # list of valid variables
  valid = filter(vars) do var
    v = Tables.getcolumn(cols, var)
    issupported(elscitype(v))
  end

  # initialize visualization
  fig    = Makie.Figure()
  label  = Makie.Label(fig[1,1], "VARIABLE")
  menu   = Makie.Menu(fig[1,2], options = collect(valid))
  color  = Makie.@lift Tables.getcolumn(cols, $(menu.selection))
  viz(fig[2,:], dom; color = color, kwargs...)

  Makie.on(menu.selection) do var
    color[] = Tables.getcolumn(cols, var)
  end

  fig
end

issupported(::Type) = false
issupported(::Type{<:Finite}) = true
issupported(::Type{<:Infinite}) = true
issupported(::Type{<:Unknown}) = true