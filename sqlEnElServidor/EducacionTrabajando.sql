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
set @FechaAtencionFinal='20160331'
set @FechaCorte=@FechaAtencionFinal

select
	p.Regional, 
	CONVERT(CHAR(7), p.Fecha_Atencion,112)  as Mes,
	COUNT(p.Id_Declaracion) as EdadEscolar,
	sum(p.graduado_PEntrega) as Graduados,
	sum(p.Estudia_PEntrega) as Estudia_PEntrega,
	SUM(p.Estudia_PEntregaOMun) as Estudia_PEntregaOMun,
	sum(p.NoEstudia_PEntrega) as NoEstudia_PEntrega,
	sum(p.EstudiaConCert_PEntrega) as EstudiaConCert_PEntrega,
	sum(p.EstudiaSinCert_PEntrega) as EstudiaSinCert_PEntrega,
	sum(NoEsPE_EsConCertMMun_Seguimiento) as NoEsPE_EsConCertMMun_Seguimiento,
	sum(case when NoEsPE_EsConCertMMun_Seguimiento=1 then 0 else NoEsPE_EsConCertOMun_Seguimiento end ) as NoEsPE_EsConCertOMun_Seguimiento,
	sum(EsSinCertPE_EsConCertMMun_Seguimiento) as EsSinCertPE_EsConCertMMun_Seguimiento,
	sum(case when EsSinCertPE_EsConCertMMun_Seguimiento=1 then 0 else  EsSinCertPE_EsConCertOMun_Seguimiento end ) as EsSinCertPE_EsConCertOMun_Seguimiento,
	sum(Graduado_Seguimiento) as Graduado_Seguimiento,
	sum( Estudia_AlFinalizarPeriodo) as Estudia_AlFinalizarPeriodo,
	COUNT(p.Id_Declaracion) - sum (Estudia_AlFinalizarPeriodo) as PendientePorAccesoEducacion
		
from

(
select 
--ROW_NUMBER() over ( order by Declaracion.Id, Personas.tipo desc, Personas.edad desc ) as Num,
Declaracion.Id as Id_Declaracion,
Personas.Id as Id_Persona,
Coalesce(grupos.Descripcion,'') as Grupo, 
Sucursales.Nombre as Regional,
Lentrega.Descripcion as Lugar_Entrega,   
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
case when e_seguimiento.Verificado_Entidad=1 then 'Si' else case when e_seguimiento.Verificado_Entidad=0 then 'No' else '' end end  as Verificado_SEG,

coalesce(G_SEG.Descripcion,'') as Grado_SEG,
coalesce(MUN_SEG.Descripcion,'')  as Municipio_SEG,
coalesce(e_seguimiento.Establecimiento,'') as Instituto_SEG,

case when e_seguimiento.id is null then case when e_segunda.id is null then 'Primera' else 'Segunda' end else case when e_segunda.Fecha> e_seguimiento.Fecha then 'Segunda' else  'Seguimiento' end end as MR, 
case when e_seguimiento.id is null then case when e_segunda.id is null then dbo.ConvertirFecha(Declaracion.Fecha_Valoracion) else dbo.ConvertirFecha(e_segunda.Fecha) end else case when e_segunda.Fecha> e_seguimiento.Fecha then dbo.ConvertirFecha(e_segunda.Fecha) else  dbo.ConvertirFecha(e_seguimiento.Fecha) end end as Fecha_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then E_PE.Descripcion else E_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then E_SE.Descripcion else  E_SEG.Descripcion end end, '') as Estudia_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MNE_PE.Descripcion else MNE_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MNE_SE.Descripcion else  MNE_SEG.Descripcion end end, '') as Motivo_NE_MR, 
case when (case when e_seguimiento.id is null then case when e_segunda.Id is null then Personas.Id_Motivo_NoEstudio else e_segunda.Id_Motivo_NoEstudia end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Id_Motivo_NoEstudia else e_seguimiento.Id_Motivo_NoEstudia end end)=@id_yasegraduo then 'Si' else 'No'end as Graduado_MR,
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then C_PE.Descripcion else C_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then C_SE.Descripcion else case when C_SEG.Descripcion='Si' then 'Si' else case when e_seguimiento.Verificado_Entidad=1 then 'Si' else 'No' end  end end end, '') as CertVer_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then G_PE.Descripcion else G_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then G_SE.Descripcion else G_SEG.Descripcion end end, '') as Grado_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MUN_PE.Descripcion else MUN_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MUN_SE.Descripcion else MUN_SEG.Descripcion end end, '') as Municipio_MR, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then Personas.Institucion_Estudia else e_segunda.Establecimiento end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Establecimiento else e_seguimiento.Establecimiento end end, '') as Instituto_Mr,

