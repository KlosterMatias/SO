

Program prog_0709;

{$mode objfpc}{$H+}

Uses 
BaseUnix, Unix, SysUtils;

Function GetFilePermissions(mode: TMode): string;
Begin
  Result := '';
  If (mode And S_IRUSR) <> 0 Then Result := Result + 'r'
  Else Result := Result + '-';
  If (mode And S_IWUSR) <> 0 Then Result := Result + 'w'
  Else Result := Result + '-';
  If (mode And S_IXUSR) <> 0 Then Result := Result + 'x'
  Else Result := Result + '-';
End;

Function GetFileType(mode: TMode): string;
Begin
  Case mode And S_IFMT Of 
    S_IFDIR: Result := 'd';
    // Directorio
    S_IFLNK: Result := 'l';
    // Enlace simbólico
    S_IFCHR, S_IFBLK: Result := 'b';
    // Dispositivo (carácter/bloque)
    Else If (mode And S_IXUSR) <> 0 Then
           Result := '*'  // Ejecutable
    Else
      Result := '-';
    // Archivo regular
  End;
End;

Procedure ListDirectory(Const path: String);

Var 
  dir: PDir;
  entry: PDirent;
  statbuf: Stat;
  filepath: string;
  fileCount: Integer = 0;
Begin
  dir := fpOpenDir(PChar(path));
  If dir = Nil Then
    Begin
      WriteLn('Error: No se pudo abrir el directorio ', path);
      Exit;
    End;

  entry := fpReadDir(dir);
  While entry <> Nil Do
    Begin
      filepath := path + '/' + entry^.d_name;
      If FpLstat(filepath, statbuf) = 0 Then
        Begin
          Write(GetFilePermissions(statbuf.st_mode), ' ', statbuf.st_size: 8, ' ', entry^.d_name);

          // Mostrar tipo especial
          Case GetFileType(statbuf.st_mode) Of 
            'd': Write(' (Directorio)');
            'l': Write(' (Enlace simbólico)');
            'b': Write(' (Dispositivo)');
            '*': Write(' (Ejecutable)');
          End;

          WriteLn;
          Inc(fileCount);
        End
      Else
        WriteLn('Error: No se pudo obtener información del archivo ', entry^.d_name);

      entry := fpReadDir(dir);
    End;

  fpCloseDir(dir);
  WriteLn('Total de archivos listados: ', fileCount);
End;

Var 
  dirPath: string;
Begin
  If ParamCount = 0 Then
    dirPath := '.'
  Else
    dirPath := ParamStr(1);

  If Not DirectoryExists(dirPath) Then
    WriteLn('Error: El directorio especificado no existe.')
  Else
    ListDirectory(dirPath);
End.
