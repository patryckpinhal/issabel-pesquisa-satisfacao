#!/usr/bin/php
<?php

    $servername = "localhost";
    $username = "user";
    $password = "senha";
    $dbname = "pesquisa_satisfacao";

    $conn = mysqli_connect($servername, $username, $password, $dbname);

    if (!$conn) {
        die("Connection failed: " . mysqli_connect_error());
    }
    else{
        echo "Conectado no banco de dados com sucesso!\n";
    }

?>
