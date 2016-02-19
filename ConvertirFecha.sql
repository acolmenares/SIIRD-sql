USE [IRDCOL]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertirFecha]    Script Date: 01/07/2016 10:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[ConvertirFecha]
(
	@Fecha datetime
)
RETURNS varchar(10)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(10);
	-- Add the T-SQL statements to compute the return value here
	if( @Fecha is null)
		set @ResultVar= ''
	else
	    set @ResultVar=  LEFT( CONVERT(Varchar(10), @Fecha, 120),10)
	-- Return the result of the function
	RETURN @ResultVar
END
--case isnull(Declaracion.Fecha_Radicacion,'') when '' then '' else 
--LEFT(CONVERT(VARCHAR, Declaracion.Fecha_Radicacion, 120), 10 )  end as Fecha_Radicacion,
