#include <stdio.h>
#include "data_gen.h"

int main() {
    FILE *fp = fopen("output.yaml", "w");
    if (!fp) {
        perror("Failed to create output.yaml");
        return 1;
    }

    fprintf(fp, "- package: %s\n", PKG_0_NAME);
    fprintf(fp, "  version: %s\n", PKG_0_VERSION);
    fprintf(fp, "  commit: %s\n", PKG_0_COMMIT);
    fprintf(fp, "  date: %s\n", PKG_0_DATE);
    fprintf(fp, "  notes:\n");
    fprintf(fp, "    - %s\n", PKG_0_NOTE_0);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_1);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_2);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_3);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_4);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_5);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_6);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_7);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_8);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_9);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_10);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_11);
    fprintf(fp, "    - %s\n", PKG_0_NOTE_12);
//    fprintf(fp, "    - %s\n", PKG_0_NOTE_13);
 //   fprintf(fp, "    - %s\n", PKG_0_NOTE_14);

    fclose(fp);
    printf("output.yaml generated successfully.\n");
    return 0;
}

