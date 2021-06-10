<?php
$servername = "localhost";
$username = "crimsonw_271738_bunshopadmin";
$password = "v3q7AYbf!m=P";
$dbname = "crimsonw_271738_bunshopdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error){
    die("Connection failed:" . $conn->connect_error);
}
?>