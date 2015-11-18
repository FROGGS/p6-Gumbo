use lib 't';
use CompileTestLib;
use NativeCall;
use Test;

plan 19;

compile_test_lib('00-structure-sizes');
native size_t               is nativesize(64) is unsigned is Int is repr('P6int') { * };
native GumboTag             is nativesize(32) is unsigned is Int is repr('P6int') { * };
native GumboNamespaceEnum   is nativesize(32) is unsigned is Int is repr('P6int') { * };

#   typedef struct {
#    68   unsigned int line;
#    69   unsigned int column;
#    70   unsigned int offset;
#    71 } GumboSourcePosition;

class GumboSourcePosition is repr('CStruct') is export {
    has uint32  $.line;
    has uint32  $.column;
    has uint32  $.offset;
}

#   typedef struct {
#    90   const char* data;
#    91 
#    93   size_t length;
#    94 } GumboStringPiece;
#   
class GumboStringPiece is repr('CStruct') is export {
    has Str             $.data;
    has size_t          $.length;
}

#    typedef struct {
#      void** data;
#    
#      unsigned int length;
#    
#      unsigned int capacity;
#    } GumboVector;

class GumboVector is repr('CStruct') is export {
    has OpaquePointer $.data;
    has uint32        $.length;
    has uint32        $.capacity; 
}

class MyGumboTest is repr('CStruct') {
    HAS GumboVector             $.children;
    has GumboTag                $.tag;
    has GumboNamespaceEnum      $.tag_namespace;
    HAS GumboStringPiece        $.original_tag;
    HAS GumboStringPiece        $.original_end_tag;
    HAS GumboSourcePosition     $.start_pos;
    #~ HAS GumboSourcePosition     $.end_pos;
    #~ HAS GumboVector             $.attributes;
}

class GumboElement is repr('CStruct') {
    HAS GumboVector             $.children;
    has GumboTag                $.tag;
    has GumboNamespaceEnum      $.tag_namespace;
    HAS GumboStringPiece        $.original_tag;
    HAS GumboStringPiece        $.original_end_tag;
    HAS GumboSourcePosition     $.start_pos;
    HAS GumboSourcePosition     $.end_pos;
    HAS GumboVector             $.attributes;
}

for size_t,
    GumboStringPiece,
    GumboSourcePosition,
    GumboVector,
    GumboTag,
    GumboNamespaceEnum,
    MyGumboTest,
    GumboElement
{
    sub sizeof() returns int32 { ... }
    trait_mod:<is>(&sizeof, :native('./00-structure-sizes'));
    trait_mod:<is>(&sizeof, :symbol('sizeof_' ~ $_.^name));

    is nativesizeof($_), sizeof(), "sizeof($_.^name())";
}
