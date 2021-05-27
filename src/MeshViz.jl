module MeshViz

using Meshes

import Makie

@Makie.recipe(Viz, obj) do scene
  Makie.Attributes(;
    color        = Makie.theme(scene, :patchcolor),
    visible      = Makie.theme(scene, :visible),
    strokecolor  = Makie.theme(scene, :patchstrokecolor),
    colormap     = Makie.theme(scene, :colormap),
    colorrange   = Makie.automatic,
    strokewidth  = Makie.theme(scene, :patchstrokewidth),
    inspectable  = Makie.theme(scene, :inspectable)
  )
end

# -----------
# SimpleMesh
# -----------

Makie.plottype(::SimpleMesh) = Viz{<:Tuple{SimpleMesh}}

function Makie.plot!(plot::Viz{<:Tuple{SimpleMesh}})
  mesh = plot[:obj][]

  # retrieve geometry + topology
  verts = vertices(mesh)
  topo  = topology(mesh)
  elems = elements(topo)

  # convert to Julia arrays
  coords = reduce(hcat, coordinates(v) for v in verts)'
  connec = reduce(hcat, collect(indices(e)) for e in elems)'

  # enable shading in 3D
  shading = embeddim(mesh) == 3

  Makie.mesh!(
    plot, coords, connec,
    color = plot[:color], colormap = plot[:colormap], colorrange = plot[:colorrange],
    shading = shading, visible = plot[:visible], inspectable = plot[:inspectable]
  )
end

# ---------
# PointSet
# ---------

Makie.plottype(::PointSet) = Viz{<:Tuple{PointSet}}

function Makie.plot!(plot::Viz{<:Tuple{PointSet}})
  pset = plot[:obj][]

  # retrieve coordinates of points
  coords = coordinates.(pset)

  Makie.scatter!(
    plot, coords,
    color = plot[:color], colormap = plot[:colormap], colorrange = plot[:colorrange],
    visible = plot[:visible], inspectable = plot[:inspectable]
  )
end

end
