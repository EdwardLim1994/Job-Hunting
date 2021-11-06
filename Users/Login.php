<?php

require_once "../connect.php";


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $usernameORemail = $_POST['usernameORemail'];
    $password = $_POST['password'];
    $sql = "SELECT COUNT(id) as getUser, id, role from user WHERE username = '$usernameORemail' OR email = '$usernameORemail' AND password = '$password'";

    $results = mysqli_query($conn, $sql);
    if (mysqli_num_rows($results) > 0) {
        $id = 0;
        $role = "";
        $token = substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyz"), 0, 6);

        while ($row = mysqli_fetch_assoc($results)) {
            $getUser = $row['getUser'];
            $id = $row['id'];
            $role = $row['role'];
        }

        if ($getUser) {

            $sql = "UPDATE user SET token = '$token' WHERE id = $id";

            if (mysqli_query($conn, $sql)) {
                $response = [
                    "status" => "success",
                    "data" => [
                        "id" => $id,
                        "role" => $role,
                        "token" => $token
                    ]
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "User not found. Either password or username is wrong. Please try again"
                ];

                echo json_encode($response);
            }
        } else {
            $response = [
                "status" => "failed",
                "message" => "User not found. Either password or username is wrong. Please try again"
            ];

            echo json_encode($response);
        }
    } else {
        $response = [
            "status" => "failed",
            "message" => "Failed to insert into database"
        ];

        echo json_encode($response);
    }
}

mysqli_close($conn);