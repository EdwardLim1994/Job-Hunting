<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request = json_decode(file_get_contents('php://input'));

    $checkType = $request->checkType;
    $input = $request->input;

    $sql_checkUser = "SELECT id FROM user";
    $results_checkUser  = mysqli_query($conn, $sql_checkUser);

    if (mysqli_num_rows($results_checkUser) > 0) {
        switch ($checkType) {
            case ("email"):

                $sql = "SELECT COUNT(id) as getEmail FROM user WHERE email = '$input'";
                $results = mysqli_query($conn, $sql);

                if (mysqli_num_rows($results) > 0) {
                    while ($row = mysqli_fetch_assoc($results)) {
                        $getEmail = $row['getEmail'];
                    }

                    if ($getEmail) {
                        $response = [
                            'status' => 'failed',
                            'message' => 'Email has already been used'
                        ];

                        echo json_encode($response);
                    } else {
                        $response = [
                            'status' => 'success',
                        ];

                        echo json_encode($response);
                    }
                } else {
                    $response = [
                        "status" => "error",
                        "message" => "Cannot get data from database"
                    ];
                    echo json_encode($response);
                }
                break;

            case ("username"):
                $sql = "SELECT COUNT(id) as getUsername FROM user WHERE username = '$input'";
                $results = mysqli_query($conn, $sql);

                if (mysqli_num_rows($results)) {
                    while ($row = mysqli_fetch_assoc($results)) {
                        $getEmail = $row['getUsername'];
                    }

                    if ($getEmail) {
                        $response = [
                            'status' => 'failed',
                            'message' => 'Username has already been used'
                        ];

                        echo json_encode($response);
                    } else {
                        $response = [
                            'status' => 'success',
                        ];

                        echo json_encode($response);
                    }
                } else {
                    $response = [
                        "status" => "error",
                        "message" => "Cannot get data from database"
                    ];
                    echo json_encode($response);
                }
                break;
        }
    } else {
        $response = [
            "status" => "not found",
            "message" => "No User register yet"
        ];
        echo json_encode($response);
    }
}

mysqli_close($conn);