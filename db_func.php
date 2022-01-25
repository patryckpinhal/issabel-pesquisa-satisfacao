#!/usr/bin/php
<?php

function insertAvaliation($call_date, $call_id, $call_queue, $telephone, $agent, $response){
    
    include 'dbconnection.php';
    $sql = "INSERT INTO pesquisa (call_date, call_id, call_queue, telephone, agent, response) VALUES ('".trim($call_date)."', '".trim($call_id)."', '".trim($call_queue)."', '".trim($telephone)."', '".trim($agent)."', '".trim($response)."')";

    if (mysqli_query($conn, $sql)) {
        echo "Linha no banco adicionada com sucesso!\n";
    } else {
        echo "Error! linha não adicionada no banco!\n";
    }

    mysqli_close($conn);
}
?>