case when Personas.Id_Motivo_NoEstudio=@id_yasegraduo then 1 else 0 end as Graduado_PEntrega,
case when (E_PE.Descripcion='Si' and MUN_PE.Descripcion =Lentrega.Descripcion  ) then 1 else 0 end as Estudia_PEntrega,
case when (E_PE.Descripcion='Si' and MUN_PE.Descripcion <>Lentrega.Descripcion  ) then 1 else 0 end as Estudia_PEntregaOMun,
case when not (E_PE.Descripcion='Si') and not(isnull(Personas.Id_Motivo_NoEstudio,0)=@id_yasegraduo)  then 1 else 0 end as NoEstudia_PEntrega,
case when ( E_PE.Descripcion='Si' and C_PE.Descripcion='Si' and MUN_PE.Descripcion =Lentrega.Descripcion  ) then 1 else 0 end as EstudiaConCert_PEntrega,
case when (E_PE.Descripcion='Si' and not(C_PE.Descripcion='Si') and (MUN_PE.Descripcion =Lentrega.Descripcion  ))  then 1 else 0 end as EstudiaSinCert_PEntrega,
-- '--' as NE_PEntrega,
case when  
not(E_PE.Descripcion='Si') and not(isnull(Personas.Id_Motivo_NoEstudio,0)=@id_yasegraduo) 
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and MUN_SEG.Descripcion=Lentrega.Descripcion)
)
then 1 else 0 end as NoEsPE_EsConCertMMun_Seguimiento,
case when  
not(E_PE.Descripcion='Si') and not(isnull(Personas.Id_Motivo_NoEstudio,0)=@id_yasegraduo) 
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and not (MUN_SE.Descripcion=Lentrega.Descripcion or MUN_SE.Descripcion IS NULL) )
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and not ( MUN_SEG.Descripcion=Lentrega.Descripcion OR MUN_SEG.Descripcion IS NULL))
)
then 1 else 0 end as NoEsPE_EsConCertOMun_Seguimiento,
-- '--' as E_PEntrega,	
case when  
E_PE.Descripcion='Si' and not(C_PE.Descripcion='Si')
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and  MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and MUN_SEG.Descripcion=Lentrega.Descripcion)
)
then 1 else 0 end as EsSinCertPE_EsConCertMMun_Seguimiento,
case when  
E_PE.Descripcion='Si' and not(C_PE.Descripcion='Si')
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and not MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and not MUN_SEG.Descripcion=Lentrega.Descripcion)
)
then 1 else 0 end as EsSinCertPE_EsConCertOMun_Seguimiento,

case when not (isnull(Personas.Id_Motivo_NoEstudio,0)=@id_yasegraduo) 
and 
(
e_segunda.Id_Motivo_NoEstudia =@id_yasegraduo or e_seguimiento.Id_Motivo_NoEstudia =@id_yasegraduo
)
then 1 else 0 end as Graduado_Seguimiento,
case when 
Personas.Id_Motivo_NoEstudio=@id_yasegraduo  -- G_PE
or
(
E_PE.Descripcion='Si' and C_PE.Descripcion='Si'
) -- EConCert_PE
or
(
not(E_PE.Descripcion='Si') and not(Personas.Id_Motivo_NoEstudio=@id_yasegraduo) 
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and MUN_SEG.Descripcion=Lentrega.Descripcion)
)
)
or
(
not(E_PE.Descripcion='Si') and not(Personas.Id_Motivo_NoEstudio=@id_yasegraduo) 
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and not MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and not MUN_SEG.Descripcion=Lentrega.Descripcion)
)
)
or
(
E_PE.Descripcion='Si' and not(C_PE.Descripcion='Si')
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and  MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and MUN_SEG.Descripcion=Lentrega.Descripcion)
)
)
or
(
E_PE.Descripcion='Si' and not(C_PE.Descripcion='Si')
and 
(
 (E_SE.Descripcion='Si' and C_SE.Descripcion='Si' and not MUN_SE.Descripcion=Lentrega.Descripcion)
 or
 (E_SEG.Descripcion='Si' and (C_SEG.Descripcion='Si' or e_seguimiento.Verificado_Entidad=1) and not MUN_SEG.Descripcion=Lentrega.Descripcion)
)
)
or
(
not (isnull(Personas.Id_Motivo_NoEstudio,0)=@id_yasegraduo) 
and 
(
e_segunda.Id_Motivo_NoEstudia =@id_yasegraduo or e_seguimiento.Id_Motivo_NoEstudia =@id_yasegraduo
)
)
then 1 else 0 end as Estudia_AlFinalizarPeriodo


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
	Declaracion_Unidades.Fecha_Investigacion<= isnull(@FechaAtencionFinal, (CONVERT(VARCHAR(10),GETDATE(),103)))
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
	Personas_Educacion.Fecha<=isnull(@FechaAtencionFinal,CONVERT(VARCHAR(10),GETDATE(),103))
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
	Personas_Educacion.Fecha<=isnull(@FechaAtencionFinal,CONVERT(VARCHAR(10),GETDATE(),103))
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
) p

group by p.Regional, CONVERT(CHAR(7), p.Fecha_Atencion,112) 
order by p.Regional, CONVERT(CHAR(7), p.Fecha_Atencion,112) 

