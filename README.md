# StringInterpolation.jl

String interpolation is an awesome feature of Julia, but string interpolation for [non-standard string literals](http://docs.julialang.org/en/latest/manual/metaprogramming/#non-standard-string-literals) is not automatic and requires significant boilerplate code to make it work.

This package simply ressurects an [old Base method](https://github.com/JuliaLang/julia/blob/deab8eabd7089e2699a8f3a9598177b62cbb1733/base/string.jl#L613) `interp_parse` and adds a macro `@interpolate`. For example:

~~~julia
julia> Pkg.clone("https://github.com/EricForgy/StringInterpolation.jl.git")
julia> using StringInterpolation
julia> x = "World"
julia> @interpolate "Hello \$x"
"Hello World"
~~~

Note the `$` is escaped in the string we want to interpolate.

The intended use for this package is when building non-standard string literals. For example:

~~~julia
macro test_str(s)
    return quote
        str = @interpolate $s
        # Do what you want to do with interpolated string here.
        sprint(print,str)
    end
end
~~~

## Example

The following non-standard string literal simply makes 3 copies of the interpolated string:

~~~julia
macro triple_str(s)
    return quote
        str = @interpolate $s
        sprint(print,str^3)
    end
end
~~~

Then, you can use the macro as follows:

~~~julia
julia> x = "World"; println(triple"Hello \$x\n")
Hello World
Hello World
Hello World
~~~
