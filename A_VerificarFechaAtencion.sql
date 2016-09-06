use IRDCOL

declare  @Fecha_Inicial_Radicacion varchar(8) = '20151001';
declare  @Fecha_Final_Radicacion varchar(8) = '20160831';
declare  @Declarante int = 921
declare  @Tipo_Persona varchar(1) ='D';

declare  @Id_Elegible int = 4036
declare  @Id_Contactado int = 4037
declare  @Id_Programado int = 4038
declare  @Id_ReProgramado int = 4039
declare  @Id_NO int = 20

declare @PrimeraEntrega int =72
declare @SegundaEntrega int =918

select 
*
from
(
select 
DPrimeraAsistio.Descripcion as Atendido, 
Declaracion.Fecha_Valoracion as FechaAtencion,
Declaracion.Fecha_Radicacion as FechaRadicacion,
ProgramacionPrimera.Fecha,
ProgramacionPrimera.Numero as Programacion,
GrupoPrimera.Descripcion as Grupo,
EstadoPrimera.Descripcion as EstadoPrimera

from Declaracion
left join Declaracion_Estados DPrimera on DPrimera.Id=(
   select top 1 Declaracion_estados.Id 
     from Declaracion_Estados 
	    join Programacion pr on pr.Id=Declaracion_Estados.Id_Programa and pr.Id_TipoEntrega=@PrimeraEntrega
     where Declaracion_Estados.Id_Declaracion=Declaracion.Id
     and  Declaracion_Estados.Id_Tipo_Estado in (@Id_Programado, @Id_ReProgramado) 
	 order by pr.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas DPrimeraAsistio on DPrimeraAsistio.Id= DPrimera.Id_Asistio
left join Programacion ProgramacionPrimera on ProgramacionPrimera.Id=DPrimera.Id_Programa
left join SubTablas EstadoPrimera on EstadoPrimera.Id = ProgramacionPrimera.Id_Estado
left join SubTablas GrupoPrimera on GrupoPrimera.Id = ProgramacionPrimera.Id_Grupo
--where Declaracion.id=49590
) r

where 
r.FechaRadicacion>=@Fecha_Inicial_Radicacion
and EstadoPrimera='Cerrado'
--and r.Atendido='No'
and 

(
(r.Atendido='Si' and r.FechaAtencion is null)
or
(r.Atendido='No' and r.FechaAtencion is not null)
or
(
  r.Grupo is null and r.FechaAtencion is not null)
)

