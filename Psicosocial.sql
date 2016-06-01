use  [IRDCOL]

declare  @Tipo_Declaracion int ='921' -- desplazado
declare  @Fecha_Valoracion_Inicial varchar(8) = '20151001'  -- 
declare  @Fecha_Valoracion_Final varchar(8)='20160531' --
declare  @Tipo_Persona varchar(1) ='D';
declare @PrimeraEntrega int =72
declare @SegundaEntrega int =918

select
Declaracion.Id,
	convert(date,Declaracion.Fecha_Radicacion) as Fecha_Radicacion,
	convert(date,Declaracion.Fecha_Desplazamiento) as Fecha_Desplazamiento,
	convert(date,Declaracion.Fecha_Declaracion) as Fecha_Declaracion ,
	convert(date,Declaracion.Fecha_Valoracion) as Fecha_Atencion,
	Fuente.Descripcion as Fuente,
	Regional.Descripcion as Regional,
	LF.Descripcion as MunicipioAtencion,
	TipoDeclaracion.Descripcion as TipoDeclarante,
	Personas.Primer_Apellido,
	Personas.Segundo_Apellido,
	Personas.Primer_Nombre,
	Personas.Segundo_Nombre,
	TI.Descripcion as TI,
	Personas.Identificacion,
	PerCount.TotalFamilia as TFR,
	Coalesce(Emociones.Descripcion,'') as Emociones,
	---
	Coalesce(MuertoPE.Dato_Usted,0) as YoMuertoPE,
	Coalesce(NoDormirPE.Dato_Usted,0) as YoNoDormirPE,
	Coalesce(ApetitoPE.Dato_Usted,0) as YoApetitoPE,
	Coalesce(MiedoPE.Dato_Usted,0) as YoMiedoPE,
	Coalesce(VenganzaPE.Dato_Usted,0) as YoVengazaPE,
	Coalesce(CulpaPE.Dato_Usted,0) as YoCulpaPE,
	Coalesce(RelFamiPE.Dato_Usted,0) as YoRelFamiPE,
	Coalesce(TristezaPE.Dato_Usted,0) as YoTristezaPE,
	Coalesce(RabiaPE.Dato_Usted,0) as YoRabiaPE,
	Coalesce(DolorCabezaPE.Dato_Usted,0) as YoDolorCabezaPE,
	Coalesce(DolorEstomagoPE.Dato_Usted,0) as YoDolorEstomagoPE,
	Coalesce(RelComuPE.Dato_Usted,0) as YoRelComuPE,
	Coalesce(MuertoPE.Dato_Familia,0) as FamMuertoPE,
	Coalesce(NoDormirPE.Dato_Familia,0) as FamNoDormirPE,
	Coalesce(ApetitoPE.Dato_Familia,0)  as FamApetitoPE,
	Coalesce(MiedoPE.Dato_Familia,0) as FamMiedoPE,
	Coalesce(VenganzaPE.Dato_Familia,0) as FamVengazaPE,
	Coalesce(CulpaPE.Dato_Familia,0) as FamCulpaPE,
	Coalesce(RelFamiPE.Dato_Familia,0) as FamRelFamiPE,
	Coalesce(TristezaPE.Dato_Familia,0) as FamTristezaPE,
	Coalesce(RabiaPE.Dato_Familia,0) as FamRabiaPE,
	Coalesce(DolorCabezaPE.Dato_Familia,0)  as FamDolorCabezaPE,
	Coalesce(DolorEstomagoPE.Dato_Familia,0) as FamDolorEstomagoPE,
	Coalesce(RelComuPE.Dato_Familia,0) as FamRelComuPE,
	case when FamiliarPE.Id is null then '' else 'SI' end as FamiliarPE,
	case when VecinoPE.Id is null then '' else 'SI' end as VecinoPE,
	case when AyudaEspiritualPE.Id is null then '' else 'SI' end as AyudaEspiritualPE,
	case when FunSaludPE.Id is null then '' else 'SI' end as FunSaludPE,
	case when OrgVictimasPE.Id is null then '' else 'SI' end as OrgVictimasPE,
	---
	Coalesce(MuertoSE.Dato_Usted,0) as YoMuertoSE,
	Coalesce(NoDormirSE.Dato_Usted,0) as YoNoDormirSE,
	Coalesce(ApetitoSE.Dato_Usted,0) as YoApetitoSE,
	Coalesce(MiedoSE.Dato_Usted,0) as YoMiedoSE,
	Coalesce(VenganzaSE.Dato_Usted,0) as YoVengazaSE,
	Coalesce(CulpaSE.Dato_Usted,0) as YoCulpaSE,
	Coalesce(RelFamiSE.Dato_Usted,0) as YoRelFamiSE,
	Coalesce(TristezaSE.Dato_Usted,0) as YoTristezaSE,
	Coalesce(RabiaSE.Dato_Usted,0) as YoRabiaSE,
	Coalesce(DolorCabezaSE.Dato_Usted,0) as YoDolorCabezaSE,
	Coalesce(DolorEstomagoSE.Dato_Usted,0) as YoDolorEstomagoSE,
	Coalesce(RelComuSE.Dato_Usted,0) as YoRelComuSE,
	Coalesce(MuertoSE.Dato_Familia,0) as FamMuertoSE,
	Coalesce(NoDormirSE.Dato_Familia,0) as FamNoDormirSE,
	Coalesce(ApetitoSE.Dato_Familia,0)  as FamApetitoSE,
	Coalesce(MiedoSE.Dato_Familia,0) as FamMiedoSE,
	Coalesce(VenganzaSE.Dato_Familia,0) as FamVengazaSE,
	Coalesce(CulpaSE.Dato_Familia,0) as FamCulpaSE,
	Coalesce(RelFamiSE.Dato_Familia,0) as FamRelFamiSE,
	Coalesce(TristezaSE.Dato_Familia,0) as FamTristezaSE,
	Coalesce(RabiaSE.Dato_Familia,0) as FamRabiaSE,
	Coalesce(DolorCabezaSE.Dato_Familia,0)  as FamDolorCabezaSE,
	Coalesce(DolorEstomagoSE.Dato_Familia,0) as FamDolorEstomagoSE,
	Coalesce(RelComuSE.Dato_Familia,0) as FamRelComuSE,
	case when FamiliarSE.Id is null then '' else 'SI' end as FamiliarSE,
	case when VecinoSE.Id is null then '' else 'SI' end as VecinoSE,
	case when AyudaEspiritualSE.Id is null then '' else 'SI' end as AyudaEspiritualSE,
	case when FunSaludSE.Id is null then '' else 'SI' end as FunSaludSE,
	case when OrgVictimasSE.Id is null then '' else 'SI' end as OrgVictimasSE,
	---
	case when (
	case when MuertoPE.Dato_Usted>0 then 1 else 0 end+  case when NoDormirPE.Dato_Usted>0 then 1 else 0 end+
	case when ApetitoPE.Dato_Usted>0 then 1 else 0 end + case when MiedoPE.Dato_Usted>0 then 1 else 0 end+
	case when VenganzaPE.Dato_Usted>0 then 1 else 0 end + case when CulpaPE.Dato_Usted>0 then 1 else 0 end +
	case when RelFamiPE.Dato_Usted>0 then 1 else 0 end + case when TristezaPE.Dato_Usted>0 then 1 else 0 end+
	case when RabiaPE.Dato_Usted >0 then 1 else 0 end + case when DolorCabezaPE.Dato_Usted >0 then 1 else 0 end+
	case when DolorEstomagoPE.Dato_Usted>0 then 1 else 0 end + case when RelComuPE.Dato_Usted >0 then 1 else 0 end +
	case when MuertoPE.Dato_Familia>0 then 1 else 0 end+  case when NoDormirPE.Dato_Familia>0 then 1 else 0 end+
	case when ApetitoPE.Dato_Familia>0 then 1 else 0 end + case when MiedoPE.Dato_Familia>0 then 1 else 0 end+
	case when VenganzaPE.Dato_Familia>0 then 1 else 0 end + case when CulpaPE.Dato_Familia>0 then 1 else 0 end +
	case when RelFamiPE.Dato_Familia>0 then 1 else 0 end + case when TristezaPE.Dato_Familia>0 then 1 else 0 end+
	case when RabiaPE.Dato_Familia >0 then 1 else 0 end + case when DolorCabezaPE.Dato_Familia >0 then 1 else 0 end+
	case when DolorEstomagoPE.Dato_Familia>0 then 1 else 0 end + case when RelComuPE.Dato_Familia >0 then 1 else 0 end) > 0
	then 
	   (
	   (Coalesce(MuertoPE.Dato_Usted,0) + Coalesce(NoDormirPE.Dato_Usted,0) + Coalesce(ApetitoPE.Dato_Usted,0) +
	   Coalesce(MiedoPE.Dato_Usted,0) + Coalesce(VenganzaPE.Dato_Usted,0) + Coalesce(CulpaPE.Dato_Usted,0) +
	   Coalesce(RelFamiPE.Dato_Usted,0) + Coalesce(TristezaPE.Dato_Usted,0) + Coalesce(RabiaPE.Dato_Usted,0) +
	   Coalesce(DolorCabezaPE.Dato_Usted,0) + Coalesce(DolorEstomagoPE.Dato_Usted,0) +	Coalesce(RelComuPE.Dato_Usted,0) +
	   Coalesce(MuertoPE.Dato_Familia,0) +	Coalesce(NoDormirPE.Dato_Familia,0) +Coalesce(ApetitoPE.Dato_Familia,0)  +
	   Coalesce(MiedoPE.Dato_Familia,0) +	Coalesce(VenganzaPE.Dato_Familia,0) + Coalesce(CulpaPE.Dato_Familia,0) +
	   Coalesce(RelFamiPE.Dato_Familia,0) + Coalesce(TristezaPE.Dato_Familia,0) +	Coalesce(RabiaPE.Dato_Familia,0) +
	   Coalesce(DolorCabezaPE.Dato_Familia,0) + Coalesce(DolorEstomagoPE.Dato_Familia,0)+Coalesce(RelComuPE.Dato_Familia,0))
	   /
	   (
	    (case when MuertoPE.Dato_Usted>0 then 1.00 else 0 end+  case when NoDormirPE.Dato_Usted>0 then 1.00 else 0 end+
		 case when ApetitoPE.Dato_Usted>0 then 1.00 else 0 end + case when MiedoPE.Dato_Usted>0 then 1.00 else 0 end+
		 case when VenganzaPE.Dato_Usted>0 then 1.00 else 0 end + case when CulpaPE.Dato_Usted>0 then 1.00 else 0 end +
		 case when RelFamiPE.Dato_Usted>0 then 1.00 else 0 end + case when TristezaPE.Dato_Usted>0 then 1.00 else 0 end+
		 case when RabiaPE.Dato_Usted >0 then 1.00 else 0 end + case when DolorCabezaPE.Dato_Usted >0 then 1.00 else 0 end+
		 case when DolorEstomagoPE.Dato_Usted>0 then 1 else 0 end + case when RelComuPE.Dato_Usted >0 then 1.00 else 0 end +
		 case when MuertoPE.Dato_Familia>0 then 1.00 else 0 end+  case when NoDormirPE.Dato_Familia>0 then 1.00 else 0 end+
		 case when ApetitoPE.Dato_Familia>0 then 1.00 else 0 end + case when MiedoPE.Dato_Familia>0 then 1.00 else 0 end+
		 case when VenganzaPE.Dato_Familia>0 then 1.00 else 0 end + case when CulpaPE.Dato_Familia>0 then 1.00 else 0 end +
		 case when RelFamiPE.Dato_Familia>0 then 1.00 else 0 end + case when TristezaPE.Dato_Familia>0 then 1.00 else 0 end+
		 case when RabiaPE.Dato_Familia >0 then 1.00 else 0 end + case when DolorCabezaPE.Dato_Familia >0 then 1.00 else 0 end+
		 case when DolorEstomagoPE.Dato_Familia>0 then 1.00 else 0 end + case when RelComuPE.Dato_Familia >0 then 1.00 else 0 end)*5.00
	   )) 
	   -
	   (case when FamiliarPE.Id is null then 0 else 1.00 end +	case when VecinoPE.Id is null then 0 else 1.00 end +
	    case when AyudaEspiritualPE.Id is null then 0 else 1.00 end +	case when FunSaludPE.Id is null then 0 else 1.00 end +
	    case when OrgVictimasPE.Id is null then 0 else 1.00 end )/25.00 
	else null end as IndicePE,
	--
	case when (
	case when MuertoSE.Dato_Usted>0 then 1 else 0 end+  case when NoDormirSE.Dato_Usted>0 then 1 else 0 end+
	case when ApetitoSE.Dato_Usted>0 then 1 else 0 end + case when MiedoSE.Dato_Usted>0 then 1 else 0 end+
	case when VenganzaSE.Dato_Usted>0 then 1 else 0 end + case when CulpaSE.Dato_Usted>0 then 1 else 0 end +
	case when RelFamiSE.Dato_Usted>0 then 1 else 0 end + case when TristezaSE.Dato_Usted>0 then 1 else 0 end+
	case when RabiaSE.Dato_Usted >0 then 1 else 0 end + case when DolorCabezaSE.Dato_Usted >0 then 1 else 0 end+
	case when DolorEstomagoSE.Dato_Usted>0 then 1 else 0 end + case when RelComuSE.Dato_Usted >0 then 1 else 0 end +
	case when MuertoSE.Dato_Familia>0 then 1 else 0 end+  case when NoDormirSE.Dato_Familia>0 then 1 else 0 end+
	case when ApetitoSE.Dato_Familia>0 then 1 else 0 end + case when MiedoSE.Dato_Familia>0 then 1 else 0 end+
	case when VenganzaSE.Dato_Familia>0 then 1 else 0 end + case when CulpaSE.Dato_Familia>0 then 1 else 0 end +
	case when RelFamiSE.Dato_Familia>0 then 1 else 0 end + case when TristezaSE.Dato_Familia>0 then 1 else 0 end+
	case when RabiaSE.Dato_Familia >0 then 1 else 0 end + case when DolorCabezaSE.Dato_Familia >0 then 1 else 0 end+
	case when DolorEstomagoSE.Dato_Familia>0 then 1 else 0 end + case when RelComuSE.Dato_Familia >0 then 1 else 0 end) > 0
	then 
	   (
	   (Coalesce(MuertoSE.Dato_Usted,0) + Coalesce(NoDormirSE.Dato_Usted,0) + Coalesce(ApetitoSE.Dato_Usted,0) +
	   Coalesce(MiedoSE.Dato_Usted,0) + Coalesce(VenganzaSE.Dato_Usted,0) + Coalesce(CulpaSE.Dato_Usted,0) +
	   Coalesce(RelFamiSE.Dato_Usted,0) + Coalesce(TristezaSE.Dato_Usted,0) + Coalesce(RabiaSE.Dato_Usted,0) +
	   Coalesce(DolorCabezaSE.Dato_Usted,0) + Coalesce(DolorEstomagoSE.Dato_Usted,0) +	Coalesce(RelComuSE.Dato_Usted,0) +
	   Coalesce(MuertoSE.Dato_Familia,0) +	Coalesce(NoDormirSE.Dato_Familia,0) +Coalesce(ApetitoSE.Dato_Familia,0)  +
	   Coalesce(MiedoSE.Dato_Familia,0) +	Coalesce(VenganzaSE.Dato_Familia,0) + Coalesce(CulpaSE.Dato_Familia,0) +
	   Coalesce(RelFamiSE.Dato_Familia,0) + Coalesce(TristezaSE.Dato_Familia,0) +	Coalesce(RabiaSE.Dato_Familia,0) +
	   Coalesce(DolorCabezaSE.Dato_Familia,0) + Coalesce(DolorEstomagoSE.Dato_Familia,0)+Coalesce(RelComuSE.Dato_Familia,0))
	   /
	   (
	    (case when MuertoSE.Dato_Usted>0 then 1.00 else 0 end+  case when NoDormirSE.Dato_Usted>0 then 1.00 else 0 end+
		 case when ApetitoSE.Dato_Usted>0 then 1.00 else 0 end + case when MiedoSE.Dato_Usted>0 then 1.00 else 0 end+
		 case when VenganzaSE.Dato_Usted>0 then 1.00 else 0 end + case when CulpaSE.Dato_Usted>0 then 1.00 else 0 end +
		 case when RelFamiSE.Dato_Usted>0 then 1.00 else 0 end + case when TristezaSE.Dato_Usted>0 then 1.00 else 0 end+
		 case when RabiaSE.Dato_Usted >0 then 1.00 else 0 end + case when DolorCabezaSE.Dato_Usted >0 then 1.00 else 0 end+
		 case when DolorEstomagoSE.Dato_Usted>0 then 1 else 0 end + case when RelComuSE.Dato_Usted >0 then 1.00 else 0 end +
		 case when MuertoSE.Dato_Familia>0 then 1.00 else 0 end+  case when NoDormirSE.Dato_Familia>0 then 1.00 else 0 end+
		 case when ApetitoSE.Dato_Familia>0 then 1.00 else 0 end + case when MiedoSE.Dato_Familia>0 then 1.00 else 0 end+
		 case when VenganzaSE.Dato_Familia>0 then 1.00 else 0 end + case when CulpaSE.Dato_Familia>0 then 1.00 else 0 end +
		 case when RelFamiSE.Dato_Familia>0 then 1.00 else 0 end + case when TristezaSE.Dato_Familia>0 then 1.00 else 0 end+
		 case when RabiaSE.Dato_Familia >0 then 1.00 else 0 end + case when DolorCabezaSE.Dato_Familia >0 then 1.00 else 0 end+
		 case when DolorEstomagoSE.Dato_Familia>0 then 1.00 else 0 end + case when RelComuSE.Dato_Familia >0 then 1.00 else 0 end)*5.00
	   )) 
	   -
	   (case when FamiliarSE.Id is null then 0 else 1.00 end +	case when VecinoSE.Id is null then 0 else 1.00 end +
	    case when AyudaEspiritualSE.Id is null then 0 else 1.00 end +	case when FunSaludSE.Id is null then 0 else 1.00 end +
	    case when OrgVictimasSE.Id is null then 0 else 1.00 end )/25.00
	else null end as IndiceSE,
	Coalesce(ApoyoEmocional.Descripcion,'') as ApoyoEmocional
	/*
	Coalesce(MuertoPE.Dato_Usted,0) + Coalesce(NoDormirPE.Dato_Usted,0) + Coalesce(ApetitoPE.Dato_Usted,0) +
	Coalesce(MiedoPE.Dato_Usted,0) + Coalesce(VenganzaPE.Dato_Usted,0) + Coalesce(CulpaPE.Dato_Usted,0) +
	Coalesce(RelFamiPE.Dato_Usted,0) + Coalesce(TristezaPE.Dato_Usted,0) + Coalesce(RabiaPE.Dato_Usted,0) +
	Coalesce(DolorCabezaPE.Dato_Usted,0) + Coalesce(DolorEstomagoPE.Dato_Usted,0) +	Coalesce(RelComuPE.Dato_Usted,0) +
	Coalesce(MuertoPE.Dato_Familia,0) +	Coalesce(NoDormirPE.Dato_Familia,0) +Coalesce(ApetitoPE.Dato_Familia,0)  +
	Coalesce(MiedoPE.Dato_Familia,0) +	Coalesce(VenganzaPE.Dato_Familia,0) + Coalesce(CulpaPE.Dato_Familia,0) +
	Coalesce(RelFamiPE.Dato_Familia,0) + Coalesce(TristezaPE.Dato_Familia,0) +	Coalesce(RabiaPE.Dato_Familia,0) +
	Coalesce(DolorCabezaPE.Dato_Familia,0) + Coalesce(DolorEstomagoPE.Dato_Familia,0)+Coalesce(RelComuPE.Dato_Familia,0) as sum1_pe,
	--
	case when MuertoPE.Dato_Usted>0 then 1 else 0 end+  case when NoDormirPE.Dato_Usted>0 then 1 else 0 end+
	case when ApetitoPE.Dato_Usted>0 then 1 else 0 end + case when MiedoPE.Dato_Usted>0 then 1 else 0 end+
	case when VenganzaPE.Dato_Usted>0 then 1 else 0 end + case when CulpaPE.Dato_Usted>0 then 1 else 0 end +
	case when RelFamiPE.Dato_Usted>0 then 1 else 0 end + case when TristezaPE.Dato_Usted>0 then 1 else 0 end+
	case when RabiaPE.Dato_Usted >0 then 1 else 0 end + case when DolorCabezaPE.Dato_Usted >0 then 1 else 0 end+
	case when DolorEstomagoPE.Dato_Usted>0 then 1 else 0 end + case when RelComuPE.Dato_Usted >0 then 1 else 0 end +
	case when MuertoPE.Dato_Familia>0 then 1 else 0 end+  case when NoDormirPE.Dato_Familia>0 then 1 else 0 end+
	case when ApetitoPE.Dato_Familia>0 then 1 else 0 end + case when MiedoPE.Dato_Familia>0 then 1 else 0 end+
	case when VenganzaPE.Dato_Familia>0 then 1 else 0 end + case when CulpaPE.Dato_Familia>0 then 1 else 0 end +
	case when RelFamiPE.Dato_Familia>0 then 1 else 0 end + case when TristezaPE.Dato_Familia>0 then 1 else 0 end+
	case when RabiaPE.Dato_Familia >0 then 1 else 0 end + case when DolorCabezaPE.Dato_Familia >0 then 1 else 0 end+
	case when DolorEstomagoPE.Dato_Familia>0 then 1 else 0 end + case when RelComuPE.Dato_Familia >0 then 1 else 0 end
	as cant1_pe,
	(case when FamiliarSE.Id is null then 0 else 1.00 end +	case when VecinoSE.Id is null then 0 else 1.00 end +
	case when AyudaEspiritualSE.Id is null then 0 else 1.00 end +	case when FunSaludSE.Id is null then 0 else 1.00 end +
	case when OrgVictimasSE.Id is null then 0 else 1.00 end )/25.00 as cant2_pe,
	--
	*/
