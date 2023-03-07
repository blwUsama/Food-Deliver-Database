/* this file will handle all operations that edit rows beside deleting a row. 
// it will handle editing a row, confirming the edit, canceling the edit,
// it will also handle adding a new row, confirming the addition, canceling the addition
*/ 

function delete_row(row)
{
    if(confirm("are you sure you wish to delete entry?"))
    {
    let id = row.querySelector(".primary_key").innerHTML;
    let id_field = columns[0].value;
    let SQLtable = document.getElementById("SQLtable").value;

    let url = "../delete.php?table=" + SQLtable + "&id=" + id + "&id_field=" + id_field;
    xhr = new XMLHttpRequest();
    xhr.open("GET", url);
    xhr.send()
    xhr.onreadystatechange = function (){
        if(this.readyState == 4 && this.status == 200)
        {
            searchButton.click();
        }
    }
    }
}

function inputs2data(row, values)       // this function will be called anytime a row of inputs must be turned back to a row of data
                                         // it must also change the cross and check buttons to delete and edit buttons
                                         // will be used in cancel_edit(), confirm_edit(), confirm_add()
                                         // the 'values' parameter must be an array of length == cells.length - 1
{
    let inputs = row.querySelectorAll("input");
    let cells = row.querySelectorAll("td");
    let primaryKeyCount = cells.length - inputs.length - 1;
    // console.log("inside inputs2data");
    for(let i = primaryKeyCount; i < cells.length ; i++)
    {
        // console.log("i = "+i+"  cells[i].innerHTML = "+cells[i].innerHTML);
        cells[i].innerHTML = values[i - primaryKeyCount];
    }
    let htmlbuttons = "<button class='delete_button'> <img id='delete_icon' onclick='this.parentElement.click()' src='../images/delete_icon.png'> </button>" +
                      "<button class='edit_button'> <img id='edit_icon' onclick='this.parentElement.click()' src='../images/edit_icon.png'> </button>";
    cells[cells.length - 1].innerHTML = htmlbuttons;
    // console.log("finished inputs2data");
}

function edit_row(row) //this function will be called on a row when the edit button is clicked
{
    let cells = row.querySelectorAll('td');
    let id = row.querySelector(".primary_key");
    for(let i = 1; i < cells.length - 1; i++ )
    {
        let value;
        if(cells[i].innerHTML != 'NULL')
        value = cells[i].innerHTML;
        cells[i].innerHTML = "<input type='text' value='"+value+"' style='max-width: " + cells[i].offsetWidth + "px'>";


    }
    let htmlbuttons = "<button class='cancel_edit'> <img id='cross_icon' onclick='this.parentElement.click()' src='../images/cross.png'> </button>" +
                      "<button class='confirm_edit'> <img id='check_icon' onclick='this.parentElement.click()' src='../images/check_mark.png'> </button>";                    
    cells[cells.length - 1].innerHTML = htmlbuttons;
}

function cancel_edit(row) //this function will be called to cancel an edit action
{
    let inputs = row.querySelectorAll("input");
    let values = new Array();
    for(let i = 0; i < inputs.length; i++)
    {
        values.push(inputs[i].defaultValue);
    }

    inputs2data(row, values);
}

function confirm_edit(row) // this function will be called to confirm an edit action, 
                               // the new values are sent to edit.php via XMLHttpRequest in the form of a json file
{
    let SQLtable = document.getElementById("SQLtable").value;
    let id = row.querySelector(".primary_key");
    let inputs = row.querySelectorAll("input");
    let sqlColumns = new Array();
    let sqlValues = new Array();

    sqlColumns.push(columns[0].value);        //the id column gets omitted because it doesn't turn into an input, 
    sqlValues.push(id.innerHTML);         //so we include it in the json file outside the for loop
    
    for(let i = 1 ; i < columns.length; i++) //columns is defined in search.js
    {
        sqlColumns.push(columns[i].value)
        sqlValues.push(inputs[i - 1].value);
    }

    let dictionary = {};
    for (let i = 0; i < sqlColumns.length; i++)
    {
        dictionary[sqlColumns[i]] = sqlValues[i];
    }
    dictionary['table'] = SQLtable; //the last key value pair will represent the table in which we'll be modifying

    let json = JSON.stringify(dictionary);
    let xhr = new XMLHttpRequest();
    let url = "../edit.php";
    xhr.open("POST", url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(json);

    xhr.onreadystatechange = function(){
        if(this.readyState == 4 && this.status == 200)
        {
            sqlValues.shift();              // inputs2data's values.length must be == the number of inputs on the row, whereas sqlValues exceeds that
            inputs2data(row, sqlValues);    // with 1 because it also contains the primary key on the first position, which shouldn't be turned to an input
        }
        if(this.readyState == 4 && this.status == 500)
        {
            alert("invalid changes, please check inputs")
        }
    }

}

function confirm_add(row)
{
    let SQLtable = document.getElementById("SQLtable").value;
    let inputs = row.querySelectorAll("input");
    let sqlColumns = new Array();
    let sqlValues = new Array();
    let dictionary = {};

    for (let i = 0; i < inputs.length; i++)
    {
        sqlColumns.push(columns[i].value);
        sqlValues.push(inputs[i].value);
        dictionary[sqlColumns[i]] = sqlValues[i];
    }
    dictionary['table'] = SQLtable;
    let json = JSON.stringify(dictionary);

    let xhr = new XMLHttpRequest();
    let url = "add.php";
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send(json);
    xhr.onreadystatechange = function() {
        if(this.readyState == 4 && this.status == 200)
        {
            inputs2data(row, sqlValues);
            console.log(this.responseText);
            searchButton.click();

        }
    }

}

addButton.addEventListener("click", function(){  //this function will be called to add a new row

    let table = document.getElementById("HTMLtable");
    let header_row = document.getElementById("table_head"); //we only need the header cells for reference to set
    let header_cells = header_row.querySelectorAll("th");   //the new row's text inputs widths

    let row = table.insertRow(1);
    for(let i = 0; i < columns.length; i++)
    {
        let cell = row.insertCell(i);
        cell.innerHTML = "<input type='text' style='max-width:" + header_cells[i].offsetWidth + "px'>";

    }

    let cell = row.insertCell(columns.length) //inserting the action buttons
    cell.innerHTML =  "<button class='cancel_add'> <img id='cross_icon' onclick='this.parentElement.click()' src='../images/cross.png'> </button>" +
                      "<button class='confirm_add'> <img id='check_icon' onclick='this.parentElement.click()' src='../images/check_mark.png'> </button>";   
})

table_body.addEventListener("click", function(event){
    if(event.target.className == "delete_button")
    {
        let target = event.target;
        let row = target.closest("tr");
        delete_row(row);
    }

    if(event.target.className == "edit_button")
    {
        let target = event.target;
        let row = target.closest("tr");
        edit_row(row);
    }

    if(event.target.className == "cancel_edit")
    {
        let target = event.target;
        let row = target.closest("tr");
        let id = target.dataset.id;
        cancel_edit(row, id);
    }

    if(event.target.className == "confirm_edit")
    {
        let target = event.target;
        let row = target.closest("tr");
        let id = target.dataset.id;
        confirm_edit(row, id);
    }

    if(event.target.className == "cancel_add")
    {
        let target = event.target;
        let row = target.closest("tr");
        row.remove();
    }

    if(event.target.className == "confirm_add")
    {
        console.log("confirm add pressed");
        let target = event.target;
        let row = target.closest("tr");
        confirm_add(row);
    }

})
