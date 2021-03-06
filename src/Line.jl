import Base.∈

export Line,
       an_element

"""
    Line{N<:Real} <: LazySet{N}

Type that represents a line in 2D of the form ``a⋅x = b`` (i.e., a special case
of a `Hyperplane`).

### Fields

- `a` -- normal direction
- `b` -- constraint

### Examples

The line ``y = -x + 1``:

```jldoctest
julia> Line([1., 1.], 1.)
LazySets.Line{Float64,Array{Float64,1}}([1.0, 1.0], 1.0)
```
"""
struct Line{N<:Real, V<:AbstractVector{N}} <: LazySet{N}
    a::V
    b::N

    # default constructor with length constraint
    function Line{N, V}(a::V, b::N) where {N<:Real, V<:AbstractVector{N}}
        @assert length(a) == 2 "lines must be two-dimensional"
        @assert a != zeros(N, 2) "the normal vector of a line must not be zero"
        return new{N, V}(a, b)
    end
end

# convenience constructor without type parameter
Line(a::V, b::N) where {N<:Real, V<:AbstractVector{N}} = Line{N, V}(a, b)

# constructor from a LinearConstraint
Line(c::LinearConstraint{N}) where {N<:Real} = Line(c.a, c.b)


# --- LazySet interface functions ---


"""
    dim(L::Line)::Int

Return the ambient dimension of a line.

### Input

- `L` -- line

### Output

The ambient dimension of the line, which is 2.
"""
function dim(L::Line)::Int
    return 2
end

"""
    σ(d::AbstractVector{N}, L::Line{N}) where {N<:Real}

Return the support vector of a line in a given direction.

### Input

- `d` -- direction
- `L` -- line

### Output

The support vector in the given direction, which is defined the same way as for
the more general `Hyperplane`.
"""
function σ(d::AbstractVector{N}, L::Line{N}) where {N<:Real}
    return σ(d, Hyperplane(L.a, L.b))
end

"""
    an_element(L::Line{N})::Vector{N} where N<:Real

Return some element of a line.

### Input

- `L` -- line

### Output

An element on the line.

### Algorithm

If the ``b`` value of the line is zero, the result is the origin.
Otherwise the result is some ``x = [x1, x2]`` such that ``a·[x1, x2] = b``.
We first find out in which dimension ``a`` is nonzero, say, dimension 1, and
then choose ``x1 = 1`` and accordingly ``x2 = \\frac{b - a1}{a2}``.
"""
function an_element(L::Line{N})::Vector{N} where N<:Real
    if L.b == zero(N)
        return zeros(N, 2)
    end
    i = L.a[1] == zero(N) ? 2 : 1
    x = Vector{N}(undef, 2)
    x[3-i] = one(N)
    x[i] = (L.b - L.a[3-i]) / L.a[i]
    return x
end

"""
    ∈(x::AbstractVector{N}, L::Line{N})::Bool where {N<:Real}

Check whether a given point is contained in a line.

### Input

- `x` -- point/vector
- `L` -- line

### Output

`true` iff `x ∈ L`.

### Algorithm

The point ``x`` belongs to the line if and only if ``a⋅x = b`` holds.
"""
function ∈(x::AbstractVector{N}, L::Line{N})::Bool where {N<:Real}
    @assert length(x) == dim(L)
    return dot(L.a, x) == L.b
end
