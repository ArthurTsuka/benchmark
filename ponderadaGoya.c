#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

// Função para criação da lista, com numero aleatorios, entre 0 e 1.000.000
void criar_lista(int *lista, int n) {
    for (int i = 0; i < n; i++) {
        lista[i] = rand() % 1000000;
    }
}

// Nessa função, foi realizado a soma de todos os elementos da lista sem o uso da paralelização.
long soma(int *lista, int n) {
    long soma = 0;

    for (int i = 0; i < n; i++) {
        soma += lista[i];
    }

    return soma;
}
// Nessa função, foi realizado a paralelização para realizar a soma de todos os elementos da lista.
long soma_paralela(int *lista, int n) {
    long soma = 0;

    // Indicando que a paralelização irá ocorrer no for.
    #pragma omp parallel for reduction(+:soma)
    for (int i = 0; i < n; i++) {
        soma += lista[i];
    }

    return soma;
} 


int main() {
    int n = 100000000;     //Quantidade de Número
    int *lista = (int *)malloc(n * sizeof(int));    // Alocação da memória necessária para a lista (Quantidade de números x bytes(inteiro))
    
    srand(time(NULL));
    criar_lista(lista, n);

    // Calcular o tempo de processamento sem a utilização do paralelismo
    double tempo_inicial = omp_get_wtime();
    long soma_sem_paralelo = soma(lista, n);
    double tempo_soma_sem_paralelo = omp_get_wtime() - tempo_inicial;
    printf("Tempo soma sem paralelo: %f segundos\n", tempo_soma_sem_paralelo);

    // Calcular o tempo de processamento usando o paralelismo
    double tempo_inicial2 = omp_get_wtime();
    long soma_com_paralelo = soma_paralela(lista, n);
    double tempo_soma_com_paralelo = omp_get_wtime() - tempo_inicial2;
    printf("Tempo soma com paralelo: %f segundos\n", tempo_soma_com_paralelo);

    // Verificação se as somas de ambas as lista estão iguais.
    printf("Soma sem paralelo: %ld\n", soma_sem_paralelo);
    printf("Soma com paralelo: %ld\n", soma_com_paralelo);

    // Limpando a memória alocada para a lista;
    free(lista);
    return 0;
}


