using Contracts
using Test

@contract function f(x)
    x+1
end
@test f(3) == 4

@contract function f2(x::Int, y::Int)
    x+y
end
@test f2(3, 4) == 7

@contract function g(x::Int, y::Int)
    requires(x < y)
    ensures(result > x)
    x^2 + y^2
end
@test g(3, 4) == 25
@test_throws Exception g(4, 3)
@test_throws Exception g(3, 0)
