use [IRDCOL]
declare @Id_Regional int 
declare @FechaAtencionInicial varchar (10)
declare @FechaAtencionFinal varchar (10)
declare @FechaCorte varchar (10)
declare @ruv int
declare @id_segunda int
declare @id_seguimiento int
declare @desplazado int = 921
declare @id_atender_si int = 19
declare @edad_desde int= 6
declare @edad_hasta int= 17
declare @id_yasegraduo int = 1693
set @ruv=32
set @id_segunda=918
set  @id_seguimiento=919
set @Id_Regional=null
set @FechaAtencionInicial='20151001'
set @FechaAtencionFinal='20160229'
set @FechaCorte=@FechaAtencionFinal

select 
ROW_NUMBER() over ( order by Declaracion.Id, Personas.tipo desc, Personas.edad desc ) as Num,
Declaracion.Id as Id_Declaracion,
Personas.Id as Id_Persona,
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

EA.Descripcion as Estudiaba_Antes,
coalesce(MUN_EA.Descripcion,'') as Municipio_EA,
coalesce(Personas.Institucion_Estudiaba,'')  as Institucion_EA,

E_PE.Descripcion as Estudia_PE,
coalesce(MNE_PE.Descripcion,'') as Motivo_NE_PE,
case when Personas.Id_Motivo_NoEstudio=@id_yasegraduo then 'Si' else case when Personas.Id_Motivo_NoEstudio is null then '' else  'No' end end as Graduado_PE ,
coalesce(C_PE.Descripcion,'') as Certificado_PE,
coalesce(G_PE.Descripcion,'')   as Grado_PE,
coalesce(MUN_PE.Descripcion,'')  as Municipio_PE,
coalesce(Personas.Institucion_Estudia,'') as Institucion_PE,
coalesce(apoyo.Descripcion,'')  as ApoyoEducativo,

e_segunda.Id_Estudia_Actualmente as Id_Estudia_SE,
dbo.ConvertirFecha(e_segunda.Fecha) as Fecha_SE,
coalesce(E_SE.Descripcion,'') as Estudia_SE,
coalesce(MNE_SE.Descripcion,'') as Motivo_NE_SE,
case when e_segunda.Id_Motivo_NoEstudia =@id_yasegraduo then 'Si' else case when e_segunda.Id_Motivo_NoEstudia is null then '' else 'No' end   end as Graduado_SE,
coalesce(C_SE.Descripcion,'') as Certificado_SE,
coalesce(G_SE.Descripcion,'') as Grado_SE,
coalesce(MUN_SE.Descripcion,'')  as Municipio_SE,
coalesce(e_segunda.Establecimiento,'') as Instituto_SE,

dbo.ConvertirFecha(e_seguimiento.Fecha) as Fecha_SEG,
coalesce(E_SEG.Descripcion,'') as Estudia_SEG,
coalesce(MNE_SEG.Descripcion,'') as Motivo_NE_SEG,
case when e_seguimiento.Id_Motivo_NoEstudia =@id_yasegraduo then 'Si' else case when e_seguimiento.Id_Motivo_NoEstudia is null then '' else 'No' end   end as Graduado_SEG,
coalesce(C_SEG.Descripcion,'') as Certificado_SEG,
coalesce(G_SEG.Descripcion,'') as Grado_SEG,
coalesce(MUN_SEG.Descripcion,'')  as Municipio_SEG,
coalesce(e_seguimiento.Establecimiento,'') as Instituto_SEG,

