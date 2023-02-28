<?php
include "connection.php";

if(isset($_GET['table'], $_GET['id']))
{
    echo "checkpoint 1";

    $query = "DELETE FROM " . $_GET['table'] . " WHERE id_partener = " . $_GET['id'];
    // $query = "DELETE FROM partener WHERE id_partener = 1";

    if ($connection->query($query)) {
        echo "Row deleted successfully.";
    } else {
        echo "Error deleting row: " . mysqli_error($connection);
    }
    echo "checkpoint 2";
}

echo "checkpoint 3";
?>