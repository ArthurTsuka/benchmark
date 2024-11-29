# Benchmark

Tarefas: Realizar um somatorio

| Quantidade de Números  |     CuPy    |     CUDA    | OpenMP (C)  | Threads Python|
|------------------------|-------------|-------------|-------------|---------------|
| 10,000 Números         |      0.263 Segundos        |      0.00015 Segundos       |        0.015 Segundos     |        0.0035 Segundos       |
| 100,000 Números        |      0.241 Segundos       |      0.00013 Segundos       |        0.012 Segundos     |        0.004 Segundos       |
| 1,000,000 Números      |      0.273 Segundos       |      0.00023 Segundos       |        0.011 Segundos     |        0.020 Segundos       |

Foi realizado a mesma tarefa, de calcular o somatorio de uma lista de tamanho n(10000, 100000, 1000000 digitos) com abordagens diferentes.