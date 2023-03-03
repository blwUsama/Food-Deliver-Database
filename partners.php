<?php
// this file must only echo the table content of the partners table, if it echoes any other
// html code that will get caught in the XMLHttpRequest response as well and will result in unwanted behavior

include "connection.php";

$query_partners = "SELECT * FROM partner ORDER BY ". $_GET['column'] ." ". $_GET['order'];

$result_partners = $connection->query($query_partners);

while($partner = $result_partners->fetch_assoc())
{

  echo "<tr>";
  echo "<td class='primary_key'>" . $partner['partner_id'] . "</td>";
  echo "<td>" . $partner['name'] . "</td>";
  echo "<td>" . $partner['city'] . "</td>";
  echo "<td>" . $partner['address'] . "</td>";
  echo "<td>" . $partner['phone'] . "</td>";
  echo "<td>" . $partner['opening_time'] . "</td>";
  echo "<td>" . $partner['closing_time'] . "</td>";
  echo "<td>  <button class='delete_button'> <img id='delete_icon' onclick='this.parentElement.click()' src='images/delete_icon.png'> </button> 
              <button class='edit_button'> <img id='edit_icon' onclick='this.parentElement.click()' src='images/edit_icon.png'> </button>
        </td>";
  echo "</tr>";
  echo "</table>";
  }

?>