
<?php
// this file must only echo the table content of the partners table, if it echoes any other
// html code that will get caught in the XMLHttpRequest response as well and will result in unwanted behavior

include "connection.php";
$query_partners = "SELECT * FROM partener ORDER BY ". $_GET['column'] ." ". $_GET['order'];


$result_partners = $connection->query($query_partners);

while($partner = $result_partners->fetch_assoc())
{

  echo "<tr>";
  echo "<td>" . $partner['id_partener'] . "</td>";
  echo "<td>" . $partner['nume'] . "</td>";
  echo "<td>" . $partner['oras'] . "</td>";
  echo "<td>" . $partner['adresa'] . "</td>";
  echo "<td>" . $partner['telefon'] . "</td>";
  echo "<td>" . $partner['ora_deschidere'] . "</td>";
  echo "<td>" . $partner['ora_inchidere'] . "</td>";
  echo "<td>  <button onclick='delete_row(\"partener\", " . $partner['id_partener'] . ")'> 
                <img id=\"delete_icon\" src=\"images/delete_icon.png\"> </button> </td>";
  echo "</tr>";
  echo "</table>";
  }

?>