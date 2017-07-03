USE [master]
GO

CREATE DATABASE [ComeYa]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ComeYa', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\ComeYa.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ComeYa_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\ComeYa_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ComeYa].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [ComeYa] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ComeYa] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ComeYa] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ComeYa] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ComeYa] SET ARITHABORT OFF 
GO
ALTER DATABASE [ComeYa] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ComeYa] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ComeYa] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ComeYa] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ComeYa] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ComeYa] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ComeYa] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ComeYa] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ComeYa] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ComeYa] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ComeYa] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ComeYa] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ComeYa] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ComeYa] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ComeYa] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ComeYa] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ComeYa] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ComeYa] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ComeYa] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ComeYa] SET  MULTI_USER 
GO
ALTER DATABASE [ComeYa] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ComeYa] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ComeYa] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ComeYa] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

USE [ComeYa]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
GO


CREATE TABLE [dbo].[RECETA](
	[recetaID] [int] NOT NULL,
	[titulo] [varchar](30) NULL,
	[preparaci�n] [varchar](MAX) NULL,
	[ratingProm] [float] NULL,
	CONSTRAINT [PK_Rec_recetaID] PRIMARY KEY CLUSTERED (recetaID)
) 
GO

CREATE TABLE [dbo].[USUARIO](
	[userID] [int] IDENTITY(1,1) NOT NULL,
	[loginName] [nvarchar](40) NOT NULL,
	[PasswordHash] [BINARY](64) NOT NULL,
	[email] [nvarchar](40) NOT NULL,
    CONSTRAINT [PK_User_userID] PRIMARY KEY CLUSTERED (userID ASC)
 )
GO

CREATE TABLE [dbo].[CATEGORIA](
	[catID] [int] NOT NULL,
	[catNomb] [varchar](30) NULL,
	CONSTRAINT [PK_Cat_catID] PRIMARY KEY CLUSTERED (catID)
)
GO

CREATE TABLE [dbo].[INGREDIENTE](
	[ingredID] [int] NOT NULL,
	[nombIng] [varchar](30) NULL,
	CONSTRAINT [PK_Ing_ingredID] PRIMARY KEY CLUSTERED (ingredID)
)
GO

CREATE TABLE [dbo].[RECETA_USER](
	[userID] [int] IDENTITY(1,1)NOT NULL,
	[recetaID] [int] NOT NULL,
	[rating] [float] NULL,
	[usada] [bit] NULL,
	CONSTRAINT fk_rec_us1 FOREIGN KEY(recetaID) REFERENCES RECETA(recetaID),
	CONSTRAINT fk_rec_us2 FOREIGN KEY(userID) REFERENCES USUARIO(userID)
) 
GO

CREATE TABLE [dbo].[USER_PREF_CAT](
	[userID] [int] NOT NULL,
	[catID] [int] NOT NULL,
	[prefer] [bit] NULL,
	CONSTRAINT fk_us_prefcat1 FOREIGN KEY(userID) REFERENCES USUARIO(userID),
	CONSTRAINT fk_us_prefcat2 FOREIGN KEY(catID) REFERENCES CATEGORIA(catID)
) 
GO

CREATE TABLE [dbo].[CATEGORIA_RECETA](
	[catID] [int] NOT NULL,
	[recetaID] [int] NOT NULL,
	CONSTRAINT fk_cat_rec1 FOREIGN KEY(catID) REFERENCES CATEGORIA(catID),
	CONSTRAINT fk_cat_rec2 FOREIGN KEY(recetaID) REFERENCES RECETA(recetaID)
) 
GO

CREATE TABLE [dbo].[RECETA_INGRED](
	[ingredID] [int] NOT NULL,
	[recetaID] [int] NOT NULL,
	[cantidad] [int] NULL,
	CONSTRAINT fk_rec_ing1 FOREIGN KEY(ingredID) REFERENCES INGREDIENTE(ingredID),
	CONSTRAINT fk_rec_ing2 FOREIGN KEY(recetaID) REFERENCES RECETA(recetaID)
) 
GO

