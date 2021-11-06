<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST' and isset($_POST)) {

    $position = $_POST['addJobPosition'];
    $salary = $_POST['addJobSalary'];
    $experience = $_POST['addJobExperience'];
    $description = $_POST['addJobDescription'];
    $requirement = $_POST['addJobRequirement'];
    $userID = $_POST['userID'];

    $sql = "SELECT id FROM company WHERE user_id = $userID";
    $results = mysqli_query($conn, $sql);

    if (mysqli_num_rows($results)) {
        while ($row = mysqli_fetch_assoc($results)) {
            $companyID = $row['id'];
        }

        $sql = "INSERT INTO job (position, salary, experience, description, requirement, postDate, company_id) VALUES ('$position', $salary, $experience, '$description', '$requirement', now(), $companyID)";
        if (mysqli_query($conn, $sql)) {
            header("Location: " . FRONTEND_URL . "/profile.html#notify/job/add/success");
        } else {
            header("Location: " . FRONTEND_URL . "/profile.html#notify/job/add/failed");
        }
    } else {
        header("Location: " . FRONTEND_URL . "/profile.html#notify/job/add/failed");
    }
}
mysqli_close($conn);