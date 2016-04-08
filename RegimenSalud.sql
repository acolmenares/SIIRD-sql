USE [IRDCOL]

SELECT
 ROW_NUMBER() over ( order by Declaracion.Id, Personas.tipo desc, Personas.edad desc ) as Num,
 Personas.Id, 
 Declaracion.Id as Declaracion,
 Sucursales.Nombre as Regional,
Coalesce(grupos.Descripcion,'') as Grupo,
Fuentes.Descripcion as Fuente,
LFuentes.Descripcion as Lugar_Fuente,
dbo.ConvertirFecha(Declaracion.Fecha_Radicacion) as Fecha_Radicacion,
dbo.ConvertirFecha(Declaracion.Fecha_Declaracion) as Fecha_Declaracion,
dbo.ConvertirFecha(Declaracion.Fecha_Desplazamiento) as Fecha_Desplazamiento,
dbo.ConvertirFecha(Declaracion.Fecha_Valoracion) as Fecha_Atencion,
Personas.Tipo,
TipoIdentificacion.Descripcion as TI,
Personas.Identificacion,
Personas.Primer_Apellido, 
Coalesce(Personas.Segundo_Apellido,'') as Segundo_Apellido,
Personas.Primer_Nombre, 
Coalesce(Personas.Segundo_Nombre,'') as Segundo_Nombre,
Coalesce(Personas.Edad,'') as Edad,
dbo.ConvertirFecha(Personas.Fecha_Nacimiento) as Fecha_Nacimiento,
Coalesce(Generos.Descripcion ,'') as Genero,
dbo.ConcatenarNombres(Declarante.Primer_Nombre, Declarante.Segundo_Nombre, Declarante.Primer_Apellido, Declarante.Segundo_Apellido) as Nombre_Declarante,
Declarante.Identificacion as Identificacion_Declarante,

Coalesce( Celular.Descripcion,'') as Celular_Declarante,
Coalesce(Direccion.Descripcion,'') as Direccion_Declarante,
Coalesce(Barrio.Descripcion,'') as Barrio_Declarante,

Coalesce(regimen_salud_antes.Descripcion, '') as RS_Antes,
Coalesce(eps_antes.Descripcion, '') as EPS_Antes,
Coalesce(municipio_antes.Descripcion, '') as Municipio_Antes,
Coalesce(departamento_antes.Descripcion, '') as Dpto_Antes,

Coalesce(regimen_salud_primera.Descripcion, '') as RS_Primera,
Coalesce(eps_primera.Descripcion, '') as EPS_Primera,
Coalesce(municipio_primera.Descripcion, '') as Municipio_Primera,
Coalesce(departamento_primera.Descripcion, '') as Dpto_Primera,

dbo.ConvertirFecha(rs_segunda.Fecha) as Fecha_Segunda,
Coalesce(regimen_salud_segunda.Descripcion, '') as RS_Segunda,
Coalesce(eps_segunda.Descripcion, '') as EPS_Segunda,
Coalesce(municipio_segunda.Descripcion, '') as Municipio_Segunda,
Coalesce(departamento_segunda.Descripcion, '') as Dpto_Segunda,

dbo.ConvertirFecha(rs_seguimiento.Fecha) as Fecha_Seguimiento,
Coalesce(regimen_salud_seguimiento.Descripcion, '') as RS_Seguimiento,
Coalesce(eps_seguimiento.Descripcion, '') as EPS_Seguimiento,
Coalesce(municipio_seguimiento.Descripcion, '') as Municipio_Seguimiento,
Coalesce(departamento_seguimiento.Descripcion, '') as Dpto_Seguimiento,

coalesce(EstadoRUV.Descripcion,'') as Estado_RUV,
dbo.ConvertirFecha(RUV.Fecha_Inclusion) as Fecha_Valoracion_RUV,
dbo.ConvertirFecha(RUV.Fecha_Investigacion) as Fecha_Investigacion_RUV,

case rs_cerrar.Id_Cerrar when 19 then case  when (rs_cerrar.Id_Eps is null or rs_cerrar.Id_Eps= 635) then 'NO' else 'SI' end else 'NO' end as Cerrado,
dbo.ConvertirFecha(rs_cerrar.Fecha) as Fecha_Seguimiento_MR,
Coalesce(regimen_salud_seguimiento_mr.Descripcion, '') as RS_Seguimiento_MR,
Coalesce(eps_seguimiento_mr.Descripcion, '') as EPS_Seguimiento_MR,
Coalesce(municipio_seguimiento_mr.Descripcion, '') as Municipio_Seguimiento_MR,
Coalesce(Departamento_seguimiento_mr.Descripcion, '') as Dpto_Seguimiento_MR,
Coalesce(tipo_seguimiento_mr.Descripcion, '') as Tipo_Seguimiento_MR


FROM Declaracion
LEFT OUTER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join Personas Declarante on Declarante.Id_Declaracion= Personas.Id_Declaracion and Declarante.Tipo='D'

