using MeshViz
using Meshes
using GeoTables
using ReferenceTests
using ImageIO
using Random
using Test

import CairoMakie as Mke

@testset "MeshViz.jl" begin
  # 1D point set
  p = PointSet(Point1[(0.,), (1.,), (2.,)])
  # TODO

  # 2D point set
  p = PointSet(Point2[(0.,0.), (1.,0.), (1.,1.), (0.,1.)])
  @test_reference "data/pset2D-1.png" viz(p)
  @test_reference "data/pset2D-2.png" viz(p, color = :red)
  @test_reference "data/pset2D-3.png" viz(p, color = 1:4)
  @test_reference "data/pset2D-4.png" viz(p, color = 1:4, colorscheme = :inferno)

  # 3D point set
  p = PointSet(Point3[(0.,0.,0.), (1.,0.,0.), (1.,1.,0.), (0.,1.,0.),
                      (0.,0.,1.), (1.,0.,1.), (1.,1.,1.), (0.,1.,1.)])
  @test_reference "data/pset3D-1.png" viz(p)
  @test_reference "data/pset3D-2.png" viz(p, color = :red)
  @test_reference "data/pset3D-3.png" viz(p, color = 1:8)
  @test_reference "data/pset3D-4.png" viz(p, color = 1:8, colorscheme = :inferno)

  # 1D Cartesian grid
  d = CartesianGrid(10)
  # TODO

  # 2D Cartesian grid
  d = CartesianGrid(10,10)
  @test_reference "data/grid2D-1.png" viz(d)
  @test_reference "data/grid2D-2.png" viz(d, showfacets = true)
  @test_reference "data/grid2D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/grid2D-4.png" viz(d, color = 1:100)
  @test_reference "data/grid2D-5.png" viz(d, color = 1:100, colorscheme = :inferno)

  # 3D Cartesian grid
  d = CartesianGrid(10,10,10)
  @test_reference "data/grid3D-1.png" viz(d)
  @test_reference "data/grid3D-2.png" viz(d, showfacets = true)
  @test_reference "data/grid3D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/grid3D-4.png" viz(d, color = 1:1000)
  @test_reference "data/grid3D-5.png" viz(d, color = 1:1000, colorscheme = :inferno)

  # 2D N-gons
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  @test_reference "data/tri2D-1.png" viz(t)      
  @test_reference "data/tri2D-2.png" viz(t, showboundary = false)
  @test_reference "data/tri2D-3.png" viz(t, color = :orange)
  @test_reference "data/tri2D-4.png" viz(t, color = :cyan, boundarycolor = :red)
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  @test_reference "data/quad2D-1.png" viz(q)      
  @test_reference "data/quad2D-2.png" viz(q, showboundary = false)
  @test_reference "data/quad2D-3.png" viz(q, color = :orange)
  @test_reference "data/quad2D-4.png" viz(q, color = :cyan, boundarycolor = :red)

  # 3D N-gons
  o = Octagon([(0.0,0.0,1.0), (0.5,-0.5,0.0), (1.0,0.0,0.0), (1.5,0.5,-0.5),
               (1.0,1.0,0.0), (0.5,1.5,0.0), (0.0,1.0,0.0), (-0.5,0.5,0.0)])
  @test_reference "data/oct3D-1.png" viz(o)
  @test_reference "data/oct3D-2.png" viz(o, showboundary = false)
  @test_reference "data/oct3D-3.png" viz(o, color = :orange)
  @test_reference "data/oct3D-4.png" viz(o, color = :cyan, boundarycolor = :red)

  # Polygonal areas
  Random.seed!(2020)
  p = PolyArea((0.,0.), (0.5,-1.5), (1.,0.), (1.5,0.5),
               (1.,1.), (0.5,1.5), (-0.5,0.5), (0.,0.))
  @test_reference "data/poly2D-1.png" viz(p)      
  @test_reference "data/poly2D-2.png" viz(p, showboundary = false)
  @test_reference "data/poly2D-3.png" viz(p, color = :orange)
  @test_reference "data/poly2D-4.png" viz(p, color = :cyan, boundarycolor = :red)

  # Multi-geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  m = Multi([t, q])
  @test_reference "data/multi2D-1.png" viz(m)      
  @test_reference "data/multi2D-2.png" viz(m, showboundary = false)
  @test_reference "data/multi2D-3.png" viz(m, color = :orange)
  @test_reference "data/multi2D-4.png" viz(m, color = :cyan, boundarycolor = :red)

  # 2D boxes
  b = Box((0.,0.), (1.,1.))
  @test_reference "data/box2D-1.png" viz(b)      
  @test_reference "data/box2D-2.png" viz(b, showboundary = false)
  @test_reference "data/box2D-3.png" viz(b, color = :orange)
  @test_reference "data/box2D-4.png" viz(b, color = :cyan, boundarycolor = :red)

  # 3D boxes
  b = Box((0.,0.,0.), (1.,1.,1.))
  @test_reference "data/box3D-1.png" viz(b)      
  @test_reference "data/box3D-2.png" viz(b, color = :orange)

  # 3D spheres
  s = Sphere((0.,0.,0.), 1.)
  @test_reference "data/sphere3D-1.png" viz(s)
  @test_reference "data/sphere3D-2.png" viz(s, color = :orange)

  # Collections of geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  d = Collection([t, q])
  @test_reference "data/collec2D-1.png" viz(d)
  @test_reference "data/collec2D-2.png" viz(d, showfacets = true)
  @test_reference "data/collec2D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/collec2D-4.png" viz(d, color = 1:2)
  @test_reference "data/collec2D-5.png" viz(d, color = 1:2, colorscheme = :inferno)

  # Simple meshes
  s = Sphere((0.,0.,0.), 1.)
  m = discretize(s, RegularDiscretization(10))
  @test_reference "data/mesh3D-1.png" viz(m)
  @test_reference "data/mesh3D-2.png" viz(m, color = 1:nvertices(m))
  @test_reference "data/mesh3D-3.png" viz(m, color = 1:nelements(m))
  @test_reference "data/mesh3D-4.png" viz(m, color = 1:nelements(m), showfacets = true)
  @test_reference "data/mesh3D-5.png" viz(m, color = :orange, showfacets = true, facetcolor = :cyan)

  # 2D partitions
  Random.seed!(2020)
  g = CartesianGrid(10, 10)
  p = partition(g, PlanePartition((1.,1.)))
  @test_reference "data/part2D-1.png" viz(p)

  # 3D partitions
  Random.seed!(2020)
  g = CartesianGrid(10, 10, 10)
  p = partition(g, PlanePartition((1.,1.,1.)))
  @test_reference "data/part3D-1.png" viz(p)

  # Vector of points
  p = Point2[(0.,0.), (1.,0.), (1.,1.), (0.,1.)]
  @test_reference "data/points2D-1.png" viz(p)
  @test_reference "data/points2D-2.png" viz(p, color = 1:4)
  @test_reference "data/points2D-3.png" viz(p, color = 1:4, colorscheme = :inferno)
  @test_reference "data/points2D-4.png" viz(p, size = 20)

  # Data over grid
  d = meshdata(CartesianGrid(10,10), etable = (z=1:100,w=1:100))
  @test_reference "data/griddata2D-1.png" viz(d, variable = :z)
  @test_reference "data/griddata2D-2.png" viz(d, variable = :w)
  @test_reference "data/griddata2D-3.png" viz(d, colorscheme = :inferno)

  # Data over point set
  p = PointSet(centroid.(CartesianGrid(10,10)))
  d = meshdata(p, etable = (z=1:100,))
  @test_reference "data/psetdata2D-1.png" viz(d)
  @test_reference "data/psetdata2D-2.png" viz(d, colorscheme = :inferno)
end
