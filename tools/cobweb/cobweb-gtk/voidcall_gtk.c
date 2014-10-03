/****F* cobweb/voidcall_gtk
 *  Name:
 *    voidcall_gtk
 *  Purpose:
 *    wrapping void C returns in callbacks for use with COBOL and GTK+
 *  Input:
 *    GTK callback, (in this case always, voidcall_gtk)
 *    Actual COBOL callback program-pointer
 *  Output:
 *    Eat the COBOL handler stack value and return as void
 *  SOURCE
*/
void
voidcall_gtk(void *gtk, int (*cobfunc)(void *))
{
    if ((cobfunc) && (cobfunc(gtk))) return; else return;
}
/*
 ****
*/

