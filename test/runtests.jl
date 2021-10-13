using MeshViz
using Meshes
using GeoTables
using ReferenceTests
using ImageIO
using Test

import CairoMakie as Mke

@testset "MeshViz.jl" begin
  # 1D Cartesian grid
  d = CartesianGrid(10)
  # TODO

  # 2D Cartesian grid
  d = CartesianGrid(10,10)
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, elementcolor = 1:100)

  # 3D Cartesian grid
  d = CartesianGrid(10,10,10)
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, elementcolor = 1:1000)
end
