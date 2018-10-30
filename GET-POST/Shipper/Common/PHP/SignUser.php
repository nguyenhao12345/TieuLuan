<?php
$mysqli = mysqli_connect("mysql.hostinger.vn", "u443919026_app", "lequydon123", "u443919026_hieu");
$target_dir    = "image/";
$domain = "http://appnhacdat.pe.hu/";
$target_file   = $target_dir . basename($_FILES["name"]["name"]);
$phonenumber = $_POST["phonenumber"];
$passwd = $_POST["passwd"];
$nameType = $_POST["nameType"];
$nameUser = $_POST["nameUser"];
if ($mysqli) {
    if ($result = $mysqli->query("SELECT phonenumber FROM User WHERE phonenumber = '".$phonenumber."'")) {
        $tam = 0;
        while($row = mysqli_fetch_array($result, MYSQLI_BOTH)){ 
            if ($row["phonenumber"] != NULL) {
                $tam = 1;
                break;
            }
        }
        if ($tam == 0) {
            if (move_uploaded_file($_FILES["name"]["tmp_name"], $target_file)){
                $urlImage = $domain.$target_file;
                if ($result2 = $mysqli->query("INSERT INTO User (phonenumber, passwd, url_image, nameType, nameUser) VALUES ('$phonenumber','$passwd','$urlImage','$nameType','$nameUser')")) {       
                    echo json_encode ([ 
                        "phonenumber" => $phonenumber,
                        "passwd" => $passwd,
                        "url_image" => $urlImage,
                        "nameType" => $nameType,
                        "nameUser" => $nameUser
                    ]);
                }
            }
        } else {
            echo json_encode ("tam khac 0");
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



