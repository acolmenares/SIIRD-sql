USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[RUVConsultaNoValorados]    Script Date: 01/mar/2016 09:55:47 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Angel Colmenares>
-- Create date: <20160211>
-- Description:	<Dentro de los elegibles (elegible y atender) busca los que no tienen registro de RUV>
-- =============================================
ALTER PROCEDURE [dbo].[RUVConsultaNoValorados]
	-- Add the parameters for the stored procedure here
	@FechaRadicacionInicial date=null, @FechaRadicacionFinal date=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here

select 
Declaracion.Id as Id_Declaracion,
Declaracion.Id_Regional, 
Personas.Id as Id_Persona, 
Declaracion.Numero_Declaracion as Numero_Declaracion,
Declaracion.Fecha_Desplazamiento,
Declaracion.Fecha_Declaracion as Fecha_Declaracion,
Declaracion.Fecha_Radicacion as Fecha_Radicacion,
Declaracion.Fecha_Valoracion, 
Personas.Id_Tipo_Identificacion,
Personas.Identificacion,
Personas.Primer_Apellido, 
Coalesce(Personas.Segundo_Apellido,'') as Segundo_Apellido,
Personas.Primer_Nombre, 
Coalesce(Personas.Segundo_Nombre,'') as Segundo_Nombre
from
Declaracion
left JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion 
left join SubTablas TipoIdentificacion on TipoIdentificacion.Id= Personas.Id_Tipo_Identificacion
left join Declaracion_Estados de
	on   de.Id= ( 
	select top 1 Declaracion_Estados.Id  
	from Declaracion_Estados
	where Declaracion_Estados.Id_Declaracion=Declaracion.Id 
	and Declaracion_Estados.Id_Tipo_Estado=4036  -- elegible
	order by Declaracion_Estados.Fecha desc, Declaracion_estados.Id desc
	)
left join Declaracion_Unidades RUV 
	on   RUV.Id= ( 
	select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=Declaracion.Id 
	and Declaracion_Unidades.Id_Unidad=32  -- RUV
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
--left join SubTablas EstadoRUV on EstadoRUV.Id= RUV.Id_EstadoUnidad

where
Declaracion.Tipo_Declaracion=921  -- desplazado
and (Declaracion.Id_Regional = 1637 or Declaracion.Id_Regional = 4521)
and Personas.Tipo='D'  -- solo la persona declarante
and de.Id_Como_Estado=19  -- elegible si
and( Declaracion.Id_Atender=19 or Declaracion.Id_Atender is null ) -- SI atender o por definirse
and Ruv.Id is null  -- no esta en Declaracion_Unidades
and Declaracion.Fecha_Radicacion>= isnull(@FechaRadicacionInicial,Declaracion.Fecha_Radicacion)
and Declaracion.Fecha_Radicacion<=ISNULL( @FechaRadicacionFinal, Declaracion.Fecha_Radicacion)

order by Declaracion.Id


END
