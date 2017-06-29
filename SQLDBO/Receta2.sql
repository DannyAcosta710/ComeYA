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
	[titulo] [varchar] NULL,
	[preparación] [varchar] NULL,
	[ratingProm] [float] NULL
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
	[catNomb] [varchar] NULL,
	CONSTRAINT [PK_Cat_catID] PRIMARY KEY CLUSTERED (catID)
)
GO

CREATE TABLE [dbo].[INGREDIENTE](
	[ingredID] [int] NOT NULL,
	[nombIng] [varchar] NULL,
	CONSTRAINT [PK_Ing_ingredID] PRIMARY KEY CLUSTERED (ingredID)
)
GO

CREATE TABLE [dbo].[RECETA_USER](
	[userID] [int] NOT NULL,
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


--agregandoles salt al gusto
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

--llenando la dbo

TRUNCATE TABLE [dbo].[USUARIO]

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
       SET @responseMessage='Acceso inválido lince ;v'

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
	



--INSERCIÓN DE DEMÁS USUARIOS :V :V V: V:

--LLAMAR AL PROCESO ADDUSER

--INSERCIÓN DE LOS DATOS EN LAS DEMÁS TABLAS


INSERT INTO RECETA (recetaID, titulo, preparación,ratingProm) 
VALUES
(10501, 'Huevo frito', 'Fría un huevo. Añada sal al gusto. Añada detalles. Disfrute.', 4.2),
(10502, 'Lomo Saltado', '1. Cortamos la carne de res en cubos de regular tamaño (2 cm. por 2 cm. está bien) y lo sazonamos con un poco de sal y pimienta (no mucho porque si nos excedemos en la sazón no será muy agradable que digamos, pero en cambio si nos falta algo de sal o algo de pimienta se podrá rectificar al final).2. Cortamos las cebollas en tiras gruesas a lo largo. Un truco es dividir la cebolla en ocho partes: hacemos un corte vertical para dividir la cebolla en dos mitades ( | ), luego hacemos un corte horizontal para formar una cruz y dividir la cebolla en cuartos ( – ), a continuación hacemos un corte diagonal ( / ) y finalmente un corte diagonal en sentido contrario ( \ ). De este modo tendremos ocho trozos de cebolla en capas gruesas y largas.3. Hacemos lo mismo con los tomates, y les quitamos las semillas.4. Cortamos también el ají amarillo en tiras largas. Se trata de un ingrediente opcional, pues algunos cocineros no lo ponen, pero su presencia contribuye al sabor y le da color al plato.5. En una sartén con un poco de aceite bien caliente doramos ligeramente los dos dientes de ajos molidos o picados.',3.1),
(10503, 'Arroz con pollo', 'Salpimentar y freír las presas de pollo en aceite caliente. Retirar presas. Dorar en ese mismo aceite los ajos, la cebolla, el ají y el culantro.Colocar las presas de pollo nuevamente, añadir la cerveza y seguir cocinando hasta que el pollo esté listo.Retirar las presas, sin dejar que se enfríen. Incorporar el arroz, las arvejas, el choclo y el pimiento. Mezclar bien.Agregar el agua, rectificando la sazón y llevar a hervir. Bajar el fuego y seguir cocinando 20 minutos más hasta que el arroz esté cocido.Servir el arroz con las presas de pollo bien calientes y decorar con ensalada de palta o cebolla',2.1),
(10504, 'Leche asada', 'Ambos sabemos que esto es demasiado dificil para ti. Mejor compralo.',1.0),
(10505, 'Pudín', 'Salir de casa. Comprarlo. Profit.',5.0);


INSERT INTO INGREDIENTE (ingredID, nombIng) 
VALUES
(20501,'Canela'),
(20502,'Pollo'),
(20503,'Arroz'),
(20504,'Azúcar'),
(20505,'Leche'),
(20506,'Cebolla'),
(20507,'Zanahoria'),
(20508,'Arverja'),
(20509,'Culantro'),
(20510,'Carne de res'),
(20511,'Huevo'),
(20512,'Sal'),
(20513,'Vainilla'),
(20512,'Papa');


INSERT INTO CATEGORIA (catID, catNomb) 
VALUES
(30501,'Plato de fondo'),
(30502,'Postre'),
(30503,'Bebida'),
(30504,'Aperitivo');



INSERT INTO CATEGORIA_RECETA (catID, recetaID) 
VALUES
(30501,10502),
(30501,10503),
(30502,10504),
(30505,10505);

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

INSERT INTO USER_PREF_CAT (userID,catID,prefer) 
VALUES
('DannyRex777',30501,1),
('jajdpRex777',30502,0),
('CesarRex777',30503,1),
('PepeRex777',30504,0),
('EduRex777',30501,1);

INSERT INTO RECETA_USER (userID,recetaID,rating,usada) 
VALUES
('DannyRex777',10503,2.5,1),
('jajdpRex777',10505,3.4,0),
('CesarRex777',10502,1.0,1),
('PepeRex777',10501,2.6,0),
('EduRex777',10504,4.2,1);