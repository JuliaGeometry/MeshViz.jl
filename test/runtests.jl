using MeshViz
using Meshes
using GeoTables
using ReferenceTests
using ImageIO
using Test

import CairoMakie as Mke

@testset "MeshViz.jl" begin
  # 1D point set
  p = PointSet(rand(Point1, 100))
  # TODO

  # 2D point set
  p = PointSet(rand(Point2, 100))
  viz(p)
  viz(p, color = :red)
  viz(p, color = 1:100)
  viz(p, color = 1:100, colormap = :inferno)

  # 3D point set
  p = PointSet(rand(Point3, 100))
  viz(p)
  viz(p, color = :red)
  viz(p, color = 1:100)
  viz(p, color = 1:100, colormap = :inferno)

  # 1D Cartesian grid
  d = CartesianGrid(10)
  # TODO

  # 2D Cartesian grid
  d = CartesianGrid(10,10)
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, color = 1:100)
  viz(d, color = 1:100, colormap = :inferno)

  # 3D Cartesian grid
  d = CartesianGrid(10,10,10)
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, color = 1:1000)
  viz(d, color = 1:1000, colormap = :inferno)

  # N-gons
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  viz(t)      
  viz(t, showboundary = false)
  viz(t, color = :orange)
  viz(t, color = :black, boundarycolor = :red)
  viz(q)      
  viz(q, showboundary = false)
  viz(q, color = :orange)
  viz(q, color = :black, boundarycolor = :red)

  # Polygonal areas
  p = PolyArea((0.,0.), (0.5,-1.5), (1.,0.), (1.5,0.5),
               (1.,1.), (0.5,1.5), (-0.5,0.5), (0.,0.))
  viz(p)      
  viz(p, showboundary = false)
  viz(p, color = :orange)
  viz(p, color = :black, boundarycolor = :red)

  # Multi-geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  m = Multi([t, q])
  viz(m)      
  viz(m, showboundary = false)
  viz(m, color = :orange)
  viz(m, color = :black, boundarycolor = :red)

  # 2D boxes
  b = Box((0.,0.), (1.,1.))
  viz(b)      
  viz(b, showboundary = false)
  viz(b, color = :orange)
  viz(b, color = :black, boundarycolor = :red)

  # 3D boxes
  b = Box((0.,0.,0.), (1.,1.,1.))
  viz(b)      
  viz(b, color = :orange)

  # 3D spheres
  s = Sphere((0.,0.,0.), 1.)
  viz(s)
  viz(s, color = :orange)

  # Collections of geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  d = Collection([t, q])
  viz(d)
  viz(d, showfacets = true)
  viz(d, showfacets = true, facetcolor = :red)
  viz(d, color = 1:2)
  viz(d, color = 1:2, colormap = :inferno)

  # Simple meshes
  s = Sphere((0.,0.,0.), 1.)
  m = discretize(s, RegularDiscretization(10))
  viz(m)
  viz(m, color = 1:nvertices(m))
  viz(m, color = 1:nelements(m))
  viz(m, color = 1:nelements(m), showfacets = true)
  viz(m, color = :orange, showfacets = true, facetcolor = :white)

  # Vector of points
  p = rand(Point2, 100)
  viz(p)
  viz(p, color = 1:100)
  viz(p, color = 1:100, colormap = :inferno)
  viz(p, pointsize = 20)

  # Data over grid
  d = meshdata(CartesianGrid(10,10), etable = (z=rand(100),w=1:100))
  viz(d, variable = :z)
  viz(d, variable = :w)
  viz(d, colormap = :inferno)

  # Data over point set
  d = meshdata(PointSet(rand(Point2,100)), etable = (z=rand(100),))
  viz(d)
  viz(d, colormap = :inferno)
end
