using Literate

fl = "packaging_julia.jl"

println("File: $fl")

Literate.notebook(fl, "./", credit=false, execute=false, mdstrings=true)
