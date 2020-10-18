# Examples

Some simple examples.

```@setup draw
push!(LOAD_PATH,"../../src/")

using Yao, YaoDraw
```

## Preparing the Greenberger–Horne–Zeilinger state

This is taken from the [Yao.jl tutorial](https://tutorials.yaoquantum.org/dev/generated/quick-start/1.prepare-ghz-state/).

```@example draw
draw(chain(4,
    put(1=>X),
    repeat(H, 2:4),
    control(2, 1=>X),
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:4)))
```

## Quantum Fourier Transform

[QFT circuit](https://tutorials.yaoquantum.org/dev/generated/quick-start/2.qft-phase-estimation/) also from the Yao.jl tutorial.

```@example draw
A(i, j) = control(i, j=>shift(2π/(1<<(i-j+1))))
B(n, k) = chain(n, [j==k ? put(k=>H) : A(j, k) for j in k:n]...)
qft(n) = chain([B(n, k) for k in 1:n]...)

draw(chain(4, qft(4)))
```

(It's clear from this that one of the important things missing from YaoDraw is being able to display the rotation angle.)

## Grover's search

This is a slightly simplified version of the [Grover circuit](https://tutorials.yaoquantum.org/dev/generated/quick-start/3.grover-search/) from the Yao.jl tutorial which I've explained in more detail in this [blog entry](https://john-hearn.info/articles/grovers-with-yao-jl).

```@example draw
using LinearAlgebra

function oracle(u::T) where T<:Unsigned
    n = ceil(Int, log(2, u)) # Use only as many bits as necessary
    v = ones(ComplexF64, 1<<n)
    v[u+1] *= -1 # Flip the value we're looking for
    matblock(Diagonal(v))
end

n = 4
gen = repeat(n, H)
reflect0 = control(n, -collect(1:n-1), n=>-Z) # I-2|0><0|
Uf = oracle(0b1101)
repeating_circuit = chain(n, Uf, gen, reflect0, gen)
grovers = chain(n, gen, repeating_circuit)
draw(grovers)
```

## A quantum die

And a simple one from [this blog post](https://john-hearn.info/articles/plot-recipe-for-yao-jl) which implements a six-sided die.

```@example draw
import YaoBlocks.ConstGate.P0

draw(chain(4,
    repeat(H, 1:3),
    control((2,3), 4=>X),
    put(4=>P0)))
```