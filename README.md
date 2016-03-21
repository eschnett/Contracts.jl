# Contracts

[![Build Status](https://travis-ci.org/eschnett/Contracts.jl.svg?branch=master)](https://travis-ci.org/eschnett/Contracts.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/79eet0ihw3t8lyqg/branch/master?svg=true)](https://ci.appveyor.com/project/eschnett/contracts-jl/branch/master)
[![codecov.io](https://codecov.io/github/eschnett/Contracts.jl/coverage.svg?branch=master)](https://codecov.io/github/eschnett/Contracts.jl?branch=master)

Contracts provides macros for pre- and post-conditions in functions.

## Example

```Julia
@def function f(x, y)
    requires(x < y)
    ensures(result > x)
    x^2 + y^2
end
```

There is a current discussion on the Julia mailing list regarding the
names of these features. So far, the names `precondition`, `pre`,
`require`, and `requires` have been proposed.

## Future plans

- Loops: Loop invariants and loop variants
- Data structures: Data structure invariants
