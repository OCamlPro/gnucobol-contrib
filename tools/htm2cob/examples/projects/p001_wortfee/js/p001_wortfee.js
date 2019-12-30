// global variable
var selected_image = 'img0';

function click_img(sel_img, ok_img)
{
    // exit, if it yet selected
    if(selected_image != 'img0') {
         return;    
    }    
    // set global variable
    selected_image = sel_img;
    
    if(sel_img == ok_img) {
        document.getElementById(sel_img).style.background = "#00FF00";
    } else {    
        document.getElementById(sel_img).style.background = "#FF0000";
        document.getElementById(ok_img).style.background = "#00FF00";
    }
}

function next_question()
{
    // exit, if it not yet selected
    if(selected_image == 'img0') {
        alert("Please select an answer!");
        return false;    
    }    

    // set value and submit form 
    document.getElementById("selected_img").value = selected_image;
    return true;    
}


