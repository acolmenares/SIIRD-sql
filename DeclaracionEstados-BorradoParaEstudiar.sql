use IRDCOL;

declare  @Fecha_Inicial_Radicacion varchar(8) = '20151001';
declare  @Fecha_Final_Radicacion varchar(8) = '20160630';
declare  @Declarante int = 921
declare  @Tipo_Persona varchar(1) ='D';

declare  @Id_Elegible int = 4036
declare  @Id_Contactado int = 4037
declare  @Id_Programado int = 4038
declare  @Id_ReProgramado int = 4039
declare  @Id_NO int = 20

declare @PrimeraEntrega int =72
declare @SegundaEntrega int =918

select r.Regional, CONVERT(CHAR(6), r.FechaSegundaEntrega,112),
sum ( case when 
                r.AsistioSegundaEntrega='Si' or 0=0 then 1 else 0 end ) --and  CONVERT(CHAR(6), r.Fecha_Radicacion,112)= CONVERT(CHAR(6), r.FechaSegundaEntrega,112)

from  
(
select 
    Declaracion.Id,
	convert(date,Declaracion.Fecha_Radicacion) as Fecha_Radicacion,
	convert(date,Declaracion.Fecha_Desplazamiento) as Fecha_Desplazamiento,
	convert(date,Declaracion.Fecha_Declaracion) as Fecha_Declaracion ,
	convert(date,Declaracion.Fecha_Valoracion) as Fecha_Atencion,
	Declaracion.Horario,
	Grupo.Descripcion as Grupo,
	Fuente.Descripcion as Fuente,
	Regional.Descripcion as Regional,
	LF.Descripcion as MunicipioAtencion,
	TipoDeclaracion.Descripcion as TipoDeclarante,
	EnLinea.Descripcion as EnLinea,
	Personas.Primer_Apellido,
	Personas.Segundo_Apellido,
	Personas.Primer_Nombre,
	Personas.Segundo_Nombre,
	TI.Descripcion as TI,
	Personas.Identificacion,
	Coalesce( Celular.Descripcion,'') as Celular,
	Coalesce( Telefono.Descripcion,'') as Telefono,
	Coalesce(Direccion.Descripcion,'') as Direccion,
	Coalesce(Barrio.Descripcion,'') as Barrio,
	Coalesce(Declaracion.Gestantes,0)
	+ Coalesce( Declaracion.Menores_Ninas,0)  + Coalesce(Declaracion.Menores_Ninos,0) 
	+ Coalesce(Declaracion.Recien_Nacidos,0) 
	+ Coalesce(Declaracion.Lactantes,0)
	+ Coalesce(Declaracion.Resto_Nucleo,0) as TFE,
	PerCount.TotalFamilia as TFR,
	Coalesce(Elegible.Descripcion,'') as  Elegibilidad,
	convert(date,DElegible.Fecha) as FechaElegibilidad,
	Coalesce(Contactado.Descripcion,'') as Contactado,
	convert(date,DContactado.Fecha) as FechaContactado,
	Coalesce(Programado.Descripcion,'') as Programado,
	convert(date,DProgramado.Fecha) as FechaProgramado,
	Coalesce(ReProgramado.Descripcion,'') as ReProgramado,
	convert(date,DReProgramado.Fecha) as FechaReProgramado,
	Atendido.Descripcion as Atendido,
	Coalesce(NoAtencion.Descripcion,'') as MotivoNoAtencion,
	Coalesce(TipoReProgramacion.Descripcion,'') as TipoReprogramacion,
    --convert(date, DSegunda.Fecha) as FechaSegundaEntrega,
	convert(date, ProgramacionSegunda.Fecha) as FechaSegundaEntrega,
	coalesce(DSegundaAsistio.Descripcion,'') as AsistioSegundaEntrega	
	--ProgramacionSegunda.Numero,
	--GrupoSegunda.Descripcion

from Declaracion
INNER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join SubTablas Grupo on Grupo.Id= Declaracion.Id_Grupo 
left join SubTablas Fuente on Fuente.Id = Declaracion.Id_Fuente
left join SubTablas LF on LF.Id = Declaracion.Id_lugar_fuente
left join SubTablas Regional on Regional.Id= Declaracion.Id_Regional
left join SubTablas TipoDeclaracion on TipoDeclaracion.Id= Declaracion.Tipo_Declaracion
left join SubTablas EnLinea on EnLinea.Id=Declaracion.Id_EnLinea
left join SubTablas Atendido on Atendido.Id = Declaracion.Id_Atender
left join SubTablas TI on TI.Id= Personas.Id_Tipo_Identificacion
left join Personas_Contactos Celular 
	on   Celular.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=76 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Telefono 
	on   Telefono.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=75 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Personas.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Declaracion_Estados DElegible on DElegible.Id=(
  select top 1 Declaracion_Estados.Id from  Declaracion_Estados  
  where Declaracion_Estados.Id_Declaracion=Declaracion.Id
  and Declaracion_Estados.Id_Tipo_Estado=@Id_Elegible
  order by Declaracion_Estados.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas Elegible on Elegible.Id= DElegible.Id_Como_Estado

left join Declaracion_Estados DContactado on DContactado.Id=(
  select top 1 Declaracion_Estados.Id from  Declaracion_Estados  
  where Declaracion_Estados.Id_Declaracion=Declaracion.Id
  and Declaracion_Estados.Id_Tipo_Estado=@Id_Contactado
  order by Declaracion_Estados.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas Contactado on Contactado.Id= DContactado.Id_Como_Estado


left join Declaracion_Estados DProgramado on DProgramado.Id=(
  select top 1 Declaracion_Estados.Id from  Declaracion_Estados  
  join Programacion on Programacion.Id=Declaracion_Estados.Id_Programa and Programacion.Id_TipoEntrega=@PrimeraEntrega
  where Declaracion_Estados.Id_Declaracion=Declaracion.Id
  and Declaracion_Estados.Id_Tipo_Estado=@Id_Programado 
  order by Declaracion_Estados.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas Programado on Programado.Id= DProgramado.Id_Como_Estado



left join Declaracion_Estados DReProgramado on DReProgramado.Id=(
  select top 1 Declaracion_Estados.Id from  Declaracion_Estados  
  where Declaracion_Estados.Id_Declaracion=Declaracion.Id
  and Declaracion_Estados.Id_Tipo_Estado=@Id_ReProgramado
  order by Declaracion_Estados.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas ReProgramado on ReProgramado.Id= DReProgramado.Id_Como_Estado
left join SubTablas NoAtencion on NoAtencion.Id= Declaracion.Id_Motivo_Noatender

left join Declaracion_Estados DTipoReProgramacion on DTipoReProgramacion.Id=(
  select top 1 Declaracion_Estados.Id from  Declaracion_Estados  
  where Declaracion_Estados.Id_Declaracion=Declaracion.Id
  and ((Declaracion_Estados.Id_Tipo_Estado=@Id_Programado or Declaracion_Estados.Id_Tipo_Estado=@Id_ReProgramado)
  and Declaracion_Estados.Id_Asistio=@Id_NO) 
  order by Declaracion_Estados.Fecha desc, Declaracion_Estados.Id desc
)
left join Programacion pr on pr.Id= DTipoReProgramacion.Id_Programa
left join SubTablas TipoReProgramacion on TipoReProgramacion.Id= pr.Id_TipoEntrega

-- Fecha Segunda Entrega y si asistio ..
-- tomar la fecha del grupo no del estado !!!!! 
left join Declaracion_Estados DSEgunda on DSEgunda.Id=(
   select top 1 Declaracion_estados.Id 
     from Declaracion_Estados 
	    join Programacion pr on pr.Id=Declaracion_Estados.Id_Programa and pr.Id_TipoEntrega=@SegundaEntrega
     where Declaracion_Estados.Id_Declaracion=Declaracion.Id
     and  Declaracion_Estados.Id_Tipo_Estado in (@Id_Programado, @Id_ReProgramado) 
	 order by pr.Fecha desc, Declaracion_Estados.Id desc
)
left join SubTablas DSegundaAsistio on DSegundaAsistio.Id= DSEgunda.Id_Asistio
left join Programacion ProgramacionSegunda on ProgramacionSegunda.Id=DSEgunda.Id_Programa
--left join SubTablas GrupoSegunda on GrupoSegunda.Id= ProgramacionSegunda.Id_Grupo
--
,
(
  select per.Id_Declaracion, count(per.Id)  as TotalFamilia,
   sum( case when (per.Edad>=0 and per.Edad<=5) then 1 else 0 end) as Ninos05,
   sum( case when (per.Edad>=6 and per.Edad<=17) then 1 else 0 end) as Ninos617
  from Personas per group by per.Id_Declaracion
) as PerCount 

WHERE (Personas.Tipo = @Tipo_Persona)  
And Declaracion.Fecha_Radicacion >= @Fecha_Inicial_Radicacion
And Declaracion.Fecha_Radicacion <= @Fecha_Final_Radicacion
AND Declaracion.Tipo_Declaracion = @Declarante
and PerCount.Id_Declaracion= Declaracion.Id
--order by DSEgunda.Fecha
) r  
where r.AsistioSegundaEntrega='Si'
group by r.Regional, CONVERT(CHAR(6), r.FechaSegundaEntrega,112)
order by r.Regional 