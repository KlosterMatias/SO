program prog_0708;
uses BaseUnix, Unix, Unixtype;

var 
  ubicacion: pchar;
  fd: cint;
  fsinfo: TStatFS;
  totalSpace, usedSpace, freeSpace: QWord;

begin
  ubicacion := '.';
  fd := fpOpen(ubicacion, O_RdOnly);
  
  if fstatfs(fd, fsinfo) <> 0 then
  begin
    Writeln('Fallo el fpStatFS. Error No: ', fpgeterrno);
    Halt(1);
  end;
  
  // Calcular el espacio total, libre y ocupado en bytes
  totalSpace := fsinfo.bsize * fsinfo.blocks;    // Espacio total en bytes
  freeSpace := fsinfo.bsize * fsinfo.bavail;     // Espacio libre en bytes
  usedSpace := totalSpace - freeSpace;           // Espacio ocupado en bytes

  // Mostrar resultados
  Writeln('Tipo de FS: ', fsinfo.fstype);
  Writeln('Tamaño de bloque: ', fsinfo.bsize);
  Writeln('Espacio total: ', totalSpace, ' bytes');
  Writeln('Espacio libre: ', freeSpace, ' bytes');
  Writeln('Espacio ocupado: ', usedSpace, ' bytes');
  
  // Cerrar el archivo descriptor
  fpClose(fd);
end.
