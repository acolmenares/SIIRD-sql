USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_RetencionInsertar]    Script Date: 07/mar/2016 01:57:26 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OrdenCompra_RetencionInsertar]
@Id_OrdenCompra int, @Porcentaje numeric(18,2), @Valor numeric(18,2), @Id_Concepto int, @Base numeric(18,2), @Fecha_Cierre datetime, @Cierre bit
AS

INSERT OrdenCompra_Retencion
(
Id_OrdenCompra , Porcentaje , Valor , Id_Concepto , Base_Retencion , Fecha_Cierre , Cierre 
)
VALUES
(
@Id_OrdenCompra , @Porcentaje , @Valor , @Id_Concepto, @Base , @Fecha_Cierre , @Cierre 
)
SELECT SCOPE_IDENTITY()
