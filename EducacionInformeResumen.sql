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
declare @id_muerto int = 280
set @ruv=32
set @id_segunda=918
set  @id_seguimiento=919
set @Id_Regional=null
set @FechaAtencionInicial='20151001'
set @FechaAtencionFinal='20160531'
set @FechaCorte=@FechaAtencionFinal

select 
    r.Regional, 
	r.MunicipioAtencion,
	r.MesAtencion,
	COUNT(r.Id_Declaracion) as EdadEscolar,
	sum( r.PE_Graduados) as PE_Graduados,
	sum( r.PE_Estudian_MA_CC) as PE_Estudian_MA_CC,
	sum( r.PE_Estudian_MA_SC) as PE_Estudian_MA_SC,
	sum( r.PE_Estudian_OM) as PE_Estudian_OM,
	sum( r.PE_No_Estudian) as PE_No_Estudian,
	sum( r.SEG_Remitir) as SEG_Remitir,
	sum (r.SEG_Estudian_MA_CV) as SEG_Estudian_MA_CV,
	sum (r.SEG_Estudian_OM_CV) as SEG_Estudian_OM_CV,
	sum( r.SEG_Graduados ) as SEG_Graduados,
	sum (r.SEG_Estudian_MA_CV+r.SEG_Estudian_OM_CV+r.SEG_Graduados) as SEG_Estudian,
	sum (r.SEG_Estudian_MA_CV+r.SEG_Estudian_OM_CV+r.SEG_Graduados+ r.PE_Graduados +r.PE_Estudian_MA_CC) as Estudian_FinalizarPeriodo,
	( sum(r.SEG_Estudian_MA_CV+r.SEG_Estudian_OM_CV+r.SEG_Graduados+ r.PE_Graduados +r.PE_Estudian_MA_CC)*1.0/COUNT(r.Id_Declaracion))
	    as Porc_AccesoEducacion,
    COUNT(r.Id_Declaracion)- sum(r.SEG_Estudian_MA_CV+r.SEG_Estudian_OM_CV+r.SEG_Graduados+ r.PE_Graduados +r.PE_Estudian_MA_CC) as PendientesPorAcceso
