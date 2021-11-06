<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $id = $_POST['deleteJobID'];
    $deleteType = $_POST['userRole'];
    $userID = $_POST['userID'];

    switch ($deleteType) {
        case ("employer"):
            $sql = "DELETE FROM job WHERE id = $id";

            if (mysqli_query($conn, $sql)) {
                header("Location: " . FRONTEND_URL . "/profile.html#notify/job/delete/employer/success");
            } else {
                header("Location: " . FRONTEND_URL . "/profile.html#notify/job/delete/employer/failed");
            }
            break;

        case ("employee"):
            $sql = "DELETE FROM savedjob WHERE job_id = $id";

            if (mysqli_query($conn, $sql)) {
                header("Location: " . FRONTEND_URL . "/profile.html#notify/job/delete/employee/success");
            } else {
                header("Location: " . FRONTEND_URL . "/profile.html#notify/job/delete/employee/failed");
            }
            break;
    }
}

mysqli_close($conn);
