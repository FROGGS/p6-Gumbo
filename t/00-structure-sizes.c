#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT extern
#endif

#include <gumbo.h>

#define s(name)     DLLEXPORT int sizeof_ ## name () { return sizeof(name); }

s(size_t)
s(GumboStringPiece)
s(GumboSourcePosition)
s(GumboVector)
s(GumboTag)
s(GumboNamespaceEnum)
s(GumboElement)

typedef struct {
  GumboVector children;
  GumboTag tag;
  GumboNamespaceEnum tag_namespace;
  GumboStringPiece original_tag;
  GumboStringPiece original_end_tag;
  GumboSourcePosition start_pos;
  //~ GumboSourcePosition end_pos;
  //~ GumboVector attributes;
} MyGumboTest;

s(MyGumboTest)
