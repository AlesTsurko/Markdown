//metadoc Markdown copyright Ales Tsurko
//metadoc Markdown license MIT
//metadoc Markdown category API
//metadoc Markdown description Markdown parser.

#include <string.h>
#include "mkdio.h"
#include "IoSeq.h"
#include "IoState.h"
#include "IoMarkdown.h"

#define DATA(self) ((UArray *)(IoObject_dataPointer(self)))
static const char *protoId = "Markdown";

// _tag makes an IoTag for the bookkeeping of names and methods for this proto
IoTag *IoMarkdown_newTag(void *state)
{
    // first allocate a new IoTag
    IoTag *tag = IoTag_newWithName_(protoId);

    // record this tag as belonging to this VM
    IoTag_state_(tag, state);

    // give the tag pointers to the _free, _mark and _rawClone functions we'll need to use
    IoTag_freeFunc_(tag, (IoTagFreeFunc *)IoMarkdown_free);
    IoTag_markFunc_(tag, (IoTagMarkFunc *)IoMarkdown_mark);
    IoTag_cloneFunc_(tag, (IoTagCloneFunc *)IoMarkdown_rawClone);
    return tag;
}

// _proto creates the first-ever instance of the prototype 
IoObject *IoMarkdown_proto(void *state)
{
    // First we allocate a new IoObject
    IoMarkdown *self = IoObject_new(state);

    // Then tag it
    IoObject_tag_(self, IoMarkdown_newTag(state));

    // then register this proto generator
    IoState_registerProtoWithId_(state, self, protoId);

    // and finally, define the table of methods this proto supports
    // we just have one method here, returnSelf, then terminate the array
    // with NULLs
    {
        IoMethodTable methodTable[] = {
            {"toHTML", IoMarkdown_toHTML},
            {NULL, NULL},
        };
        IoObject_addMethodTable_(self, methodTable);
    }

    return self;
}

// _rawClone clones the existing proto passed as the only argument
IoObject *IoMarkdown_rawClone(IoMarkdown *proto)
{
    IoObject *self = IoObject_rawClonePrimitive(proto);
    // This is where any object-specific data would be copied
    return self;
}

// _new creates a new object from this prototype
IoObject *IoMarkdown_new(void *state)
{
    IoObject *proto = IoState_protoWithId_(state, protoId);
    return IOCLONE(proto);
}

// _mark is called when this proto is marked for garbage collection
// If this proto kept references to any other IoObjects, it should call their mark() methods as well.
IoObject *IoMarkdown_mark(IoMarkdown* self)
{
    return self;
}

// _free defines any cleanup or deallocation code to run when the object gets garbage collected
void IoMarkdown_free(IoMarkdown *self)
{
    // free dynamically allocated data and do any cleanup
}

// -------------------------------------------------------------------------------

//doc Markdown toHTML(string) Gets markdown string as input and returns generated HTML.
IoObject *IoMarkdown_toHTML(IoMarkdown *self, IoObject *locals, IoMessage *m)
{
    IoSeq *input = IoMessage_locals_seqArgAt_(m, locals, 0);
    char *html = 0;
    mkd_flag_t *flags = MKD_NOPANTS|MKD_FENCEDCODE|MKD_GITHUBTAGS|MKD_URLENCODEDANCHOR|MKD_TABSTOP;
    MMIOT *document = 0;
    IoSeq *outputSequence = IoSeq_new(IOSTATE);

    document = mkd_string(UTF8CSTRING(input), IoSeq_rawSize(input), flags);
    mkd_compile(document, flags);
    mkd_document(document, &html);

    UArray_setCString_(DATA(outputSequence), html);
    mkd_cleanup(document);

    return outputSequence;
}
