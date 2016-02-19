USE [IRDCOL]
SELECT
ROW_NUMBER() OVER(ORDER BY Declaracion.Id) AS Numero,
Declaracion.Id,
Sucursales.Nombre as Regional,
Coalesce(grupos.Descripcion,'') as Grupo,
Fuentes.Descripcion as Fuente,
LFuentes.Descripcion as Lugar_Fuente,
iif( ISNULL(Declaracion.Fecha_Radicacion,'')='','', LEFT(CONVERT(VARCHAR, Declaracion.Fecha_Radicacion, 120), 10 )) as Fecha_Radicacion,
iif( ISNULL(Declaracion.Fecha_Declaracion,'')='','', LEFT(CONVERT(VARCHAR, Declaracion.Fecha_Declaracion, 120), 10 )) as Fecha_Declaracion,
iif( ISNULL(Declaracion.Fecha_Desplazamiento,'')='','', LEFT(CONVERT(VARCHAR, Declaracion.Fecha_Desplazamiento, 120), 10 )) as Fecha_Desplazamiento,
Declaracion.Horario as H,
TipoDeclarante.Descripcion as TipoDeclaracion,
Declaracion.Numero_Declaracion,
Personas.Primer_Apellido, 
Coalesce(Personas.Segundo_Apellido,'') as Segundo_Apellido,
Personas.Primer_Nombre, 
Coalesce(Personas.Segundo_Nombre,'') as Segundo_Nombre,
TipoIdentificacion.Descripcion as TI,
Personas.Identificacion,
Personas.Tipo,
Coalesce( Celular.Descripcion,'') as Celular,
Coalesce(Direccion.Descripcion,'') as Direccion,
Coalesce(Barrio.Descripcion,'') as Barrio,
Coalesce(Personas.Edad,'') as Edad,
iif( ISNULL(Personas.Fecha_Nacimiento,'')='','', LEFT(CONVERT(VARCHAR, Personas.Fecha_Nacimiento, 120), 10 )) as Fecha_Nacimiento,
Coalesce(Generos.Descripcion ,'') as Genero,
Coalesce(Declaracion.Gestantes,0) as Gestantes,
Coalesce( Declaracion.Menores_Ninas,0)  + Coalesce(Declaracion.Menores_Ninos,0) as Niños_Menores,
Coalesce(Declaracion.Recien_Nacidos,0) as Recien_Nacidos,
Coalesce(Declaracion.Lactantes,0) as Lactantes,
Coalesce(Declaracion.Resto_Nucleo,0) as Resto_Nucleo,
Coalesce(Atendidos.Descripcion,'') as ATE, 
iif( ISNULL(Declaracion.Fecha_Valoracion,'')='','', LEFT(CONVERT(VARCHAR, Declaracion.Fecha_Valoracion, 120), 10 )) as Fecha_Atencion,
Coalesce(NoAtencion.Descripcion,'') as Motivo_No_Atencion,
--
coalesce(EstadoVUR.Descripcion,'') as Estado_RUV,
iif( ISNULL(VUR.Fecha_Inclusion,'')='','', LEFT(CONVERT(VARCHAR, VUR.Fecha_Inclusion, 120), 10 )) as Fecha_Valoracion_RUV,
iif( ISNULL(VUR.Fecha_Investigacion,'')='','', LEFT(CONVERT(VARCHAR, VUR.Fecha_Investigacion, 120), 10 )) as Fecha_Investigacion_RUV,
--
coalesce(EstadoPAARI.Descripcion,'') as Estado_PAARI,
iif( ISNULL(PAARI.Fecha_Inclusion,'')='','', LEFT(CONVERT(VARCHAR, PAARI.Fecha_Inclusion, 120), 10 )) as Fecha_Inclusion_PAARI,
iif( ISNULL(PAARI.Fecha_Investigacion,'')='','', LEFT(CONVERT(VARCHAR, PAARI.Fecha_Investigacion, 120), 10 )) as Fecha_Investigacion_PAARI,
--
--
coalesce(EstadoFA.Descripcion,'') as Estado_FAccion,
iif( ISNULL(FA.Fecha_Inclusion,'')='','', LEFT(CONVERT(VARCHAR, FA.Fecha_Inclusion, 120), 10 )) as Fecha_Inclusion_FAccion,
iif( ISNULL(FA.Fecha_Investigacion,'')='','', LEFT(CONVERT(VARCHAR, FA.Fecha_Investigacion, 120), 10 )) as Fecha_Investigacion_FAccion,
--
--
--
coalesce(EstadoAA.Descripcion,'') as Estado_AA,
iif( ISNULL(AA.Fecha_Inclusion,'')='','', LEFT(CONVERT(VARCHAR, AA.Fecha_Inclusion, 120), 10 )) as Fecha_AA,
iif( ISNULL(AA.Fecha_Investigacion,'')='','', LEFT(CONVERT(VARCHAR, AA.Fecha_Investigacion, 120), 10 )) as Fecha_Investigacion_AA,
--
--
--
--
coalesce(EstadoNotificacion.Descripcion,'') as Estado_Notificacion,
iif( ISNULL(Notificacion.Fecha_Inclusion,'')='','', LEFT(CONVERT(VARCHAR, Notificacion.Fecha_Inclusion, 120), 10 )) as Fecha_Notificacion,
iif( ISNULL(Notificacion.Fecha_Investigacion,'')='','', LEFT(CONVERT(VARCHAR, Notificacion.Fecha_Investigacion, 120), 10 )) as Fecha_Investigacion_Notificacion

