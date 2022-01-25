#!/usr/bin/php
<?php
include 'db_func.php';

    if (sizeof($argv)-1 == 6) {
        insertAvaliation($argv[1], $argv[2], $argv[3], $argv[4], $argv[5], $argv[6]);
    } 

    else {
        echo "Erro de parametro!\n";
        exit();
    }

?>

