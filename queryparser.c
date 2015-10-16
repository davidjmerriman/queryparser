#include "postgres.h"

#include <ctype.h>
#include <float.h>
#include <math.h>
#include <limits.h>
#include <unistd.h>
#include <sys/stat.h>
#include "utils/memutils.h"

#include "parser/parser.h"
#include "nodes/print.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFSIZE 32768

const char* progname = "queryparser";

char* readInput(void);
bool doParse(const char* query, char* (*output_fnc)(const void*) );

char* readInput() {
    char buffer[BUFSIZE];
    size_t inputSize = 1;
    char * input = malloc(sizeof(char) * BUFSIZE);

    if (input == NULL) {
        perror("Could not allocate input string");
        exit(1);
    }

    input[0] = '\0'; // C strings are null-terminated; init zero-length string

    // Read until end of input (CTRL+D, CTRL+Z on Windows)
    while (fgets(buffer, BUFSIZE, stdin)) {
        char * old = input;
        inputSize += strlen(buffer);
        input = realloc(input, inputSize);
        if (input == NULL) {
            perror("Could not reallocate input to append buffer");
            free(old);
            exit(2);
        }
        strcat(input, buffer);
    }

    if (ferror(stdin)) {
        perror("Error reading input");
        free(input);
        exit(3);
    }

    return input;
}

bool doParse(const char* query, char* (*output_fnc)(const void*)) {
	List *tree;

	tree = raw_parser(query);

	if (tree != NULL) {
		char *s;
		s = output_fnc(tree);

		printf("%s\n", s);

		pfree(s);
	}

	return (tree != NULL);
}

int main(int argc, char **argv) {
	char* line;
	MemoryContextInit();

	if (argc > 1 &&	(strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0))	{
		printf("Parse SQL query from stdin\nUSAGE: queryparser\nOPTIONS:\n\t--json: Output in JSON format\n\t--help: Show this help\n");
		return 0;
	}

    line = readInput();

	if (argc > 1 && strcmp(argv[1], "--json") == 0)	{
		return doParse(line, &nodeToJSONString) ? 0 : 1;
	} else {
        return doParse(line, &nodeToString) ? 0 : 1;
    }
}
