USE [IRDCOL]
GO
/****** Object:  UserDefinedFunction [dbo].[ConcatenarNombres]    Script Date: 19/ene/2016 05:30:43 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[ConcatenarNombres]
(
	-- Add the parameters for the function here
	@P_N varchar(256),
	@S_N varchar(256) ,
	@P_A varchar(256),
	@S_A varchar(256)
)
RETURNS varchar(256)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar (256);
	set @ResultVar= ltrim(rtrim(@P_N));
	if ( @S_N is not null) 
	    set @ResultVar=  @ResultVar+' '+ LTRIM(RTRIM( @S_N));
	if ( @P_A is not null) 
	    set @ResultVar=  @ResultVar+' '+ LTRIM(RTRIM( @P_A));
	if ( @S_A is not null) 
	    set @ResultVar=  @ResultVar+' '+ LTRIM(RTRIM( @S_A));

	-- Add the T-SQL statements to compute the return value here
	

	-- Return the result of the function
	RETURN @ResultVar;

END
