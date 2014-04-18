#ifndef DOUBLE_METAPHONE__H
#define DOUBLE_METAPHONE__H


typedef struct
{
    char *str;
    int length;
    int bufsize;
    int free_string_on_destroy;
}
metastring;      


void
DoubleMetaphone(const char *str,
                char **codes);


#endif /* DOUBLE_METAPHONE__H */