--PROCEDIMIENTOS ZOKULENTOS ;V


--agregandoles salt al gusto eks-di
ALTER TABLE dbo.[USUARIO] ADD Salt UNIQUEIDENTIFIER 
GO
--agregando un usuario
CREATE PROCEDURE dbo.uspAddUser
    @pLogin NVARCHAR(50), 
	@pEmail NVARCHAR(50),
    @pPassword NVARCHAR(36),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    BEGIN TRY
       INSERT INTO [dbo].[USUARIO](LoginName, email, PasswordHash, Salt) 
       VALUES(@pLogin, @pEmail, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt)
       SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
go

/*  
--verificando que el usuario se ingres�

DECLARE @responseMessage NVARCHAR(250)

EXEC dbo.uspAddUser
          @pLogin = N'Admin',
          @pEmail = N'admin',
          @pPassword = N'123',
          @responseMessage=@responseMessage OUTPUT

SELECT userID, loginName, email, PasswordHash, Salt
FROM [dbo].[USUARIO]
GO

--
CREATE PROCEDURE dbo.uspLogin

    @pLoginName NVARCHAR(254),
    @pPassword NVARCHAR(50),
    @responseMessage NVARCHAR(250)='' OUTPUT
AS
BEGIN

    SET NOCOUNT ON

    DECLARE @userID INT

    IF EXISTS (SELECT TOP 1 userID FROM [dbo].[USUARIO] WHERE LoginName=@pLoginName)
    BEGIN
        SET @userID=(SELECT userID FROM [dbo].[USUARIO] WHERE LoginName=@pLoginName AND PasswordHash=HASHBYTES('SHA2_512', @pPassword+CAST(Salt AS NVARCHAR(36))))

       IF(@userID IS NULL)
           SET @responseMessage='Password incorrecto'
       ELSE 
           SET @responseMessage='Usuario logueado satisfactoriamente'
    END
    ELSE
       SET @responseMessage='Acceso inv�lido lince ;v'

END
GO
--

DECLARE	@responseMessage nvarchar(250)

--Correct login and password

EXEC	dbo.uspLogin
		@pLoginName = N'Admin',
		@pPassword = N'123',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'

--Incorrect login
EXEC	dbo.uspLogin
		@pLoginName = N'Admin1', 
		@pPassword = N'123',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'

--Incorrect password
EXEC	dbo.uspLogin
		@pLoginName = N'Admin', 
		@pPassword = N'1234',
		@responseMessage = @responseMessage OUTPUT

SELECT	@responseMessage as N'@responseMessage'
	

	*/

--INSERCI�N DE DEM�S USUARIOS :V :V V: V:

--LLAMAR AL PROCESO ADDUSER

--INSERCI�N DE LOS DATOS EN LAS DEM�S TABLAS


INSERT INTO RECETA (recetaID, titulo, preparaci�n,ratingProm) 
VALUES
(10501, 'Huevo frito'
,'Fr�a un huevo. A�ada sal al gusto. A�ada detalles. Disfrute.'
, 4.2),

(10502, 'Lomo Saltado'
,'1. Cortamos la carne de res en cubos de regular tama�o (2 cm. por 2 cm. est� bien) y lo sazonamos con un poco de sal y pimienta (no mucho porque si nos excedemos en la saz�n no ser� muy agradable que digamos, pero en cambio si nos falta algo de sal o algo de pimienta se podr� rectificar al final).
2. Cortamos las cebollas en tiras gruesas a lo largo. Un truco es dividir la cebolla en ocho partes: hacemos un corte vertical para dividir la cebolla en dos mitades, luego hacemos un corte horizontal para formar una cruz y dividir la cebolla en cuartos, a continuaci�n hacemos un corte diagonal y finalmente un corte diagonal en sentido contrario. De este modo tendremos ocho trozos de cebolla en capas gruesas y largas.
3. Hacemos lo mismo con los tomates, y les quitamos las semillas.
4. Cortamos tambi�n el aj� amarillo en tiras largas. Se trata de un ingrediente opcional, pues algunos cocineros no lo ponen, pero su presencia contribuye al sabor y le da color al plato.
5. En una sart�n con un poco de aceite bien caliente doramos ligeramente los dos dientes de ajos molidos o picados.'
,3.1),

