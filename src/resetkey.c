#include <stdio.h>
#include <stdint.h>
#include <time.h>

int main(int argc, char *argv[]) {
  if (argc > 1) {
    uint64_t t;
    // timestamp
    t = (uint64_t) time(0);
    // to ms
    t *= 1000;
    // invert bytes
    t = ~t;

    char *b = (char *) &t;
    b += 7;

    // write to file (reverse bytes)
    FILE *f = fopen(argv[1], "w");
    if (f) {
      for (uint32_t i = 0; i < 8; ++i) {
        fwrite(b - i, 1, 1, f);
      }

      fclose(f);
    } else {
      printf("Can't open/create evaluation key file.\n");
    }

    printf("Evaluation key file updated.\n");
  } else {
    printf("Evaluation key file not specified.\n");
    printf("Usage:\n\tjbevalinc ~/.PyCharm2018.1/config/eval/PyCharm181.evaluation.key\n");
  }

  return 0;
}
