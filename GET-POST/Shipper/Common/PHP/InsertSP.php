<?php
$mysqli = mysqli_connect("mysql.hostinger.vn", "u443919026_app", "lequydon123", "u443919026_hieu");
$target_dir    = "imageSP/";
$domain = "http://appnhacdat.pe.hu/";
$target_file   = $target_dir . basename($_FILES["name"]["name"]);
echo json_encode ("b");
$nameSP = $_POST["nameSP"];
$priceSP = $_POST["priceSP"];
$username = $_POST["username"];
if ($mysqli) {
    if ($result = $mysqli->query("SELECT nameSP FROM SP WHERE nameSP = '".$nameSP."'")) {
        $tam = 0;
        while($row = mysqli_fetch_array($result, MYSQLI_BOTH)) { 
            if ($row["nameSP"] != NULL) {
                $tam = 1;
                break;
            }
            else {
                echo json_encode ("nameSP = nul");
            }
        }
        if ($tam == 0) {
            if (move_uploaded_file($_FILES["name"]["tmp_name"], $target_file)){
                $urlImage = $domain.$target_file;
                if ($result2 = $mysqli->query("INSERT INTO SP (nameSP, priceSP, urlPhoto, username) VALUES ('$nameSP','$priceSP','$urlImage','$username')")) { 

                    echo json_encode ([ 
                        "nameSP" => $nameSP,
                        "priceSP" => $priceSP,
                        "urlPhoto" => $urlImage,
                        "username" => $username
                        ]);
                }
                else {
                    echo json_encode ("khong insert dc");
                }
            }
        }
        else {
            echo json_encode ("tam khac 0");
        }
        $result->close();
    } 
    else {
        echo json_encode ("cau truy van sai");
    }
}
else {
    echo json_encode ("k ket noi dc");
}
class SP {
    function SP($nameSP,$priceSP,$urlPhoto,$username){
        $this -> nameSP = $nameSP;
        $this -> priceSP = $priceSP;
        $this -> urlPhoto = $urlPhoto;
        $this -> username = $username;
    }
}
mysqli_close($mysqli);

?>
