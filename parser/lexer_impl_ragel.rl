#include <cstring>
#include <cstdio>
#include <string>

%%{
    machine foo;
    main :=
        ( 'foo' | 'bar' )
        0 @{ sawFooOrBar = true; };
}%%

%% write data;

int main(int argc, char **argv) {
    bool sawFooOrBar = false;
    if (argc > 1) {
        int cs = 0;
        char *p = argv[1];
        char *pe = p + strlen(p) + 1;
        %% write init;
        %% write exec;
    }
    printf("result = %s\n", (sawFooOrBar ? "true" : "false"));
    return 0;
}