/*case when e_seguimiento.id is null then case when e_segunda.id is null then 'Primera' else  'Segunda' end else 'Seguimiento' end as MR, 
dbo.ConvertirFecha(ISNULL(e_seguimiento.Fecha, ISNULL(e_segunda.Fecha, Declaracion.Fecha_Valoracion))) as Fecha_MR,
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then E_PE.Descripcion else E_SE.Descripcion end else E_SEG.Descripcion end, '') as Estudia_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MNE_PE.Descripcion else MNE_SE.Descripcion end else MNE_SEG.Descripcion end, '') as Motivo_NE_MR, 
case when (case when e_seguimiento.id is null then case when e_segunda.Id is null then Personas.Id_Motivo_NoEstudio else e_segunda.Id_Motivo_NoEstudia end else e_seguimiento.Id_Motivo_NoEstudia end)=@id_yasegraduo then 'Si' else 'No'end as Graduado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then C_PE.Descripcion else C_SE.Descripcion end else C_SEG.Descripcion end, '') as Certificado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then G_PE.Descripcion else G_SE.Descripcion end else G_SEG.Descripcion end, '') as Grado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MUN_PE.Descripcion else MUN_SE.Descripcion end else MUN_SEG.Descripcion end, '') as Municipio_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then Personas.Institucion_Estudia else e_segunda.Establecimiento end else e_seguimiento.Establecimiento end, '') as Instituto_Mr
*/
case when e_seguimiento.id is null then case when e_segunda.id is null then 'Primera' else 'Segunda' end else case when e_segunda.Fecha> e_seguimiento.Fecha then 'Segunda' else  'Seguimiento' end end as MR, 
case when e_seguimiento.id is null then case when e_segunda.id is null then dbo.ConvertirFecha(Declaracion.Fecha_Valoracion) else 'Segunda' end else case when e_segunda.Fecha> e_seguimiento.Fecha then dbo.ConvertirFecha(e_segunda.Fecha) else  dbo.ConvertirFecha(e_seguimiento.Fecha) end end as Fecha_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then E_PE.Descripcion else E_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then E_SE.Descripcion else  E_SEG.Descripcion end end, '') as Estudia_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MNE_PE.Descripcion else MNE_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MNE_SE.Descripcion else  MNE_SEG.Descripcion end end, '') as Motivo_NE_MR, 
case when (case when e_seguimiento.id is null then case when e_segunda.Id is null then Personas.Id_Motivo_NoEstudio else e_segunda.Id_Motivo_NoEstudia end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Id_Motivo_NoEstudia else e_seguimiento.Id_Motivo_NoEstudia end end)=@id_yasegraduo then 'Si' else 'No'end as Graduado_MR,
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then C_PE.Descripcion else C_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then C_SE.Descripcion else C_SEG.Descripcion end end, '') as Certificado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then G_PE.Descripcion else G_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then G_SE.Descripcion else G_SEG.Descripcion end end, '') as Grado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MUN_PE.Descripcion else MUN_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MUN_SE.Descripcion else MUN_SEG.Descripcion end end, '') as Municipio_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then Personas.Institucion_Estudia else e_segunda.Establecimiento end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Establecimiento else e_seguimiento.Establecimiento end end, '') as Instituto_Mr


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
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Barrio 
	on   Barrio.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=79 
	order by Personas_Contactos.Activo desc, Personas_Contactos.Id desc
	)
left join Personas_Contactos Direccion 
	on   Direccion.Id= ( 
	select top 1 Personas_Contactos.Id  from Personas_Contactos
	where Personas_Contactos.Id_Persona=Declarante.Id 
	and Personas_Contactos.Id_Tipo_Contacto=74 
	order by Personas_Contactos.Activo desc,Personas_Contactos.Id desc
	)

left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Generos on Generos.Id = Personas.Id_Genero
left join SubTablas Discapacitados on Discapacitados.Id= Personas.Id_Discapacitado
left join SubTablas TipoDiscapacidad on TipoDiscapacidad.Id= Personas.Id_Tipo_Discapacidad
left join SubTablas Etnias  on Etnias.Id = Personas.Id_Grupo_Etnico

left join Declaracion_Unidades RUV 
	on   RUV.Id=(
	select top 1 
	Declaracion_Unidades.Id
	from 
	Declaracion_Unidades
	where
	Declaracion_Unidades.Id_Declaracion=Declaracion.Id and 
	Declaracion_Unidades.Fecha_Investigacion<= isnull(@FechaCorte, (CONVERT(VARCHAR(10),GETDATE(),103)))
	and Declaracion_Unidades.Id_Unidad=@ruv  
	order by 
	Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)

