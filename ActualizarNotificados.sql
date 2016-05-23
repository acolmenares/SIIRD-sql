use IRDCOL

declare @id_unidad_notificacion int = 1501;
declare @id_no_notificado int = 166;
declare @id_notificado int = 165;
declare @Id_EstadoUnidad_notificacion int;

declare @fud varchar(25);
declare @identificacion varchar(25);
declare @Id_Declaracion int;


declare @Id_UARIV int;

declare @Fecha_Notificacion datetime;
declare @Fecha_Investigacion datetime= getdate();
declare @Fecha_Creacion datetime = getdate();
declare @Id_Usuario_Creacion int =0;
declare @Fuente varchar(25) = 'En Unidad'

declare @orfeo_aa varchar(50);

declare @id_unidad_AA int = 161;
declare @id_no_aa int = 402;
declare @id_cargado int = 164;
declare @Id_EstadoUnidad_AA int;
declare @Fecha_AA datetime;
declare @id_aa int;
declare @id_notificacion int;


DECLARE Cur CURSOR FOR
    SELECT 
	ua.Id, ua.Numero_Declaracion, ua.Identificacion, ua.Fecha_Notificacion, 
	ua.Orfeo_AA, ua.Fecha_AA
	from  UARIV_Notificacion ua 
	where ( (ua.Id_Notificacion is null and  not( Fecha_Notificacion is null or   Fecha_Notificacion='19000101') )
	 or (ua.Id_AA is null and  not( Fecha_AA is null  or Fecha_AA='19000101') ))
OPEN Cur 
FETCH NEXT FROM Cur INTO @id_UARIV, @fud, @identificacion, @Fecha_Notificacion, @Orfeo_aa, @Fecha_AA
WHILE ( @@FETCH_STATUS = 0 )
    BEGIN
        print ('=')		
		print(@id_UARIV )
		print(@fud )
		print(@identificacion)
		set @Id_Declaracion=null;
		select @Id_Declaracion = d.Id from Declaracion d
		join Personas P on p.Id_Declaracion= d.Id and p.Identificacion= @identificacion
		where d.Numero_Declaracion=@fud 
		print ('Id_Declaracion')
		print (@Id_Declaracion)
		if( not  @Id_Declaracion is null)
		begin
		    set @id_aa=null;
			set @id_notificacion=null;
		    if( not( @Fecha_Notificacion is null or   @Fecha_Notificacion='19000101'))
			begin
		    set @Id_EstadoUnidad_notificacion=null;
		    select top 1 @Id_EstadoUnidad_notificacion= Declaracion_Unidades.Id_EstadoUnidad  from Declaracion_Unidades
				where Declaracion_Unidades.Id_Declaracion=@Id_Declaracion
				and Declaracion_Unidades.Id_Unidad=@id_unidad_notificacion 
				order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
            print ('@Id_EstadoUnidad_notificacion');
			
			if( @Id_EstadoUnidad_notificacion is null or @Id_EstadoUnidad_notificacion=@id_no_notificado)
			begin
				set @Id_EstadoUnidad_notificacion=@id_notificado;	
				INSERT Declaracion_Unidades(
				Id_Declaracion, Id_Unidad, Id_EstadoUnidad, Fecha_Inclusion, Fecha_Investigacion, Fecha_Creacion, Id_Usuario_Creacion, Fuente)
				VALUES
				(@Id_Declaracion, @Id_Unidad_notificacion, @Id_EstadoUnidad_notificacion,  @Fecha_Notificacion, @Fecha_Investigacion, @Fecha_Creacion, @Id_Usuario_Creacion, @Fuente	)
				select @id_notificacion= SCOPE_IDENTITY();
			end
			end

			if(not( @Fecha_AA is null  or @Fecha_AA='19000101') )
			begin
			    set @Id_EstadoUnidad_AA=null;
				select top 1 @Id_EstadoUnidad_AA= Declaracion_Unidades.Id_EstadoUnidad  from Declaracion_Unidades
				where Declaracion_Unidades.Id_Declaracion=@Id_Declaracion
				and Declaracion_Unidades.Id_Unidad=@id_unidad_AA
				order by Declaracion_Unidades.Fecha_Investigacion desc, Declaracion_Unidades.Id desc
				print ('@Id_EstadoUnidad_AA');
				print (@Id_EstadoUnidad_aa);
				if( @Id_EstadoUnidad_AA is null or @Id_EstadoUnidad_AA=@id_no_aa)
				begin
				    set @Id_EstadoUnidad_AA=@id_cargado;
			        INSERT Declaracion_Unidades(
			        Id_Declaracion, Id_Unidad, Id_EstadoUnidad, Fecha_Inclusion, Fecha_Investigacion, Fecha_Creacion, Id_Usuario_Creacion, Fuente)
			        VALUES
			        (@Id_Declaracion, @Id_Unidad_AA, @Id_EstadoUnidad_AA,  @Fecha_AA, @Fecha_Investigacion, @Fecha_Creacion, @Id_Usuario_Creacion, @Fuente	)
					select @id_aa= SCOPE_IDENTITY();
				end
			end
			
			update UARIV_Notificacion 
			set Id_Declaracion= @Id_Declaracion, 
			Fecha_Proceso=getDate(),
			Id_Notificacion=@id_notificacion,
			Id_AA= @Id_AA
			where Id= @Id_UARIV;
		end
        FETCH NEXT FROM Cur INTO @id_UARIV, @fud, @identificacion, @Fecha_Notificacion, @Orfeo_aa, @Fecha_AA
    END

CLOSE Cur 
DEALLOCATE Cur 


/*

*/
