<?php
// note: the first key-value pair in the json file is the primary key field and the primary key
//       the last key-value pair in the json file is the table in which we will be updating
$json_string = file_get_contents("php://input");
$json_data = json_decode($json_string, true);
$columns_to_change = array_keys($json_data); 
$values_to_update = array_values($json_data);

include "connection.php";
$table = $json_data["table"];
$query = "UPDATE " . $table . " SET ";

for($i = 1; $i < count($columns_to_change) - 1; $i++)
{
    if($i == count($columns_to_change) - 2) //if it's the last column to be updated we will omit the coma ' , ' from the end
        $query .= $columns_to_change[$i] . " = '" . $values_to_update[$i] . "' ";
    else
        $query .= $columns_to_change[$i] . " = '" . $values_to_update[$i] . "',";
}

$query .= "WHERE " . $columns_to_change[0] . " = " . $values_to_update[0];

if($connection->query($query))
    echo "row updated successfully";
?>
