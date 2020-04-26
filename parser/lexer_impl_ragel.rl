#include <cstring>
#include <cstdio>
#include <string>

using namespace std;

%%{
    machine foo;
    main := ( 'foo' | 'bar' ) %eof{ sawFooOrBar = true; };
}%%

%% write data;

int main(int argc, char **argv) {
    bool sawFooOrBar = false;
    if (argc > 1) {
        string_view arg1 = argv[1];
        int cs = 0;
        auto p = arg1.begin();
        auto pe = arg1.end();
        auto eof = arg1.end();
        %% write init;
        %% write exec;
    }
    printf("result = %s\n", (sawFooOrBar ? "true" : "false"));
    return 0;
}
