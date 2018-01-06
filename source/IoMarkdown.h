//metadoc copyright Ales Tsurko 2018

// don't forget the macro guard
#ifndef IOMARKDOWN_DEFINED
#define IOMARKDOWN_DEFINED 1

#include "IoObject.h"
#include "IoSeq.h"

// define a macro that can check whether an IoObject is of our type by checking whether it holds a pointer to our clone function
#define ISMarkdown(self) IoObject_hasCloneFunc_(self, (IoTagCloneFunc *)IoMarkdown_rawClone)

// declare a C type for ourselves
typedef IoObject IoMarkdown;

// define the requisite functions
IoTag    *IoMarkdown_newTag(void *state);
IoObject *IoMarkdown_proto(void *state);
IoObject *IoMarkdown_rawClone(IoMarkdown *self);
IoObject *IoMarkdown_mark(IoMarkdown *self);
void     IoMarkdown_free(IoMarkdown *self);

// define our custom C functions
IoObject *IoMarkdown_toHTML(IoMarkdown *self, IoObject *locals, IoMessage *m);

#endif
