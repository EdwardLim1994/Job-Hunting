<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST' and isset($_POST)) {

    $profile = '';
    $sql = "";

    $name = $_POST['companyName'];
    $email = $_POST['companyEmail'];
    $phone = $_POST['companyPhone'];
    $street = $_POST['companyStreet'];
    $postcode = $_POST['companyPostcode'];
    $city = $_POST['companyCity'];
    $state = $_POST['companyState'];
    $url = $_POST['companyUrl'];
    $user_id = $_POST['user_id'];

    if (isset($_FILES['companyProfile'])) {
        switch ($_POST['postType']) {
            case ("add"):
                $temp = explode(".", $_FILES["companyProfile"]["name"]);
                $newfilename = round(microtime(true)) . '.' . end($temp);
                move_uploaded_file($_FILES["companyProfile"]["tmp_name"], "../upload/" . $newfilename);

                $profile = $newfilename;
                break;

            case ("update"):
                $sql_image = "SELECT profile FROM company WHERE user_id = $user_id";

                $results_image = mysqli_query($conn, $sql);

                if (mysqli_num_rows($results_image)) {
                    while ($row = mysqli_fetch_assoc($results_image)) {
                        $file_name = $row['profile'];
                    }
                    unlink("../upload/" . $file_name);
                    $temp = explode(".", $_FILES["companyProfile"]["name"]);
                    $newfilename = round(microtime(true)) . '.' . end($temp);
                    move_uploaded_file($_FILES["companyProfile"]["tmp_name"], "../upload/" . $newfilename);

                    $profile = $newfilename;
                } else {
                    $profile = $_POST['companyProfileUpdate'];
                }
                break;
        }
    }


    switch ($_POST['postType']) {
        case ("add"):
            $sql = "INSERT INTO company (name, email, phone, url, street, city,postcode, state, profile, user_id) VALUES ('$name','$email','$phone','$url','$street', '$city','$postcode','$state', '$profile', $user_id);";
            break;

        case ('update'):
            $sql = "UPDATE company SET name='$name', email='$email', phone='$phone', url='$url', street='$street', city='$city', postcode='$postcode', state='$state', profile='$profile' WHERE user_id = $user_id;";
            break;
    }
    echo $sql;

    if (mysqli_query($conn, $sql)) {
        switch ($_POST['postType']) {
            case ("add"):
                header("Location: " . FRONTEND_URL . "/profile.html#notify/company/add/success");
                break;

            case ("update"):
                header("Location: " . FRONTEND_URL . "/profile.html#notify/company/update/success");
                break;
        }
    } else {
        switch ($_POST['postType']) {
            case ("add"):
                header("Location: " . FRONTEND_URL . "/profile.html#notify/company/add/failed");
                break;

            case ("update"):
                header("Location: " . FRONTEND_URL . "/profile.html#notify/company/update/failed");
                break;
        }
    }
}

mysqli_close($conn);