from
(
select 
    q.*,    
	case when 
	(q.SEG_Remitir=1 and q.Estudia_SF='Si'  and q.Cer_Ver_SF='Si' and q.Municipio_SF=q.MunicipioAtencion)
	    then 1 else 0 end   as SEG_Estudian_MA_CV,
    case when 
	(q.SEG_Remitir=1 and q.Estudia_SF='Si'  and q.Cer_Ver_SF='Si' and not q.Municipio_SF=q.MunicipioAtencion)
	    then 1 else 0 end   as SEG_Estudian_OM_CV,
    case when 
	(q.SEG_Remitir=1 and q.Graduado_SF='Si')
	    then 1 else 0 end   as SEG_Graduados
	
from
(
select
    p.*,
	CONVERT(CHAR(6), p.Fecha_Atencion,112)  as MesAtencion,
	case when p.graduado_PE='Si' then 1 else 0 end as PE_Graduados,
	case when p.Estudia_PE='Si' and p.Municipio_PE=p.MunicipioAtencion and p.Certificado_PE='Si' then 1 else 0 end as PE_Estudian_MA_CC,
	case when p.Estudia_PE='Si' and p.Municipio_PE=p.MunicipioAtencion and not p.Certificado_PE='Si' then 1 else 0 end as PE_Estudian_MA_SC,
	case when p.Estudia_PE='Si' and not p.Municipio_PE=p.MunicipioAtencion  then 1 else 0 end as PE_Estudian_OM,
	case when not p.Estudia_PE='Si' and  not p.graduado_PE='Si'  then 1 else 0 end as PE_No_Estudian,
	case when 
	  (p.Estudia_PE='Si' and p.Municipio_PE=p.MunicipioAtencion and not p.Certificado_PE='Si') -- PE_Estudian_MA_SC,
	  or (p.Estudia_PE='Si' and not p.Municipio_PE=p.MunicipioAtencion)                        -- PE_Estudian_OM   
	  or (not p.Estudia_PE='Si' and  not p.graduado_PE='Si')                                   -- PE_No_Estudian,       
	then 1 else 0 end as SEG_Remitir
		
from

(
select 
--ROW_NUMBER() over ( order by Declaracion.Id, Personas.tipo desc, Personas.edad desc ) as Num,
Declaracion.Id_Regional,
Declaracion.Id as Id_Declaracion,
Personas.Id as Id_Persona,
Coalesce(grupos.Descripcion,'') as Grupo, 
Sucursales.Nombre as Regional,
Lentrega.Descripcion as MunicipioAtencion,   
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
convert(date,RUV.Fecha_Inclusion) as Fecha_Valoracion_RUV,
convert(date,RUV.Fecha_Investigacion) as Fecha_Investigacion_RUV,

EA.Descripcion as Estudiaba_Antes,
coalesce(MUN_EA.Descripcion,'') as Municipio_EA,
coalesce(Personas.Institucion_Estudiaba,'')  as Institucion_EA,

isnull(E_PE.Descripcion,'') as Estudia_PE,
coalesce(MNE_PE.Descripcion,'') as Motivo_NE_PE,
case when Personas.Id_Motivo_NoEstudio=@id_yasegraduo then 'Si' else case when Personas.Id_Motivo_NoEstudio is null then '' else  'No' end end as Graduado_PE,
coalesce(C_PE.Descripcion,'') as Certificado_PE,
coalesce(G_PE.Descripcion,'')   as Grado_PE,
coalesce(MUN_PE.Descripcion,'')  as Municipio_PE,
coalesce(Personas.Institucion_Estudia,'') as Institucion_PE,
coalesce(apoyo.Descripcion,'')  as ApoyoEducativo,

convert(date,e_segunda.Fecha) as Fecha_SE,
coalesce(E_SE.Descripcion,'') as Estudia_SE,
coalesce(MNE_SE.Descripcion,'') as Motivo_NE_SE,
case when e_segunda.Id_Motivo_NoEstudia =@id_yasegraduo then 'Si' else case when e_segunda.Id_Motivo_NoEstudia is null then '' else 'No' end   end as Graduado_SE,
coalesce(C_SE.Descripcion,'') as Certificado_SE,
coalesce(G_SE.Descripcion,'') as Grado_SE,
coalesce(MUN_SE.Descripcion,'')  as Municipio_SE,
coalesce(e_segunda.Establecimiento,'') as Instituto_SE,

convert(date,e_seguimiento.Fecha) as Fecha_SEG,
coalesce(E_SEG.Descripcion,'') as Estudia_SEG,
coalesce(MNE_SEG.Descripcion,'') as Motivo_NE_SEG,
case when e_seguimiento.Id_Motivo_NoEstudia =@id_yasegraduo then 'Si' else case when e_seguimiento.Id_Motivo_NoEstudia is null then '' else 'No' end   end as Graduado_SEG,
coalesce(C_SEG.Descripcion,'') as Certificado_SEG,
case when e_seguimiento.Verificado_Entidad=1 then 'Si' else case when e_seguimiento.Verificado_Entidad=0 then 'No' else '' end end  as Verificado_SEG,

coalesce(G_SEG.Descripcion,'') as Grado_SEG,
coalesce(MUN_SEG.Descripcion,'')  as Municipio_SEG,
coalesce(e_seguimiento.Establecimiento,'') as Instituto_SEG,

case when e_seguimiento.id is null then case when e_segunda.id is null then 'Primera' else 'Segunda' end else case when e_segunda.Fecha> e_seguimiento.Fecha then 'Segunda' else  'Seguimiento' end end as SF, 
case when e_seguimiento.id is null then case when e_segunda.id is null then convert(date,Declaracion.Fecha_Valoracion) else convert(date,e_segunda.Fecha) end else case when e_segunda.Fecha> e_seguimiento.Fecha then convert(date,e_segunda.Fecha) else  convert(date,e_seguimiento.Fecha) end end as Fecha_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then E_PE.Descripcion else E_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then E_SE.Descripcion else  E_SEG.Descripcion end end, '') as Estudia_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MNE_PE.Descripcion else MNE_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MNE_SE.Descripcion else  MNE_SEG.Descripcion end end, '') as Motivo_NE_SF, 
case when (case when e_seguimiento.id is null then case when e_segunda.Id is null then Personas.Id_Motivo_NoEstudio else e_segunda.Id_Motivo_NoEstudia end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Id_Motivo_NoEstudia else e_seguimiento.Id_Motivo_NoEstudia end end)=@id_yasegraduo then 'Si' else 'No'end as Graduado_SF,
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then C_PE.Descripcion else C_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then C_SE.Descripcion else case when C_SEG.Descripcion='Si' then 'Si' else case when e_seguimiento.Verificado_Entidad=1 then 'Si' else 'No' end  end end end, '') as Cer_Ver_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then G_PE.Descripcion else G_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then G_SE.Descripcion else G_SEG.Descripcion end end, '') as Grado_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MUN_PE.Descripcion else MUN_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MUN_SE.Descripcion else MUN_SEG.Descripcion end end, '') as Municipio_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then Personas.Institucion_Estudia else e_segunda.Establecimiento end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Establecimiento else e_seguimiento.Establecimiento end end, '') as Instituto_SF


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
and ( Personas.Id_Motivo_NoEstudio is null  or  Personas.Id_Motivo_NoEstudio<>@id_muerto)
) p
) q
) r
--where r.Motivo_NE_PE<>'Muerto'
group by r.Regional, r.MunicipioAtencion, r.MesAtencion
order by r.Regional, r.MunicipioAtencion, r.MesAtencion


