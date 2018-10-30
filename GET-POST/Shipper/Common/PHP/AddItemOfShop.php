<?php
$mysqli = mysqli_connect("mysql.hostinger.vn", "u443919026_app", "lequydon123", "u443919026_hieu");

$startPoint = $_POST["startPoint"];
$lastPoint = $_POST["lastPoint"];
$price = $_POST["price"];
$content = $_POST["content"];
$phonenumber = $_POST["phonenumber"];
// $arrdata = array();
if ($mysqli) {
    if ($result = $mysqli->query("INSERT INTO Items (startPoint, lastPoint, price, content,statusItem,phonenumber) VALUES ('$startPoint','$lastPoint','$price','$content','waiting','$phonenumber')")) {
            echo json_encode ("thanh cong");
        }
    else { 
        echo json_encode ("k insert dc");
    }
}
else {
    echo json_encode ("k ket noi dc");
}

mysqli_close($mysqli);
?>