from 
Declaracion
INNER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
left join SubTablas Grupo on Grupo.Id= Declaracion.Id_Grupo 
left join SubTablas Fuente on Fuente.Id = Declaracion.Id_Fuente
left join SubTablas LF on LF.Id = Declaracion.Id_lugar_fuente
left join SubTablas Regional on Regional.Id= Declaracion.Id_Regional
left join SubTablas TipoDeclaracion on TipoDeclaracion.Id= Declaracion.Tipo_Declaracion
left join SubTablas TI on TI.Id= Personas.Id_Tipo_Identificacion
left join SubTablas Emociones on Emociones.Id=Declaracion.Id_Emociones
left join Declaracion_Psicosocial MuertoPE on MuertoPE.Id_Declaracion=Declaracion.Id and MuertoPE.Id_Emocion=4533 and MuertoPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial NoDormirPE on NoDormirPE.Id_Declaracion=Declaracion.Id and NoDormirPE.Id_Emocion=4527  and NoDormirPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial ApetitoPE on ApetitoPE.Id_Declaracion=Declaracion.Id and ApetitoPE.Id_Emocion=4530 and ApetitoPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial MiedoPE on MiedoPE.Id_Declaracion=Declaracion.Id and MiedoPE.Id_Emocion=4525 and MiedoPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial VenganzaPE on VenganzaPE.Id_Declaracion=Declaracion.Id and VenganzaPE.Id_Emocion=4531 and VenganzaPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial CulpaPE on CulpaPE.Id_Declaracion=Declaracion.Id and CulpaPE.Id_Emocion=4532 and CulpaPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial RelFamiPE on RelFamiPE.Id_Declaracion=Declaracion.Id and RelFamiPE.Id_Emocion=4535 and RelFamiPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial TristezaPE on TristezaPE.Id_Declaracion=Declaracion.Id and TristezaPE.Id_Emocion= 4524 and TristezaPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial RabiaPE on RabiaPE.Id_Declaracion=Declaracion.Id and RabiaPE.Id_Emocion=4526 and RabiaPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial DolorCabezaPE on DolorCabezaPE.Id_Declaracion=Declaracion.Id and DolorCabezaPE.Id_Emocion=4528 and DolorCabezaPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial DolorEstomagoPE on DolorEstomagoPE.Id_Declaracion=Declaracion.Id and DolorEstomagoPE.Id_Emocion=4529  and DolorEstomagoPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Psicosocial RelComuPE on RelComuPE.Id_Declaracion=Declaracion.Id and RelComuPE.Id_Emocion=4534  and RelComuPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Personas_Ayuda  FamiliarPE on FamiliarPE.Id_Declaracion= Declaracion.Id and FamiliarPE.Id_Personas_Ayuda=4536 and FamiliarPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Personas_Ayuda  VecinoPE on VecinoPE.Id_Declaracion= Declaracion.Id and VecinoPE.Id_Personas_Ayuda=4537 and VecinoPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Personas_Ayuda  AyudaEspiritualPE on AyudaEspiritualPE.Id_Declaracion=Declaracion.Id and AyudaEspiritualPE.Id_Personas_Ayuda=4538 and AyudaEspiritualPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Personas_Ayuda  FunSaludPE on FunSaludPE.Id_Declaracion=Declaracion.Id and FunSaludPE.Id_Personas_Ayuda=4539 and FunSaludPE.Id_Tipo_Entrega=@PrimeraEntrega
left join Declaracion_Personas_Ayuda  OrgVictimasPE on OrgVictimasPE.Id_Declaracion= Declaracion.Id and OrgVictimasPE.Id_Personas_Ayuda= 4540 and OrgVictimasPE.Id_Tipo_Entrega=@PrimeraEntrega
---
left join Declaracion_Psicosocial MuertoSE on MuertoSE.Id_Declaracion=Declaracion.Id and MuertoSE.Id_Emocion=4533 and MuertoSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial NoDormirSE on NoDormirSE.Id_Declaracion=Declaracion.Id and NoDormirSE.Id_Emocion=4527  and NoDormirSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial ApetitoSE on ApetitoSE.Id_Declaracion=Declaracion.Id and ApetitoSE.Id_Emocion=4530 and ApetitoSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial MiedoSE on MiedoSE.Id_Declaracion=Declaracion.Id and MiedoSE.Id_Emocion=4525 and MiedoSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial VenganzaSE on VenganzaSE.Id_Declaracion=Declaracion.Id and VenganzaSE.Id_Emocion=4531 and VenganzaSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial CulpaSE on CulpaSE.Id_Declaracion=Declaracion.Id and CulpaSE.Id_Emocion=4532 and CulpaSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial RelFamiSE on RelFamiSE.Id_Declaracion=Declaracion.Id and RelFamiSE.Id_Emocion=4535 and RelFamiSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial TristezaSE on TristezaSE.Id_Declaracion=Declaracion.Id and TristezaSE.Id_Emocion= 4524 and TristezaSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial RabiaSE on RabiaSE.Id_Declaracion=Declaracion.Id and RabiaSE.Id_Emocion=4526 and RabiaSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial DolorCabezaSE on DolorCabezaSE.Id_Declaracion=Declaracion.Id and DolorCabezaSE.Id_Emocion=4528 and DolorCabezaSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial DolorEstomagoSE on DolorEstomagoSE.Id_Declaracion=Declaracion.Id and DolorEstomagoSE.Id_Emocion=4529  and DolorEstomagoSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Psicosocial RelComuSE on RelComuSE.Id_Declaracion=Declaracion.Id and RelComuSE.Id_Emocion=4534  and RelComuSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Personas_Ayuda  FamiliarSE on FamiliarSE.Id_Declaracion= Declaracion.Id and FamiliarSE.Id_Personas_Ayuda=4536 and FamiliarSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Personas_Ayuda  VecinoSE on VecinoSE.Id_Declaracion= Declaracion.Id and VecinoSE.Id_Personas_Ayuda=4537 and VecinoSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Personas_Ayuda  AyudaEspiritualSE on AyudaEspiritualSE.Id_Declaracion=Declaracion.Id and AyudaEspiritualSE.Id_Personas_Ayuda=4538 and AyudaEspiritualSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Personas_Ayuda  FunSaludSE on FunSaludSE.Id_Declaracion=Declaracion.Id and FunSaludSE.Id_Personas_Ayuda=4539 and FunSaludSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Personas_Ayuda  OrgVictimasSE on OrgVictimasSE.Id_Declaracion= Declaracion.Id and OrgVictimasSE.Id_Personas_Ayuda= 4540 and OrgVictimasSE.Id_Tipo_Entrega=@SegundaEntrega
left join Declaracion_Seguimientos ds on ds.Id_Declaracion= Declaracion.id and ds.Id_Tipo_Entrega=@SegundaEntrega
left join Subtablas ApoyoEmocional on ApoyoEmocional.Id= ds.Id_Apoyo_Emocional
,
(
  select per.Id_Declaracion, count(per.Id)  as TotalFamilia,
   sum( case when (per.Edad>=0 and per.Edad<=5) then 1 else 0 end) as Ninos05,
   sum( case when (per.Edad>=6 and per.Edad<=17) then 1 else 0 end) as Ninos617
  from Personas per group by per.Id_Declaracion
) as PerCount 

WHERE     (Personas.Tipo = @Tipo_Persona)  
And Declaracion.Fecha_Valoracion >= @Fecha_Valoracion_Inicial
And Declaracion.Fecha_Valoracion <= @Fecha_Valoracion_Final
AND Declaracion.Tipo_Declaracion = @Tipo_Declaracion
and PerCount.Id_Declaracion= Declaracion.Id
order by Declaracion.Id
