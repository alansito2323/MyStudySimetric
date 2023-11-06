
-- ASYMETRIC
CREATE ASYMMETRIC KEY MyAsymmetricPublicKey
WITH ALGORITHM = RSA_2048;

drop PROCEDURE sp_AltaUsuario2
CREATE PROCEDURE sp_AltaUsuario2
    @Nombre NVARCHAR(255),
    @Apellido NVARCHAR(255),
    @Matricula NVARCHAR(50),
    @Email NVARCHAR(255),
    @Contrase�a NVARCHAR(255), -- La contrase�a en texto plano
	@Cellphone NVARCHAR(255) 
AS
BEGIN
    -- Verificar si la matr�cula y el correo electr�nico ya existen en la tabla
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Matricula = @Matricula) 
    AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
	AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Cellphone = @Cellphone)
    BEGIN
        -- Encriptar la contrase�a proporcionada asim�tricamente
        DECLARE @Contrase�aEncriptada VARBINARY(MAX);
        SET @Contrase�aEncriptada = ENCRYPTBYASYMKEY(ASYMKEY_ID('MyAsymmetricPublicKey'), @Contrase�a);

        -- Insertar el usuario en la tabla de Usuarios
        INSERT INTO Usuarios (Nombre, Apellido, Matricula, Email, Contrase�a,Cellphone)
        VALUES (@Nombre, @Apellido, @Matricula, @Email, @Contrase�aEncriptada,@Cellphone);

        SELECT 'Si' AS Resultado; -- Devolver una cadena 'Si' si el usuario se inserta con �xito
    END
    ELSE
    BEGIN
        SELECT 'No' AS Resultado; -- Devolver una cadena 'No' si la matr�cula o el correo electr�nico ya existen
    END;
END;


DECLARE @Nombre NVARCHAR(255) = '6';
DECLARE @Apellido NVARCHAR(255) = '7';
DECLARE @Matricula NVARCHAR(50) = '8';
DECLARE @Email NVARCHAR(255) = '9';
DECLARE @Contrase�a NVARCHAR(255) = '10';

-- Ejecutar el Stored Procedure
EXEC sp_AltaUsuario2 
    @Nombre,
    @Apellido,
    @Matricula,
    @Email,
    @Contrase�a;

Select * from Usuarios