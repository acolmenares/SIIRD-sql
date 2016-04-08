use IRDCOL

declare @Id_Regional int =null
declare @FechaAtencionInicial date = '20151001'
declare @FechaAtencionFinal date = '20160331'
declare @ruv int = 32
declare @id_segunda int =918
declare @id_seguimiento int = 919
declare @desplazado int = 921
declare @id_atender_si int = 19
declare @edad_desde int= 6
declare @edad_hasta int= 17
declare @id_yasegraduo int = 1693

select
	p.Regional, 
	CONVERT(CHAR(7), p.Fecha_Atencion,112)  as Mes,
	COUNT(p.Id_Declaracion) as EdadEscolar,
	sum(p.graduado_PEntrega) as Graduados,
	sum(p.Estudia_PEntrega) as Estudia_PEntrega,
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
	QFn_PersonasEdadEscolar(
	@FechaAtencionInicial, @FechaAtencionFinal,@Id_Regional, 
	@desplazado, @id_atender_si, @edad_desde,@edad_hasta,@id_yasegraduo,@ruv, @id_segunda, @id_seguimiento) p

--where Regional='Florencia'
--and 
--Fecha_Atencion>='20151001' and Fecha_Atencion>='20151031'
--and ( EsSinCertPE_EsConCertMMun_Seguimiento=1  or  EsSinCertPE_EsConCertOMun_Seguimiento=1 )
	
group by p.Regional, CONVERT(CHAR(7), p.Fecha_Atencion,112) 
order by p.Regional, CONVERT(CHAR(7), p.Fecha_Atencion,112) 


--order by p.Regional, p.Id_Declaracion, p.Tipo desc ,p.Edad desc