(10503, 'Arroz con pollo'
, '1.	Salpimentar y fre�r las presas de pollo en aceite caliente. Retirar presas. Dorar en ese mismo aceite los ajos, la cebolla, el aj� y el culantro.
2.	Colocar las presas de pollo nuevamente, a�adir la cerveza y seguir cocinando hasta que el pollo est� listo.
3.	Retirar las presas, sin dejar que se enfr�en. Incorporar el arroz, las arvejas, el choclo y el pimiento. Mezclar bien.
4.	Agregar el agua, rectificando la saz�n y llevar a hervir. Bajar el fuego y seguir cocinando 20 minutos m�s hasta que el arroz est� cocido.
5.	Servir el arroz con las presas de pollo bien calientes y decorar con ensalada de palta o cebolla.'
,2.1),

(10504, 'Leche asada'
, '1.	Se mezcla la leche condensada, la evaporada, el az�car y la esencia de vainilla, luego se echan los huevos previamente batidos.
2.	Se llevan al horno Ba�o Mar�a por una hora (350�F � 175�C). El molde previamente debe estar acaramelado.'
,1.0),

(10505, 'Pud�n'
,'1.	Cortar el pan en trocitos peque�os. En un bol remojar el pan con la mitad de la leche. Mientras tanto, hacer un caramelo poniendo al fuego un cazo con 6 cucharadas soperas de az�car y 6 cucharadas soperas de agua. Cuando est� doradito, ba�ar el molde que vayamos a utilizar para el pudin.
2.	En otro bol, batir con las varillas la otra mitad de la leche, con el az�car restante, los huevos y las semillas de la vaina de vainilla, que las habremos extraido raspando con la punta de un cuchillo. Cuando est� todo bien mezclado, vertero en el otro bol donde ten�amos la leche y el pan y remover bien. Triturar la mezcla para que quede bien fino.
3.	Si elegimos el pudin sin frutas ni chocolate, verter el contenido en el molde caramelizado. Si decidomos utilizar frutas secas o chocolate, verterlas al bol y mezclar bien antes de verter en el molde.
4.	Precalentar el horno a una temperatura de 150�.
5.	Colocar el molde en una placa de horno, con dos dedos de agua de altura, para cocerlo al ba�o Mar�a. Bajar la temperatura del horno a 100� y hornear hasta que cuaje. Aproximadamente 35-40 minutos.
6.	Sacar del horno y dejar templar a temperatura ambiente.'
,5.0),

(10506, 'Arroz a la cubana', 
'1.	Cocer el arroz durante 20 minutos en abundante agua hirviendo con una pizca de sal. Escurre, refresca y res�rvalo en un plato.
2.	Corta 2 dientes de ajo en l�minas y ponlos a dorar en una cazuela con un poco de aceite. Agrega la panceta picada. Rehoga brevemente y vierte la salsa de tomate. A�ade un poco de albahaca (1 cucharada de las de caf�). Cocina todo junto durante 5 minutos.
3.	En una sart�n dora los otros dos dientes de ajo picados. Cuando se doren, a�ade el arroz. Saltea y mezcla bien.
4.	En otra sart�n con abundante aceite, fr�e los huevos. Pasa los pl�tanos por harina y fr�elos en la misma sart�n.
5.	Unta cuatro tazas con un poco de aceite, coloca en el fondo una hojita de perejil, ll�nalos con el arroz y desmolda cada uno sobre un plato. Sirve al lado un huevo, un poco de salsa de tomate y un pl�tano frito.'
, 3.4),

