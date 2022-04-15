using MatterEnv
using Test

@testset "MatterEnv" begin
    include("MatterBase.jl")
    include("VASP.jl")
    include("Toolkit.jl")
end
