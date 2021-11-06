<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request = json_decode(file_get_contents('php://input'));

    $id = $request->user_id;

    $sql = "SELECT * FROM company WHERE user_id = $id";

    $results = mysqli_query($conn, $sql);

    if (mysqli_num_rows($results) > 0) {
        while ($row = mysqli_fetch_assoc($results)) {
            $name = $row['name'];
            $email = $row['email'];
            $phone = $row['phone'];
            $url = $row['url'];
            $street = $row['street'];
            $postcode = $row['postcode'];
            $state = $row['state'];
            $profile = $row['profile'];
            $city = $row['city'];
        }
        $response = [
            "status" => "success",
            "data" => [
                "name" => $name,
                "email" => $email,
                "phone" => $phone,
                "url"   => $url,
                "street" => $street,
                "postcode" => $postcode,
                "state" => $state,
                "profile" => $profile,
                "city" => $city,
            ]
        ];
        echo json_encode($response);
    } else {
        $response = [
            "status" => "failed",
            "message" => "Data not found"
        ];
        echo json_encode($response);
    }
}

mysqli_close($conn);