FROM         Declaracion 
INNER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join Sucursales on Sucursales.Id_Enlace=  Declaracion.Id_Regional
left join SubTablas Grupos on Grupos.Id=Declaracion.Id_Grupo
left join SubTablas Fuentes on Fuentes.Id=Declaracion.Id_Fuente
left join SubTablas LFuentes on LFuentes.Id= Declaracion.Id_lugar_fuente
left join SubTablas TipoDeclarante on TipoDeclarante.Id= Declaracion.Tipo_Declaracion
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join Personas_Contactos Celular 
	on   Celular.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=76 order by Personas_Contactos.Activo desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 order by Personas_Contactos.Activo desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 order by Personas_Contactos.Activo desc
	)
left join SubTablas Generos on Generos.Id = Personas.Id_Genero
left join SubTablas Atendidos on Atendidos.Id=Declaracion.Id_Atender
left join SubTablas NoAtencion on NoAtencion.Id= Declaracion.Id_Motivo_Noatender
left join Declaracion_Unidades VUR 
	on   VUR.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=32 order by Declaracion_Unidades.Fecha_Investigacion desc
	)
left join SubTablas EstadoVUR on EstadoVUR.Id= VUR.Id_EstadoUnidad
--
left join Declaracion_Unidades PAARI 
	on   PAARI.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=274 order by Declaracion_Unidades.Fecha_Investigacion desc
	)
left join SubTablas EstadoPAARI on EstadoPAARI.Id= PAARI.Id_EstadoUnidad
--
--
left join Declaracion_Unidades FA 
	on   FA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=273 order by Declaracion_Unidades.Fecha_Investigacion desc
	)
left join SubTablas EstadoFA on EstadoFA.Id= FA.Id_EstadoUnidad
--
--
--
left join Declaracion_Unidades AA 
	on   AA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=161 order by Declaracion_Unidades.Fecha_Investigacion desc
	)
left join SubTablas EstadoAA on EstadoAA.Id= AA.Id_EstadoUnidad
--
--
--
--
left join Declaracion_Unidades Notificacion
	on   Notificacion.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=1501 order by Declaracion_Unidades.Fecha_Investigacion desc
	)
left join SubTablas EstadoNotificacion on EstadoNotificacion.Id= Notificacion.Id_EstadoUnidad


WHERE     
(Personas.Tipo = 'D')  
And Declaracion.Fecha_Radicacion >= '29.09.2014 00:00:00' 
And Declaracion.Fecha_Radicacion <= '31.12.2015 23:59:59'
and (Declaracion.Id_Regional=1637 or Declaracion.Id_Regional=4521 )
and Declaracion.Tipo_Declaracion='921'


/*
SELECT   Orders.OrderNumber, LineItems.Quantity, LineItems.Description
FROM     Orders
JOIN     LineItems
ON       LineItems.LineItemGUID =
         (
         SELECT  TOP 1 LineItemGUID 
         FROM    LineItems
         WHERE   OrderID = Orders.OrderID
         )
		 */