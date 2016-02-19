USE [IRDCOL]
Select Personas.*
	from SubTablas Lugarentrega
	LEFT OUTER JOIN Subtablas Regional ON Lugarentrega.Id_padre = Regional.Id,
	Declaracion
		LEFT OUTER JOIN personas ON Declaracion.Id = Personas.Id_declaracion
		LEFT OUTER JOIN Subtablas Grupos ON Declaracion.Id_grupo = Grupos.Id
		LEFT OUTER JOIN Subtablas Lentrega ON Grupos.Id_padre = Lentrega.Id
		LEFT OUTER JOIN Subtablas MunicipioEstudio ON Personas.Id_Municipio_Instituto_Actual = MunicipioEstudio.Id
	where Lugarentrega.Id_Tabla = 73
	And Lugarentrega.activo = 1  
	AND Tipo_Declaracion = 921 and Lentrega.Id = Lugarentrega.id
	And Id_Atender = 19 And Edad >= 6 and Edad <= 17  
	AND regional.id = 4521  
	And Fecha_Valoracion >= '01.10.2015 00:00:00' 
	And Fecha_Valoracion <= '30.11.2015 23:59:59'
	and not
	(
	personas.Id_Estudia_Actualmente = 20 and personas.Id_Motivo_NoEstudio = 1693 -- graduados
	or
	Id_Estudia_Actualmente = 19 and Id_Certificado = 19 and municipioestudio.descripcion = lentrega.descripcion -- estudian con certificacion
	or
	personas.Id_Estudia_Actualmente = 20 and personas.Id_Motivo_NoEstudio <> 1693 and personas.Id in  -- Rem-NO. Estud. MM
	(Select id_persona
	 from (Select top 1 *  from Personas_Educacion  where Id_Persona = personas.Id  order by fecha desc) as w
	 LEFT OUTER JOIN Subtablas Lugar ON w.Id_Municipio_Instituto = Lugar.Id
	 where  (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 19 and Lugar.Descripcion = lentrega.Descripcion)
	 or  (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 20 and Verificado_Entidad = 1 and Lugar.Descripcion = lentrega.Descripcion)
	 or  (Id_Estudia_Actualmente = 20 and Id_Motivo_NoEstudia = 1693) 
	)
	And Fecha_Valoracion >= '01.10.2015 00:00:00' 	
	And Fecha_Valoracion <= '30.11.2015 23:59:59' 
	or
	personas.Id_Estudia_Actualmente = 20 and personas.Id_Motivo_NoEstudio <> 1693 and personas.Id  in --Rem-NO. Estud. OMun  
	(Select id_persona
	 from (Select top 1 * from Personas_Educacion where Id_Persona = personas.Id  order by fecha desc, id desc) as w
	 LEFT OUTER JOIN Subtablas Lugar ON w.Id_Municipio_Instituto = Lugar.Id
	 where  (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 19 and Lugar.Descripcion <> lentrega.Descripcion)
	 or  (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 20 and Verificado_Entidad = 1 and Lugar.Descripcion <> lentrega.Descripcion) 
	)
	And Fecha_Valoracion >= '01.10.2015 00:00:00' 
	And Fecha_Valoracion <= '30.11.2015 23:59:59'
	or
	personas.Id_Estudia_Actualmente = 19 and Id_Certificado = 20and personas.Id  in 
	(Select id_persona
	 from (Select top 1 * from Personas_Educacion where Id_Persona = personas.Id   order by fecha desc ) as w
	 LEFT OUTER JOIN Subtablas Lugar ON w.Id_Municipio_Instituto = Lugar.Id
	 Where (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 19 and Lugar.Descripcion = lentrega.Descripcion) 
	 or  (Id_Estudia_Actualmente = 19 and Id_Certificado_Matricula = 20 and Verificado_Entidad = 1 and Lugar.Descripcion = lentrega.Descripcion)
	 or (Id_Estudia_Actualmente = 20 and Id_Motivo_NoEstudia = 1693))  
	 And Fecha_Valoracion >= '01.10.2015 00:00:00' 
	 And Fecha_Valoracion <= '30.11.2015 23:59:59'
	)
order by Personas.Id
