--StoredProcedure [dbo].[PersonasConsultarBusqueda]  
use  [IRDCOL]

declare  @Tipo_Declaracion int ='921' -- desplazado
declare  @Fecha_Valoracion_Inicial varchar(8) = '20151001'  -- 
declare  @Fecha_Valoracion_Final varchar(8)='20160930'--

declare  @Tipo_Persona varchar(1) ='D';

SELECT  
Personas.Id,
Declaracion.Id as Declaracion,
Sucursales.Nombre as Regional,
LFuentes.Descripcion as Lugar_Fuente,
Coalesce(grupos.Descripcion,'') as Grupo,
Fuentes.Descripcion as Fuente,
convert(date,Declaracion.Fecha_Radicacion) as Fecha_Radicacion,
convert(date,Declaracion.Fecha_Declaracion) as Fecha_Declaracion,
convert(date,Declaracion.Fecha_Desplazamiento) as Fecha_Desplazamiento,
convert(date,Declaracion.Fecha_Valoracion) as Fecha_Atencion,
Personas.Tipo,
TipoIdentificacion.Descripcion as TI,
Personas.Identificacion,
Personas.Primer_Apellido, 
Coalesce(Personas.Segundo_Apellido,'') as Segundo_Apellido,
Personas.Primer_Nombre, 
Coalesce(Personas.Segundo_Nombre,'') as Segundo_Nombre,
Coalesce(Personas.Edad,'') as Edad,
convert(date,Personas.Fecha_Nacimiento) as Fecha_Nacimiento,
Coalesce(Generos.Descripcion ,'') as Genero,
Coalesce(Parentescos.Descripcion ,'') as Parentesco,
Coalesce(Embarazadas.Descripcion ,'') as Embarazada,
Coalesce(Lactantes.Descripcion ,'') as Lactando,
Coalesce(Miembros.Descripcion ,'') as Miembro,
Coalesce(Discapacitados.Descripcion ,'') as Discapacitado,
Coalesce(TipoDiscapacidad.Descripcion ,'') as TipoDiscapacidad,
Coalesce(EstudiaActualmente.Descripcion ,'') as Est_Actual,
Personas.Institucion_Estudia as Institucion,
Coalesce(EstudiaActualmente.Descripcion ,'') as Ult_Grado,
Coalesce(SabeLE.Descripcion ,'') as Sabe_LE,
Coalesce( MotivoNE.Descripcion ,'') as Motivo_NoEstudia_PE,
Coalesce( ApoyoEducativo.Descripcion ,'') as ApoyoEducativo,
Coalesce( Etnias.Descripcion ,'') as Etnia,
Coalesce(regimen_salud_primera.Descripcion, '') as RS_Primera,
Coalesce(eps_primera.Descripcion, '') as EPS_Primera,
Coalesce(municipio_primera.Descripcion, '') as Municipio_Primera,
Coalesce(departamento_primera.Descripcion, '') as Dpto_Primera,

dbo.ConcatenarNombres(Declarante.Primer_Nombre, Declarante.Segundo_Nombre, Declarante.Primer_Apellido, Declarante.Segundo_Apellido) as Nombre_Declarante,
Declarante.Identificacion as Identificacion_Declarante,
Coalesce( Celular.Descripcion,'') as Celular_Declarante,
Coalesce(Direccion.Descripcion,'') as Direccion_Declarante,
Coalesce(Barrio.Descripcion,'') as Barrio_Declarante,

coalesce(EstadoRUV.Descripcion,'') as Estado_RUV,
convert(date,RUV.Fecha_Inclusion) as Fecha_Valoracion_RUV,
convert(date,RUV.Fecha_Investigacion) as Fecha_Investigacion_RUV,

coalesce(EstadoPAARI.Descripcion,'') as Estado_PAARI,
convert(date,PAARI.Fecha_Inclusion) as Fecha_Inclusion_PAARI,
convert(date,PAARI.Fecha_Investigacion) as Fecha_Investigacion_PAARI,

coalesce(EstadoFA.Descripcion,'') as Estado_FAccion,
convert(date,FA.Fecha_Inclusion) as Fecha_Inclusion_FAccion,
convert(date,FA.Fecha_Investigacion) as Fecha_Investigacion_FAccion,

