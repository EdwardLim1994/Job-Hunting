<?php

require_once "../connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $getType = $_POST['getType'];

    switch ($getType) {
        case ('getAll'):
            $limit = $_POST['limit'];
            $offset = (int)$_POST['offset'] * $limit;
            $sql = "SELECT * FROM job LIMIT $limit OFFSET $offset";
            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];
                    $companyID = $row['company_id'];

                    $sql_company = "SELECT name, profile FROM company WHERE id = $companyID";
                    $results_company = mysqli_query($conn, $sql_company);
                    if (mysqli_num_rows($results_company) > 0) {
                        while ($row = mysqli_fetch_assoc($results_company)) {
                            $name = $row['name'];
                            $profile = $row['profile'];
                        }
                    }
                    $item = [
                        'id' => $id,
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => nl2br($description),
                        'requirement' => nl2br($requirement),
                        'postDate' => $postDate,
                        'company' => $name,
                        'profile' => $profile
                    ];

                    array_push($data, $item);
                }

                $response = [
                    "status" =>  "success",
                    "data" => $data
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "data" => [],
                    "message" => "Not more data to find"
                ];
                echo json_encode($response);
            }

            break;

        case ('getSearch'):
            $limit = $_POST['limit'];
            $keyword = $_POST['searchTerm'];
            $offset = (int)$_POST['offset'] * $limit;
            $sql = "SELECT * FROM job WHERE position LIKE '%$keyword%' LIMIT $limit OFFSET $offset";
            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];
                    $companyID = $row['company_id'];

                    $sql_company = "SELECT name, profile FROM company WHERE id = $companyID";
                    $results_company = mysqli_query($conn, $sql_company);
                    if (mysqli_num_rows($results_company) > 0) {
                        while ($row = mysqli_fetch_assoc($results_company)) {
                            $name = $row['name'];
                            $profile = $row['profile'];
                        }
                    }
                    $item = [
                        'id' => $id,
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => nl2br($description),
                        'requirement' => nl2br($requirement),
                        'postDate' => $postDate,
                        'company' => $name,
                        'profile' => $profile
                    ];

                    array_push($data, $item);
                }

                $response = [
                    "status" =>  "success",
                    "data" => $data
                ];
                echo json_encode($response);
            } else {

                $response = [
                    "status" => "failed",
                    "data" => [],
                    "message" => "Not more data to find"
                ];

                echo json_encode($response);
            }

            break;

        case ("getOne"):
            $jobID = $_POST['jobID'];

            $sql = "SELECT * FROM job WHERE id = $jobID";

            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results) > 0) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];
                    $companyID = $row['company_id'];
                }

                $sql_company = "SELECT * FROM company WHERE id = $companyID";
                $results_company = mysqli_query($conn, $sql_company);
                if (mysqli_num_rows($results_company) > 0) {
                    while ($row = mysqli_fetch_assoc($results_company)) {
                        $name = $row['name'];
                        $email = $row['email'];
                        $phone = $row['phone'];
                        $url = $row['url'];
                        $street = $row['street'];
                        $postcode = $row['postcode'];
                        $city = $row['city'];
                        $state = $row['state'];
                        $profile = $row['profile'];
                    }

                    $response = [
                        "status" =>  "success",
                        "data" => [
                            "company" => [
                                'name' => $name,
                                'email' => $email,
                                'phone' => $phone,
                                'url' => $url,
                                'street' => $street,
                                'postcode' => $postcode,
                                'city' => $city,
                                'state' => $state,
                                'profile' => $profile
                            ],
                            "job" => [
                                'position' => $position,
                                'salary' => $salary,
                                'experience' => $experience,
                                'description' => nl2br($description),
                                'requirement' => nl2br($requirement),
                                'postDate' => $postDate
                            ]
                        ]
                    ];
                    echo json_encode($response);
                } else {
                    $response = [
                        "status" => "failed",
                        "message" => "Company not found"
                    ];
                }
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Job not found"
                ];
            }
            break;

        case ("getAllJobCount"):
            $currentRows = $_POST['currentRows'];
            $user_id = $_POST['user_id'];
            $sql = "SELECT COUNT(id) as totalRows FROM job WHERE company_id = (SELECT id FROM company WHERE user_id = $user_id)";
            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $totalRows = $row['totalRows'];
                }
                $totalPage = ceil((int)$totalRows / (int)$currentRows);

                $response = [
                    "status" =>  "success",
                    "data" => [
                        "totalRows" => $totalRows,
                        "totalPage" => $totalPage
                    ]
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }
            break;

        case ("paginateEmployer"):
            $user_id = $_POST['userID'];
            $page = $_POST['page'];
            $row = $_POST['row'];
            $targetRows = ($row * $page) - $row;
            $totalRow = $_POST['totalRow'];
            $totalPage = ceil((int)$totalRow / (int)$row);

            $sql = "SELECT * FROM job WHERE company_id = (SELECT id FROM company WHERE user_id = $user_id) LIMIT $targetRows , $row";

            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];

                    $item = [
                        'id' => $id,
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => $description,
                        'requirement' => $requirement,
                        'postDate' => $postDate,
                    ];

                    array_push($data, $item);
                }
                $response = [
                    "status" =>  "success",
                    "data" => $data,
                    "totalPage" => $totalPage,
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }

            break;

        case ("searchJobByEmployer"):
            $user_id = $_POST['userID'];
            $searchTerm = $_POST['searchTerm'];
            $currentRows = $_POST['currentRows'];

            $sql = "SELECT *, COUNT(id) as totalRows FROM job WHERE position LIKE '%$searchTerm%' AND company_id = (SELECT id FROM company WHERE user_id = $user_id) LIMIT $currentRows";

            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];
                    $totalRows = $row['totalRows'];

                    $item = [
                        'id' => $id,
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => $description,
                        'requirement' => $requirement,
                        'postDate' => $postDate,

                    ];

                    array_push($data, $item);
                }
                $response = [
                    "status" =>  "success",
                    "data" => $data,
                    "totalRows" => $totalRows,
                    "totalPage" => ceil((int)$totalRows / (int)$currentRows)
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }
            break;

        case ('getAllByEmployer'):
            $user_id = $_POST['user_id'];
            $currentRows = $_POST['currentRows'];
            $sql = "SELECT * FROM job WHERE company_id = (SELECT id FROM company WHERE user_id = $user_id) LIMIT $currentRows";

            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $postDate = $row['postDate'];

                    $item = [
                        'id' => $id,
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => $description,
                        'requirement' => $requirement,
                        'postDate' => $postDate,
                    ];

                    array_push($data, $item);
                }

                $response = [
                    "status" =>  "success",
                    "data" => $data
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }

            break;

        case ('getOneByEmployer'):
            $id = $_POST['jobID'];

            $sql = "SELECT * FROM job WHERE id = $id";
            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results) > 0) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                }


                $response = [
                    "status" =>  "success",
                    "data" => [
                        'position' => $position,
                        'salary' => $salary,
                        'experience' => $experience,
                        'description' => $description,
                        'requirement' => $requirement
                    ]
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }

            break;

        case ("getAllSavedJobCount"):
            $currentRows = $_POST['currentRows'];
            $user_id = $_POST['user_id'];
            $sql = "SELECT COUNT(job_id) as totalRows FROM savedjob WHERE user_id = $user_id";
            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                while ($row = mysqli_fetch_assoc($results)) {
                    $totalRows = $row['totalRows'];
                }
                $totalPage = ceil((int)$totalRows / (int)$currentRows);

                $response = [
                    "status" =>  "success",
                    "data" => [
                        "totalRows" => $totalRows,
                        "totalPage" => $totalPage
                    ]
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }
            break;

        case ('getAllByEmployee'):
            $user_id = $_POST['user_id'];
            $currentRows = $_POST['currentRows'];
            $sql = "SELECT job.* FROM job RIGHT JOIN savedjob ON job.id = savedjob.job_id WHERE savedjob.user_id = $user_id LIMIT $currentRows";
            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $company_id = $row['company_id'];

                    $sql_company = "SELECT name, url, profile FROM company WHERE id = $company_id";
                    $results_company = mysqli_query($conn, $sql_company);
                    if (mysqli_num_rows($results_company) > 0) {
                        while ($row = mysqli_fetch_assoc($results_company)) {
                            $name = $row['name'];
                            $url = $row['url'];
                            $profile = $row['profile'];
                        }

                        $item = [
                            'id' => $id,
                            'position' => $position,
                            'salary' => $salary,
                            'experience' => $experience,
                            'description' => nl2br($description),
                            'requirement' => nl2br($requirement),
                            'company_name' => $name,
                            'company_url' => $url,
                            'company_profile' => $profile
                        ];

                        array_push($data, $item);
                    } else {
                        $response = [
                            "status" => "failed",
                            "message" => "Data not found"
                        ];
                        echo json_encode($response);
                    }
                }

                $response = [
                    "status" =>  "success",
                    "data" => $data
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }

            break;

        case ("paginateEmployee"):
            $user_id = $_POST['userID'];
            $page = $_POST['page'];
            $row = $_POST['row'];
            $targetRows = ($row * $page) - $row;
            $totalRow = $_POST['totalRow'];
            $totalPage = ceil((int)$totalRow / (int)$row);

            $sql = "SELECT job.* FROM job RIGHT JOIN savedjob ON job.id = savedjob.job_id WHERE savedjob.user_id = $user_id LIMIT $targetRows , $row";

            $results = mysqli_query($conn, $sql);
            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $company_id = $row['company_id'];

                    $sql_company = "SELECT name, url, profile FROM company WHERE id = $company_id";
                    $results_company = mysqli_query($conn, $sql_company);
                    if (mysqli_num_rows($results_company) > 0) {
                        while ($row = mysqli_fetch_assoc($results_company)) {
                            $name = $row['name'];
                            $url = $row['url'];
                            $profile = $row['profile'];
                        }

                        $item = [
                            'id' => $id,
                            'position' => $position,
                            'salary' => $salary,
                            'experience' => $experience,
                            'description' => $description,
                            'requirement' => $requirement,
                            'company_name' => $name,
                            'company_url' => $url,
                            'company_profile' => $profile
                        ];
                    }

                    array_push($data, $item);
                }
                $response = [
                    "status" =>  "success",
                    "data" => $data,
                    "totalPage" => $totalPage
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }

            break;

        case ("searchJobByEmployee"):
            $user_id = $_POST['userID'];
            $searchTerm = $_POST['searchTerm'];
            $currentRows = $_POST['currentRows'];

            $sql = "SELECT job.*, COUNT(job.id) as totalRows FROM job RIGHT JOIN savedjob ON job.id = savedjob.job_id WHERE savedjob.user_id = $user_id AND job.position LIKE '%$searchTerm%' LIMIT $currentRows";
            $results = mysqli_query($conn, $sql);

            if (mysqli_num_rows($results) > 0) {
                $data = [];
                while ($row = mysqli_fetch_assoc($results)) {
                    $id = $row['id'];
                    $position = $row['position'];
                    $salary = $row['salary'];
                    $experience = $row['experience'];
                    $description = $row['description'];
                    $requirement = $row['requirement'];
                    $company_id = $row['company_id'];
                    $totalRows = $row['totalRows'];

                    $sql_company = "SELECT name, url, profile FROM company WHERE id = $company_id";
                    $results_company = mysqli_query($conn, $sql_company);
                    if (mysqli_num_rows($results_company) > 0) {
                        while ($row = mysqli_fetch_assoc($results_company)) {
                            $name = $row['name'];
                            $url = $row['url'];
                            $profile = $row['profile'];
                        }

                        $item = [
                            'id' => $id,
                            'position' => $position,
                            'salary' => $salary,
                            'experience' => $experience,
                            'description' => $description,
                            'requirement' => $requirement,
                            'company_name' => $name,
                            'company_url' => $url,
                            'company_profile' => $profile
                        ];
                    }

                    array_push($data, $item);
                }
                $response = [
                    "status" =>  "success",
                    "data" => $data,
                    'totalRows' => $totalRows,
                    "totalPage" => ceil((int)$totalRows / (int)$currentRows)
                ];
                echo json_encode($response);
            } else {
                $response = [
                    "status" => "failed",
                    "message" => "Data not found"
                ];
                echo json_encode($response);
            }
            break;
    }
}


mysqli_close($conn);