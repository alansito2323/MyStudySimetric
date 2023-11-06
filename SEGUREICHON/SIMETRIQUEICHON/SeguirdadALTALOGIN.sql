drop procedure sp_LoginUsuario
CREATE PROCEDURE sp_LoginUsuario
    @Email NVARCHAR(255),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    -- Declarar una variable para almacenar la contraseña encriptada
    DECLARE @ContraseñaEncriptada VARBINARY(MAX);

    -- Abrir la clave simétrica para desencriptación
    OPEN SYMMETRIC KEY MySymmetricKeyReal
    DECRYPTION BY ASYMMETRIC KEY MyAsymmetricPrivateKeyReal;

    -- Encriptar la contraseña proporcionada con la clave simétrica
    SET @ContraseñaEncriptada = ENCRYPTBYKEY(KEY_GUID('MySymmetricKeyReal'), @Contraseña);

    -- Declarar una variable para almacenar la contraseña desencriptada
    DECLARE @ContraseñaDesencriptada NVARCHAR(255);

    -- Desencriptar la contraseña almacenada en la base de datos
    SELECT @ContraseñaDesencriptada = CONVERT(NVARCHAR(255), DECRYPTBYKEY(Contraseña))
    FROM Usuarios
    WHERE Email = @Email;

    -- Cerrar la clave simétrica
    CLOSE SYMMETRIC KEY MySymmetricKeyReal;

    -- Verificar si el correo electrónico y la contraseña coinciden
    IF @ContraseñaDesencriptada IS NOT NULL AND @ContraseñaDesencriptada = @Contraseña
    BEGIN
        SELECT 'Si' AS Resultado; -- Si las credenciales son correctas
    END
    ELSE
    BEGIN
        SELECT 'No' AS Resultado; -- Si las credenciales son incorrectas
    END;
END;


DECLARE @Resultado NVARCHAR(3);
EXEC sp_LoginUsuario @Email = '4', @Contraseña = '5';

select * from Usuarios

delete from Usuarios

