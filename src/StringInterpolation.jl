module StringInterpolation

export @interpolate, interp_parse

"""
Interpolates an escaped string, e.g.

julia> x = "World"; @interpolate \"Hello \\ \b\$ \bx\"

"Hello World"
"""
macro interpolate(args...)
    return interp_parse(args...)
end

"""
String interpolation parsing

Resurrected from Julia base:
https://github.com/JuliaLang/julia/blob/deab8eabd7089e2699a8f3a9598177b62cbb1733/base/string.jl
"""
function interp_parse(s::AbstractString, unescape::Function, printer::Function)
    sx = []
    i = j = start(s)
    while !done(s,j)
        c, k = next(s,j)
        if c == '$'
            if !isempty(s[i:j-1])
                push!(sx, unescape(s[i:j-1]))
            end
            ex, j = parse(s,k,greedy=false)
            if isa(ex,Expr) && is(ex.head,:continue)
                throw(ParseError("Incomplete expression"))
            end
            push!(sx, esc(ex))
            i = j
        elseif c == '\\' && !done(s,k)
            if s[k] == '$'
                if !isempty(s[i:j-1])
                    push!(sx, unescape(s[i:j-1]))
                end
                i = k
            end
            c, j = next(s,k)
        else
            j = k
        end
    end
    if !isempty(s[i:end])
        push!(sx, unescape(s[i:j-1]))
    end
    length(sx) == 1 && isa(sx[1],ByteString) ? sx[1] :
    Expr(:call, :sprint, printer, sx...)
end

interp_parse(s::AbstractString, u::Function) = interp_parse(s, u, print)
interp_parse(s::AbstractString) = interp_parse(s, x -> isvalid(String,unescape_string(x)) ? unescape_string(x) : error("Invalid UTF-8 sequence"))

end
