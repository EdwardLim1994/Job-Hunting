<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST' and isset($_POST)) {
    $request = json_decode(file_get_contents('php://input'));
    $response = [];
    $job_id = $request->job_id;
    $user_id = $request->user_id;
    $option = $request->option;

    switch ($option) {
        case ("save"):
            $sql = "INSERT INTO savedjob (user_id, job_id) VALUES ($user_id, $job_id)";
            if (mysqli_query($conn, $sql)) {
                $response = [
                    "status" => "success"
                ];
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Could not save job into database"
                ];
            }
            break;

        case ("unsave"):
            $sql = "DELETE FROM savedjob WHERE job_id = $job_id";
            if (mysqli_query($conn, $sql)) {
                $response = [
                    "status" => "success"
                ];
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Could not delete job from database"
                ];
            }
            break;

        case ("get"):
            $sql = "SELECT COUNT(job_id) as found FROM savedjob WHERE user_id = $user_id AND job_id = $job_id";

            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results)) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $found = $row['found'];
                }
                if ($found) {
                    $response = [
                        "status" => "success"
                    ];
                } else {
                    $response = [
                        "status" => "failed",
                        "message" => "Not Found"
                    ];
                }
            } else {
                $response = [
                    "status" => "error",
                    "message" => "Could not get saved job from database"
                ];
            }
            break;
    }

    echo json_encode($response);
}

mysqli_close($conn);