left join Sucursales on Sucursales.Id_Enlace=  Declaracion.Id_Regional
left join SubTablas Grupos on Grupos.Id=Declaracion.Id_Grupo
left join SubTablas Fuentes on Fuentes.Id=Declaracion.Id_Fuente
left join SubTablas LFuentes on LFuentes.Id= Declaracion.Id_lugar_fuente

left join Personas_Contactos Celular 
	on   Celular.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=76 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Generos on Generos.Id = Personas.Id_Genero

left join Personas_Regimen_Salud rs_antes
	on   rs_antes.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	and Personas_Regimen_Salud.Id_Tipo_Entrega=54 -- antes
	order by Personas_Regimen_Salud.Fecha desc, Personas_Regimen_Salud.Id desc
	)
left join SubTablas regimen_salud_antes on regimen_salud_antes.id= rs_antes.Id_Regimen_Salud
left join SubTablas eps_antes on eps_antes.id= rs_antes.Id_Eps
left join SubTablas municipio_antes on municipio_antes.id= rs_antes.Id_Municipio
left join SubTablas departamento_antes on departamento_antes.id= municipio_antes.Id_Padre
--
left join Personas_Regimen_Salud rs_primera
	on   rs_primera.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	and Personas_Regimen_Salud.Id_Tipo_Entrega=72 -- primera
	order by Personas_Regimen_Salud.Fecha desc, Personas_Regimen_Salud.Id desc
	)
left join SubTablas regimen_salud_primera on regimen_salud_primera.id= rs_primera.Id_Regimen_Salud
left join SubTablas eps_primera on eps_primera.id= rs_primera.Id_Eps
left join SubTablas municipio_primera on municipio_primera.id= rs_primera.Id_Municipio
left join SubTablas departamento_primera on departamento_primera.id= municipio_primera.Id_Padre
--
left join Personas_Regimen_Salud rs_segunda
	on   rs_segunda.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	and Personas_Regimen_Salud.Id_Tipo_Entrega=918 -- segunda
	order by Personas_Regimen_Salud.Fecha desc, Personas_Regimen_Salud.Id desc
	)
left join SubTablas regimen_salud_segunda on regimen_salud_segunda.id= rs_segunda.Id_Regimen_Salud
left join SubTablas eps_segunda on eps_segunda.id= rs_segunda.Id_Eps
left join SubTablas municipio_segunda on municipio_segunda.id= rs_segunda.Id_Municipio
left join SubTablas departamento_segunda on departamento_segunda.id= municipio_segunda.Id_Padre
--
left join Personas_Regimen_Salud rs_seguimiento
	on   rs_seguimiento.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	and Personas_Regimen_Salud.Id_Tipo_Entrega=919 -- seguimiento
	order by Personas_Regimen_Salud.Fecha desc, Personas_Regimen_Salud.Id desc
	)
left join SubTablas regimen_salud_seguimiento on regimen_salud_seguimiento.id= rs_seguimiento.Id_Regimen_Salud
left join SubTablas eps_seguimiento on eps_seguimiento.id= rs_seguimiento.Id_Eps
left join SubTablas municipio_seguimiento on municipio_seguimiento.id= rs_seguimiento.Id_Municipio
left join SubTablas departamento_seguimiento on departamento_seguimiento.id= municipio_seguimiento.Id_Padre

left join Declaracion_Unidades RUV 
	on   RUV.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=32 
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad

left join Personas_Regimen_Salud rs_cerrar  
	on   rs_cerrar.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	order by Personas_Regimen_Salud.Fecha desc, Personas_Regimen_Salud.Id desc
	)
left join SubTablas regimen_salud_seguimiento_mr on regimen_salud_seguimiento_mr.id= rs_cerrar.Id_Regimen_Salud
left join SubTablas eps_seguimiento_mr on eps_seguimiento_mr.id= rs_cerrar.Id_Eps
left join SubTablas municipio_seguimiento_mr on municipio_seguimiento_mr.id= rs_cerrar.Id_Municipio
left join SubTablas departamento_seguimiento_mr on departamento_seguimiento_mr.id= municipio_seguimiento_mr.Id_Padre
left join SubTablas tipo_seguimiento_mr on tipo_seguimiento_mr.id= rs_cerrar.Id_Tipo_Entrega

where declaracion.id_grupo <> 592   -- no procesado
and (Declaracion.Id_Regional=1637 or Declaracion.Id_Regional=4521 ) --or Declaracion.Id_Regional=1865)
--And Declaracion.Fecha_Radicacio >= '20151001 00:00:00' 
--And Declaracion.Fecha_Radicacion <= '20160131 23:59:59'
And Declaracion.Fecha_Valoracion >= '20151001 00:00:00' 
And Declaracion.Fecha_Valoracion <= '20160331 23:59:59'
and Declaracion.Tipo_Declaracion='921'  --desplazado
Order by personas.id_declaracion, Personas.tipo desc, Personas.edad desc

--and (rs_cerrar.Id_Cerrar!=19 or rs_cerrar.Id_Eps is null or rs_cerrar.Id_Eps=635)

