using Yao
import YaoBlocks.ConstGate.P0

# Random number example
n=4
draw(chain(n,
    repeat(H, 1:3),
    control((2,3), 4=>X),
    put(4=>P0)), width=250)


# Prepare Greenberger–Horne–Zeilinger state with Quantum Circuit
draw(chain(4,
    put(1=>X),
    repeat(H, 2:4),
    control(2, 1=>X),
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:4)), width=375)


# QFT example
A(i, j) = control(i, j=>shift(2π/(1<<(i-j+1))))
B(n, k) = chain(n, [j==k ? put(k=>H) : A(j, k) for j in k:n]...)
qft(n) = chain([B(n, k) for k in 1:n]...)

draw(chain(4, qft(4)), width=650)

#dump_gate(control(2, 1, 2=>shift(2π/4)))


# Grover's search example
using LinearAlgebra

function oracle(u::T) where T<:Unsigned
    n = ceil(Int, log(2, u)) # Use only as many bits as necessary
    v = ones(ComplexF64, 1<<n)
    v[u+1] *= -1 # Flip the value we're looking for
    matblock(Diagonal(v))
end

gen = repeat(n, H)
reflect0 = control(n, -collect(1:n-1), n=>-Z) # I-2|0><0|
Uf = oracle(0b1101)
repeating_circuit = chain(n, Uf, gen, reflect0, gen)
grovers = chain(n, gen, repeating_circuit)
draw(grovers, width=380)