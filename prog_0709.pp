program prog_0709;
uses
  BaseUnix, Unix, Unixtype, SysUtils;

var
  dir: pdir;
  entry: pdirent;
  statbuf: Stat;
  count: Integer = 0;

procedure ShowPermissions(mode: TMode);
begin
  // Mostrar permisos de usuario (lectura, escritura, ejecución)
  if (mode and S_IRUSR) <> 0 then Write('r') else Write('-');
  if (mode and S_IWUSR) <> 0 then Write('w') else Write('-');
  if (mode and S_IXUSR) <> 0 then Write('x') else Write('-');
end;

procedure ListDirectory(path: string);
begin
  dir := fpOpenDir(PChar(path));
  if dir = nil then
  begin
    Writeln('Error: No se pudo abrir el directorio ', path);
    Halt(1);
  end;

  entry := fpReadDir(dir);
  while entry <> nil do
  begin
    if fpLStat(entry^.d_name, statbuf) = 0 then
    begin
      // Mostrar permisos del usuario actual
      ShowPermissions(statbuf.st_mode);
      Write(' ');

      // Mostrar tamaño en bytes
      Write(statbuf.st_size:10, ' ');

      // Mostrar tipo y nombre de archivo
      if FPS_ISDIR(statbuf.st_mode) then
        Write('[DIR] ')
      else if FPS_ISLNK(statbuf.st_mode) then
        Write('[LINK] ')
      else if FPS_ISCHR(statbuf.st_mode) or FPS_ISBLK(statbuf.st_mode) then
        Write('[DEV] ')
      else if (statbuf.st_mode and S_IXUSR) <> 0 then
        Write('[EXEC] ')
      else
        Write('[FILE] ');

      Writeln(entry^.d_name);
      Inc(count);
    end
    else
    begin
      Writeln('Error al obtener información de ', entry^.d_name);
    end;

    entry := fpReadDir(dir);
  end;

  // Cerrar el directorio
  fpCloseDir(dir);

  // Mostrar el número total de archivos listados
  Writeln('Total de archivos: ', count);
end;

begin
  if ParamCount < 1 then
  begin
    Writeln('Uso: ./prog_0709 <directorio>');
    Halt(1);
  end;

  ListDirectory(ParamStr(1));
end.