(10507, 'Picante de carne'
, '1.	Lavar y cortar la carne de res en cuadritos o dados.
2.	Hacer lo mismo con las papas blancas, pel�ndolas y pic�ndolas de igual manera, pero dej�ndolas remojar para que se ablanden.
3.	Aparte, preparar la saz�n, uniendo la carne de res picada, las cebollas, los ajos, la sal y pimienta, llev�ndolos al fuego hasta que cocinen bien.
4.	Retirar y dejar reposar diez minutos antes de servir el picante.'
, 3.4),

(10508, 'Ensalada rusa'
,'1.	Primero hierve las papas (patatas), las betarragas y las zanahorias, todas con sin pelar. Las zanahorias normalmente necesitan m�s tiempo
2.	Cuando est�n hervidas retira las verduras, d�jalas enfriar y las p�lalas
3.	Mientras tanto pon en otra olla las vainitas y los guisantes y hi�rvelos sin pasarte de hervor
4.	En otra olla hierve los huevos
5.	Cuando tengas todo hervido, pica las papas, las beterragas y las zanahorias en dados
6.	Agrega las vainitas y los guisantes
7.	A�ade mayonesa, sal y pimienta al gusto. Remu�velo todo
8.	Para servir pon una hoja de lechuga y en el centro un poco de ensalada.'
, 3.4),

(10509, 'Olluquito'
, '1.	En un olla fre�r en aceite caliente la cebolla y luego el aj� panca, hasta que est� bien dorado e integrado.
2.	Ahora, agregar ajos, carne, sal, cocinar un poco y luego adicionar los olluquitos, pimienta y or�gano, as� como las ramitas de perejil, en este proceso revolver para integrar bien los sabores.
3.	Finalmente, servir con arroz blanco y camote sancochado.'
, 3.4),

(10510, 'Chanfainita'
, '1.	Lavar y limpiar bien el bofe de res y llevar a la cocci�n en una olla con agua.
Cuando el bofe est� cocinado, escurrirlo y picarlo en cuadraditos.
2.	En otra cacerola u olla aparte, calentar el aceite y fre�r la cebolla, el ajo, el aj� amarillo, el aj� panca, la sal, la pimienta y el comino hasta que doren.
3.	Agregar el bofe de res y la hierbabuena. Fre�r durantes unos minutos m�s y a�adir el caldo junto con las papas. Tapar y dejar que hierva hasta que se cocicen las papas.
4.	Disolver la maicena en agua, luego agregarla a la olla de la cocci�n, mover constantemente y dejar que cocine por 5 minutos m�s. Cuando est� listo rociarle or�gano.
5.	Servir con arroz blanco y mote cocido rociado de perejil picado.'
, 3.4),

(10511, 'Locro'
, '1.	Calentar el aceite en una olla y preparar un aderezo con la cebolla, los ajos, el aj� molido y el or�gano. Cocinar unos minutos y agregar el zapallo, las arvejas, las papas y los choclos.
2.	Tapar olla, y cocinar a fuego lento hasta que los ingredientes est�n cocidos. A�adir la leche, y el queso fresco. Mezclar y sazonar. Retirar.
3.	Finalmente, servir con trozos de queso fresco y aceitunas. Acompa�ar con arroz blanco.'
, 3.4),

