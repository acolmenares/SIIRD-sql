USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[OrdenCompra_DetalleEliminar]    Script Date: 07/mar/2016 01:46:43 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[OrdenCompra_DetalleEliminar]
@Id int
AS
DELETE OrdenCompra_Detalle
WHERE Id = @Id



