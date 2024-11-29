import cupy as cp
import numpy as np
import time

t1 = time.time()
numero =  cp.random.randint(0, 100000, size=10000)
t2 = time.time()

print(f"Soma: {sum(numero)}")
print(f"Tempo de execução: {t2-t1}")