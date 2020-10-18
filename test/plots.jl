using Yao

n=3
results = zero_state(n) |>
    repeat(n, H) |>
    r -> measure(r, nshots=10000)

plot(results)