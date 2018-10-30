<?php
$mysqli = mysqli_connect("mysql.hostinger.vn", "u443919026_app", "lequydon123", "u443919026_hieu");
$phonenumber = $_POST["phonenumber"];
if ($mysqli) {
    if ($result = $mysqli->query("SELECT phonenumber, passwd , url_image, nameType, nameUser FROM User WHERE phonenumber = '".$phonenumber."'")) {
        $tam = 0;
        while($row = mysqli_fetch_array($result, MYSQLI_BOTH)){ 
            if ($row["phonenumber"] != NULL) {
                echo json_encode ([ 
                    "phonenumber" => $phonenumber,
                    "url_image" => $row["url_image"],
                    "nameType" => $row["nameType"],
                    "passwd" => $row["passwd"],
                    "nameUser" => $row["nameUser"]
                    ]);
                $tam = 1;           //ton tai
                break;
            }
        }
        if ($tam == 0) {
            echo json_encode ("sai thong tin");
        }
        $result->close();
    } else {
        echo json_encode ("cau truy van sai");
    }
}
else {
    echo "k ket noi dc";
}
?>