/*
case when e_seguimiento.id is null then case when e_segunda.id is null then 'Primera' else 'Segunda' end else case when e_segunda.Fecha> e_seguimiento.Fecha then 'Segunda' else  'Seguimiento' end end as SF, 
case when e_seguimiento.id is null then case when e_segunda.id is null then convert(date,Declaracion.Fecha_Valoracion) else convert(date,e_segunda.Fecha) end else case when e_segunda.Fecha> e_seguimiento.Fecha then convert(date,e_segunda.Fecha) else  convert(date,e_seguimiento.Fecha) end end as Fecha_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then E_PE.Descripcion else E_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then E_SE.Descripcion else  E_SEG.Descripcion end end, '') as Estudia_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MNE_PE.Descripcion else MNE_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MNE_SE.Descripcion else  MNE_SEG.Descripcion end end, '') as Motivo_NE_SF, 
case when (case when e_seguimiento.id is null then case when e_segunda.Id is null then Personas.Id_Motivo_NoEstudio else e_segunda.Id_Motivo_NoEstudia end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Id_Motivo_NoEstudia else e_seguimiento.Id_Motivo_NoEstudia end end)=@id_yasegraduo then 'Si' else 'No'end as Graduado_SF,
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then C_PE.Descripcion else C_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then C_SE.Descripcion else case when C_SEG.Descripcion='Si' then 'Si' else case when e_seguimiento.Verificado_Entidad=1 then 'Si' else 'No' end  end end end, '') as Cer_Ver_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then G_PE.Descripcion else G_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then G_SE.Descripcion else G_SEG.Descripcion end end, '') as Grado_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then MUN_PE.Descripcion else MUN_SE.Descripcion end else case when e_segunda.Fecha> e_seguimiento.Fecha then MUN_SE.Descripcion else MUN_SEG.Descripcion end end, '') as Municipio_SF, 
coalesce(case when e_seguimiento.id is null then case when e_segunda.id is null then Personas.Institucion_Estudia else e_segunda.Establecimiento end else case when e_segunda.Fecha> e_seguimiento.Fecha then e_segunda.Establecimiento else e_seguimiento.Establecimiento end end, '') as Instituto_SF,
*/
