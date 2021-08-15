A =
[
    13 11 12 22
    -1 -1 -3 -4
    -4 -2 -2 -9
    -8 -2  0 -5
     0 -6 -7 -4
]

open(io -> write(io, A), "abc", "w")

B = Matrix{Int64}(undef, (5, 4))
open(io -> read!(io, B), "abc", "r")
# B = reshape(B', 5, 4) if file matrix was row major

rm("abc")
display(B)