use [IRDCOL]
declare @FechaAtencionInicial varchar (10)
declare @FechaAtencionFinal varchar (10)
declare @FechaCorte varchar (10)
set @FechaAtencionInicial='20151001'
set @FechaAtencionFinal='20160131'
set @FechaCorte=@FechaAtencionFinal

select 
Personas.Id, Declaracion.Id as Declaracion,
Coalesce(grupos.Descripcion,'') as Grupo, Sucursales.Nombre as Regional, Lentrega.Descripcion as Lugar_Entrega,
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
Coalesce( Etnias.Descripcion ,'') as Etnia,
Coalesce(Discapacitados.Descripcion ,'') as Discapacitado,
Coalesce(TipoDiscapacidad.Descripcion ,'') as TipoDiscapacidad,
Coalesce(Generos.Descripcion ,'') as Genero,
dbo.ConcatenarNombres(Declarante.Primer_Nombre, Declarante.Segundo_Nombre, Declarante.Primer_Apellido, Declarante.Segundo_Apellido) as Nombre_Declarante,
Declarante.Identificacion as Identificacion_Declarante,

Coalesce( Celular.Descripcion,'') as Celular_Declarante,
Coalesce(Direccion.Descripcion,'') as Direccion_Declarante,
Coalesce(Barrio.Descripcion,'') as Barrio_Declarante,

coalesce(EstadoRUV.Descripcion,'') as Estado_RUV,
dbo.ConvertirFecha(RUV.Fecha_Inclusion) as Fecha_Valoracion_RUV,
dbo.ConvertirFecha(RUV.Fecha_Investigacion) as Fecha_Investigacion_RUV,

Personas.Id_Estudia_Antes,
Personas.Id_Estudia_Actualmente, e_segunda.Id_Estudia_Actualmente, e_seguimiento.Id_Estudia_Actualmente
from 
Declaracion
LEFT  JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join Personas Declarante on Declarante.Id_Declaracion= Personas.Id_Declaracion and Declarante.Tipo='D'
left join Sucursales on Sucursales.Id_Enlace=  Declaracion.Id_Regional
left join SubTablas Grupos on Grupos.Id=Declaracion.Id_Grupo
left JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id

left join Personas_Contactos Celular 
	on   Celular.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=76 
	order by Personas_Contactos.Activo, Personas_Contactos.Id desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 
	order by Personas_Contactos.Activo, Personas_Contactos.Id desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 
	order by Personas_Contactos.Activo,Personas_Contactos.Id desc
	)

left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Generos on Generos.Id = Personas.Id_Genero
left join SubTablas Discapacitados on Discapacitados.Id= Personas.Id_Discapacitado
left join SubTablas TipoDiscapacidad on TipoDiscapacidad.Id= Personas.Id_Tipo_Discapacidad
left join SubTablas Etnias  on Etnias.Id = Personas.Id_Grupo_Etnico

left join Declaracion_Unidades RUV 
	on   RUV.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Fecha_Investigacion<= @FechaCorte
	and Declaracion_Unidades.Id_Unidad=32  -- RUV
	order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad


left join Personas_Educacion e_segunda
	on   e_segunda.Id= ( 
	select top 1 Personas_Educacion.Id  from Personas_Educacion
	where Personas_Educacion.Id_Persona=Personas.Id 
	and Personas_Educacion.Id_Tipo_Entrega=918 -- segunda
	and Personas_Educacion.Fecha<=@FechaCorte
	order by Personas_Educacion.Fecha, Personas_Educacion.Id desc
	)
left join Personas_Educacion e_seguimiento
	on   e_seguimiento.Id= ( 
	select top 1 Personas_Educacion.Id  from Personas_Educacion
	where Personas_Educacion.Id_Persona=Personas.Id 
	and Personas_Educacion.Id_Tipo_Entrega=919 -- seguimiento
	and Personas_Educacion.Fecha<=@FechaCorte
	order by Personas_Educacion.Fecha, Personas_Educacion.Id desc
	)

where 
Declaracion.Id= Personas.Id_Declaracion
and Declaracion.Tipo_Declaracion='921'  --desplazado
and Declaracion.Fecha_Valoracion>=@FechaAtencionInicial
and Declaracion.Fecha_Valoracion<=@FechaAtencionFinal
and Declaracion.Id_Atender=19  -- si atender !!!
and Personas.Edad>=6 and Personas.Edad<=17
Order by personas.id_declaracion, Personas.tipo desc, Personas.edad desc

