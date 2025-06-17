let 
  tower-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeMbPVPJPwkY7AhKj1vbEPLgS9alU1hidDz6oYnVjtQ";
in
{
  "email.age".publicKeys = [ tower-key ];
}
