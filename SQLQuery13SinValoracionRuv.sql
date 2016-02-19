--@Id_Declaracion int, @Id_Unidad int, @Id_EstadoUnidad int, 
-- @Fecha_Inclusion datetime, @Fecha_Investigacion datetime, @Fecha_Creacion datetime, 
--@Id_Usuario_Creacion int, @Fecha_Modificacion datetime, @Id_Usuario_Modificacion int, 
--@Fecha_Cierre datetime, @Cierre bit, @Fuente nvarchar(100)

use [IRDCOL]

declare @FechaRadicacionInicial varchar(8)
declare @FechaRadicacionFinal varchar(8)

set @FechaRadicacionInicial = '20160101'
set @FechaRadicacionFinal =   '20160131'


select 
Declaracion.Id as Id_Declaracion,
Declaracion.Id_Regional, 
Personas.Id as Id_Persona, 
Personas.Id_Tipo_Identificacion,
Personas.Identificacion,
Declaracion.Fecha_Desplazamiento,
Declaracion.Fecha_Radicacion as Fecha_Radicacion,
Declaracion.Fecha_Declaracion as Fecha_Declaracion,
Declaracion.Fecha_Valoracion,
Declaracion.Numero_Declaracion as Numero_Declaracion,
Personas.Tipo,
Personas.Primer_Apellido, 
Coalesce(Personas.Segundo_Apellido,'') as Segundo_Apellido,
Personas.Primer_Nombre, 
Coalesce(Personas.Segundo_Nombre,'') as Segundo_Nombre

from
Declaracion
left JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion 
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join Declaracion_Estados de
	on   de.Id= ( 
	select top 1 Declaracion_Estados.Id  
	from Declaracion_Estados
	where Declaracion_Estados.Id_Declaracion=Declaracion.Id 
	and Declaracion_Estados.Id_Tipo_Estado=4036
	order by Declaracion_Estados.Fecha, Declaracion_estados.Id desc
	)
left join Declaracion_Unidades RUV 
	on   RUV.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=32  -- RUV
	order by Declaracion_Unidades.Fecha_Investigacion, Declaracion_Unidades.Id desc
	)
--left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad

where
Declaracion.Tipo_Declaracion=921  -- desplazado
and (Declaracion.Id_Regional = 1637 or Declaracion.Id_Regional = 4521)
and Personas.Tipo='D'  -- solo la persona declarante
and de.Id_Como_Estado=19  -- elegible si
and( Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null ) -- si atender o por definirse
and ruv.Id is null  -- no esta en Declaracion_unidades
and  Declaracion.Fecha_Radicacion>=@FechaRadicacionInicial  
and Declaracion.Fecha_Radicacion<=@FechaRadicacionFinal
order by Declaracion.Id