<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $id = $_POST['id'];
    $name = $_POST['name'];
    $email = $_POST['email'];
    $username = $_POST['username'];
    $password = $_POST['password'] ? $_POST['password'] : "";

    $sql = $password ?
        "UPDATE user SET name = '$name', email = '$email', username = '$username', password = '$password' WHERE id = $id" :
        "UPDATE user SET name = '$name', email = '$email', username = '$username' WHERE id = $id";

    if (mysqli_query($conn, $sql)) {
        $response = [
            "status" => "success",
        ];

        echo json_encode($response);
    } else {
        $response = [
            "status" => "failed",
            "message" => "Failed to update data into database" . mysqli_error($conn)
        ];

        echo json_encode($response);
    }
}

mysqli_close($conn);