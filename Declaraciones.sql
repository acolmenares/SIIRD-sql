use IRDCOL
declare  @Fecha_Inicial_Radicacion varchar(8) = '20151001';
declare  @Fecha_Final_Radicacion varchar(8) = '20160430';
declare  @Declarante int = 921
declare  @Tipo_Persona varchar(1) ='D';
declare  @SegundaEntrega int = 918

SELECT     
	Declaracion.Id,
	Declaracion.Fecha_Radicacion,
	Declaracion.Fecha_Desplazamiento,
	Declaracion.Fecha_Declaracion,
	Declaracion.Fecha_Valoracion as Fecha_Atencion,
	Declaracion.Horario,
	Grupo.Descripcion as Grupo,
	Fuente.Descripcion as Fuente,
	Regional.Descripcion as Regional,
	LF.Descripcion as MunicipioAtencion,
	TipoDeclaracion.Descripcion as TipoDeclarante,
	EnLinea.Descripcion as EnLinea,
	Atendido.Descripcion as Atendido,
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
	Personas.Edad,
	Personas.Fecha_Nacimiento,
	Generos.Descripcion as Genero,
	Etnias.Descripcion as Etnia,
	Coalesce(Declaracion.Gestantes,0) as Gestantes,
	Coalesce( Declaracion.Menores_Ninas,0)  + Coalesce(Declaracion.Menores_Ninos,0) as Menores,
	Coalesce(Declaracion.Recien_Nacidos,0) as Recien_Nacidos,
	Coalesce(Declaracion.Lactantes,0) as Lactantes,
	Coalesce(Declaracion.Resto_Nucleo,0) as Resto_Nucleo,
	Coalesce(Declaracion.Gestantes,0)
	+ Coalesce( Declaracion.Menores_Ninas,0)  + Coalesce(Declaracion.Menores_Ninos,0) 
	+ Coalesce(Declaracion.Recien_Nacidos,0) 
	+ Coalesce(Declaracion.Lactantes,0)
	+ Coalesce(Declaracion.Resto_Nucleo,0) as TFE,
	PerCount.TotalFamilia as TFR,
	Coalesce(NoAtencion.Descripcion,'') as Motivo_No_Atencion,
	Coalesce(TipoTenencia.Descripcion,'') as TipoTenencia,
	Coalesce(Habitaciones.Descripcion,'') as Habitaciones,
	Coalesce(PerVivienda.Descripcion,'') as PersonasVivienda,
	Coalesce(PerHabitacion.Descripcion,'') as PersonasHabitacion,
	Coalesce(MaterialVivienda.Descripcion,'') as MaterialesVivienda,
	Coalesce(AguaPotable.Descripcion,'') as AguaPotable,
	Coalesce(ObtencionAgua.Descripcion,'') as ObtencionAgua,
	Coalesce(TipoDesplazamiento.Descripcion,'') as TipoDesplazamiento,
	Coalesce(Departamento.Descripcion,'') as Departamento,
	Coalesce(Municipio.Descripcion,'') as Municipio,
	Coalesce(Concejo.Descripcion,'') as ConcejoResguardo,
	Coalesce(Declaracion.Vereda_Desplazamiento ,'') as Vereda,
	Coalesce(CuantasVecesDesplazado.Descripcion,'') as CuantasVecesDesplazado,
	Coalesce(HaDeclaradoAntes.Descripcion,'') as HaDeclaradoAntes,
    dbo.ConvertirFecha(Declaracion.Fecha_Desplazamiento_Anterior) as FechaDesplazamientoAnterior,
	Coalesce(Declaracion.Lugar_Desplazamiento,'') as LugarDesplazamientoAntes,
	Coalesce(HaRegresado.Descripcion,'') as HaRegresado,
	Coalesce(CausasDesplazamiento.Descripcion,'') as CausasDesplazamiento,
	Coalesce(TiempoEnDeclarar.Descripcion,'') as TiempoEnDeclarar,
	Coalesce(PorqueTardoEnDeclarar.Descripcion,'') as PorqueTardoEnDeclarar,
	Coalesce(EsDelMunicipio.Descripcion,'') as EsDelMunicipio,
	Coalesce(PorqueNoDeclaroEnMunicipio.Descripcion,'') as PorqueNoDeclaroEnMunicipio,
	Coalesce(AddFamiliasAccion.Descripcion,'') as ADDFamiliasAccion,
	Coalesce(MunicipioFamiliasAccion.Descripcion,'') as MunicipioFamiliasAccion,
	Coalesce(AddUnidos.Descripcion,'') as ADDUnidos,
	Coalesce(Declaracion.Municipio_Unidos,'') as MunicipioUnidos,
	Coalesce(SolicitoAyuda.Descripcion,'') as SolicitoAyuda,
	Coalesce(EntidadInicial.Descripcion,'') as EntidadInicial,
	Coalesce(ComoFueAtencion.Descripcion,'') as ComoFueAtencion,
	Coalesce(FuenteIngresos.Descripcion,'') as FuenteIngresos,
	Coalesce(Declaracion.Promedio_Ingresos_Mensuales,0) as PromedioIngresos,
	Coalesce(DaniosFamilia.Descripcion, '') as DaniosFamila,
	Coalesce(VBGGeneral.Descripcion, '') as VBGGeneral,
	/*Coalesce(.Descripcion,'') as ,
	Coalesce(.Descripcion,'') as
	Coalesce(.Descripcion,'') as ,
	Coalesce(.Descripcion,'') as ,
	Coalesce(.Descripcion,'') as ,*/
	Coalesce(ApoyoEmocional.Descripcion,'') as ApoyoEmocional
	/*
	left join SubTablas SolicitoAyuda on SolicitoAyuda.Id= Declaracion.Id_Solicito_ayuda
left join SubTablas EntidadInicial on EntidadInicial.Id = Declaracion.Id_Entidad_Inicial_Atencion
left join SubTablas ComoFueAtencion on ComoFueAtencion.Id=Declaracion.Id_Como_Fue_Atencion
fuente Ingresos

	*/
	FROM       Declaracion 
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
left join SubTablas Generos on Generos.Id = Personas.Id_Genero
left join SubTablas Etnias on Etnias.Id = Personas.Id_Grupo_Etnico
left join SubTablas NoAtencion on NoAtencion.Id= Declaracion.Id_Motivo_Noatender
left join Declaracion_Seguimientos ds on ds.Id_Declaracion= Declaracion.id and ds.Id_Tipo_Entrega=@SegundaEntrega
left join SubTablas TipoTenencia on TipoTenencia.Id= Declaracion.Id_Tipo_Tenencia_Vivienda
left join SubTablas Habitaciones on Habitaciones.Id = Declaracion.Id_Cuantas_Habitaciones
left join SubTablas PerVivienda on PerVivienda.Id = Declaracion.Id_Cuantas_Personas_Vivienda
left join SubTablas PerHabitacion on PerHabitacion.Id= Declaracion.Id_Cuantas_Personas_Habitacion
left join SubTablas MaterialVivienda on MaterialVivienda.Id = Declaracion.Id_Materiales_Vivienda
left join SubTablas AguaPotable on AguaPotable.Id= Declaracion.Id_Agua_Potable
left join (
select distinct(Id_Declaracion), 
( SELECT Stuff(
  (SELECT N', ' + tt1.Descripcion from 
  (
  select sdoa.Descripcion
  from Declaracion_Obtencion_Agua doa
  left join SubTablas sdoa on sdoa.Id = doa.Id_Lugar_Agua
  where doa.Id_Declaracion = Declaracion_Obtencion_Agua.Id_Declaracion
  ) as tt1 FOR XML PATH(''),TYPE)
  .value('text()[1]','nvarchar(max)'),1,2,N'') as Decripcion ) as Descripcion
from Declaracion_Obtencion_Agua 
) ObtencionAgua  on ObtencionAgua.Id_Declaracion=Declaracion.id
left join SubTablas TipoDesplazamiento on TipoDesplazamiento.Id= Declaracion.Id_Forma_Declaracion
left join SubTablas Departamento on Departamento.Id= Declaracion.Id_Departamento_Expulsor
left join SubTablas Municipio on Municipio.Id = Declaracion.Id_Municipio_Expulsor
left join SubTablas Concejo on Concejo.Id  = Declaracion.Id_Concejo_Expulsor
left join SubTablas CuantasVecesDesplazado on CuantasVecesDesplazado.Id= Declaracion.Id_Cuantos_Desplazamientos
left join SubTablas HaDeclaradoAntes on HaDeclaradoAntes.Id= Declaracion.Id_Ha_Declarado_Antes
left join SubTablas HaRegresado on HaRegresado.Id= Declaracion.Id_Ha_Regresado
left join (
select distinct(Id_Declaracion), 
( SELECT Stuff(
  (SELECT N', ' + tt1.Descripcion from 
  (
  select sdoa.Descripcion
  from Declaracion_Causas_Desplazamiento doa
  left join SubTablas sdoa on sdoa.Id = doa.Id_Causa_Desplazamiento
  where doa.Id_Declaracion = Declaracion_Causas_Desplazamiento.Id_Declaracion
  ) as tt1 FOR XML PATH(''),TYPE)
  .value('text()[1]','nvarchar(max)'),1,2,N'') as Decripcion ) as Descripcion
from Declaracion_Causas_Desplazamiento
) CausasDesplazamiento  on CausasDesplazamiento.Id_Declaracion=Declaracion.id
left join SubTablas TiempoEnDeclarar on TiempoEnDeclarar.Id= Declaracion.Id_Cuanto_Tiempo_Demoro
left join SubTablas PorqueTardoEnDeclarar on PorqueTardoEnDeclarar.Id= Declaracion.Id_Motivo_Demora
left join SubTablas EsDelMunicipio on EsDelMunicipio.Id= Declaracion.Id_Es_Del_Municipio
left join SubTablas PorqueNoDeclaroEnMunicipio on PorqueNoDeclaroEnMunicipio.Id= Declaracion.Id_Motivo_NoDeclaro_Municipio
left join SubTablas AddFamiliasAccion on AddFamiliasAccion.Id= Declaracion.Id_Familias_Accion
left join SubTablas MunicipioFamiliasAccion on MunicipioFamiliasAccion.Id = Declaracion.Id_Municipio_Faccion
left join SubTablas AddUnidos on AddUnidos.Id = Declaracion.Id_Red_Unidos 
left join SubTablas SolicitoAyuda on SolicitoAyuda.Id= Declaracion.Id_Solicito_ayuda
left join SubTablas EntidadInicial on EntidadInicial.Id = Declaracion.Id_Entidad_Inicial_Atencion
left join SubTablas ComoFueAtencion on ComoFueAtencion.Id=Declaracion.Id_Como_Fue_Atencion
left join (
select distinct(Id_Declaracion), 
( SELECT Stuff(
  (SELECT N'-' + tt1.Descripcion from 
  (
  select sdoa.Descripcion
  from Declaracion_Fuentes_Ingreso doa
  left join SubTablas sdoa on sdoa.Id = doa.Id_Fuentes_Ingreso
  where doa.Id_Declaracion = Declaracion_Fuentes_Ingreso.Id_Declaracion
  ) as tt1 FOR XML PATH(''),TYPE)
  .value('text()[1]','nvarchar(max)'),1,2,N'') as Decripcion ) as Descripcion
from Declaracion_Fuentes_Ingreso
) FuenteIngresos  on FuenteIngresos.Id_Declaracion=Declaracion.id
--
left join (
select distinct(Id_Declaracion), 
( SELECT Stuff(
  (SELECT N'-' + tt1.Descripcion from 
  (
  select sdoa.Descripcion
  from Declaracion_Danos_Familia doa
  left join SubTablas sdoa on sdoa.Id = doa.Id_Danos_Familia
  where doa.Id_Declaracion = Declaracion_Danos_Familia.Id_Declaracion
  ) as tt1 FOR XML PATH(''),TYPE)
  .value('text()[1]','nvarchar(max)'),1,2,N'') as Decripcion ) as Descripcion
from Declaracion_Danos_Familia
) DaniosFamilia  on DaniosFamilia.Id_Declaracion=Declaracion.id
--
left join SubTablas VBGGeneral on VBGGeneral.Id = Declaracion.Id_VBG_general 

left join Subtablas ApoyoEmocional on ApoyoEmocional.Id= ds.Id_Apoyo_Emocional,
(
  select per.Id_Declaracion, count(per.Id)  as TotalFamilia,
   sum( case when (per.Edad>=0 and per.Edad<=5) then 1 else 0 end) as Ninos05,
   sum( case when (per.Edad>=6 and per.Edad<=17) then 1 else 0 end) as Ninos617
  from Personas per group by per.Id_Declaracion
) as PerCount 
WHERE     (Personas.Tipo = @Tipo_Persona)  
And Declaracion.Fecha_Radicacion >= @Fecha_Inicial_Radicacion
And Declaracion.Fecha_Radicacion <= @Fecha_Final_Radicacion
AND Declaracion.Tipo_Declaracion = @Declarante
and PerCount.Id_Declaracion= Declaracion.Id
order by Declaracion.Id

