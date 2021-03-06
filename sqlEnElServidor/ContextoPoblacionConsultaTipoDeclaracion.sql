-- del PROC CYRContextoPoblacionConsultaTipoDeclaracion
use IRDCOL

Select Lugarentrega.ID,Regional.ID,regional.Descripcion as Regional , Lugarentrega.Descripcion as LugarEntrega 
,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 921  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72 and Programacion.Fecha>= '20161001 00:00:00' And Programacion.Fecha <= '20161130 23:59:59')
) as [Familias D],
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 921  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)
) as [Beneficiarios D] ,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 922  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)

) as [Vulnerable F] ,

(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 922  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)
) as [Vulnerable B] ,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 923  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)
) as [Especial F] ,
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id 
and declaracion.tipo_declaracion = 923  And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)

) as [Especial B]
,
(Select COUNT(declaracion.id) from Declaracion 
where id_lugar_fuente = Lugarentrega.id   And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)

) as [Total Familias] ,
(Select COUNT(personas.id) from Declaracion 
LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
where id_lugar_fuente = Lugarentrega.id   And Declaracion.Fecha_Valoracion >= '20161001 00:00:00' And Declaracion.Fecha_Valoracion <= '20161130 23:59:59' AND Declaracion.Id = 
   (Select top 1 Id_Declaracion 
    from declaracion_estados
    LEFT OUTER JOIN Programacion ON Declaracion_estados.Id_programa = Programacion.Id
    where id_tipo_estado in (4038, 4039)
    and id_como_estado = 19
    and declaracion_estados.id_declaracion = declaracion.id
    and id_asistio = 19 
    and programacion.Id_TipoEntrega = 72)

) as [Total Beneficiarios]


from SubTablas Lugarentrega
LEFT OUTER JOIN Subtablas Regional ON Lugarentrega.Id_padre = Regional.Id
where Lugarentrega.Id_Tabla = 73
And Lugarentrega.activo = 1  Order By regional.orden, lugarentrega.orden 
