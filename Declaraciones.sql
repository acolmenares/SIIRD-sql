use IRDCOL
declare  @Fecha_Inicial_Radicacion varchar(8) = '20151001';
declare  @Fecha_Final_Radicacion varchar(8) = '20160430';
declare  @Declarante int = 921
declare  @Tipo_Persona varchar(1) ='D';

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
	Coalesce(NoAtencion.Descripcion,'') as Motivo_No_Atencion

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
left join SubTablas NoAtencion on NoAtencion.Id= Declaracion.Id_Motivo_Noatender,
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

