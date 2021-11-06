<?php

require_once "../connect.php";


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $request = json_decode(file_get_contents('php://input'));

    $checkType = $request->checkType;
    $input = $request->input;

    switch ($checkType) {
        case ("email"):
            $sql = "SELECT COUNT(id) as getEmail FROM company WHERE email = '$input'";
            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results)) {
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

        case ("name"):
            $sql = "SELECT COUNT(id) as getCompanyName FROM company WHERE name = '$input'";
            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results)) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $getEmail = $row['getCompanyName'];
                }

                if ($getEmail) {
                    $response = [
                        'status' => 'failed',
                        'message' => 'This company name has already been used'
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
}

mysqli_close($conn);