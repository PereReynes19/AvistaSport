<?php 
  $db = "camaras"; //database name
  $dbuser = "root"; //database username
  $dbpassword = ""; //database password
  $dbhost = "localhost"; //database host

  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;

  $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);

  if(isset($_POST["username"]) && isset($_POST["password"])){
       //checking if there is POST data

       $username = $_POST["username"];
       $password = $_POST["password"];

       $username = mysqli_real_escape_string($link, $username);
       //escape inverted comma query conflict from string

       $sql = "SELECT * FROM usuarios WHERE nombre = '$username'";
       //building SQL query
       $res = mysqli_query($link, $sql);
       $numrows = mysqli_num_rows($res);
       //check if there is any row
       if($numrows > 0){
           //is there is any data with that username
           $obj = mysqli_fetch_object($res);
           //get row as object
           if(md5($password) == $obj->password){
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