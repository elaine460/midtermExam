<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$sqlloadtutor = "SELECT * FROM tbl_tutors";
$results_per_page = 5;
$pageno = (int)$_POST['pageno'];

$page_first_result = ($pageno - 1) * $results_per_page;

$result = $conn->query($sqlloadtutor);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$$sqlloadtutor = $sqlloadtutor . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadtutor);
if ($result->num_rows > 0) {
    //do something
    $tutors["tutors"] = array();
    while ($row = $result->fetch_assoc()) {
        $ttlist = array();
        $ttlist['tutor_id'] = $row['tutor_id'];
        $ttlist['tutor_email'] = $row['tutor_email'];
        $ttlist['tutor_phone'] = $row['tutor_phone'];
        $ttlist['tutor_name'] = $row['tutor_name'];
        $ttlist['tutor_password'] = $row['tutor_password'];
        $ttlist['tutor_description'] = $row['tutor_description'];
        $ttlist['tutor_datereg'] = $row['tutor_datereg'];
        array_push($tutors["tutors"],$ttlist);
    }
    $response = array('status' => 'success', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page", 'data' => $tutors);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page",'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>