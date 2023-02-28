console.log("wazap");


let column = document.getElementById("columns");
let order = document.getElementById("order");
let button = document.getElementById("search_button");
let table = document.getElementById("table");

button.addEventListener("click", function() {
    let xhr = new XMLHttpRequest();
    url = "departments.php?column="+column.value+"&order="+order.value;

    xhr.open("GET", url);
    xhr.send();

    xhr.onreadystatechange = function() {
        if(this.readyState == 4 && this.status == 200)
        {
            let results = xhr.responseText;
            table.innerHTML = results;
        }
    }
})



