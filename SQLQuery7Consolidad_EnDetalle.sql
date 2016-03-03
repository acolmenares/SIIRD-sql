use [IRDCOL]

declare @FechaRadicacionInicial varchar(8)
declare @FechaRadicacionFinal varchar(8)
declare @FechaCorte varchar(8)

set @FechaRadicacionInicial = '20160101'
set @FechaRadicacionFinal =   '20160131'
set @FechaCorte = @FechaRadicacionFinal

select 
detalle.Id_Regional,
detalle.MesRadicacion,
--detalle.Elegible, detalle.Atender
count( detalle.Declaracion) as Radicados,
sum( case when detalle.Elegible='S' and detalle.Atender<>'N'  then 1 else 0 end) as Elegibles,
sum( case when detalle.Elegible='S' and  detalle.Atender<>'N' then 0 else 1 end) as NoElegibles,
sum ( case when ( detalle.Elegible='S' and  detalle.Atender<>'N' and detalle.MesRadicacion= detalle.MesValoracion ) then 1 else 0 end ) as Atendido_Mes,
sum ( case when ( detalle.Elegible='S' and  detalle.Atender<>'N' and detalle.MesRadicacion<> detalle.MesValoracion  ) then 1 else 0 end ) as Atendido_Otro_Mes,
sum ( case when ( detalle.Elegible='S' and  detalle.Atender<>'N' and  detalle.MesValoracion=''  ) then 1 else 0 end ) as PorAtender
 from 

(
select 
Declaracion.Id_Regional, 
CONVERT(CHAR(6),Declaracion.Fecha_Radicacion,112)  as MesRadicacion,
isnull(CONVERT(CHAR(6),Declaracion.Fecha_Valoracion,112),'')  as MesValoracion,
case when de.Id_Como_Estado=19  then 'S' else 'N' end as Elegible,
case when Declaracion.Id_Atender=19 then 'S'else case when Declaracion.Id_Atender=20 then 'N' else '?'end   end as Atender,

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
dbo.ConvertirFecha(Personas.Fecha_Nacimiento) as Fecha_Nacimiento


from
Declaracion

left join Sucursales on Sucursales.Id_Enlace=  Declaracion.Id_Regional
left join SubTablas Grupos on Grupos.Id=Declaracion.Id_Grupo
left join SubTablas Fuentes on Fuentes.Id=Declaracion.Id_Fuente
left join SubTablas LFuentes on LFuentes.Id= Declaracion.Id_lugar_fuente
left JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id

left JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion and Personas.Tipo='D'
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Generos on Generos.Id = Personas.Id_Genero


left join Declaracion_Estados de
	on   de.Id= ( 
	select top 1 Declaracion_Estados.Id  
	from Declaracion_Estados
	where Declaracion_Estados.Id_Declaracion=Declaracion.Id 
	and Declaracion_Estados.Id_Tipo_Estado=4036
	and Declaracion_Estados.Fecha<=@FechaCorte
	order by Declaracion_Estados.Fecha desc, Declaracion_estados.Id desc
	)

where
Declaracion.Tipo_Declaracion=921
and  Declaracion.Fecha_Radicacion>=@FechaRadicacionInicial  
and Declaracion.Fecha_Radicacion<=@FechaRadicacionFinal
) as detalle

group by detalle.Id_Regional, detalle.MesRadicacion
order by detalle.Id_Regional, detalle.MesRadicacion
