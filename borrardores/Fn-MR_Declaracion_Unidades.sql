USE [IRDCOL]
GO
/****** Object:  UserDefinedFunction [dbo].[MR_Declaracion_Unidades]    Script Date: 02/mar/2016 09:23:45 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[MR_Declaracion_Unidades]
(
	-- Add the parameters for the function here
	@Id_Declaracion int,
	@Id_Unidad int,
	@FechaCorte Date = null
)
RETURNS int
AS
BEGIN
	if( @FechaCorte is null) SET @FechaCorte=(CONVERT(VARCHAR(10),GETDATE(),103))

	-- Declare the return variable here
	--DECLARE @Id int;

	-- Add the T-SQL statements to compute the return value here
	return (select top 1 Declaracion_Unidades.Id  from Declaracion_Unidades
	where Declaracion_Unidades.Id_Declaracion=@Id_Declaracion
	and Declaracion_Unidades.Fecha_Investigacion<= @FechaCorte
	and Declaracion_Unidades.Id_Unidad=@Id_Unidad  --32  -- RUV
	order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
	)
	
	-- Return the result of the function
	--RETURN @Id

END
