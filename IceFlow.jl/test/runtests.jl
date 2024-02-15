using Test
using IceFlow

@testset "averaging" begin

    mat = [1 2 3; 7 9 11; 2 4 6]

    @test IceFlow.av(mat) == [4.75 6.25; 5.5 7.5]
    @test IceFlow.avx(mat) == [4.0 5.5 7.0; 4.5 6.5 8.5]
    @test IceFlow.avy(mat) == [ 1.5 2.5; 8.0 10.0; 3.0 5.0]

end
