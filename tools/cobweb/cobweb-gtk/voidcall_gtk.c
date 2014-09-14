/****F* cobweb/voidcall
 *  NAME
 *    voidcall
 *  SYNOPSIS
 *    voidcall(void *gtk, int (*cobfunc)(void *))
 *  SOURCE
*/
void
voidcall(void *gtk, int (*cobfunc)(void *))
{
    if ((cobfunc) && (cobfunc(gtk))) return; else return;
}
/*
 ****
*/
