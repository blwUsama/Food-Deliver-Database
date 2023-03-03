console.log("wazap");


let columns = document.getElementById("columns");
let order = document.getElementById("order");
let button = document.getElementById("search_button");
let table_head = document.getElementById("table_head");
let table_body = document.getElementById("table_body");

button.addEventListener("click", function() {
    let htmlHeader = "";                                                   //the following block of code is responsible for rendering the table header
    for(let i = 0; i < columns.length; i++)
    {
        htmlHeader += "<th>" + columns[i].innerHTML + "</th>";
    }
    htmlHeader += "<th> actions </th>";
    table_head.innerHTML = htmlHeader;

    let xhr = new XMLHttpRequest();                                        //the following block of code is responsible for rendering the table body
    url = "partners.php?column="+columns.value+"&order="+order.value;

    xhr.open("GET", url);
    xhr.send();

    xhr.onreadystatechange = function() {
        if(this.readyState == 4 && this.status == 200)
        {
            console.log("checkpoint");
            let results = xhr.responseText;
            table_body.innerHTML = results;
        }
    }

})


