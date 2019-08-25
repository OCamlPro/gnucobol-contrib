function length_check()
{
    if (document.formname.firstname.value.length < 2)
    {
        alert("The length of first name is too short!");
        return(false);
    } 
    else if(document.formname.lastname.value.length < 2)
    {
        alert("The length of last name is too short!");
        return(false);
    }
     
    return(true);
}