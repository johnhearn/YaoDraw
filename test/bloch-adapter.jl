using Test

let
    Zero = [1,0]
    One = [0,1]
    I = [1 0;0 1]
    X = [0 1;1 0]
    Y = [0 -im;im 0]
    Z = [1 0;0 -1]
    H = [1 1;1 -1]/√2
    Rx(θ) = exp(-im*θ*X/2)
    Ry(θ) = exp(-im*θ*Y/2)
    Rz(θ) = exp(-im*θ*Z/2)

    θ, ϕ = blochAngles(Zero)
    @show θ, ϕ
    @test θ ≈ 0
    @test isnan(ϕ)
    θ, ϕ = blochAngles(One)
    @test θ ≈ π 
    @test ϕ ≈ 0

    θ, ϕ = blochAngles(H*Zero)
    @test θ ≈ π/2 
    @test ϕ ≈ 0 atol=1e-7
    θ, ϕ = blochAngles(H*One)
    @test θ ≈ π/2
    @test ϕ ≈ π

    θ, ϕ = blochAngles(X*Zero)
    @test θ ≈ π
    @test ϕ ≈ 0
    θ, ϕ = blochAngles(X*One)
    @test θ ≈ 0
    @test isnan(ϕ)

    θ, ϕ = blochAngles(Y*Zero)
    @test θ ≈ π
    @test ϕ ≈ π/2
    θ, ϕ = blochAngles(Y*One)
    @test θ ≈ 0
    @test isnan(ϕ)

    θ, ϕ = blochAngles(Rx(π/2)*Zero)
    @test θ ≈ π/2
    @test ϕ ≈ -π/2
    θ, ϕ = blochAngles(Rx(3π/2)*Zero)
    @test θ ≈ π/2
    @test ϕ ≈ π/2
end

using Yao

drawBlochSphere(rand_state(1))