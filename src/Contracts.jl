module Contracts

# function f(x,y)
#     requires(x>0)
#     requires(x<y)
#     ensures(result>0)
#     ensures(result>=x)
#     ... body ...

export @def
macro def(fun::Expr)
    @assert fun.head === :function
    @assert fun.args[1].head === :call
    decl = fun.args[1]
    name = decl.args[1]
    args = decl.args[2:end]
    argnames = []
    for arg in args
        if isa(arg, Symbol)
            push!(argnames, arg)
        else
            @assert isa(arg, Expr)
            @assert arg.head === :(::)
            push!(argnames, arg.args[1])
        end
    end
    @assert fun.args[2].head === :block
    requires = []
    ensures = []
    stmts = []
    for stmt in fun.args[2].args
        # TODO: attach LineNumberNodes to corresponding
        # requires/ensures statments; don't allow requires/ensures
        # after first body statement
        if stmt.head === :call
            if stmt.args[1] === :requires
                append!(requires, stmt.args[2:end])
            elseif stmt.args[1] === :ensures
                append!(ensures, stmt.args[2:end])
            else
                push!(stmts, stmt)
            end
        else
            push!(stmts, stmt)
        end
    end
    inner =
    Expr(:function,
         # TODO: use gensym here
         Expr(:call, symbol(name, "_impl"), args...),
         Expr(:block, stmts...))
    outer =
    Expr(:function,
         decl,
         Expr(:block,
              # TODO: use new functions `check_requires` and
              # `check_ensures` instead of `@assert`
              [Expr(:macrocall, symbol("@assert"), req) for req in requires]...,
              :(result = $(symbol(name, "_impl"))($(argnames...))),
              [Expr(:macrocall, symbol("@assert"), ens) for ens in ensures]...,
              :result))
    esc(Expr(:toplevel, inner, outer))
end

end
