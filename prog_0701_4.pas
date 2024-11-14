
Program prog_0701_4;

Uses BaseUnix;

Var fd : Longint;
  datos: String;
Begin
  If fpAccess(ParamStr(1), X_OK Or F_OK) = 0 Then
    Begin
      fd := FPOpen(ParamStr(1), O_WrOnly Or O_Creat);
      If fd <> 0 Then
        Begin
          Writeln('Escriba lo que desea en el archivo:');
          Readln(datos);
          If (Length(datos)+1) <> (FPWrite(fd, datos, Length(datos)+1)) Then
            Writeln ('Error al escribir en el archivo!!!');
          FPClose(fd);
        End;
    End
  Else writeln('No existe el archivo o el usuario no tiene permiso para realizar operaciones en el archivo');
End.
