console.log("wazap");


let columns = document.getElementById("columns");
let order = document.getElementById("order");
let searchButton = document.getElementById("search_button");
let addButton = document.getElementById("add_entry_button");
let table_head = document.getElementById("table_head");
let table_body = document.getElementById("table_body");
let SQLtable = document.getElementById("SQLtable").value;
let searchBar = document.getElementById("search_bar");

console.log("search bar value: " + searchBar.value)

searchButton.addEventListener("click", function() {
    addButton.style.visibility = 'visible';

    let htmlHeader = "";                                                   //the following block of code is responsible for rendering the table header
    for(let i = 0; i < columns.length; i++)
    {
        htmlHeader += "<th>" + columns[i].innerHTML + "</th>";
    }
    htmlHeader += "<th> actions </th>";
    table_head.innerHTML = htmlHeader;

    let xhr = new XMLHttpRequest();                                        //the following block of code is responsible for rendering the table body
    url = "../tableGen.php?table="+SQLtable+"&column="+columns.value+"&order="+order.value+"&searchPattern="+searchBar.value;

    xhr.open("GET", url);
    xhr.send();

    xhr.onreadystatechange = function() {
        if(this.readyState == 4 && this.status == 200)
        {
            let results = xhr.responseText;
            table_body.innerHTML = results;
        }
    }

})

searchBar.addEventListener('keypress', function (event){
    if(event.key == "Enter")
        searchButton.click();
})