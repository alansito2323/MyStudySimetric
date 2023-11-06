CREATE ASYMMETRIC KEY MyAsymmetricPrivateKeyReal
WITH ALGORITHM = RSA_2048; -- Elige el algoritmo y tama�o de clave que prefieras


CREATE SYMMETRIC KEY MySymmetricKeyReal
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY MyAsymmetricPrivateKeyReal;

-- Abrir la clave sim�trica para desencriptaci�n
OPEN SYMMETRIC KEY MySymmetricKeyReal
DECRYPTION BY ASYMMETRIC KEY MyAsymmetricPrivateKeyReal;




drop PROCEDURE sp_AltaUsuario
CREATE PROCEDURE sp_AltaUsuario
    @Nombre NVARCHAR(255),
    @Apellido NVARCHAR(255),
    @Matricula NVARCHAR(50),
    @Email NVARCHAR(255),
    @Contrase�a NVARCHAR(255), -- La contrase�a en texto plano,
	@Cellphone NVARCHAR(255)
AS
BEGIN
    -- Verificar si la matr�cula y el correo electr�nico ya existen en la tabla
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Matricula = @Matricula) 
    AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Email = @Email)
	AND NOT EXISTS (SELECT 1 FROM Usuarios WHERE Cellphone = @Cellphone)
    BEGIN
        -- Encriptar la contrase�a proporcionada utilizando la clave sim�trica MySymmetricKeyReal
        DECLARE @Contrase�aEncriptada VARBINARY(MAX);
        OPEN SYMMETRIC KEY MySymmetricKeyReal
        DECRYPTION BY ASYMMETRIC KEY MyAsymmetricPrivateKeyReal;
        SET @Contrase�aEncriptada = ENCRYPTBYKEY(KEY_GUID('MySymmetricKeyReal'), @Contrase�a);
        CLOSE SYMMETRIC KEY MySymmetricKeyReal;

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

Select * from Usuarios



	-- Declarar las variables de entrada
DECLARE @Nombre NVARCHAR(255) = '1';
DECLARE @Apellido NVARCHAR(255) = '2';
DECLARE @Matricula NVARCHAR(50) = '3';
DECLARE @Email NVARCHAR(255) = '4';
DECLARE @Contrase�a NVARCHAR(255) = '5';

-- Ejecutar el Stored Procedure
EXEC sp_AltaUsuario 
    @Nombre,
    @Apellido,
    @Matricula,
    @Email,
    @Contrase�a;