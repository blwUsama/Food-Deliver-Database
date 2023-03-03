function edit_row(row, id) //this function will be called on a row when the edit button is clicked
{
    let cells = row.querySelectorAll('td')
    for(let i = 1; i < cells.length - 1; i++ )
    {
        let value = cells[i].innerHTML;
        cells[i].innerHTML = "<input type='text' value='"+value+"' style='max-width: "+cells[i].offsetWidth+"px'>";
    }
    let htmlbuttons = "<button class='cancel_edit' data-id='" + id + "'> <img id='cross_icon' onclick='this.parentElement.click()' src='images/cross.png'> </button>" +
                   "<button class='confirm_edit'> <img id='check_icon' onclick='this.parentElement.click()' src='images/check_mark.png'> </button>";                    
    cells[cells.length - 1].innerHTML = htmlbuttons;
}

function cancel_edit(row, id) //this function will be called on a row when the cancel button is clicked 
{
    let cells = row.querySelectorAll("td");
    for(let i = 1; i < cells.length - 1; i++)
    {
        let value = cells[i].querySelector("input").defaultValue;
        cells[i].innerHTML = value;
    }
    let htmlbuttons = "<button onclick='delete_row(\"partner\", " + id + ")'>" +
                        "<img id='delete_icon' src='images/delete_icon.png'> </button>" +
                      "<button class='edit_button' data-id='" + id + "'> " +
                        "<img id='edit_icon' onclick='this.parentElement.click()' src='images/edit_icon.png'> </button>";
    cells[cells.length - 1].innerHTML = htmlbuttons;
}

function confirm_edit(row, id) //this function will be called when the confirm edit button is clicked
{
    let ids = row.querySelectorAll(".primary_key");
    let inputs = row.querySelectorAll("input"); //7 - count(primary_keys) inputs
    let sqlColumns = new Array();
    let sqlValues = new Array();

    sqlColumns.push(columns[0].value);              //the id column gets omitted because it doesn't turn into an input, 
    sqlValues.push(ids[0].innerHTML);     //so we include it in the json file outside the for loop
    
    console.log(inputs);

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
    dictionary['table'] = "partner"; 

    let json = JSON.stringify(dictionary);
    let xhr = new XMLHttpRequest();
    let url = "edit.php";
    xhr.open("POST", url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(json);

    xhr.onreadystatechange = function(){
        if(this.readyState == 4 && this.status == 200)
        {
            let cells = row.querySelectorAll("td");
            for(let i = 1; i < cells.length - 1; i++)
            {
                let value = cells[i].querySelector("input").defaultValue;
                cells[i].innerHTML = sqlValues[i];
            }
            let htmlbuttons = "<button onclick='delete_row(\"partner\", " + id + ")'>" +
                                "<img id='delete_icon' src='images/delete_icon.png'> </button>" +
                              "<button class='edit_button' data-id='" + id + "'> " +
                                "<img id='edit_icon' onclick='this.parentElement.click()' src='images/edit_icon.png'> </button>";
            cells[cells.length - 1].innerHTML = htmlbuttons;
        }
        if(this.readyState == 4 && this.status == 500)
        {
            alert("invalid changes, please check inputs")
        }
    }

}

table_body.addEventListener("click", function(event){
    if(event.target.className == "edit_button")
    {
        let target = event.target;
        let row = target.closest("tr");
        let id = target.dataset.id;
        edit_row(row, id);
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
        console.log("confirm button pressed");
        let target = event.target;
        let row = target.closest("tr");
        let id = target.dataset.id;
        confirm_edit(row, id);
    }

})