left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad

left join Personas_Educacion e_segunda
	on   e_segunda.Id= ( 
	select top 1 
	Personas_Educacion.Id
	from
	Personas_Educacion
	where
	Personas_Educacion.Id_Persona= Personas.Id and
	Personas_Educacion.Id_Tipo_Entrega= @id_segunda and
	Personas_Educacion.Fecha<=isnull(@FechaCorte,CONVERT(VARCHAR(10),GETDATE(),103))
	order by 
	Personas_Educacion.Fecha desc, 
	Personas_Educacion.Id desc
	)
	
left join Personas_Educacion e_seguimiento
	on   e_seguimiento.Id= ( 
	select top 1 
	Personas_Educacion.Id
	from
	Personas_Educacion
	where
	Personas_Educacion.Id_Persona= Personas.Id and
	Personas_Educacion.Id_Tipo_Entrega= @id_seguimiento and
	Personas_Educacion.Fecha<=isnull(@FechaCorte,CONVERT(VARCHAR(10),GETDATE(),103))
	order by 
	Personas_Educacion.Fecha desc, 
	Personas_Educacion.Id desc
	)

left join SubTablas  EA on EA.Id= Personas.Id_Estudia_Antes 
left join SubTablas  MUN_EA on MUN_EA.Id = Personas.Id_Municipio_Instituto 

left join SubTablas  E_PE on E_PE.Id= Personas.Id_Estudia_Actualmente
left join SubTablas  MNE_PE on MNE_PE.Id = Personas.Id_Motivo_NoEstudio
left join SubTablas  C_PE on C_PE.Id = Personas.Id_Certificado
left join SubTablas  G_PE on G_PE.Id = Personas.Id_Ultimo_Grado
left join SubTablas  MUN_PE on MUN_PE.id = Personas.Id_Municipio_Instituto_Actual
left join SubTablas  apoyo on apoyo.Id = Personas.Id_Tipo_Apoyo_Educativo

left join SubTablas  E_SE on E_SE.Id= e_segunda.Id_Estudia_Actualmente
left join SubTablas  MNE_SE on MNE_SE.Id= e_segunda.Id_Motivo_NoEstudia
left join SubTablas  C_SE on C_SE.Id = e_segunda.Id_Certificado_Matricula
left join SubTablas  G_SE on G_SE.Id = e_segunda.Id_Grado_Escolar
left join SubTablas  MUN_SE on MUN_SE.Id = e_segunda.Id_Municipio_Instituto

left join SubTablas  E_SEG on E_SEG.Id= e_seguimiento.Id_Estudia_Actualmente
left join SubTablas  MNE_SEG on MNE_SEG.Id = e_seguimiento.Id_Motivo_NoEstudia
left join SubTablas  C_SEG on C_SEG.Id= e_seguimiento.Id_Certificado_Matricula
left join SubTablas  G_SEG on G_SEG.Id = e_seguimiento.Id_Grado_Escolar
left join SubTablas  MUN_SEG on MUN_SEG.Id= e_seguimiento.Id_Municipio_Instituto

where 
Declaracion.Fecha_Valoracion>=@FechaAtencionInicial
and Declaracion.Fecha_Valoracion<=@FechaAtencionFinal
and Declaracion.Id_Regional= ISNULL(@Id_Regional, Declaracion.Id_Regional)
and Declaracion.Id_Atender= @id_atender_si  -- si atender !!!
and Declaracion.Tipo_Declaracion=@desplazado  --desplazado
and Declaracion.Id= Personas.Id_Declaracion
and Personas.Edad>=@edad_desde
and Personas.Edad<=@edad_hasta
--and ( Personas.Id_Motivo_NoEstudio =@id_yasegraduo or e_segunda.Id_Motivo_NoEstudia =@id_yasegraduo or e_seguimiento.Id_Motivo_NoEstudia=@id_yasegraduo)
Order by Declaracion.Id, Personas.tipo desc, Personas.edad desc

