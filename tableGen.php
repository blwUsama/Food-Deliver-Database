<?php
include "connection.php";

$query_describe = "DESCRIBE " . $_GET['table'];
$result_describe = $connection->query($query_describe);
$columns = [];
$primary_key_checker = []; // boolean array, count($primary_key_checker) == count($columns)
                           // if $columns[i] is a primary key column, $primary_key_checker[i] will hold 1, it will hold 0 otherwise
while($entry = $result_describe->fetch_assoc())
{
    array_push($columns, $entry['Field']);
    if($entry['Key'] == 'PRI')
        array_push($primary_key_checker, 1);
    else
        array_push($primary_key_checker, 0);
}
// initially the query was of form : SELECT * FROM table WHERE CONCAT(col1, col2, col3 ...) LIKE '%search%pattern'
// but this query omits any rows that have a null value, so we'll be using COALESCE(col, '') to replace any null fields with an empty string
$coalesced_columns = [];
for($i = 0; $i < count($columns); $i++)
{
    array_push($coalesced_columns, "COALESCE(" . $columns[$i] . ", '')");
}

$query_data = "SELECT * FROM " . $_GET['table']; 
$query_data .= " WHERE CONCAT (" . implode(',', $coalesced_columns) . ") LIKE '%" . $_GET['searchPattern'] . "%'";
$query_data .= " ORDER BY " . $_GET['column'] . " " . $_GET['order'];
// echo $query_data;
$result_data = $connection->query($query_data);
while($row = $result_data->fetch_assoc())
{
    echo "<tr>";
    for($i = 0; $i < count($columns); $i++)
    {
        if($primary_key_checker[$i] == 1)
            echo "<td class='primary_key'>" . $row[$columns[$i]] . "</td>";
        else
            if($row[$columns[$i]])
            echo "<td>" . $row[$columns[$i]] . "</td>";
            else
            echo "<td> NULL </td>";

    }
    echo "<td style='width:75px'>  <button class='delete_button'> <img id='delete_icon' onclick='this.parentElement.click()' src='../images/delete_icon.png'> </button> 
                <button class='edit_button'> <img id='edit_icon' onclick='this.parentElement.click()' src='../images/edit_icon.png'> </button>
         </td>";
    echo "</tr>";
}
?>