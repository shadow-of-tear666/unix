#include <pthread.h>
#include <unistd.h>
#include <cstdio>

pthread_cond_t initialize_condition = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

bool is_ready = true;

void *consumer(void *param)
{
    while (true) {
        pthread_mutex_lock(&mutex);
        while (is_ready) {
            pthread_cond_wait(&initialize_condition, &mutex);
            printf("mutex was unlocked\n");
        }
        is_ready = true;
        printf("extract\n");
        pthread_mutex_unlock(&mutex);
    }
}


void *provider(void *param)
{
    while (true) {
        pthread_mutex_lock(&mutex);
        if (! is_ready) {
            pthread_mutex_unlock(&mutex);
            continue;
        }
        is_ready = false;
        printf("Unlock\n");
        pthread_cond_signal(&initialize_condition);
        pthread_mutex_unlock(&mutex);
        sleep (1);
    }
}

int main()
{
    pthread_t thread1, thread2;
    pthread_create(&thread1, nullptr, consumer, nullptr);
    pthread_create(&thread2, nullptr, provider, nullptr);
    pthread_join(thread1, nullptr);
    pthread_join(thread2, nullptr);
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&initialize_condition);

    return 0;
}

