"""
    blochAngles(sv::Array{<:Number,1})

Convert a single qubit state vector represented as an array with two elements
and convert it to the [Bloch
angles](https://en.wikipedia.org/wiki/Bloch_sphere#Definition) ``\\theta``,
``\\phi`` and the unmeasurable global phase ``\\gamma``.

```@example
θ, ϕ = blochAngles([1/√2, -/√2])
```

```@example
θ, ϕ, γ = blochAngles([im/√2, -im/√2])
```
"""
function blochAngles(sv::Array{<:Number,1})
    γ = angle(sv[1])
    sv *= exp(-im*γ)
    θ = 2acos(min(1.0,real(sv[1])))
    ϕ = imag(log(sv[2]/sin(θ/2)))
    θ, ϕ, γ
end

"""
    drawBlochSphere(reg::ArrayReg)

Draws a single qubit as a Bloch sphere.
"""
function drawBlochSphere(reg::ArrayReg{1,T,Array{T,2}}) where T<:Number
    @assert nqubits(reg) == 1
    θ, ϕ = blochAngles(statevec(reg))
    drawBlochSphere(θ, ϕ)
end