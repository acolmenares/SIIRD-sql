USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[CYRContextoPoblacionConsultaEdades]    Script Date: 12/abr/2016 01:34:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[CYRContextoPoblacionConsultaEdades] 
@Fecha_Atencion_Inicial nvarchar(11) = null,
@Fecha_Atencion_Final nvarchar(11)= null,

@Fecha_Declaracion_Inicial nvarchar(11)= null,
@Fecha_Declaracion_Final nvarchar(11)= null,

@Fecha_Radicacion_Inicial nvarchar(11)= null,
@Fecha_Radicacion_Final nvarchar(11)= null,

@Fecha_Desplazamiento_Inicial nvarchar(11)= null,
@Fecha_Desplazamiento_Final nvarchar(11)= null,

@Id_Regional int = null,
@Id_Lugar_Entrega int= null,
@Id_Tipo_Entrega int= null,
@Grupos nvarchar(2000) = null,
@Id_Tipo_Declaracion int= null

AS

Declare @Squery varchar(8000);
SET NOCOUNT ON;
SET Dateformat DMY;

declare @FecIniAte varchar(20);
declare @FecFinAte varchar(20);

Set @FecIniAte = @Fecha_Atencion_Inicial + ' 00:00:00'
Set @FecFinAte = @Fecha_Atencion_Final + ' 23:59:59'

declare @FecIniDec varchar(20);
declare @FecFinDec varchar(20);

Set @FecIniDec = @Fecha_Declaracion_Inicial + ' 00:00:00'
Set @FecFinDec = @Fecha_Declaracion_Final + ' 23:59:59'

declare @FecIniRad varchar(20);
declare @FecFinRad varchar(20);

Set @FecIniRad = @Fecha_Radicacion_Inicial + ' 00:00:00'
Set @FecFinRad = @Fecha_Radicacion_Final + ' 23:59:59'

declare @FecIniDes varchar(20);
declare @FecFinDes varchar(20);

Set @FecIniDes = @Fecha_Desplazamiento_Inicial + ' 00:00:00'
Set @FecFinDes = @Fecha_Desplazamiento_Final + ' 23:59:59'


Set @Squery = '

Select Lugarentrega.ID,regional.id,regional.Descripcion as Regional , Lugarentrega.Descripcion as LugarEntrega 

,
--
-- aqui hago el proceso para Declaraciones
--
(Select COUNT(declaracion.id) from Declaracion 
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
where lentrega.id = Lugarentrega.id  '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega >0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End



Set @Squery = @Squery + '

) as Familias ,

--
-- aqui hago el proceso para Total Personas
--
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
where lentrega.id = Lugarentrega.id '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End



Set @Squery = @Squery + '

) as Beneficiarios ,

--
-- aqui hago el proceso para Edad <= 5
--
(Select COUNT(personas.id) from Declaracion
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
LEFT OUTER JOIN Subtablas Regional ON Lentrega.Id_padre = Regional.Id
where lentrega.id = Lugarentrega.id 
and Personas.edad <= 5 '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End



Set @Squery = @Squery + '

) as [Edad <= 5] ,

--
-- aqui hago el proceso para Edad >= 6 y <=17
--
(Select COUNT(personas.id) from Declaracion
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
LEFT OUTER JOIN Subtablas Regional ON Lentrega.Id_padre = Regional.Id
where lentrega.id = Lugarentrega.id 
and personas.edad >= 6 and personas.edad <= 17 '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End


-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End

Set @Squery = @Squery + '

) as [Edad >= 6 y <= 17] ,

--
-- aqui hago el proceso para Edad >= 18 y <= 25
--
(Select COUNT(personas.id) from Declaracion
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
LEFT OUTER JOIN Subtablas Regional ON Lentrega.Id_padre = Regional.Id
where lentrega.id= Lugarentrega.id 
and personas.edad >= 18 and personas.edad <= 25  '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End
/* */
Set @Squery = @Squery + '

) as [Edad >= 18 y <= 25] ,

--
-- aqui hago el proceso para Edad >= 26 y <= 59
--
(Select COUNT(personas.id) from Declaracion
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
LEFT OUTER JOIN Subtablas Regional ON Lentrega.Id_padre = Regional.Id
where lentrega.id= Lugarentrega.id 
and personas.edad >= 26 and personas.edad <= 59  '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End


/* */
Set @Squery = @Squery + '

) as [Edad >= 26 y <= 59]

,
--
-- aqui hago el proceso Total Edad >= 60
--
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
LEFT OUTER JOIN Subtablas Regional ON Lentrega.Id_padre = Regional.Id
where lentrega.id = Lugarentrega.id
and personas.Edad >= 60 '

-- Tipo de Declaracion
if (@Id_Tipo_Declaracion > 0 )
Begin
Set @Squery = @Squery + ' And Declaracion.tipo_declaracion = ' + cast(@Id_Tipo_Declaracion as varchar)
End

-- Fechas de Atencion
If (@Fecha_Atencion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion >= ''' + cast(@FecIniAte as varchar) + ''''
End

If (@Fecha_Atencion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Valoracion <= ''' + cast(@FecFinAte as varchar) + ''''
End

-- Fechas de Declaracion
If (@Fecha_Declaracion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion >= ''' + cast(@FecIniDec as varchar) + ''''
End

If (@Fecha_Declaracion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Declaracion <= ''' + cast(@FecFinDec as varchar) + ''''
End

-- Fechas de Radicacion
If (@Fecha_Radicacion_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion >= ''' + cast(@FecIniRad as varchar) + ''''
End

If (@Fecha_Radicacion_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Radicacion <= ''' + cast(@FecFinRad as varchar) + ''''
End

-- Fechas de Desplazamiento
If (@Fecha_Desplazamiento_Inicial is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento >= ''' + cast(@FecIniDes as varchar) + ''''
End

If (@Fecha_Desplazamiento_Final is not null)
Begin
set @sQuery = @sQuery + ' And Declaracion.Fecha_Desplazamiento <= ''' + cast(@FecFinDes as varchar) + ''''
End
-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Regional = ' + cast(@Id_Regional as varchar)
End
-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Lugar_Fuente = ' + cast(@Id_Lugar_Entrega as varchar)
End
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = ' + cast(@Id_Tipo_Entrega as varchar) + ')' 
End



Set @Squery = @Squery + '

) as [Edad >= 60]


from SubTablas Lugarentrega
LEFT OUTER JOIN Subtablas Regional ON Lugarentrega.Id_padre = Regional.Id
where Lugarentrega.Id_Tabla = 73
And Lugarentrega.activo = 1 ';



-- Regional
if (@Id_Regional > 0)
Begin
Set @Squery = @Squery + ' AND Regional.Id = ' + cast(@Id_Regional as varchar)
End

-- Lugar de Entrega
if (@Id_Lugar_Entrega > 0)
Begin
Set @Squery = @Squery + ' AND Lugarentrega.Id = ' + cast(@Id_Lugar_Entrega as varchar)
End

Set @Squery = @Squery + ' Order BY regional.orden, lugarentrega.orden ';

--print(@Squery)
exec (@Squery)

