<?php 
  $db = "camaras"; //database name
  $dbuser = "root"; //database nombre
  $dbpass = ""; //database pass
  $dbhost = "localhost"; //database host

  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;

  $link = mysqli_connect($dbhost, $dbuser, $dbpass, $db);

  if(isset($_POST["nombre"]) && isset($_POST["pass"])){
       //checking if there is POST data

       $nombre = $_POST["nombre"];
       $pass = $_POST["pass"];

       $nombre = mysqli_real_escape_string($link, $nombre);
       //escape inverted comma query conflict from string

       $sql = "SELECT * FROM usuarios WHERE nombre = '$nombre'";
       //building SQL query
       $res = mysqli_query($link, $sql);
       $numrows = mysqli_num_rows($res);
       //check if there is any row
       if($numrows > 0){
           //is there is any data with that nombre
           $obj = mysqli_fetch_object($res);
           //get row as object
           if(md5($pass) == $obj->pass){
               $return["success"] = true;
               $return["uid"] = $obj->user_id;
               $return["fullname"] = $obj->fullname;
               $return["address"] = $obj->address;
           }else{
               $return["error"] = true;
               $return["message"] = "La contraseña es incorrecta";
           }
       }else{
           $return["error"] = true;
           $return["message"] = 'Usuario no encontrado';
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Los campos no pueden estar vacios';
  }

  mysqli_close($link);

  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($return);
  //converting array to JSON string
?>