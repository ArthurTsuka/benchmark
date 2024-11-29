import random
import threading
import time
import multiprocessing as mp

# Função para gerar uma lista de número aleatorios, entre 1 e 99 de tamanho n. 
def criar_lista_aleatoria(n):
    data = [random.randint(1, 100) for _ in range(n)]

    return data

# Função responsável por fazer a soma da lista.
def soma_lista(data, result, index):
    soma = 0
    for _ in data:
        soma += _
    result[index] = soma

if __name__ == '__main__':
    # Tamanho das listas.
    tamanho_lista = [1000, 10000, 100000, 1000000]

    for i in tamanho_lista:

        # Qtd de Threads 
        n_processo = 3

        # Chamada da função que cria a lista.
        data = criar_lista_aleatoria(i)

        # Timestamp antes de começar a somatoria
        t1 = time.time()

        # Divisão da lista de acordo a quantidade de processos definido.
        chunk_size = (len(data) + n_processo - 1) // n_processo
        chunks = [data[i * chunk_size:(i + 1) * chunk_size] for i in range(n_processo)]

        results = mp.Array('i', n_processo)
        t = []

        # Criação e execução dos processos
        for thread_id in range(n_processo):
            t.append(mp.Process(target=soma_lista, args=(chunks[thread_id], results, thread_id)))

        for x in t:
            x.start()
        
        for x in t:
            x.join()
        
        # Somatoria das listas(já somadas) de cada thread.
        total_sum = sum(results)

        # Timestamp depois de realizar todas as somas.
        t2 = time.time()
        print("Quantidade de Numeros na lista = ", i)
        print("Tempo de duracao = ", t2 - t1)
        print("Soma total:", total_sum)
