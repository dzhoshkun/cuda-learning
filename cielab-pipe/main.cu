#include <stdio.h>

int main(int argc, char *argv[])
{
    // sanity check
    if (argc != 2)
    {
        printf("Usage: %s <path-to-image>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // all good
    return EXIT_SUCCESS;
}

