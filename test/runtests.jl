using MeshViz
using Meshes
using GeoTables
using ReferenceTests
using ImageIO
using Test

import CairoMakie as Mke

@testset "MeshViz.jl" begin
  # point set
  d = PointSet(rand(Point2, 100))
  viz(d)
  viz(d, pointcolor = :red)

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

  g = Triangle((1.,0.), (2.,0.), (2.,1.))
  viz(g)      
  viz(g, showboundary = false)
  viz(g, elementcolor = :orange)
  viz(g, elementcolor = :black, boundarycolor = :red)

  g = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  viz(g)      
  viz(g, showboundary = false)
  viz(g, elementcolor = :orange)
  viz(g, elementcolor = :black, boundarycolor = :red)

  g = PolyArea((0.,0.), (0.5,-1.5), (1.,0.), (1.5,0.5),
               (1.,1.), (0.5,1.5), (-0.5,0.5), (0.,0.))
  viz(g)      
  viz(g, showboundary = false)
  viz(g, elementcolor = :orange)
  viz(g, elementcolor = :black, boundarycolor = :red)

  g = Box((0.,0.), (1.,1.))
  viz(g)      
  viz(g, showboundary = false)
  viz(g, elementcolor = :orange)
  viz(g, elementcolor = :black, boundarycolor = :red)

  g = Box((0.,0.,0.), (1.,1.,1.))
  viz(g)      
  viz(g, color = :orange)

  g = Sphere((0.,0.,0.), 1.)
  viz(g)
  viz(g, color = :orange)

  p = rand(Point2, 100)
  viz(p)
  viz(p, pointsize = 20)
  viz(p, pointcolor = 1:100)

  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  d = Collection([t, q])
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, elementcolor = 1:2)
  viz(d, elementcolor = 1:2, colormap = :inferno)

  d1 = CartesianGrid(10,10)
  d2 = PointSet(rand(Point2, 100))
  d3 = rand(Point2, 100)
  viz(d1, color = 1:100)
  viz(d2, color = 1:100)
  viz(d3, color = 1:100)
  viz(d1, color = 1:100, colormap = :inferno)
  viz(d2, color = 1:100, colormap = :inferno)
  viz(d3, color = 1:100, colormap = :inferno)

  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  d = Collection([t, q])
  viz(d, color = 1:2)

  d = meshdata(CartesianGrid(10,10), etable = (z=rand(100),w=1:100))
  viz(d, variable = :z)
  viz(d, variable = :w)
  viz(d, colormap = :inferno)

  d = meshdata(PointSet(rand(Point2,100)), etable = (z=rand(100),))
  viz(d)
  viz(d, colormap = :inferno)
end
