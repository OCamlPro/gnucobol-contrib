function user_login(user)
{
    document.formname.user.value = user;
    document.formname.submit();
}

function guest_login(user)
{
    document.formname.user.value = "";
    document.formname.submit();
}