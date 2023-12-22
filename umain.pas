unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, sMemo, Vcl.ExtCtrls, sButton, Vcl.Buttons, sLabel, Data.DB,
  DBAccess, MyAccess, sEdit, MemDS, Clipbrd, sCheckBox;

type
  TFPATCH = class(TForm)
    Panel1: TPanel;
    sMemo1: TsMemo;
    cDBsource: TComboBox;
    cDBcheck: TComboBox;
    bCreatePatch: TsButton;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    con1: TMyConnection;
    cServer: TsEdit;
    bCopy: TsButton;
    cServer2: TsEdit;
    sLabel4: TsLabel;
    bDelete: TsButton;
    con2: TMyConnection;
    eDelimiter: TsEdit;
    sLabel5: TsLabel;
    sMemo2: TsMemo;
    cAutoPatch: TsCheckBox;
    bInfo: TsButton;
    procedure FormCreate(Sender: TObject);
    procedure cServerExit(Sender: TObject);
    procedure cServerChange(Sender: TObject);
    procedure cDBsourceEnter(Sender: TObject);
    procedure cDBcheckEnter(Sender: TObject);
    procedure bCreatePatchClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure cServer2Exit(Sender: TObject);
    procedure cServer2Change(Sender: TObject);
    procedure eDelimiterChange(Sender: TObject);
    procedure bInfoClick(Sender: TObject);
    procedure cAutoPatchExit(Sender: TObject);
  private
    { Private declarations }
    autoPatch: boolean;
    delimiterNonTables, folderPatch, QRunning: string;
    function ConnectDatabase(Server, Database: string): Boolean;
    function GetCompositeColumns(Query: TMyQuery; keyName: string): string;
    function GetCompositeParameters(Query: TMyQuery; Database, RoutineName: string): string;
    procedure CreatePatchTable;
    procedure CreatePatchRoutines;
    procedure CreatePatchTrigger;
    procedure AutoPatching;
  public
    { Public declarations }
  end;

var
  FPATCH: TFPATCH;

implementation

{$R *.dfm}

function TFPATCH.ConnectDatabase(Server, Database: string): Boolean;
begin
  if Database = 'con1' then
  begin
    try
      con1.Server := Server;
      con1.Database := 'Test';
      con1.Connect;
      Result := con1.Connected;
    except
      Result := False;
    end;
  end;

  if Database = 'con2' then
  begin
    try
      con2.Server := Server;
      con2.Database := 'Test';
      con2.Connect;
      Result := con2.Connected;
    except
      Result := False;
    end;
  end;
end;

function TFPATCH.GetCompositeColumns(Query: TMyQuery; keyName: string): string;
var
  Columns: TStringList;
begin
  Columns := TStringList.Create;
  try
    Query.First;
    while not Query.Eof do
    begin
      if Query.FieldByName('Key_name').AsString = keyName then
      begin
        Columns.Add('`' + Query.FieldByName('Column_name').AsString + '`');
      end
      else
      begin
        if Columns.Count > 0 then
          Break;
      end;

      Query.Next;
    end;

    Result := Columns.DelimitedText;
  finally
    Columns.Free;
  end;
end;

procedure TFPATCH.bCopyClick(Sender: TObject);
begin
  Clipboard.AsText := sMemo1.Lines.Text;
  ShowMessage('Teks berhasil disalin ke clipboard!');
end;

procedure TFPATCH.bCreatePatchClick(Sender: TObject);
var
  PatchFileName, dateFile: string;
  Confirmation: Integer;
