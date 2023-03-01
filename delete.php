<?php
include "connection.php";

if(isset($_GET['table'], $_GET['id']))
{
    $query = "DELETE FROM " . $_GET['table'] . " WHERE partner_id = " . $_GET['id'];

    if ($connection->query($query)) {
        echo "Row deleted successfully.";
    } else {
        echo "Error deleting row: " . mysqli_error($connection);
    }
}
?>