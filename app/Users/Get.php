<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request = json_decode(file_get_contents('php://input'));

    $id = $request->id;

    $sql = "SELECT name, email, username FROM user WHERE id = $id";

    $results = mysqli_query($conn, $sql);

    if (mysqli_num_rows($results)) {
        while ($row = mysqli_fetch_assoc($results)) {
            $name = $row['name'];
            $email = $row['email'];
            $username = $row['username'];
        }

        $response = [
            'status' => 'success',
            'data' => [
                'name' => $name,
                'email' => $email,
                'username' => $username
            ]
        ];
        echo json_encode($response);
    } else {
        $response = [
            "status" => "error",
            "message" => "Cannot get data from database"
        ];
        echo json_encode($response);
    }
}

mysqli_close($conn);