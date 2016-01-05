using JSON

macro test_str(s)
    return quote
        str = @interpolate $s
        # Do what you want to do with interpolated string here.
        sprint(print,str^3)
    end
end

function test1(x)
    test"Non-standard string literal has interpolation: $x\n"
end

println("************")
println("Test Result:")
println("************")
println("Call test1(2):")
println(test1(2))
println("Call test1(Dict(:a=>2)):")
println(test1(Dict(:a=>2)))
