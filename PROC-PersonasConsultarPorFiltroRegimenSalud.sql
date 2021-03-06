USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[PersonasConsultarPorFiltroRegimenSalud]    Script Date: 07/ene/2016 04:16:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PersonasConsultarPorFiltroRegimenSalud]

@Id_grupo int = null, 
@Identificacion nvarchar(100) = null,
@Nombre nvarchar(100) =  null, 
@Id_regional int = null,
@Fecha_Inicial_Entrega nvarchar(11) = null,
@Fecha_Final_Entrega nvarchar(11) = null,
@wdeclarante int = null,
@Id_LugarEntrega int = null,
@Pendiente bit
As

Declare @Squery varchar(8000);
SET NOCOUNT ON;
SET Dateformat DMY;

declare @FecIniEnt varchar(20);
declare @FecFinEnt varchar(20);


Set @FecIniEnt = @Fecha_Inicial_Entrega + ' 00:00:00'
Set @FecFinEnt = @Fecha_Final_Entrega + ' 23:59:59'



Set @Squery = '
SELECT Personas.*, 
case rs_cerrar.Id_Cerrar when 19 then case  when (rs_cerrar.Id_Eps is null or rs_cerrar.Id_Eps= 635) then ''NO'' else ''SI'' end else ''NO'' end as Cerrado
FROM Declaracion
LEFT OUTER JOIN Personas ON Declaracion.Id = Personas.Id_Declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.id
left join Personas_Regimen_Salud rs_cerrar  
	on   rs_cerrar.Id= ( 
	select top 1 Personas_Regimen_Salud.Id  from Personas_Regimen_Salud
	where Personas_Regimen_Salud.Id_Persona=Personas.Id 
	order by Personas_Regimen_Salud.Fecha desc
	)
where declaracion.id_grupo <> 592  ';


if @id_Grupo is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.id_grupo = ' + cast(@id_Grupo as varchar) ;
End

If @identificacion is not null
Begin
Set @Squery = @Squery + 'AND Personas.identificacion like ''%' + cast(@identificacion as varchar(100)) + '%''';
End

If @nombre is not null
Begin
Set @Squery = @Squery + 'AND (Personas.Primer_Nombre like ''%' + cast(@nombre as varchar(100)) + '%''
   or Personas.Primer_Apellido like ''%' + cast(@nombre as varchar(100)) + '%'')';
End

if @id_Regional is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.id_regional = ' + cast(@id_Regional as varchar) ;
End

If (@Fecha_Inicial_Entrega is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniEnt as varchar) + ''''
End

If (@Fecha_Final_Entrega is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinEnt as varchar) + ''''
End

if @wdeclarante is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.tipo_declaracion  = ' + cast(@wdeclarante as varchar) ;
End

if @Id_LugarEntrega is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_LugarEntrega as varchar) ;
End

if @Pendiente = 1
Begin
/*
Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id_persona
  from Personas_regimen_salud pers where pers.Id_Tipo_Entrega = 72
   and pers.Id_regimen_Salud <> 173 and pers.id_persona = personas.Id) '
  
Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id_persona
  from Personas_regimen_salud pers where pers.Id_Tipo_Entrega = 919
   and pers.Id_regimen_Salud <> 173 and pers.id_persona = personas.Id) '

Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id_persona
  from Personas_regimen_salud pers where pers.Id_Tipo_Entrega = 918
   and pers.Id_regimen_Salud <> 173 and pers.id_persona = personas.Id) '
 
Set @Squery = @Squery + ' and personas.Id not in ( select Pers.id_persona
  from Personas_regimen_salud pers where pers.Id_Cerrar = 19
    and pers.id_persona = personas.Id) '   
	*/
  Set @Squery= @Squery + ' and (rs_cerrar.Id_Cerrar!=19 or rs_cerrar.Id_Eps is null or rs_cerrar.Id_Eps=635)';
End


--print(@Squery)
exec (@Squery)
