USE [IRDCOL]
SELECT
ROW_NUMBER() over ( order by Declaracion.Id) as Num,
Declaracion.Id,
Sucursales.Nombre as Regional,
Coalesce(grupos.Descripcion,'') as Grupo,
Fuentes.Descripcion as Fuente,
LFuentes.Descripcion as Lugar_Fuente,
dbo.ConvertirFecha(Declaracion.Fecha_Radicacion) as Fecha_Radicacion,
dbo.ConvertirFecha(Declaracion.Fecha_Declaracion) as Fecha_Declaracion,
dbo.ConvertirFecha(Declaracion.Fecha_Desplazamiento) as Fecha_Desplazamiento,
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
--Coalesce(Barrio.Descripcion,'') as Barrio,
Coalesce(Personas.Edad,'') as Edad,
dbo.ConvertirFecha(Personas.Fecha_Nacimiento) as Fecha_Nacimiento,
Coalesce(Generos.Descripcion ,'') as Genero,
Coalesce(Declaracion.Gestantes,0) as Gestantes,
Coalesce( Declaracion.Menores_Ninas,0)  + Coalesce(Declaracion.Menores_Ninos,0) as Niños_Menores,
Coalesce(Declaracion.Recien_Nacidos,0) as Recien_Nacidos,
Coalesce(Declaracion.Lactantes,0) as Lactantes,
Coalesce(Declaracion.Resto_Nucleo,0) as Resto_Nucleo,
Coalesce(Atendidos.Descripcion,'') as ATE, 
dbo.ConvertirFecha(Declaracion.Fecha_Valoracion) as Fecha_Atencion,
Coalesce(NoAtencion.Descripcion,'') as Motivo_No_Atencion,
--
coalesce(EstadoVUR.Descripcion,'') as Estado_RUV,
dbo.ConvertirFecha(VUR.Fecha_Inclusion) as Fecha_Valoracion_RUV,
dbo.ConvertirFecha(VUR.Fecha_Investigacion) as Fecha_Investigacion_RUV,
--
coalesce(EstadoPAARI.Descripcion,'') as Estado_PAARI,
dbo.ConvertirFecha(PAARI.Fecha_Inclusion) as Fecha_Inclusion_PAARI,
dbo.ConvertirFecha(PAARI.Fecha_Investigacion) as Fecha_Investigacion_PAARI,
--
--
coalesce(EstadoFA.Descripcion,'') as Estado_FAccion,
dbo.ConvertirFecha(FA.Fecha_Inclusion) as Fecha_Inclusion_FAccion,
dbo.ConvertirFecha(FA.Fecha_Investigacion) as Fecha_Investigacion_FAccion,
--
coalesce(EstadoAA.Descripcion,'') as Estado_AA,
dbo.ConvertirFecha(AA.Fecha_Inclusion) as Fecha_AA,
dbo.ConvertirFecha(AA.Fecha_Investigacion) as Fecha_Investigacion_AA,
--
--
--
coalesce(EstadoNotificacion.Descripcion,'') as Estado_Notificacion,
dbo.ConvertirFecha(Notificacion.Fecha_Inclusion) as Fecha_Notificacion,
dbo.ConvertirFecha(Notificacion.Fecha_Investigacion) as Fecha_Investigacion_Notificacion

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
	and Declaracion_Unidades.Id_Unidad=32 order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoVUR on EstadoVUR.Id= VUR.Id_EstadoUnidad
--
left join Declaracion_Unidades PAARI 
	on   PAARI.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=274 order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoPAARI on EstadoPAARI.Id= PAARI.Id_EstadoUnidad
--
--
left join Declaracion_Unidades FA 
	on   FA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=273 order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoFA on EstadoFA.Id= FA.Id_EstadoUnidad
--
--
--
left join Declaracion_Unidades AA 
	on   AA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=161 order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
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
	and Declaracion_Unidades.Id_Unidad=1501 order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoNotificacion on EstadoNotificacion.Id= Notificacion.Id_EstadoUnidad


WHERE     
(Personas.Tipo = 'D')  -- declarante
And Declaracion.Fecha_Valoracion>='20141001 00:00:00'
And Declaracion.Fecha_Valoracion<='20160131 00:00:00'

--And Declaracion.Fecha_Radicacion >= '20140701 00:00:00' --'29.09.2014 00:00:00' --'2014.09.29 00:00:00'
--And Declaracion.Fecha_Radicacion <= '20160131 23:59:59'
and (
	Declaracion.Id_Regional=1637  -- florencia
	or Declaracion.Id_Regional=4521  -- popayan
	--or Declaracion.Id_Regional=1865 --caucasia
	) 
and Declaracion.Tipo_Declaracion='921' -- desplazado
--and EstadoPAARI.Descripcion is null
order by Declaracion.Id


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