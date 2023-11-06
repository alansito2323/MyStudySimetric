
-- ASYMETRIC
CREATE ASYMMETRIC KEY MyAsymmetricPublicKey
WITH ALGORITHM = RSA_2048;

drop PROCEDURE sp_AltaUsuario2
CREATE PROCEDURE sp_AltaUsuario2
    @Nombre NVARCHAR(255),
    @Apellido NVARCHAR(255),
    @Matricula NVARCHAR(50),
    @Email NVARCHAR(255),
    @Contraseña NVARCHAR(255), -- La contraseña en texto plano
	@Cellphone NVARCHAR(255) 
AS
BEGIN
    -- Verificar si la matrícula y el correo electrónico ya existen en la tabla
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Matricula = @Matricula) 
    AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
	AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Cellphone = @Cellphone)
    BEGIN
        -- Encriptar la contraseña proporcionada asimétricamente
        DECLARE @ContraseñaEncriptada VARBINARY(MAX);
        SET @ContraseñaEncriptada = ENCRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), @Contraseña);

        -- Insertar el usuario en la tabla de Usuarios
        INSERT INTO Usuarios (Nombre, Apellido, Matricula, Email, Contraseña,Cellphone)
        VALUES (@Nombre, @Apellido, @Matricula, @Email, @ContraseñaEncriptada,@Cellphone);

        SELECT 'Si' AS Resultado; -- Devolver una cadena 'Si' si el usuario se inserta con éxito
    END
    ELSE
    BEGIN
        SELECT 'No' AS Resultado; -- Devolver una cadena 'No' si la matrícula o el correo electrónico ya existen
    END;
END;


DECLARE @Nombre NVARCHAR(255) = '6';
DECLARE @Apellido NVARCHAR(255) = '7';
DECLARE @Matricula NVARCHAR(50) = '8';
DECLARE @Email NVARCHAR(255) = '9';
DECLARE @Contraseña NVARCHAR(255) = '10';

-- Ejecutar el Stored Procedure
EXEC sp_AltaUsuario2 
    @Nombre,
    @Apellido,
    @Matricula,
    @Email,
    @Contraseña;

Select * from Usuarios