begin
  if (cDBsource.Text = '') or (cDBcheck.Text = '') then
  begin
    MessageDlg('Database Lama dan Database Baru harus diisi!', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    if cDBsource.Text = cDBcheck.Text then
    begin
      MessageDlg('Database Lama dan Database Baru tidak boleh sama!', mtWarning, [mbOK], 0);
      Exit;
    end
    else
    begin
      Confirmation := MessageDlg('Yakin ingin Patch, Apakah Database Lama dan Baru sudah Benar?', mtConfirmation, mbYesNo, 0);
      if Confirmation <> mrYes then
      begin
        MessageDlg('Patch dibatalkan..', mtInformation, [mbOK], 0);
        Exit;
      end;

      folderPatch := cDBsource.Text + ' - ' + cDBcheck.Text + ' (' + FormatDateTime('dd-mmm-yyyy', Now) + ')';
      if DirectoryExists(folderPatch) then
      begin
        RemoveDir(folderPatch);
        CreateDir(folderPatch);
      end
      else
        CreateDir(folderPatch);

      PatchFileName := FormatDateTime('yymmdd-hh.nn.ss', Now) + '.txt';
      sMemo1.Cursor := crAppStart;
      sMemo1.Text := '';

      CreatePatchTable;
//      CreatePatchRoutines;
      CreatePatchTrigger;

      sMemo1.Cursor := crDefault;

      if sMemo1.Text <> '' then
      begin
        sMemo1.Lines.SaveToFile(folderPatch + '\' + PatchFileName);
      end;

      if not autoPatch then
        MessageDlg('Sukses Membuat Patch.' + #13 + 'Patch tersimpan di folder : '+ #13 + folderPatch, mtInformation, [mbOK], 0)
      else
        MessageDlg('Sukses Melakukan Patch ke Database ' + cDBcheck.Text + #13 + 'Patch tersimpan di folder : '+ #13 + folderPatch, mtInformation, [mbOK], 0)


//      Confirmation := MessageDlg('Sukses membuat Patch. Ingin menyimpan Patch?', mtConfirmation, mbYesNo, 0);
//      if Confirmation = mrYes then
//        MessageDlg('Patch disimpan dalam file : ' + PatchFileName, mtInformation, [mbOK], 0)
//      else
//        DeleteFile(PatchFileName);
    end;
  end;
end;

procedure TFPATCH.bDeleteClick(Sender: TObject);
begin
  sMemo1.Text := '';
  sMemo2.Text := '';
end;

procedure TFPATCH.cAutoPatchExit(Sender: TObject);
begin
  autoPatch := cautoPatch.Checked;
end;

procedure TFPATCH.cDBcheckEnter(Sender: TObject);
var
  TempQuery:TMyQuery;
begin
  TempQuery:=TMyQuery.Create(self);
  if cServer2.Text<>'' then
  begin
    if (cDBcheck.Text = '') then
    begin
      if ConnectDatabase(cServer2.Text,'con2') then
      begin
        TempQuery.Connection:=con2;
        TempQuery.SQL.Text:='SHOW DATABASES';
        TempQuery.Open;
        cDBcheck.Items.Clear;
        while not TempQuery.Eof do
        begin
          cDBcheck.Items.Append(TempQuery.Fields[0].AsString);
          TempQuery.Next;
        end;
        cDBcheck.ItemIndex:=0;
      end
      else
      begin
        MessageDlg('Server Tidak ada!',mtWarning,[MBOK],0);
        cServer2.SetFocus;
      end;
      FreeAndNil(TempQuery);
    end;
  end else
  begin
    MessageDlg('Isi Nama Server dulu!',mtWarning,[MBOK],0);
    cServer2.SetFocus;
    exit;
  end;
end;

procedure TFPATCH.cDBsourceEnter(Sender: TObject);
var
    TempQuery:TMyQuery;
begin
  TempQuery:=TMyQuery.Create(self);
  if cServer.Text<>'' then
  begin
    if (cDBsource.Text = '') then
    begin
      if ConnectDatabase(cServer.Text,'con1') then
      begin
        TempQuery.Connection:=con1;
        TempQuery.SQL.Text:='SHOW DATABASES';
        TempQuery.Open;
        cDBsource.Items.Clear;
        while not TempQuery.Eof do
        begin
          cDBsource.Items.Append(TempQuery.Fields[0].AsString);
          TempQuery.Next;
        end;
        cDBsource.ItemIndex:=0;
      end
      else
      begin
        MessageDlg('Server Tidak ada!',mtWarning,[MBOK],0);
        cServer.SetFocus;
      end;
      FreeAndNil(TempQuery);
    end;
  end
  else
  begin
    MessageDlg('Isi Nama Server dulu!',mtWarning,[MBOK],0);
    cServer.SetFocus;
    exit;
  end;
end;

procedure TFPATCH.cServer2Change(Sender: TObject);
begin
  cDBcheck.Text := '';
end;

procedure TFPATCH.cServer2Exit(Sender: TObject);
begin
  if con2.Server <> cServer2.Text then
  begin
    if con2.Connected then
      con2.Connected := False;

    con2.Server := cServer2.Text;
    con2.Connected := True;
  end;
end;

procedure TFPATCH.cServerChange(Sender: TObject);
begin
  cDBsource.Text := '';
end;

procedure TFPATCH.cServerExit(Sender: TObject);
begin
  if con1.Server <> cServer.Text then
  begin
    if con1.Connected then
      con1.Connected := False;

    con1.Server := cServer.Text;
    con1.Connected := True;
  end;
end;

procedure TFPATCH.FormCreate(Sender: TObject);
begin
  cServer.Text := con1.Server;
  cServer2.Text := con2.Server;
  delimiterNonTables := eDelimiter.Text;
  autoPatch := cautoPatch.Checked;
end;

procedure TFPATCH.CreatePatchTable;
var
  SourceQuery, CheckQuery: TMyQuery;
  SourceTables, CheckTables: TStringList;
  TableName, ColumnName, childKeySource, childKeyCheck: string;
  SourceDB, CheckDB, tableQuery, QueryText, CurrentQuery: string;
  StartPos, EndPos: Integer;
begin
  SourceDB := cDBsource.Text;
  CheckDB := cDBcheck.Text;

  SourceQuery := TMyQuery.Create(nil);
  CheckQuery := TMyQuery.Create(nil);
  SourceTables := TStringList.Create;
  CheckTables := TStringList.Create;

  try
    tableQuery := 'SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA = :Database';

    SourceQuery.Connection := con1;
    SourceQuery.SQL.Text := tableQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.Open;
    while not SourceQuery.Eof do
    begin
      SourceTables.Add(SourceQuery.Fields[0].AsString);
      SourceQuery.Next;
    end;

    CheckQuery.Connection := con2;
    CheckQuery.SQL.Text := tableQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;
    while not CheckQuery.Eof do
    begin
      CheckTables.Add(CheckQuery.Fields[0].AsString);
      CheckQuery.Next;
    end;

    for TableName in SourceTables do
    begin
      if CheckTables.IndexOf(TableName) = -1 then
      begin
        // Create Table
        SourceQuery.SQL.Text := 'SHOW CREATE TABLE `' + SourceDB + '`.`' + TableName + '`';
        SourceQuery.Open;

        sMemo1.Lines.Add('DROP TABLE IF EXISTS `' + TableName + '`;');
        sMemo1.Lines.Add(SourceQuery.Fields[1].AsString + ';');
      end
      else
      begin
        // Edit Column & Index in Table
        tableQuery := 'SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT, IS_NULLABLE FROM information_schema.columns ' +
          'WHERE TABLE_SCHEMA = :Database AND TABLE_NAME = :TableName';

        SourceQuery.SQL.Text := tableQuery;
        SourceQuery.ParamByName('Database').AsString := SourceDB;
        SourceQuery.ParamByName('TableName').AsString := TableName;
        SourceQuery.Open;

        CheckQuery.SQL.Text := tableQuery;
        CheckQuery.ParamByName('Database').AsString := CheckDB;
        CheckQuery.ParamByName('TableName').AsString := TableName;
        CheckQuery.Open;

        while not SourceQuery.Eof do
        begin
          CheckQuery.First;
          CheckQuery.Filtered := False;
          CheckQuery.Filter := 'UPPER(COLUMN_NAME) = ' + QuotedStr(UpperCase(SourceQuery.FieldByName('COLUMN_NAME').AsString));
          CheckQuery.Filtered := True;

          if not CheckQuery.IsEmpty then
          begin
            // Edit Column
            if (SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> CheckQuery.FieldByName('COLUMN_DEFAULT').AsString) OR (SourceQuery.FieldByName('IS_NULLABLE').AsString <> CheckQuery.FieldByName('IS_NULLABLE').AsString) then
            begin
              if SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> '' then
              begin
                if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                begin
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' +
                  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NULL;');
                end
                else
                begin
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' +
                  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NOT NULL;');
                end;
              end
              else
              begin
                if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                begin
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString +
                  '` ' +  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NULL;');
                end
                else
                begin
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString +
                  '` ' +  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NOT NULL;');
                end;
              end;
            end;
          end
          else
          begin
            // Add Column
            if SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> '' then
            begin
              if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
              begin
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' +
                SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NULL;');
              end
              else
              begin
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' +
                SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NOT NULL;');
              end;
            end
            else
            begin
              if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
              begin
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString +
                '` ' +  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NULL;');
              end
              else
              begin
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString +
                '` ' +  SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NOT NULL;');
              end;
            end;
          end;

          SourceQuery.Next;
        end;
        CheckQuery.Filtered := False;

        SourceQuery.SQL.Text := 'SHOW INDEX FROM '+ TableName + ' IN ' + SourceDB;
        SourceQuery.Open;

        CheckQuery.SQL.Text := 'SHOW INDEX FROM '+ TableName + ' IN ' + CheckDB;
        CheckQuery.Open;

        SourceQuery.First;
        while not SourceQuery.Eof do
        begin
          CheckQuery.First;
          if CheckQuery.Locate('Key_name', SourceQuery.FieldByName('Key_name').AsString, []) then
          begin
            // Edit Index
            childKeySource := GetCompositeColumns(SourceQuery, SourceQuery.FieldByName('Key_name').AsString);
            childKeyCheck := GetCompositeColumns(CheckQuery, CheckQuery.FieldByName('Key_name').AsString);

            if (childKeySource <> childKeyCheck) then
            begin
              sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` DROP INDEX `' + SourceQuery.FieldByName('Key_name').AsString +
              '`, ADD INDEX `' + SourceQuery.FieldByName('Key_name').AsString + '` (' + GetCompositeColumns(SourceQuery, SourceQuery.FieldByName('Key_name').AsString) + ') USING BTREE;');
            end;
          end
          else
          begin
            // Add Index
            sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD INDEX `' + SourceQuery.FieldByName('Key_name').AsString +
            '` (' + GetCompositeColumns(SourceQuery, SourceQuery.FieldByName('Key_name').AsString) + ') USING BTREE;');
          end;

          SourceQuery.Next;
        end;
      end;

    end;

    // untuk auto-patch
    if autoPatch and (sMemo1.Text <> '') then
    begin
      QueryText := sMemo1.Text;
      con2.Database := CheckDB;
      if not con2.InTransaction then con2.StartTransaction;
      try
        while QueryText <> '' do
        begin
          EndPos := Pos(';', QueryText);
          if EndPos > 0 then
          begin
            CurrentQuery := Trim(Copy(QueryText, 1, EndPos - 1));
            Delete(QueryText, 1, EndPos);
          end
          else
          begin
            CurrentQuery := Trim(QueryText);
            QueryText := '';
          end;

          if CurrentQuery <> '' then
          begin
            CheckQuery.SQL.Text := CurrentQuery;
            CheckQuery.Execute;
          end;
        end;
        con2.Commit;
      except
        on E: Exception do
        begin
          con2.Rollback;
          ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
        end;
      end;
    end;

  finally
    SourceQuery.Free;
    CheckQuery.Free;
    SourceTables.Free;
    CheckTables.Free;
  end;
end;

function TFPATCH.GetCompositeParameters(Query: TMyQuery; Database, RoutineName: string): string;
var
  Params: TStringList;
begin
  Params := TStringList.Create;
  try
    Query.SQL.Text := Query.SQL.Text + ' AND PARAMETER_NAME IS NOT NULL ';
    Query.Open;

    Query.First;
    while not Query.Eof do
    begin
      if Query.FieldByName('ROUTINE_TYPE').AsString = 'PROCEDURE' then
      begin
        Params.Add(Query.FieldByName('PARAMETER_MODE').AsString + ' ' +
                 '`' + Query.FieldByName('PARAMETER_NAME').AsString + '` ' +
                 Query.FieldByName('DATA_TYPE').AsString);
      end;

      if Query.FieldByName('ROUTINE_TYPE').AsString = 'FUNCTION' then
      begin
        Params.Add('`' + Query.FieldByName('PARAMETER_NAME').AsString + '` ' +
                 Query.FieldByName('DATA_TYPE').AsString);
      end;

      Query.Next;
    end;

    // Hapus tanda kutip ganda tambahan dari definisi parameter
    Result := StringReplace(Params.DelimitedText, '"', '', [rfReplaceAll]);
  finally
    Params.Free;
  end;
end;

procedure TFPATCH.bInfoClick(Sender: TObject);
begin
  ShowMessage('Dalam Tahap Pengembangan');
end;

procedure TFPATCH.eDelimiterChange(Sender: TObject);
begin
  if eDelimiter.Text <> '' then
    delimiterNonTables := eDelimiter.Text
  else
    delimiterNonTables := '|';
end;

procedure TFPATCH.CreatePatchRoutines;
var
  SourceQuery, CheckQuery, ParameterQuery, ParameterQuery2: TMyQuery;
  SourceRoutines, CheckRoutines: TStringList;
  SourceDB, CheckDB, RoutinesName, RoutinesQuery, ParamsQuery, OutputFolder: string;
  patchFlag: boolean;
begin
  SourceDB := cDBsource.Text;
  CheckDB := cDBcheck.Text;

  SourceQuery := TMyQuery.Create(nil);
  ParameterQuery := TMyQuery.Create(nil);
  CheckQuery := TMyQuery.Create(nil);
  ParameterQuery2 := TMyQuery.Create(nil);
  SourceRoutines := TStringList.Create;
  CheckRoutines := TStringList.Create;

  try
    // PATCH PROCEDURE
    OutputFolder := folderPatch + '\' + 'PROCEDURE\';
    if DirectoryExists(OutputFolder) then
    begin
      RemoveDir(OutputFolder);
      CreateDir(OutputFolder);
    end
    else
      CreateDir(OutputFolder);

    RoutinesQuery := 'SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_TYPE = :RoutineType AND ROUTINE_SCHEMA = :Database';

    SourceQuery.Connection := con1;
    SourceQuery.SQL.Text := RoutinesQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.ParamByName('RoutineType').AsString := 'PROCEDURE';
    SourceQuery.Open;
    while not SourceQuery.Eof do
    begin
      SourceRoutines.Add(SourceQuery.Fields[0].AsString);
      SourceQuery.Next;
    end;

    CheckQuery.Connection := con2;
    CheckQuery.SQL.Text := RoutinesQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.ParamByName('RoutineType').AsString := 'PROCEDURE';
    CheckQuery.Open;
    while not CheckQuery.Eof do
    begin
      CheckRoutines.Add(CheckQuery.Fields[0].AsString);
      CheckQuery.Next;
    end;

    RoutinesQuery := 'SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = :Database';
    ParamsQuery := 'SELECT * FROM information_schema.PARAMETERS WHERE SPECIFIC_SCHEMA = :Database';

    SourceQuery.SQL.Text := RoutinesQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.Open;

    CheckQuery.SQL.Text := RoutinesQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;

    ParameterQuery.Connection := con1;
    ParameterQuery.SQL.Text := ParamsQuery;
    ParameterQuery.ParamByName('Database').AsString := SourceDB;
    ParameterQuery.Open;

    ParameterQuery2.Connection := con2;
    ParameterQuery2.SQL.Text := ParamsQuery;
    ParameterQuery2.ParamByName('Database').AsString := CheckDB;
    ParameterQuery2.Open;

    for RoutinesName in SourceRoutines do
    begin
      sMemo2.Text := '';

      SourceQuery.Filtered := False;
      SourceQuery.Filter := 'ROUTINE_NAME = ' + QuotedStr(RoutinesName);
      SourceQuery.Filtered := True;

      CheckQuery.Filtered := False;
      CheckQuery.Filter := 'ROUTINE_NAME = ' + QuotedStr(RoutinesName);
      CheckQuery.Filtered := True;

      ParameterQuery.Filtered := False;
      ParameterQuery.Filter := 'SPECIFIC_NAME = ' + QuotedStr(RoutinesName);
      ParameterQuery.Filtered := True;

      ParameterQuery2.Filtered := False;
      ParameterQuery2.Filter := 'SPECIFIC_NAME = ' + QuotedStr(RoutinesName);
      ParameterQuery2.Filtered := True;

      if CheckRoutines.IndexOf(RoutinesName) = -1 then
      begin
        // Create Procedure
        sMemo2.Lines.Add('/* New Procedure */');
        sMemo2.Lines.Add('DROP PROCEDURE IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
        sMemo2.Lines.Add('CREATE PROCEDURE `' + RoutinesName + '`(');
//        sMemo2.Lines.Add(GetCompositeParameters(ParameterQuery, SourceDB, RoutinesName));

        ParameterQuery.First;
        while not ParameterQuery.Eof do
        begin
          sMemo2.Lines.Add('  ' + ParameterQuery.FieldByName('PARAMETER_MODE').AsString + ' `' +
          ParameterQuery.FieldByName('PARAMETER_NAME').AsString + '` ' + ParameterQuery.FieldByName('DATA_TYPE').AsString);

          ParameterQuery.Next;

          if not ParameterQuery.Eof then
            sMemo2.Lines[sMemo2.Lines.Count - 1] := sMemo2.Lines[sMemo2.Lines.Count - 1] + ',';
        end;
        sMemo2.Lines.Add(')');
        sMemo2.Lines.Add(SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString + delimiterNonTables);
        sMemo2.Lines.Add('');
      end
      else
      begin
        // Edit Procedure
        patchFlag := False;

        if GetCompositeParameters(ParameterQuery, SourceDB, RoutinesName) <> GetCompositeParameters(ParameterQuery2, CheckDB, RoutinesName) then
          patchFlag := True;

        if SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString <> CheckQuery.FieldByName('ROUTINE_DEFINITION').AsString then
          patchFlag := True;

        if patchFlag then
        begin
          sMemo2.Lines.Add('/* Updated Procedure */');
          sMemo2.Lines.Add('DROP PROCEDURE IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
          sMemo2.Lines.Add('CREATE PROCEDURE `' + RoutinesName + '`(');

          ParameterQuery.First;
          while not ParameterQuery.Eof do
          begin
            sMemo2.Lines.Add('  ' + ParameterQuery.FieldByName('PARAMETER_MODE').AsString + ' `' +
            ParameterQuery.FieldByName('PARAMETER_NAME').AsString + '` ' + ParameterQuery.FieldByName('DATA_TYPE').AsString);

            ParameterQuery.Next;

            if not ParameterQuery.Eof then
              sMemo2.Lines[sMemo2.Lines.Count - 1] := sMemo2.Lines[sMemo2.Lines.Count - 1] + ',';
          end;
          sMemo2.Lines.Add(')');
          sMemo2.Lines.Add(SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString + delimiterNonTables);
          sMemo2.Lines.Add('');
        end;
      end;

      if sMemo2.Text <> '' then
        sMemo2.Lines.SaveToFile(OutputFolder + RoutinesName + '.txt');

      sMemo2.Text := '';
    end;

    SourceRoutines.Clear;
    CheckRoutines.Clear;

    // PATCH FUNCTION
    OutputFolder := folderPatch + '\' + 'FUNCTION\';
    if DirectoryExists(OutputFolder) then
    begin
      RemoveDir(OutputFolder);
      CreateDir(OutputFolder);
    end
    else
      CreateDir(OutputFolder);

    RoutinesQuery := 'SELECT ROUTINE_NAME FROM information_schema.ROUTINES WHERE ROUTINE_TYPE = :RoutineType AND ROUTINE_SCHEMA = :Database';

    SourceQuery.Connection := con1;
    SourceQuery.SQL.Text := RoutinesQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.ParamByName('RoutineType').AsString := 'FUNCTION';
    SourceQuery.Open;
    while not SourceQuery.Eof do
    begin
      SourceRoutines.Add(SourceQuery.Fields[0].AsString);
      SourceQuery.Next;
    end;

    CheckQuery.Connection := con2;
    CheckQuery.SQL.Text := RoutinesQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.ParamByName('RoutineType').AsString := 'FUNCTION';
    CheckQuery.Open;
    while not CheckQuery.Eof do
    begin
      CheckRoutines.Add(CheckQuery.Fields[0].AsString);
      CheckQuery.Next;
    end;

    RoutinesQuery := 'SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = :Database';
    ParamsQuery := 'SELECT * FROM information_schema.PARAMETERS WHERE SPECIFIC_SCHEMA = :Database';

    SourceQuery.SQL.Text := RoutinesQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.Open;

    CheckQuery.SQL.Text := RoutinesQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;

    ParameterQuery.Connection := con1;
    ParameterQuery.SQL.Text := ParamsQuery;
    ParameterQuery.ParamByName('Database').AsString := SourceDB;
    ParameterQuery.Open;

    ParameterQuery2.Connection := con2;
    ParameterQuery2.SQL.Text := ParamsQuery;
    ParameterQuery2.ParamByName('Database').AsString := CheckDB;
    ParameterQuery2.Open;

    for RoutinesName in SourceRoutines do
    begin
      sMemo2.Text := '';

      SourceQuery.Filtered := False;
      SourceQuery.Filter := 'ROUTINE_NAME = ' + QuotedStr(RoutinesName);
      SourceQuery.Filtered := True;

      CheckQuery.Filtered := False;
      CheckQuery.Filter := 'ROUTINE_NAME = ' + QuotedStr(RoutinesName);
      CheckQuery.Filtered := True;

      ParameterQuery.Filtered := False;
      ParameterQuery.Filter := 'SPECIFIC_NAME = ' + QuotedStr(RoutinesName);
      ParameterQuery.Filtered := True;

      ParameterQuery2.Filtered := False;
      ParameterQuery2.Filter := 'SPECIFIC_NAME = ' + QuotedStr(RoutinesName);
      ParameterQuery2.Filtered := True;

      if CheckRoutines.IndexOf(RoutinesName) = -1 then
      begin
        // Create Function
        sMemo2.Lines.Add('/* New Function */');
        sMemo2.Lines.Add('DROP FUNCTION IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
        sMemo2.Lines.Add('CREATE FUNCTION `' + RoutinesName + '`(');
//        sMemo2.Lines.Add(GetCompositeParameters(ParameterQuery, SourceDB, RoutinesName));

        ParameterQuery.First;
        while not ParameterQuery.Eof do
        begin
          sMemo2.Lines.Add('  `' +
          ParameterQuery.FieldByName('PARAMETER_NAME').AsString + '` ' + ParameterQuery.FieldByName('DATA_TYPE').AsString);

          ParameterQuery.Next;

          if not ParameterQuery.Eof then
            sMemo2.Lines[sMemo2.Lines.Count - 1] := sMemo2.Lines[sMemo2.Lines.Count - 1] + ',';
        end;
        sMemo2.Lines.Add(') RETURNS ' + SourceQuery.FieldByName('DTD_IDENTIFIER').AsString);
        sMemo2.Lines.Add(SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString + delimiterNonTables);
        sMemo2.Lines.Add('');
      end
      else
      begin
        // Edit Function
        patchFlag := False;

        if GetCompositeParameters(ParameterQuery, SourceDB, RoutinesName) <> GetCompositeParameters(ParameterQuery2, CheckDB, RoutinesName) then
          patchFlag := True;

        if SourceQuery.FieldByName('DTD_IDENTIFIER').AsString <> CheckQuery.FieldByName('DTD_IDENTIFIER').AsString then
          patchFlag := True;

        if SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString <> CheckQuery.FieldByName('ROUTINE_DEFINITION').AsString then
          patchFlag := True;

        if patchFlag then
        begin
          sMemo2.Lines.Add('/* Updated Function */');
          sMemo2.Lines.Add('DROP FUNCTION IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
          sMemo2.Lines.Add('CREATE FUNCTION `' + RoutinesName + '`(');

          ParameterQuery.First;
          while not ParameterQuery.Eof do
          begin
            sMemo2.Lines.Add('  `' +
            ParameterQuery.FieldByName('PARAMETER_NAME').AsString + '` ' + ParameterQuery.FieldByName('DATA_TYPE').AsString);

            ParameterQuery.Next;

            if not ParameterQuery.Eof then
              sMemo2.Lines[sMemo2.Lines.Count - 1] := sMemo2.Lines[sMemo2.Lines.Count - 1] + ',';
          end;
          sMemo2.Lines.Add(') RETURNS ' + SourceQuery.FieldByName('DTD_IDENTIFIER').AsString);
          sMemo2.Lines.Add(SourceQuery.FieldByName('ROUTINE_DEFINITION').AsString + delimiterNonTables);
          sMemo2.Lines.Add('');
        end;
      end;

      if sMemo2.Text <> '' then
        sMemo2.Lines.SaveToFile(OutputFolder + RoutinesName + '.txt');

      sMemo2.Text := '';
    end;
  finally
    SourceQuery.Free;
    ParameterQuery.Free;
    CheckQuery.Free;
    ParameterQuery2.Free;
    SourceRoutines.Free;
    CheckRoutines.Free;
  end;
end;

procedure TFPATCH.CreatePatchTrigger;
var
  SourceQuery, CheckQuery: TMyQuery;
  SourceTrigger, CheckTrigger: TStringList;
  SourceDB, CheckDB, TriggerName, TriggerQuery, OutputFolder: string;
  PatchFlag, nameTriggerSame: boolean;
begin
  SourceDB := cDBsource.Text;
  CheckDB := cDBcheck.Text;

  SourceQuery := TMyQuery.Create(nil);
  CheckQuery := TMyQuery.Create(nil);
  SourceTrigger := TStringList.Create;
  CheckTrigger := TStringList.Create;

  try
    OutputFolder := folderPatch + '\' + 'TRIGGER\';
    if DirectoryExists(OutputFolder) then
    begin
      RemoveDir(OutputFolder);
      CreateDir(OutputFolder);
    end
    else
      CreateDir(OutputFolder);

    TriggerQuery := 'SELECT TRIGGER_NAME, ACTION_TIMING, EVENT_MANIPULATION, EVENT_OBJECT_TABLE FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = :Database';

    SourceQuery.Connection := con1;
    SourceQuery.SQL.Text := TriggerQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.Open;
    while not SourceQuery.Eof do
    begin
      var TriggerInfo: string := Format('%s|%s|%s',
        [SourceQuery.FieldByName('ACTION_TIMING').AsString,
         SourceQuery.FieldByName('EVENT_MANIPULATION').AsString,
         SourceQuery.FieldByName('EVENT_OBJECT_TABLE').AsString]);
      SourceTrigger.Add(TriggerInfo);

      SourceQuery.Next;
    end;

    CheckQuery.Connection := con2;
    CheckQuery.SQL.Text := TriggerQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;
    while not CheckQuery.Eof do
    begin
      var TriggerInfo: string := Format('%s|%s|%s',
        [CheckQuery.FieldByName('ACTION_TIMING').AsString,
         CheckQuery.FieldByName('EVENT_MANIPULATION').AsString,
         CheckQuery.FieldByName('EVENT_OBJECT_TABLE').AsString]);
      CheckTrigger.Add(TriggerInfo);

      CheckQuery.Next;
    end;

    SourceQuery.Connection := con1;
    CheckQuery.Connection := con2;

//    for RoutinesName in SourceRoutines do
    for var SourceTriggerIndex := 0 to SourceTrigger.Count - 1 do
    begin
      sMemo2.Text := '';

      var SourceTriggerInfo := SourceTrigger[SourceTriggerIndex];
      // Mencari trigger yang cocok berdasarkan ACTION_TIMING, EVENT_MANIPULATION dan EVENT_OBJECT_TABLE
      var MatchingTriggerInfo: string := '';
      for var CheckTriggerInfo in CheckTrigger do
      begin
        if SameText(SourceTriggerInfo, CheckTriggerInfo) then
        begin
          MatchingTriggerInfo := CheckTriggerInfo;
          Break;
        end;
      end;

      if MatchingTriggerInfo = '' then
      begin
        // Create Trigger
        SourceQuery.SQL.Text := 'SELECT TRIGGER_NAME FROM information_schema.TRIGGERS WHERE ' +
        'TRIGGER_SCHEMA = :Database AND EVENT_OBJECT_TABLE = :Table AND ACTION_TIMING = :Time AND EVENT_MANIPULATION = :Event';
        SourceQuery.ParamByName('Database').AsString := SourceDB;
        SourceQuery.ParamByName('Table').AsString := SourceTriggerInfo.Split(['|'])[2];
        SourceQuery.ParamByName('Time').AsString := SourceTriggerInfo.Split(['|'])[0];
        SourceQuery.ParamByName('Event').AsString := SourceTriggerInfo.Split(['|'])[1];
        SourceQuery.Open;

        SourceQuery.SQL.Text := 'SHOW CREATE TRIGGER `' + SourceDB + '`.`' + SourceQuery.Fields[0].AsString + '`';
        SourceQuery.Open;

        sMemo2.Lines.Add('/* New Trigger */');
        sMemo2.Lines.Add('DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`' + delimiterNonTables);
        QRunning := 'DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`';
        AutoPatching;

        sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
        QRunning := SourceQuery.Fields[2].AsString;
        AutoPatching;
      end
      else
      begin
        // Edit Trigger
        PatchFlag := False;
        nameTriggerSame := True;

        TriggerQuery := 'SELECT TRIGGER_NAME, ACTION_STATEMENT FROM information_schema.TRIGGERS WHERE ' +
        'TRIGGER_SCHEMA = :Database AND EVENT_OBJECT_TABLE = :Table AND ACTION_TIMING = :Time AND EVENT_MANIPULATION = :Event';

        SourceQuery.SQL.Text := TriggerQuery;
        SourceQuery.ParamByName('Database').AsString := SourceDB;
        SourceQuery.ParamByName('Table').AsString := SourceTriggerInfo.Split(['|'])[2];
        SourceQuery.ParamByName('Time').AsString := SourceTriggerInfo.Split(['|'])[0];
        SourceQuery.ParamByName('Event').AsString := SourceTriggerInfo.Split(['|'])[1];
        SourceQuery.Open;

        CheckQuery.SQL.Text := TriggerQuery;
        CheckQuery.ParamByName('Database').AsString := CheckDB;
        CheckQuery.ParamByName('Table').AsString := SourceTriggerInfo.Split(['|'])[2];
        CheckQuery.ParamByName('Time').AsString := SourceTriggerInfo.Split(['|'])[0];
        CheckQuery.ParamByName('Event').AsString := SourceTriggerInfo.Split(['|'])[1];
        CheckQuery.Open;

        if SourceQuery.Fields[1].AsString <> CheckQuery.Fields[1].AsString then
          PatchFlag := True;

        if SourceQuery.Fields[0].AsString <> CheckQuery.Fields[0].AsString then
          nameTriggerSame := False;

        if PatchFlag then
        begin
          SourceQuery.SQL.Text := 'SHOW CREATE TRIGGER `' + SourceDB + '`.`' + SourceQuery.Fields[0].AsString + '`';
          SourceQuery.Open;

          if not nameTriggerSame then
          begin
            QRunning := 'DROP TRIGGER IF EXISTS `' + CheckQuery.Fields[0].AsString + '`';
            AutoPatching;
          end;

          sMemo2.Lines.Add('/* Updated Trigger */');
          sMemo2.Lines.Add('DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`' + delimiterNonTables);
          QRunning := 'DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`';
          AutoPatching;

          sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
          QRunning := SourceQuery.Fields[2].AsString;
          AutoPatching;
        end;
      end;

      if sMemo2.Text <> '' then
        sMemo2.Lines.SaveToFile(OutputFolder + SourceQuery.Fields[0].AsString + '.txt');
      sMemo2.Text := '';
    end;

  finally
    SourceQuery.Free;
    CheckQuery.Free;
    SourceTrigger.Free;
    CheckTrigger.Free;
  end;
end;

procedure TFPATCH.AutoPatching;
var
  QueryText: string;
  StartPos, EndPos: Integer;
  ExecQuery: TMyQuery;
begin
  if autoPatch then
  begin
    ExecQuery := TMyQuery.Create(nil);
    try
      QueryText := QRunning;
      con2.Database := cDBcheck.Text;
      ExecQuery.Connection := con2;

      if not con2.InTransaction then
        con2.StartTransaction;

      try
        if QueryText <> '' then
        begin
          ExecQuery.SQL.Text := QueryText;
          ExecQuery.Execute;
        end;

        con2.Commit;
      except
        on E: Exception do
        begin
          con2.Rollback;
          ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
        end;
      end;
    finally
      ExecQuery.Free;
    end;
  end;
end;


end.

