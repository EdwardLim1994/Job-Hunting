<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST' and isset($_POST)) {

    $id = $_POST['updateJobID'];
    $position = $_POST['updateJobPosition'];
    $salary = $_POST['updateJobSalary'];
    $experience = $_POST['updateJobExperience'];
    $description = $_POST['updateJobDescription'];
    $requirement = $_POST['updateJobRequirement'];

    $sql = "UPDATE job SET position = '$position', salary = $salary, experience = $experience, description = '$description', requirement ='$requirement' WHERE id = $id;";

    if (mysqli_query($conn, $sql)) {
        header("Location: " . FRONTEND_URL . "/profile.html#notify/job/update/success");
    } else {
        header("Location: " . FRONTEND_URL . "/profile.html#notify/job/update/failed");
    }
}


mysqli_close($conn);