<?php

require_once "../connect.php";


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $request = json_decode(file_get_contents('php://input'));

    $id = $request->id;


    $sql = "UPDATE user SET token = '' WHERE id = $id";

    if (mysqli_query($conn, $sql)) {
        $response = [
            "status" => "success"
        ];

        echo json_encode($response);
    } else {
        $response = [
            "status" => "failed",
            "message" => "Failed to update database"
        ];

        echo json_encode($response);
    }
}

mysqli_close($conn);