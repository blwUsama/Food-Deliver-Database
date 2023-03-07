<?php
include "connection.php";

if(isset($_GET['table'], $_GET['id'], $_GET['id_field']))
{
    $query = "DELETE FROM " . $_GET['table'] . " WHERE " . $_GET['id_field'] . " = " . $_GET['id'];

    if ($connection->query($query)) {
        echo "Row deleted successfully.";
    } else {
        echo "Error deleting row: " . mysqli_error($connection);
    }
}
?>