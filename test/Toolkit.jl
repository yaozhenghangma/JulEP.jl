using MatterEnv
using Test

@testset "smear" begin
    @test 6.66448 <= gaussian(0.13, 0.1; σ=0.05) <= 6.66450
    @test 9.5492 <= lorentzian(0.11, 0.1; γ=0.03) <= 9.5494
end
