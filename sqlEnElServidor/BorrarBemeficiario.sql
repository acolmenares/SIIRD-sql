
declare @identificacion  varchar(25) = '1064488824' -- '1064488825' --99021315016

select * from Personas p where p.Identificacion= @identificacion  -- '1064488825'


delete from Personas_Regimen_Salud where Id_persona =
(select Id from Personas p where p.Identificacion=@identificacion)

delete from Personas where Id =
(select Id from Personas p where p.Identificacion=@identificacion)

select * from Personas p where p.Identificacion= @identificacion
