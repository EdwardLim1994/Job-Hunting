<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $request = json_decode(file_get_contents('php://input'));

    $name = $request->name;
    $email = $request->email;
    $username = $request->username;
    $role = $request->role;
    $password = $request->password;
    $token = substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyz"), 0, 6);

    $sql = "INSERT INTO user (name, email, username, role, password, token) VALUES ('$name', '$email', '$username', '$role', '$password', '$token')";

    if (mysqli_query($conn, $sql)) {

        $sql = "SELECT id, role from user ORDER BY id DESC LIMIT 1";

        $results = mysqli_query($conn, $sql);
        if (mysqli_num_rows($results) > 0) {
            $id = 0;
            $role = "";

            while ($row = mysqli_fetch_assoc($results)) {
                $id = $row['id'];
                $role = $row['role'];
            }

            $response = [
                "status" => "success",
                "data" => [
                    "id" => $id,
                    "role" => $role,
                    "token" => $token
                ]
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