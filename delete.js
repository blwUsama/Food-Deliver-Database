function delete_row(table, id){
    if(confirm("Are you sure you wish to delete entry ?"))
    {
        xhr = new XMLHttpRequest();
        url = "delete.php?table=" + table + "&id=" + id;
        xhr.open("GET", url);
        xhr.send();
        xhr.onreadystatechange = function()
        {
            if(xhr.readyState == 4 && xhr.status == 200)
            button.click();
        }
    }
}