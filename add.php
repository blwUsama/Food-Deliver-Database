<?php
    include "connection.php";
    $json_string = file_get_contents("php://input");

    $json_data = json_decode($json_string, true);
    $columns = array_keys($json_data);
    $values = array_values($json_data);
    $table = $json_data['table'];
    array_pop($columns);
    array_pop($values);
    $query = "INSERT INTO " . $table . "(" . implode(',', $columns) . ") VALUES ( '" . implode("','", $values) . "')";
    // echo $query;
    if($connection->query($query))
        echo "row created successfully";   
?>

