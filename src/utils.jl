# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

function mayberepeat(value::AbstractVector, meshes)
  [value[e] for (e, mesh) in enumerate(meshes) for _ in 1:nelements(mesh)]
end

mayberepeat(value, meshes) = value

function vizmany!(plot, meshes)
  color       = plot[:color]
  alpha       = plot[:alpha]
  colorscheme = plot[:colorscheme]

  mesh   = reduce(merge, meshes)
  colors = Makie.@lift mayberepeat($color, meshes)
  alphas = Makie.@lift mayberepeat($alpha, meshes)

  viz!(plot, mesh,
    color = colors,
    alpha = alphas,
    colorscheme = colorscheme,
    showfacets = false,
  )
end
