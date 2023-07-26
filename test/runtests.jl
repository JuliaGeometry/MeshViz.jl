using MeshViz
using Meshes
using CategoricalArrays
using Unitful
using Dates
using ReferenceTests
using ImageIO
using Random
using Test

import GLMakie as Mke

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
  @test_reference "data/pset2D-5.png" viz(p, color = :red, alpha = 0.5)
  @test_reference "data/pset2D-6.png" viz(p, color = 1:4, alpha = 0.5)

  # 3D point set
  p = PointSet(Point3[(0.,0.,0.), (1.,0.,0.), (1.,1.,0.), (0.,1.,0.),
                      (0.,0.,1.), (1.,0.,1.), (1.,1.,1.), (0.,1.,1.)])
  @test_reference "data/pset3D-1.png" viz(p)
  @test_reference "data/pset3D-2.png" viz(p, color = :red)
  @test_reference "data/pset3D-3.png" viz(p, color = 1:8)
  @test_reference "data/pset3D-4.png" viz(p, color = 1:8, colorscheme = :inferno)
  @test_reference "data/pset3D-5.png" viz(p, color = :red, alpha = 0.5)
  @test_reference "data/pset3D-6.png" viz(p, color = 1:8, alpha = 0.5)

  # 1D Cartesian grid
  d = CartesianGrid(10)
  @test_reference "data/grid1D-1.png" viz(d)
  @test_reference "data/grid1D-2.png" viz(d, color = :red)

  # 2D Cartesian grid
  d = CartesianGrid(10,10)
  @test_reference "data/grid2D-1.png" viz(d)
  @test_reference "data/grid2D-2.png" viz(d, showfacets = true)
  @test_reference "data/grid2D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/grid2D-4.png" viz(d, color = 1:100)
  @test_reference "data/grid2D-5.png" viz(d, color = 1:100, colorscheme = :inferno)
  @test_reference "data/grid2D-6.png" viz(d, color = :red)
  @test_reference "data/grid2D-7.png" viz(d, color = :red, alpha = 0.5)
  @test_reference "data/grid2D-8.png" viz(d, color = 1:100, alpha = 0.5)
  @test_reference "data/grid2D-9.png" viz(d, color = 1:100, showfacets = true)
  @test_reference "data/grid2D-10.png" viz(d, color = 1:100, showfacets = true, facetcolor = :red)
  @test_reference "data/grid2D-11.png" viz(d, showfacets = true, segmentsize = 5)
  @test_reference "data/grid2D-12.png" viz(d, showfacets = true, facetcolor = :red, segmentsize = 5)

  # 3D Cartesian grid
  d = CartesianGrid(10,10,10)
  @test_reference "data/grid3D-1.png" viz(d)
  @test_reference "data/grid3D-2.png" viz(d, showfacets = true)
  @test_reference "data/grid3D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/grid3D-4.png" viz(d, color = 1:1000)
  @test_reference "data/grid3D-5.png" viz(d, color = 1:1000, colorscheme = :inferno)
  @test_reference "data/grid3D-6.png" viz(d, color = :red)
  @test_reference "data/grid3D-7.png" viz(d, color = :red, alpha = 0.5)
  @test_reference "data/grid3D-8.png" viz(d, color = 1:1000, alpha = 0.5)
  @test_reference "data/grid3D-9.png" viz(d, color = 1:1000, showfacets = true)
  @test_reference "data/grid3D-10.png" viz(d, color = 1:1000, showfacets = true, facetcolor = :red)
  @test_reference "data/grid3D-11.png" viz(d, showfacets = true, segmentsize = 5)
  @test_reference "data/grid3D-12.png" viz(d, showfacets = true, facetcolor = :red, segmentsize = 5)

  # 2D chain
  c = Rope((0.,0.), (1.,0.5), (1.,1.), (2.,0.))
  @test_reference "data/chain2D-1.png" viz(c)
  @test_reference "data/chain2D-2.png" viz(c, color = :orange)
  c = Ring((0.,0.), (1.,0.5), (1.,1.), (2.,0.))
  @test_reference "data/chain2D-3.png" viz(c)
  @test_reference "data/chain2D-4.png" viz(c, color = :orange)
  @test_reference "data/chain2D-5.png" viz(c, segmentsize = 5)
  @test_reference "data/chain2D-6.png" viz(c, color = :orange, segmentsize = 5)
  c = Rope((1.,0.5), (1.,1.), (2.,0.), (0.,0.))
  @test_reference "data/chain2D-7.png" viz(c, showfacets = true)
  @test_reference "data/chain2D-8.png" viz(c, showfacets = true, facetcolor = :red)
  @test_reference "data/chain2D-9.png" viz(c, showfacets = true, pointsize = 20)
  @test_reference "data/chain2D-10.png" viz(c, showfacets = true, facetcolor = :red, pointsize = 20)

  # 2D N-gons
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  @test_reference "data/tri2D-1.png" viz(t)
  @test_reference "data/tri2D-2.png" viz(t, showfacets = true)
  @test_reference "data/tri2D-3.png" viz(t, color = :orange)
  @test_reference "data/tri2D-4.png" viz(t, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/tri2D-5.png" viz(t, color = :orange, alpha = 0.5)
  @test_reference "data/tri2D-6.png" viz(t, showfacets = true, segmentsize = 5)
  @test_reference "data/tri2D-7.png" viz(t, showfacets = true, facetcolor = :red, segmentsize = 5)
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  @test_reference "data/quad2D-1.png" viz(q)
  @test_reference "data/quad2D-2.png" viz(q, showfacets = true)
  @test_reference "data/quad2D-3.png" viz(q, color = :orange)
  @test_reference "data/quad2D-4.png" viz(q, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/quad2D-5.png" viz(q, color = :orange, alpha = 0.5)
  @test_reference "data/quad2D-6.png" viz(q, showfacets = true, segmentsize = 5)
  @test_reference "data/quad2D-7.png" viz(q, showfacets = true, facetcolor = :red, segmentsize = 5)

  # 3D N-gons
  o = Octagon([(0.0,0.0,1.0), (0.5,-0.5,0.0), (1.0,0.0,0.0), (1.5,0.5,-0.5),
               (1.0,1.0,0.0), (0.5,1.5,0.0), (0.0,1.0,0.0), (-0.5,0.5,0.0)])
  @test_reference "data/oct3D-1.png" viz(o)
  @test_reference "data/oct3D-2.png" viz(o, showfacets = true)
  @test_reference "data/oct3D-3.png" viz(o, color = :orange)
  @test_reference "data/oct3D-4.png" viz(o, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/oct3D-5.png" viz(o, color = :orange, alpha = 0.5)

  # Polygonal areas
  Random.seed!(2020)
  p = PolyArea((0.,0.), (0.5,-1.5), (1.,0.), (1.5,0.5),
               (1.,1.), (0.5,1.5), (-0.5,0.5))
  @test_reference "data/poly2D-1.png" viz(p)      
  @test_reference "data/poly2D-2.png" viz(p, showfacets = true)
  @test_reference "data/poly2D-3.png" viz(p, color = :orange)
  @test_reference "data/poly2D-4.png" viz(p, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/poly2D-5.png" viz(p, color = :orange, alpha = 0.5)

  # Multi-geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  m = Multi([t, q])
  @test_reference "data/multi2D-1.png" viz(m)      
  @test_reference "data/multi2D-2.png" viz(m, showfacets = true)
  @test_reference "data/multi2D-3.png" viz(m, color = :orange)
  @test_reference "data/multi2D-4.png" viz(m, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/multi2D-5.png" viz(m, color = :orange, alpha = 0.5)

  # 2D boxes
  b = Box((0.,0.), (1.,1.))
  @test_reference "data/box2D-1.png" viz(b)      
  @test_reference "data/box2D-2.png" viz(b, showfacets = true)
  @test_reference "data/box2D-3.png" viz(b, color = :orange)
  @test_reference "data/box2D-4.png" viz(b, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/box2D-5.png" viz(b, color = :orange, alpha = 0.5)

  # 3D boxes
  b = Box((0.,0.,0.), (1.,1.,1.))
  @test_reference "data/box3D-1.png" viz(b)
  @test_reference "data/box3D-2.png" viz(b, color = :orange)
  @test_reference "data/box3D-3.png" viz(b, color = :orange, alpha = 0.5)

  # 2D bezier
  b = BezierCurve((0.,0.), (1.,0.), (1.,1.))
  @test_reference "data/bezier2D-1.png" viz(b)
  @test_reference "data/bezier2D-2.png" viz(b, color = :orange)
  @test_reference "data/bezier2D-3.png" viz(b, color = :orange, alpha = 0.5)

  # 3D bezier
  b = BezierCurve((0.,0.,0.), (1.,0.,0.), (1.,1.,1.))
  @test_reference "data/bezier3D-1.png" viz(b)
  @test_reference "data/bezier3D-2.png" viz(b, color = :orange)
  @test_reference "data/bezier3D-3.png" viz(b, color = :orange, alpha = 0.5)

  # 2D balls
  b = Ball((0.,0.), 1.)
  @test_reference "data/ball2D-1.png" viz(b)
  @test_reference "data/ball2D-2.png" viz(b, showfacets = true)
  @test_reference "data/ball2D-3.png" viz(b, color = :orange)
  @test_reference "data/ball2D-4.png" viz(b, color = :cyan, showfacets = true, facetcolor = :red)
  @test_reference "data/ball2D-5.png" viz(b, color = :orange, alpha = 0.5)

  # 2D spheres
  s = Sphere((0.,0.), 1.)
  @test_reference "data/sphere2D-1.png" viz(s)
  @test_reference "data/sphere2D-2.png" viz(s, color = :orange)
  @test_reference "data/sphere2D-3.png" viz(s, color = :orange, alpha = 0.5)

  # 3D spheres
  s = Sphere((0.,0.,0.), 1.)
  @test_reference "data/sphere3D-1.png" viz(s)
  @test_reference "data/sphere3D-2.png" viz(s, color = :orange)
  @test_reference "data/sphere3D-3.png" viz(s, color = :orange, alpha = 0.5)

  # cylinders
  c = Cylinder(1.)
  @test_reference "data/cylinder3D-1.png" viz(c)
  @test_reference "data/cylinder3D-2.png" viz(c, color = :orange)
  @test_reference "data/cylinder3D-3.png" viz(c, color = :orange, alpha = 0.5)
  c = Cylinder((1.,0.,0.), (1.,1.,1.), 1.)
  @test_reference "data/cylinder3D-4.png" viz(c)
  @test_reference "data/cylinder3D-5.png" viz(c, color = :orange)
  @test_reference "data/cylinder3D-6.png" viz(c, color = :orange, alpha = 0.5)

  # cylinder surface
  c = CylinderSurface((1.,0.,0.), (1.,1.,1.), 1.)
  @test_reference "data/cylsurf3D-1.png" viz(c)
  @test_reference "data/cylsurf3D-2.png" viz(c, color = :orange)
  @test_reference "data/cylsurf3D-3.png" viz(c, color = :orange, alpha = 0.5)

  # collections of 1D geometries
  c1 = Rope((0.,0.), (1.,1.), (0.,1.))
  c2 = Rope((1.,1.), (2.,2.), (1.,2.))
  c  = GeometrySet([c1, c2])
  @test_reference "data/collec1D-1.png" viz(c)
  @test_reference "data/collec1D-2.png" viz(c, color = 1:2)
  @test_reference "data/collec1D-3.png" viz(c, color = 1:2, colorscheme = :inferno)
  @test_reference "data/collec1D-4.png" viz(c, color = [:red,:green], alpha = 0.5)
  @test_reference "data/collec1D-5.png" viz(c, color = 1:2, alpha = 0.5)

  # collections of 2D geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  d = GeometrySet([t, q])
  @test_reference "data/collec2D-1.png" viz(d)
  @test_reference "data/collec2D-2.png" viz(d, showfacets = true)
  @test_reference "data/collec2D-3.png" viz(d, showfacets = true, facetcolor = :red)
  @test_reference "data/collec2D-4.png" viz(d, color = 1:2)
  @test_reference "data/collec2D-5.png" viz(d, color = 1:2, colorscheme = :inferno)
  @test_reference "data/collec2D-6.png" viz(d, color = [:red,:green], alpha = 0.5)
  @test_reference "data/collec2D-7.png" viz(d, color = 1:2, alpha = 0.5)

  # collections of 3D multi-geometries
  b1 = Box((0.,0.,0.), (1.,1.,1.))
  b2 = Box((2.,1.,0.), (3.,2.,1.))
  s1 = Ball((3.,0.,3.), 1.)
  s2 = Ball((-1.,0.,-1.), 1.)
  m1 = Multi([b1, b2])
  m2 = Multi([s1, s2])
  d = GeometrySet([m1, m2])
  @test_reference "data/collec3D-1.png" viz(d)
  @test_reference "data/collec3D-2.png" viz(d, color = 1:2)
  @test_reference "data/collec3D-3.png" viz(d, color = 1:2, colorscheme = :inferno)
  @test_reference "data/collec3D-4.png" viz(d, color = [:red,:green], alpha = 0.5)
  @test_reference "data/collec3D-5.png" viz(d, color = 1:2, alpha = 0.5)

  # surface meshes
  s = Sphere((0.,0.,0.), 1.)
  m = discretize(s, RegularDiscretization(10))
  nv = nvertices(m)
  ne = nelements(m)
  @test_reference "data/surf3D-1.png" viz(m)
  @test_reference "data/surf3D-2.png" viz(m, color = 1:nv)
  @test_reference "data/surf3D-3.png" viz(m, color = 1:ne)
  @test_reference "data/surf3D-4.png" viz(m, color = 1:ne, showfacets = true)
  @test_reference "data/surf3D-5.png" viz(m, color = :orange, showfacets = true, facetcolor = :cyan)
  @test_reference "data/surf3D-6.png" viz(m, color = :orange, alpha = 0.5)
  @test_reference "data/surf3D-7.png" viz(m, color = 1:ne, alpha = 0.5)
  @test_reference "data/surf3D-8.png" viz(m, color = 1:ne, alpha = range(0.1, 1.0, length=ne))

  # volume meshes
  g = CartesianGrid(10,10,10)
  v = vertices(g)
  e = collect(elements(topology(g)))
  m = SimpleMesh(v, e)
  nv = nvertices(m)
  ne = nelements(m)
  @test_reference "data/vol3D-1.png" viz(m)
  @test_reference "data/vol3D-2.png" viz(m, color = 1:nv)
  @test_reference "data/vol3D-3.png" viz(m, color = 1:ne)
  @test_reference "data/vol3D-4.png" viz(m, color = :orange)
  @test_reference "data/vol3D-5.png" viz(m, color = :orange, alpha = 0.5)
  @test_reference "data/vol3D-6.png" viz(m, color = 1:ne, alpha = 0.5)
  @test_reference "data/vol3D-7.png" viz(m, color = 1:ne, alpha = range(0.1, 1.0, length=ne))

  # 2D partitions
  Random.seed!(2020)
  g = CartesianGrid(10, 10)
  p = partition(g, PlanePartition((1.,1.)))
  @test_reference "data/part2D-1.png" viz(p)
  @test_reference "data/part2D-2.png" viz(p, alpha = 0.2)

  # 3D partitions
  Random.seed!(2020)
  g = CartesianGrid(10, 10, 10)
  p = partition(g, PlanePartition((1.,1.,1.)))
  @test_reference "data/part3D-1.png" viz(p)
  @test_reference "data/part3D-2.png" viz(p, alpha = 0.5)

  # vector of points
  p = Point2[(0.,0.), (1.,0.), (1.,1.), (0.,1.)]
  @test_reference "data/points2D-1.png" viz(p)
  @test_reference "data/points2D-2.png" viz(p, color = 1:4)
  @test_reference "data/points2D-3.png" viz(p, color = 1:4, colorscheme = :inferno)
  @test_reference "data/points2D-4.png" viz(p, pointsize = 20)
  @test_reference "data/points2D-5.png" viz(p, color = :red)
  @test_reference "data/points2D-6.png" viz(p, color = :red, alpha = 0.5)
  @test_reference "data/points2D-7.png" viz(p, color = 1:4, alpha = 0.5)

  # vector of 2D geometries
  t = Triangle((1.,0.), (2.,0.), (2.,1.))
  q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
  g = [t, q]
  @test_reference "data/geoms2D-1.png" viz(g)
  @test_reference "data/geoms2D-2.png" viz(g, color = 1:2)
  @test_reference "data/geoms2D-3.png" viz(g, color = 1:2, colorscheme = :inferno)
  @test_reference "data/geoms2D-4.png" viz(g, color = :red)
  @test_reference "data/geoms2D-5.png" viz(g, color = :red, alpha = 0.5)
  @test_reference "data/geoms2D-6.png" viz(g, color = 1:2, alpha = 0.5)
  @test_reference "data/geoms2D-7.png" viz(g, showfacets = true, facetcolor = :red)

  # vector of 3D geometries
  c1 = Cylinder((0.,0.,0.), (1.,1.,0.), 2.)
  c2 = Cylinder((2.,2.,0.), (3.,3.,0.), 1.)
  g  = [c1, c2]
  @test_reference "data/geoms3D-1.png" viz(g)
  @test_reference "data/geoms3D-2.png" viz(g, color = 1:2)
  @test_reference "data/geoms3D-3.png" viz(g, color = 1:2, colorscheme = :inferno)
  @test_reference "data/geoms3D-4.png" viz(g, color = :red)
  @test_reference "data/geoms3D-5.png" viz(g, color = :red, alpha = 0.5)
  @test_reference "data/geoms3D-6.png" viz(g, color = 1:2, alpha = 0.5)

  # views of grids (optimized for performance)
  g = CartesianGrid(10,10)
  v = view(g, 1:2:100)
  @test_reference "data/gridview2D-1.png" viz(v)
  @test_reference "data/gridview2D-2.png" viz(v, color=1:50)
  @test_reference "data/gridview2D-3.png" viz(v, color=1:50, colorscheme = :inferno)
  g = CartesianGrid(10,10,10)
  v = view(g, 1:2:1000)
  @test_reference "data/gridview3D-1.png" viz(v)
  @test_reference "data/gridview3D-2.png" viz(v, color=1:500)
  @test_reference "data/gridview3D-3.png" viz(v, color=1:500, colorscheme = :inferno)

  # views of meshes
  g = CartesianGrid(10,10)
  m = convert(SimpleMesh, g)
  v = view(m, 1:2:100)
  @test_reference "data/meshview2D-1.png" viz(v)
  @test_reference "data/meshview2D-2.png" viz(v, color=1:50)
  @test_reference "data/meshview2D-3.png" viz(v, color=1:50, colorscheme = :inferno)
  g = CartesianGrid(10,10,10)
  m = convert(SimpleMesh, g)
  v = view(m, 1:2:1000)
  @test_reference "data/meshview3D-1.png" viz(v)
  @test_reference "data/meshview3D-2.png" viz(v, color=1:500)
  @test_reference "data/meshview3D-3.png" viz(v, color=1:500, colorscheme = :inferno)

  # data over grid
  d = meshdata(CartesianGrid(10,10), etable = (z=1:100,))
  @test_reference "data/griddata2D.png" viewer(d)

  # data over point set
  p = PointSet(centroid.(CartesianGrid(10,10)))
  d = meshdata(p, etable = (z=1:100,))
  @test_reference "data/psetdata2D.png" viewer(d)

  # custom values as colors
  rng = MersenneTwister(123)
  d = CartesianGrid(10,10)
  c = categorical(rand(rng, 1:4, 100))
  @test_reference "data/values-1.png" viz(d, color = c, colorscheme = :Accent_4)
  c = categorical(rand(rng, 1:10, 100))
  @test_reference "data/values-2.png" viz(d, color = c, colorscheme = :BrBG_10)
  c = [fill(missing, 50); categorical(rand(rng, 1:4, 50))]
  @test_reference "data/values-3.png" viz(d, color = c, colorscheme = :BrBG_4)
  d = CartesianGrid(2,2)
  c = [1,missing,3,missing]
  @test_reference "data/values-4.png" viz(d, color = c, colorscheme = :Accent_4)
  c = [1u"km/hr", 2u"km/hr", 3u"km/hr", 4u"km/hr"]
  @test_reference "data/values-5.png" viz(d, color = c, colorscheme = :viridis)
  c = [DateTime(2023,1,1), DateTime(2023,1,2), DateTime(2023,1,3), DateTime(2023,1,4)]
  @test_reference "data/values-6.png" viz(d, color = c, colorscheme = :viridis)
  c = [Date(2023,1,1), Date(2023,1,2), Date(2023,1,3), Date(2023,1,4)]
  @test_reference "data/values-7.png" viz(d, color = c, colorscheme = :viridis)
end
