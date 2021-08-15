import numpy as np

A = np.random.rand(2, 2).astype(float)
print(A)

with open("abc", "wb") as f:
    f.write(A)

with open("abc", mode = "rb") as f:
    A = np.frombuffer(f.read(), dtype = float).reshape(2, 2) 
    # A = A.T.reshape(2, 2) if file matrix was column major
    print(A)