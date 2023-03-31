Makie.plottype(::Triangulation) = Viz{<:Tuple{SimpleMesh}}

function _convert(::Type{SimpleMesh}, tri::Triangulation) # for plotting, we can drop some information
    # Be a bit explicit, in case of ghost triangles. Don't need to use each_solid_vertex 
    # here, any missing vertices just won't get plotted as they won't appear in any 
    # connectivities. Using it messes up the order anyway (each_solid_vertex accesses in a 
    # different order than 1, 2, ….)
    points = Meshes.Point2[]
    triangles = NTuple{3,Int64}[]
    for p in DelaunayTriangulation.each_point(tri)
        push!(points, Meshes.Point2(p))
    end
    for τ in DelaunayTriangulation.each_solid_triangle(tri)
        ijk = DelaunayTriangulation.indices(τ)
        push!(triangles, ijk)
    end
    triangles = connect.(triangles, Triangle)
    return SimpleMesh(points, triangles)
end
Makie.convert_arguments(::Type{<:Viz}, tri::Triangulation) = (_convert(SimpleMesh, tri),)

function _convert(::Type{Chain}, ch::DelaunayTriangulation.ConvexHull)
    points = Meshes.Point2[]
    for i in DelaunayTriangulation.get_indices(ch)
        p = DelaunayTriangulation.get_point(DelaunayTriangulation.get_points(ch), i)
        push!(points, Point2(p))
    end
    return Chain(points)
end
Makie.convert_arguments(::Type{<:Viz}, ch::DelaunayTriangulation.ConvexHull) = (_convert(Chain, ch),)

#=
points = [0.0 3.0 2.0 -1.0 4.0 -2.0 2.0 5.0; 1.0 -1.0 0.0 2.0 2.0 -1.0 1.0 1.0]
tri = triangulate(points)
_mesh = convert(SimpleMesh, tri)
@test _mesh.vertices == Meshes.Point2.(eachcol(points))
@test _mesh.topology.connec == connect.(get_triangles(tri), Triangle)

fig, ax, sc = viz(_mesh, showfacets=true)
ax2 = Axis(fig[1, 2])
triplot!(ax2, tri)

fig
=#