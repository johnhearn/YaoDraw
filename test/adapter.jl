using Yao
import YaoBlocks.ConstGate.P0

# Random number example
n=4
draw(chain(n, 
    repeat(H, 1:3),
    control((2,3), 4=>X),
    put(4=>P0)))


# Prepare Greenberger–Horne–Zeilinger state with Quantum Circuit
circuit = chain(
    4,
    put(1=>X),
    repeat(H, 2:4),
    control(2, 1=>X),
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:4),
)

draw(circuit)


# QFT example
A(i, j) = control(i, j=>shift(2π/(1<<(i-j+1))))
B(n, k) = chain(n, [j==k ? put(k=>H) : A(j, k) for j in k:n if j!=k]...)
qft(n) = chain([B(n, k) for k in 1:n]...)

draw(chain(3, qft(3)))

qft(2)

dump_gate(control(2, 1, 2=>shift(2π/4)))

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
draw(grovers)



draw(chain(n, control(n, -collect(1:n-1), n=>-Z)))

draw(chain(n, gen, repeating_circuit))

reflect0 = chain(n, 
    repeat(n, X), 
    control(n, -collect(1:n-1), n=>Z), 
    repeat(n, X))

draw(reflect0)

repeating_circuit = chain(n, Uf, gen, reflect0, gen)
draw(chain(n, repeating_circuit))

mat(reflect0) ≈ mat(control(n, -collect(1:n-1), n=>-Z))

draw(1, control(n, -collect(1:n-1), n=>-X))

Scale{Val{-1},1,XGate} <: Scale{Val{-1},1,<:ConstantGate{1}}


# Battleships example
# Parameters for the board
n=2
bits = n^2 + 1
ship_locs = [2, 3]

# Define the query circuit
sqrt(gate::AbstractBlock) = matblock(√mat(X))
oracle = chain(bits, control(i, bits=>sqrt(X)) for i in ship_locs)

oracle |> draw

gen = chain(repeat(H, 1:bits-1))
controls = [control(bits, i=>X) for i in 1:bits-1]
circuit = chain(bits, gen, controls..., oracle, gen)

circuit |> draw

extra = chain(bits, put(bits=>sqrt(Y)), put(bits=>Z))
oracle2 = chain()
circuit = chain(bits, gen, controls..., extra, oracle, oracle, gen, put(bits=>sqrt(Y)))

extra |> draw

sqrt(Y)
