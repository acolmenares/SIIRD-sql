/****** Script for SelectTopNRows command from SSMS  ******/
use IRDSEG
SELECT 
      Login,
      Nombre_Completo,
      Contrasena,
      Correo,
      Perfiles.Descripcion as Perfil, Perfiles.Administrador,
      Sucursales.Descripcion as Sucursal,
      Activo
      
  FROM Usuarios
  left join Sucursales  on Sucursales.Id= Usuarios.Id_Sucursal
  left join Perfiles on Perfiles.Id= Usuarios.Id_Perfil
  order by Activo desc,Usuarios.Id, Perfiles.Descripcion