(10512, 'Ceviche'
, '1.	Cortar la cebolla al hilo, en pluma. Se recomienda partir la cebolla por la mitad, quitarle la primera capa, colocar una mitad sobre la tabla de picar, hacer cortes delgados, y repetir con la otra mitad. Una vez cortada la cebolla lavarla para quitarle el amargor.
2.	Extraer el zumo de los limones exprimi�ndolos a mano, y guardar el zumo en un recipiente. Un punto a tener en cuenta es que no se debe exprimir el lim�n hasta dejarlo seco. Se debe exprimir poco porque si pretendemos quitarle todo el zumo lo que vamos a lograr es que la parte astringente del lim�n bote esa acidez que a muchos les malogra el ansiado cebiche. Por eso se pide en la receta 20 limones. Exprimimos razonablemente cada uno de los 20 limones y tendremos una buena cantidad de zumo sin problemas de acidez.
3.	Cortamos el pescado en cuadrados lo m�s uniformes posible. Cada uno corta los trozos del tama�o que mejor le agrade. Pero si se nos pide una recomendaci�n les dir�amos que hagan cubos de 2 cent�metros por 2 cent�metros, obviamente al ojo, a simple c�lculo (no vayan a estar midiendo con una regla cada cuadrado para ver si tiene o no 2 cent�metros, esa no es la idea).
4.	Ahora preparamos el aj� limo. Para eso cortamos las dos puntas y las desechamos. Luego partimos el aj� a lo largo por la mitad, retiramos con un cuchillo las semillas teniendo cuidado que no rocen con las manos porque no es nada agradable. Ya sin las semillas se corta el aj� en rodajas y obtendremos medialunas. Alternativamente se puede cortar el aj� en cubitos de 2 mil�metros por 2 mil�metros, aunque lo tradicional y m�s sencillo es cortarlo en rodajas.
5.	Lleg� el momento. Colocamos los trozos de pescado en un recipiente y los aderezamos con la sal, la pimienta y el aj� limo. Si se desea agregamos tambi�n los ingredientes opcionales: una pizca de sazonador ajino moto, culantro (cilantro) picado y/o apio picado. Revolvemos todo y dejamos durante tres minutos para que el pescado se impregne de los sabores.
6.	Echamos el zumo de lim�n sobre el pescado e incorporamos la cebolla.
7.	Una vez que hemos puesto en el recipiente todos los ingredientes los removemos con una cuchara, a ritmo normal, ni muy suave ni muy violento. Se trata de mezclar los ingredientes. Es bueno adem�s probar la saz�n para rectificar el sabor si fuere necesario (de repente te parece que le falta algo de sal, o quiz�s algo de aj�, y ese es el momento para corregir la saz�n a tu gusto).
8.	Dejar reposar el preparado para que el pescado crudo se cocine. �Cu�l es el tiempo recomendable?. Tambi�n es al gusto de cada uno. Hay comensales que prefieren el pescado casi crudo as� que se lo comen de inmediato, otros prefieren que el pescado est� cocido y para ellos con 10 minutos est� bien. Para los dem�s, entre los que me incluyo, con 5 a 7 minutos de reposo resulta razonable.
9.	Finalmente, se coloca el preparado en una fuente y se puede acompa�ar con rodajas de camote cocido, trozos de yuca cocida o frita, ma�z choclo cocido, hojas de lechuga, e incluso pl�tano verde frito.'
, 3.4),

(10513, 'Aj� de gallina'
, '1.	En una olla poner a sancochar la pechuga de la gallina, una vez sancochada se deber� deshilachar.En caso de usar el pan previamente se tiene que remojar por unos minutos, luego escurrirlo, y licuarlo. En caso de usar galletas de soda solo se tiene que pulverizar.
2.	Limpiar los aj�es amarillos y cortarlos en tiras para soasarlos.
3.	Una vez soasados licuarlos, para esto nos podemos ayudar con la leche y con el caldo que nos deje el pollo sancochado.
4.	Picar la cebolla en cuadraditos y dorarla junto a los ajos, a esto agregarle nuestros aj�s amarillos ya licuados.
5.	Sobre esto echar el pan o la galleta, revolviendo con una cuchara de palo.
6.	Una vez que nuestra receta adquiera consistencia agregarle las pecanas. Si deseamos que nuestro aj� de de gallina no quede muy espeso hay que echarle el caldo con el que sancochamos la gallina.
7.	Echarle la gallina deshilachada.
8.	A�adir el queso parmesano y revolver ocasionalmente con la cuchara de palo.
9.	Servir con rodajas de huevo duro, una rodaja de papa amarilla sancochada y arroz blanco.'
, 3.4),

