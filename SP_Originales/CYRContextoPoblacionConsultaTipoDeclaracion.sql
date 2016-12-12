USE [IRDCOL]
GO
/****** Object:  StoredProcedure [dbo].[CYRContextoPoblacionConsultaTipoDeclaracion]    Script Date: 12/12/2016 14:30:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---
--- exec dbo.CYRContextoPoblacionConsultaTipoDeclaracion  NULL,NULL,NULL,NULL,'01/oct/2014','31/Dec/2014',NULL,NULL,NULL,NULL,NULL,NULL
---  
ALTER Procedure [dbo].[CYRContextoPoblacionConsultaTipoDeclaracion]
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
@Grupos nvarchar(2000) = null

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

--
----aqui hago el proceso para Declaraciones
--
Set @Squery = '
Select Lugarentrega.ID,Regional.ID,regional.Descripcion as Regional , Lugarentrega.Descripcion as LugarEntrega 
,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 921 '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(2000))
End
-- Tipo de Entrega

if (@Id_Tipo_Entrega  > 0)
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

--
--- aqui hago el proceso para Total Beneficiarios
--

Set @Squery = @Squery + '
) as [Familias D],
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 921 '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega  > 0)
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

--
---aqui hago el proceso para Vulnerable F
--

Set @Squery = @Squery + '
) as [Beneficiarios D] ,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 922 ' 

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega
if (@Id_Tipo_Entrega  > 0)
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
--
---aqui hago el proceso para Vulnerable Beneficiario
--

Set @Squery = @Squery + '

) as [Vulnerable F] ,

(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 922 '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega  > 0)
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

--
---aqui hago el proceso para Especial Familia
--
Set @Squery = @Squery + '
) as [Vulnerable B] ,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 923 '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- Tipo de Entrega

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

--
-- aqui hago el proceso para Especial Beneficiario
--

Set @Squery = @Squery + '
) as [Especial F] ,
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 923 '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega  > 0)
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
--
-- aqui hago el proceso para TD Total Familia
-- 

Set @Squery = @Squery + '

) as [Especial B]
,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id  '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega  > 0)
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

--
--aqui hago el proceso para TD Total Beneficiarios
--

Set @Squery = @Squery + '

) as [Total Familias] ,
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id  '

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
-- Grupos
if (@Grupos) is not null
Begin
Set @Squery = @Squery + ' AND Declaracion.Id_Grupo in ' + cast(@Grupos as varchar(200))
End
-- TIpo de Entrega

if (@Id_Tipo_Entrega  > 0)
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

) as [Total Beneficiarios]


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

Set @Squery = @Squery + ' Order By regional.orden, lugarentrega.orden ';


--print(@Squery)
exec (@Squery)
