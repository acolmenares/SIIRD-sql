USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_RetencionActualizar]    Script Date: 07/mar/2016 01:56:40 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  

ALTER PROCEDURE [dbo].[OrdenCompra_RetencionActualizar]
@Id int, @Id_OrdenCompra int, @Porcentaje numeric(18,2), @Valor numeric(18,2), @Id_Concepto int, @Base numeric(18,2), @Fecha_Cierre datetime, @Cierre bit
AS
UPDATE OrdenCompra_Retencion
SET Id_OrdenCompra = @Id_OrdenCompra ,
	Porcentaje = @Porcentaje,
	Valor = @Valor,
	Id_Concepto = @Id_Concepto,
	Base_Retencion = @Base,
	Fecha_Cierre = @Fecha_Cierre, 
	Cierre = @Cierre 
WHERE Id = @Id
