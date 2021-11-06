<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request = json_decode(file_get_contents('php://input'));

    $id = $request->id;
    $token = $request->token;

    $sql = "SELECT COUNT(id) as getUser, role FROM user WHERE id = $id AND token = '$token'";
    echo $sql;
    $results = mysqli_query($conn, $sql);

    if (mysqli_num_rows($results) > 0) {

        while ($row = mysqli_fetch_assoc($results)) {
            $getUser = $row['getUser'];
            $role = $row['role'];
        }
        if ($getUser > 0) {
            $response = [
                "status" => "success",
                "data" => [
                    "role" => $role
                ]
            ];

            echo json_encode($response);
        } else {
            $response = [
                "status" => "failed",
            ];

            echo json_encode($response);
        }
    } else {
        $response = [
            "status" => "failed",
            "message" => "Failed to get data from database"
        ];

        echo json_encode($response);
    }
}

mysqli_close($conn);