(10514, 'Tiradito'
, '1.	Corta el pescado. En forma de l�minas delgadas, corta el pescado y col�calo en un recipiente para esperar por los dem�s ingredientes de la preparaci�n.
2.	Prepara los aj�es. Debes sofre�r y saltear los aj�es durante 5 minutos. Luego los pones en una licuadura y formas una cremas.
3.	Mezcla los ingredientes. En un recipiente hondo, coloca el jugo de lim�n junto al cilantro picado y la crema de aj�.
4.	Deja reposar la mezcla. Durante 20 minutos, los ingredientes deben entremezclarse para formar el jugo que luego "cocinar�" las tiras de pescado.
5.	Rociar el pescado con la mezcla. Sobre un plato o recipiente, debes colocar las tiras de pescado y luego verter la mezcla para su maceraci�n. Debes chequear que la mezcla est� en contacto con toda la superficie del pescado.'
, 3.4),

(10515, 'Papa a la huanca�na'
, '1.	Quitar las pepas y las venas a los aj�es amarillos. Una vez limpios cocer los aj�es por uno o dos minutos en agua hirviendo y luego quitarles la piel. Reservar.
2.	Poner en la licuadora una parte del queso trozado en cubos peque�os, la leche, los aj�es sin piel, el ajo molido, el aceite y las galletas de soda. Licuar e ir a�adiendo el resto del queso hasta formar una crema.
3.	Probar. Si le falta sal rectificar agreg�ndolo al gusto. Si la crema est� muy espesa agregar un poco m�s de leche y volver a licuar. Si la crema est� aguada agregar m�s galletas y volver a licuar.'
, 3.4);

INSERT INTO INGREDIENTE (ingredID, nombIng) 
VALUES
(20501,'Canela'),
(20502,'Pollo'),
(20503,'Arroz'),
(20504,'Az�car'),
(20505,'Leche'),
(20506,'Cebolla'),
(20507,'Zanahoria'),
(20508,'Arverja'),
(20509,'Culantro'),
(20510,'Carne de res'),
(20511,'Huevo'),
(20512,'Sal'),
(20513,'Vainilla'),
(20514,'Papa');


INSERT INTO CATEGORIA (catID, catNomb) 
VALUES
(30501,'Plato de fondo'),
(30502,'Postre'),
(30503,'Bebida'),
(30504,'Aperitivo');

INSERT INTO RECETA_INGRED (	ingredID, recetaID, cantidad) 
VALUES
(20502,10503,1),
(20503,10503,2),
(20507,10503,3),
(20508,10503,4),
(20509,10503,5),
(20510,10502,1),
(20503,10502,2),
(20512,10502,3),
(20511,10501,1),
(20512,10501,1),
(20505,10504,1),
(20504,10504,1),
(20505,10505,1);

SET IDENTITY_INSERT RECETA_USER ON
INSERT INTO RECETA_USER (userID,recetaID,rating,usada) 
VALUES
(1,10503,2.5,1),
(1,10505,3.4,0),
(1,10502,1.0,1),
(1,10501,2.6,0),
(1,10504,4.2,1)
SET IDENTITY_INSERT RECETA_USER OFF;

INSERT INTO CATEGORIA_RECETA (catID, recetaID) 
VALUES
(30501,10502),
(30503,10503),
(30502,10504),
(30504,10505);

INSERT INTO USER_PREF_CAT (userID,catID,prefer) 
VALUES
(1,30501,1),
(2,30502,0),
(3,30503,1),
(4,30504,0),
(5,30501,1);
