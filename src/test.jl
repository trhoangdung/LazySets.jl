export foo

"""
This is a very nice function.
"""
function foo(::Vector{N}, ::N) where {N<:Signed}
    println("foo_signed")
end

"""
This is a very poor function.
"""
function foo(::Vector{N}, ::N) where {N<:AbstractFloat}
    println("foo_float")
end