coalesce(EstadoAA.Descripcion,'') as Estado_AA,
convert(date,AA.Fecha_Inclusion) as Fecha_AA,
convert(date,AA.Fecha_Investigacion) as Fecha_Investigacion_AA,

coalesce(EstadoNotificacion.Descripcion,'') as Estado_Notificacion,
convert(date,Notificacion.Fecha_Inclusion) as Fecha_Notificacion,
convert(date,Notificacion.Fecha_Investigacion) as Fecha_Investigacion_Notificacion,
PerCount.TotalFamilia,
PerCount.Ninos05,
PerCount.Ninos617

FROM  Declaracion
left join Sucursales on Sucursales.Id_Enlace=  Declaracion.Id_Regional
left join SubTablas Grupos on Grupos.Id=Declaracion.Id_Grupo
left join SubTablas Fuentes on Fuentes.Id=Declaracion.Id_Fuente
left join SubTablas LFuentes on LFuentes.Id= Declaracion.Id_lugar_fuente
JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Generos on Generos.Id = Personas.Id_Genero
left join SubTablas Parentescos on Parentescos.Id= Personas.Id_Parentesco
left join SubTablas Embarazadas on Embarazadas.Id= Personas.Id_Embarazada
left join SubTablas Lactantes on Lactantes.Id= Personas.Id_Embarazada
left join SubTablas Miembros on Miembros.Id= Personas.Id_Tipo_Miembro
left join SubTablas Discapacitados on Discapacitados.Id= Personas.Id_Discapacitado
left join SubTablas TipoDiscapacidad on TipoDiscapacidad.Id= Personas.Id_Tipo_Discapacidad
left join SubTablas EstudiaActualmente  on EstudiaActualmente.Id = Personas.Id_Estudia_Actualmente
left join SubTablas UltimoGrado  on UltimoGrado.Id = Personas.Id_Ultimo_Grado
left join SubTablas SabeLE  on SabeLE.Id = Personas.Id_Sabe_Leer_Escribir
left join SubTablas MotivoNE  on MotivoNE.Id = Personas.Id_Motivo_NoEstudio
left join SubTablas ApoyoEducativo  on ApoyoEducativo.Id = Personas.Id_Tipo_Apoyo_Educativo
left join SubTablas Etnias  on Etnias.Id = Personas.Id_Grupo_Etnico
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

left join Personas Declarante on Declarante.Id_Declaracion= Personas.Id_Declaracion and Declarante.Tipo=@Tipo_Persona
left join Personas_Contactos Celular 
	on   Celular.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=76 
	order by Personas_Contactos.Activo  desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 
	order by Personas_Contactos.Activo  desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Declaracion_Unidades RUV 
	on   RUV.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=32  -- RUV
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad
left join Declaracion_Unidades PAARI 
	on   PAARI.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=274 
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoPAARI on EstadoPAARI.Id= PAARI.Id_EstadoUnidad
left join Declaracion_Unidades FA 
	on   FA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=273 
	order by Declaracion_Unidades.Fecha_Investigacion  desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoFA on EstadoFA.Id= FA.Id_EstadoUnidad
left join Declaracion_Unidades AA 
	on   AA.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=161 
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoAA on EstadoAA.Id= AA.Id_EstadoUnidad
left join Declaracion_Unidades Notificacion
	on   Notificacion.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=1501 
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
left join SubTablas EstadoNotificacion on EstadoNotificacion.Id= Notificacion.Id_EstadoUnidad,
(
  select per.Id_Declaracion, count(per.Id)  as TotalFamilia,
   sum( case when (per.Edad>=0 and per.Edad<=5) then 1 else 0 end) as Ninos05,
   sum( case when (per.Edad>=6 and per.Edad<=17) then 1 else 0 end) as Ninos617
  from Personas per group by per.Id_Declaracion
) as PerCount 
WHERE PerCount.Id_Declaracion= Declaracion.Id
And Declaracion.Tipo_Declaracion=@Tipo_Declaracion
And Declaracion.Fecha_Valoracion>=@Fecha_Valoracion_Inicial  
And Declaracion.Fecha_Valoracion<=@Fecha_Valoracion_Final 
--and Discapacitados.Descripcion='Si' -- para discapacitados prm vii y prm viii
Order by personas.id_declaracion, tipo desc, edad desc 

--14763 Atendidas