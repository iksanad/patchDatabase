unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, sMemo, Vcl.ExtCtrls, sButton, Vcl.Buttons, sLabel, Data.DB,
  DBAccess, MyAccess, sEdit, MemDS, Clipbrd, sCheckBox, Vcl.Mask, sMaskEdit,
  sCustomComboEdit, sComboBox, DAScript, MyScript;

type
  TFPATCH = class(TForm)
    Panel1: TPanel;
    sMemo1: TsMemo;
    sMemo2: TsMemo;
    cDBsource: TComboBox;
    cDBcheck: TComboBox;
    bStartPatch: TsButton;
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
    cAutoPatch: TsCheckBox;
    bExit: TsButton;
    bSetting: TsButton;
    sLabel7: TsLabel;
    cPassSource: TsEdit;
    sLabel8: TsLabel;
    cPassCheck: TsEdit;
    eDelimiter: TsEdit;
    cUserCheck: TsEdit;
    cUserSource: TsEdit;
    sLabel5: TsLabel;
    cPortSource: TsEdit;
    sLabel6: TsLabel;
    cPortCheck: TsEdit;
    bDefault: TsButton;
    cPatchChoice: TComboBox;
    sLabel9: TsLabel;
    sql1: TMyScript;
    procedure FormCreate(Sender: TObject);
    procedure cServerExit(Sender: TObject);
    procedure cServerChange(Sender: TObject);
    procedure cDBsourceEnter(Sender: TObject);
    procedure cDBcheckEnter(Sender: TObject);
    procedure bStartPatchClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure cServer2Exit(Sender: TObject);
    procedure cServer2Change(Sender: TObject);
    procedure eDelimiterChange(Sender: TObject);
    procedure cAutoPatchExit(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bSettingClick(Sender: TObject);
    procedure bDefaultClick(Sender: TObject);
    procedure sql1Error(Sender: TObject; E: Exception; SQL: string;
      var Action: TErrorAction);
  private
    { Private declarations }
    autoPatch, openSetting: boolean;
    delimiterNonTables, folderPatch, QRunning, tempError, tempNonTables: string;
    function ConnectDatabase(Server, Database: string): Boolean;
    function GetCompositeColumns(Query: TMyQuery; keyName: string): string;
    procedure CreatePatchTable;
    procedure CreatePatchField;
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
      con1.Username := cUserSource.Text;
      con1.Password := cPassSource.Text;
      con1.Port := StrToInt(cPortSource.Text);
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
      con2.Username := cUserCheck.Text;
      con2.Password := cPassCheck.Text;
      con2.Port := StrToInt(cPortCheck.Text);
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

procedure TFPATCH.sql1Error(Sender: TObject; E: Exception; SQL: string;
  var Action: TErrorAction);
begin
  Action := eaFail;
end;

procedure TFPATCH.bCopyClick(Sender: TObject);
begin
  Clipboard.AsText := sMemo1.Lines.Text;
  ShowMessage('Teks berhasil disalin ke clipboard!');
end;

procedure TFPATCH.bSettingClick(Sender: TObject);
begin
  if openSetting = False then
  begin
    self.Height := 925;
    self.Top := (screen.Height - self.Height) div 2;
    sMemo1.Top := smemo1.Top + 40;
    bStartPatch.Visible := False;
    cAutoPatch.Visible := False;
    bSetting.Top := cPatchChoice.Top-5;
    bCopy.Top := cPatchChoice.Top-5;
    bDelete.Top := cPatchChoice.Top-5;
    bDefault.Top := cPatchChoice.Top-5;
    sLabel9.Visible := True;
    cPatchChoice.Visible := True;
    slabel2.Caption := 'USERNAME SERVER 1';
    slabel3.Caption := 'USERNAME SERVER 2';
    cDBsource.Visible := False;
    cDBcheck.Visible := False;
    cUserSource.Visible := True;
    cUserCheck.Visible := True;
    sLabel7.Visible := True;
    sLabel8.Visible := True;
    cPassSource.Visible := True;
    cPassCheck.Visible := True;
    sLabel5.Visible := True;
    sLabel6.Visible := True;
    cPortSource.Visible := True;
    cPortCheck.Visible := True;
    bSetting.Caption := 'Close Setting';
    openSetting := True;
  end
  else
  begin
    self.Height := 885;
    self.Top := (screen.Height - self.Height) div 2;
    sMemo1.Top := smemo1.Top - 40;
    bStartPatch.Visible := True;
    cAutoPatch.Visible := True;
    bSetting.Top := cDBcheck.Top-6;
    bCopy.Top := cDBcheck.Top-6;
    bDelete.Top := cDBcheck.Top-6;
    bDefault.Top := cDBcheck.Top-6;
    sLabel9.Visible := False;
    cPatchChoice.Visible := False;
    slabel2.Caption := 'DATABASE SUMBER';
    slabel3.Caption := 'DATABASE TUJUAN';
    cDBsource.Visible := True;
    cDBcheck.Visible := True;
    cUserSource.Visible := False;
    cUserCheck.Visible := False;
    sLabel7.Visible := False;
    sLabel8.Visible := False;
    cPassSource.Visible := False;
    cPassCheck.Visible := False;
    sLabel5.Visible := False;
    sLabel6.Visible := False;
    cPortSource.Visible := False;
    cPortCheck.Visible := False;
    bSetting.Caption := 'Open Setting';
    openSetting := False;
  end;
end;

procedure TFPATCH.bStartPatchClick(Sender: TObject);
var
  PatchFileName, dateFile, ErrorFileName: string;
  Confirmation: Integer;
begin
  if (cDBsource.Text = '') or (cDBcheck.Text = '') then
  begin
    MessageDlg('Database Sumber dan Database Tujuan harus diisi!', mtWarning, [mbOK], 0);
    Exit;
  end
  else
  begin
    if cDBsource.Text = cDBcheck.Text then
    begin
      MessageDlg('Database Sumber dan Database Tujuan tidak boleh sama!', mtWarning, [mbOK], 0);
      Exit;
    end
    else
    begin
      Confirmation := MessageDlg('Yakin ingin Patch, Apakah Database Sumber dan Tujuan sudah Benar?', mtConfirmation, mbYesNo, 0);
      if Confirmation <> mrYes then
      begin
        MessageDlg('Patch dibatalkan..', mtInformation, [mbOK], 0);
        Exit;
      end;

      tempError := '';

      folderPatch := cDBsource.Text + ' - ' + cDBcheck.Text + ' (' + FormatDateTime('dd-mmm-yyyy', Now) + ')';
      if DirectoryExists(folderPatch) then
      begin
        RemoveDir(folderPatch);
        CreateDir(folderPatch);
      end
      else
        CreateDir(folderPatch);

      PatchFileName := FormatDateTime('yymmdd-hh.nn.ss', Now) + '.txt';
      ErrorFileName := 'error-' + FormatDateTime('yymmdd-hh.nn.ss', Now) + '.txt';
      sMemo1.Cursor := crAppStart;
      sMemo1.Text := '';

      if not con2.InTransaction then
        con2.StartTransaction;
      try
        if (cPatchChoice.ItemIndex = 0) OR (cPatchChoice.ItemIndex = 1) then
          CreatePatchTable;

        if (cPatchChoice.ItemIndex = 0) OR (cPatchChoice.ItemIndex = 4) then
          CreatePatchField;

        if (cPatchChoice.ItemIndex = 0) OR (cPatchChoice.ItemIndex = 3) then
          CreatePatchRoutines;

        if (cPatchChoice.ItemIndex = 0) OR (cPatchChoice.ItemIndex = 2) then
          CreatePatchTrigger;

        if autoPatch then
          con2.Commit;
      except
        on E: Exception do
        begin
//          con2.Rollback;
//          sMemo1.Cursor := crDefault;
          if tempError = '' then
            tempError := E.Message
          else
            tempError := tempError + #13 + E.Message;
//          ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
//          exit;
        end;
      end;

      sMemo1.Cursor := crDefault;

      if sMemo1.Text <> '' then
      begin
        sMemo1.Lines.SaveToFile(folderPatch + '\' + PatchFileName);
      end;

      if tempError <> '' then
      begin
        sMemo2.Text := '';
        sMemo2.Text := tempError;
        sMemo2.Lines.SaveToFile(folderPatch + '\' + ErrorFileName);
        sMemo2.Text := '';
      end;

      if not autoPatch then
      begin
        if tempError <> '' then
          MessageDlg('Sukses Membuat Patch, namun dengan beberapa kesalahan.' + #13 + 'Patch tersimpan di folder : ' + #13 + folderPatch, mtInformation, [mbOK], 0)
        else
          MessageDlg('Sukses Membuat Patch.' + #13 + 'Patch tersimpan di folder : ' + #13 + folderPatch, mtInformation, [mbOK], 0);
      end
      else
      begin
        if tempError <> '' then
          MessageDlg('Sukses Melakukan Patch ke Database ' + cDBcheck.Text + ' namun dengan beberapa kesalahan.' + #13 + 'Patch tersimpan di folder : ' + #13 + folderPatch, mtInformation, [mbOK], 0)
        else
          MessageDlg('Sukses Melakukan Patch ke Database ' + cDBcheck.Text + '.' + #13 + 'Patch tersimpan di folder : ' + #13 + folderPatch, mtInformation, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TFPATCH.bDefaultClick(Sender: TObject);
begin
  cServer.Text := '192.168.0.38';
  cServer2.Text := '192.168.0.38';
  cUserSource.Text := 'Fatra';
  cUserCheck.Text := 'Fatra';
  cPassSource.Text := '73fangfang';
  cPassCheck.Text := '73fangfang';
  cPortSource.Text := '3306';
  cPortCheck.Text := '3306';
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
  TempQuery: TMyQuery;
begin
  TempQuery := TMyQuery.Create(self);
  if cServer2.Text <> '' then
  begin
    if (cDBcheck.Text = '') then
    begin
      if ConnectDatabase(cServer2.Text, 'con2') then
      begin
        TempQuery.Connection := con2;
        TempQuery.SQL.Text := 'SHOW DATABASES';
        TempQuery.Open;
        cDBcheck.Items.Clear;
        while not TempQuery.Eof do
        begin
          cDBcheck.Items.Append(TempQuery.Fields[0].AsString);
          TempQuery.Next;
        end;
        cDBcheck.ItemIndex := 0;
      end
      else
      begin
        MessageDlg('Server Tidak ada atau Setting salah!', mtWarning, [MBOK], 0);
        cServer2.SetFocus;
      end;
      FreeAndNil(TempQuery);
    end;
  end
  else
  begin
    MessageDlg('Isi Nama Server dulu!', mtWarning, [MBOK], 0);
    cServer2.SetFocus;
    exit;
  end;
end;

procedure TFPATCH.cDBsourceEnter(Sender: TObject);
var
  TempQuery: TMyQuery;
begin
  TempQuery := TMyQuery.Create(self);
  if cServer.Text <> '' then
  begin
    if (cDBsource.Text = '') then
    begin
      if ConnectDatabase(cServer.Text, 'con1') then
      begin
        TempQuery.Connection := con1;
        TempQuery.SQL.Text := 'SHOW DATABASES';
        TempQuery.Open;
        cDBsource.Items.Clear;
        while not TempQuery.Eof do
        begin
          cDBsource.Items.Append(TempQuery.Fields[0].AsString);
          TempQuery.Next;
        end;
        cDBsource.ItemIndex := 0;
      end
      else
      begin
        MessageDlg('Server Tidak ada atau Setting salah!', mtWarning, [MBOK], 0);
        cServer.SetFocus;
      end;
      FreeAndNil(TempQuery);
    end;
  end
  else
  begin
    MessageDlg('Isi Nama Server dulu!', mtWarning, [MBOK], 0);
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
{
  if con2.Server <> cServer2.Text then
  begin
    if con2.Connected then
      con2.Connected := False;

    con2.Server := cServer2.Text;
    con2.Connected := True;
  end;
}
end;

procedure TFPATCH.cServerChange(Sender: TObject);
begin
  cDBsource.Text := '';
end;

procedure TFPATCH.cServerExit(Sender: TObject);
begin
{
  if con1.Server <> cServer.Text then
  begin
    if con1.Connected then
      con1.Connected := False;

    con1.Server := cServer.Text;
    con1.Connected := True;
  end;
}
end;

procedure TFPATCH.FormCreate(Sender: TObject);
begin
  cServer.Text := con1.Server;
  cUserSource.Text := con1.Username;
  cPassSource.Text := con1.Password;
  cPortSource.Text := IntToStr(con1.Port);
  cServer2.Text := con2.Server;
  cUserCheck.Text := con2.Username;
  cPassCheck.Text := con2.Password;
  cPortCheck.Text := IntToStr(con2.Port);
  delimiterNonTables := eDelimiter.Text;
  autoPatch := cautoPatch.Checked;
  openSetting := False;
end;

procedure TFPATCH.CreatePatchTable;
var
  SourceQuery, CheckQuery: TMyQuery;
  SourceTables, CheckTables, SourceIndexes, CheckIndexes: TStringList;
  TableName, IndexName, ColumnName, childKeySource, childKeyCheck: string;
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
    tableQuery := 'SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_TYPE = ' + QuotedStr('BASE TABLE') + ' AND TABLE_SCHEMA = :Database';

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
        tableQuery := 'SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT, IS_NULLABLE FROM information_schema.columns ' + 'WHERE TABLE_SCHEMA = :Database AND TABLE_NAME = :TableName';

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
            if (SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> CheckQuery.FieldByName('COLUMN_DEFAULT').AsString) or (SourceQuery.FieldByName('IS_NULLABLE').AsString <> CheckQuery.FieldByName('IS_NULLABLE').AsString) then
            begin
              if SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> '' then
              begin
                if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NULL;')
                else
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NOT NULL;');
              end
              else
              begin
                if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NULL;')
                else
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` MODIFY COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NOT NULL;');
              end;
            end;
          end
          else
          begin
            // Add Column
            if SourceQuery.FieldByName('COLUMN_DEFAULT').AsString <> '' then
            begin
              if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NULL;')
              else
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' DEFAULT ' + QuotedStr(SourceQuery.FieldByName('COLUMN_DEFAULT').AsString) + ' NOT NULL;');
            end
            else
            begin
              if SourceQuery.FieldByName('IS_NULLABLE').AsString = 'YES' then
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NULL;')
              else
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD COLUMN `' + SourceQuery.FieldByName('COLUMN_NAME').AsString + '` ' + SourceQuery.FieldByName('COLUMN_TYPE').AsString + ' NOT NULL;');
            end;
          end;

          SourceQuery.Next;
        end;
        CheckQuery.Filtered := False;

        SourceQuery.SQL.Text := 'SHOW INDEX FROM ' + TableName + ' IN ' + SourceDB;
        SourceQuery.Open;

        CheckQuery.SQL.Text := 'SHOW INDEX FROM ' + TableName + ' IN ' + CheckDB;
        CheckQuery.Open;

        CheckIndexes := TStringList.Create;
        SourceIndexes := TStringList.Create;
        try
          CheckQuery.First;
          while not CheckQuery.Eof do
          begin
            var keyName := CheckQuery.FieldByName('Key_name').AsString;
            if CheckIndexes.IndexOf(keyName) = -1 then
              CheckIndexes.Add(keyName);
            CheckQuery.Next;
          end;

          SourceQuery.First;
          while not SourceQuery.Eof do
          begin
            var keyName := SourceQuery.FieldByName('Key_name').AsString;
            if SourceIndexes.IndexOf(keyName) = -1 then
              SourceIndexes.Add(keyName);
            SourceQuery.Next;
          end;

          for IndexName in SourceIndexes do
          begin
            if CheckIndexes.IndexOf(IndexName) = -1 then
            begin
              // Add Index
              if IndexName = 'PRIMARY' then
                sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD PRIMARY KEY (' + GetCompositeColumns(SourceQuery, IndexName) + ') USING BTREE;')
              else
              begin
                if SourceQuery.FieldByName('Non_unique').AsString = '0' then
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD UNIQUE `' + IndexName + '` (' + GetCompositeColumns(SourceQuery, IndexName) + ') USING BTREE;')
                else
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` ADD INDEX `' + IndexName + '` (' + GetCompositeColumns(SourceQuery, IndexName) + ') USING BTREE;');
              end;
            end
            else
            begin
              // Edit Index
              childKeySource := GetCompositeColumns(SourceQuery, IndexName);
              childKeyCheck := GetCompositeColumns(CheckQuery, IndexName);

              if (childKeySource <> childKeyCheck) and (childKeyCheck <> '') then
              begin
                if IndexName = 'PRIMARY' then
                  sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` DROP PRIMARY KEY, ADD PRIMARY KEY (' + childKeySource + ') USING BTREE;')
                else
                begin
                  if SourceQuery.FieldByName('Non_unique').AsString = '0' then
                    sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` DROP INDEX `' + IndexName + '`, ADD UNIQUE `' + IndexName + '` (' + childKeySource + ') USING BTREE;')
                  else
                    sMemo1.Lines.Add('ALTER TABLE `' + TableName + '` DROP INDEX `' + IndexName + '`, ADD INDEX `' + IndexName + '` (' + childKeySource + ') USING BTREE;');
                end;
              end;
            end;
          end;
        finally
          SourceIndexes.Free;
          CheckIndexes.Free;
        end;
      end;
    end;

    // untuk auto-patch
    if autoPatch and (sMemo1.Text <> '') then
    begin
      QueryText := sMemo1.Text;
      con2.Database := CheckDB;
      if not con2.InTransaction then
        con2.StartTransaction;
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
            sql1.SQL.Clear;
            sql1.SQL.Text := CurrentQuery;
            sql1.Execute;
          end;
        end;
      except
        on E: Exception do
        begin
          con2.Rollback;
//          sMemo1.Cursor := crDefault;
          if tempError = '' then
            tempError := E.Message + ' - (' + CurrentQuery + ')'
          else
            tempError := tempError + #13 + E.Message + ' - (' + CurrentQuery + ')';
//          ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
//          exit;
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

procedure TFPATCH.bExitClick(Sender: TObject);
begin
  Application.Terminate;
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
  SourceQuery, CheckQuery: TMyQuery;
  SourceRoutines, CheckRoutines: TStringList;
  SourceDB, CheckDB, RoutinesName, RoutinesQuery, ParamsQuery, OutputFolder: string;
  patchFlag: boolean;
begin
  SourceDB := cDBsource.Text;
  CheckDB := cDBcheck.Text;

  SourceQuery := TMyQuery.Create(nil);
  CheckQuery := TMyQuery.Create(nil);
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

    for RoutinesName in SourceRoutines do
    begin
      sMemo2.Text := '';
      tempNonTables := RoutinesName;

      if CheckRoutines.IndexOf(RoutinesName) = -1 then
      begin
        // Create Procedure
        SourceQuery.SQL.Text := 'SHOW CREATE PROCEDURE `' + SourceDB + '`.`' + RoutinesName + '`';
        SourceQuery.Open;

        sMemo2.Lines.Add('/* New Procedure */');
        sMemo2.Lines.Add('DROP PROCEDURE IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
        QRunning := 'DROP PROCEDURE IF EXISTS `' + RoutinesName + '`';
        AutoPatching;

        sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
        QRunning := SourceQuery.Fields[2].AsString;
        AutoPatching;
      end
      else
      begin
        // Edit Procedure
        patchFlag := False;
        SourceQuery.SQL.Text := 'SHOW CREATE PROCEDURE `' + SourceDB + '`.`' + RoutinesName + '`';
        SourceQuery.Open;
        CheckQuery.SQL.Text := 'SHOW CREATE PROCEDURE `' + CheckDB + '`.`' + RoutinesName + '`';
        CheckQuery.Open;

        if SourceQuery.Fields[2].AsString <> CheckQuery.Fields[2].AsString then
          patchFlag := True;

        if patchFlag then
        begin
          sMemo2.Lines.Add('/* Updated Procedure */');
          sMemo2.Lines.Add('DROP PROCEDURE IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
          QRunning := 'DROP PROCEDURE IF EXISTS `' + RoutinesName + '`';
          AutoPatching;

          sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
          QRunning := SourceQuery.Fields[2].AsString;
          AutoPatching;
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

    SourceQuery.SQL.Text := RoutinesQuery;
    SourceQuery.ParamByName('Database').AsString := SourceDB;
    SourceQuery.Open;

    CheckQuery.SQL.Text := RoutinesQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;

    for RoutinesName in SourceRoutines do
    begin
      sMemo2.Text := '';
      tempNonTables := RoutinesName;

      if CheckRoutines.IndexOf(RoutinesName) = -1 then
      begin
        // Create Function
        SourceQuery.SQL.Text := 'SHOW CREATE FUNCTION `' + SourceDB + '`.`' + RoutinesName + '`';
        SourceQuery.Open;

        sMemo2.Lines.Add('/* New Function */');
        sMemo2.Lines.Add('DROP FUNCTION IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
        QRunning := 'DROP FUNCTION IF EXISTS `' + RoutinesName + '`';
        AutoPatching;

        sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
        QRunning := SourceQuery.Fields[2].AsString;
        AutoPatching;
      end
      else
      begin
        // Edit Function
        patchFlag := False;
        SourceQuery.SQL.Text := 'SHOW CREATE FUNCTION `' + SourceDB + '`.`' + RoutinesName + '`';
        SourceQuery.Open;
        CheckQuery.SQL.Text := 'SHOW CREATE FUNCTION `' + CheckDB + '`.`' + RoutinesName + '`';
        CheckQuery.Open;

        if SourceQuery.Fields[2].AsString <> CheckQuery.Fields[2].AsString then
          patchFlag := True;

        if patchFlag then
        begin
          sMemo2.Lines.Add('/* Updated Function */');
          sMemo2.Lines.Add('DROP FUNCTION IF EXISTS `' + RoutinesName + '`' + delimiterNonTables);
          QRunning := 'DROP FUNCTION IF EXISTS `' + RoutinesName + '`';
          AutoPatching;

          sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
          QRunning := SourceQuery.Fields[2].AsString;
          AutoPatching;
        end;
      end;

      if sMemo2.Text <> '' then
        sMemo2.Lines.SaveToFile(OutputFolder + RoutinesName + '.txt');

      sMemo2.Text := '';
    end;
  finally
    SourceQuery.Free;
    CheckQuery.Free;
    SourceRoutines.Free;
    CheckRoutines.Free;
  end;
end;

procedure TFPATCH.CreatePatchTrigger;
var
  SourceQuery, CheckQuery: TMyQuery;
  SourceTrigger, CheckTrigger: TStringList;
  SourceDB, CheckDB, TriggerName, TriggerQuery, OutputFolder, TempTrigger: string;
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
      var TriggerInfo: string := Format('%s|%s|%s', [SourceQuery.FieldByName('ACTION_TIMING').AsString, SourceQuery.FieldByName('EVENT_MANIPULATION').AsString, SourceQuery.FieldByName('EVENT_OBJECT_TABLE').AsString]);
      SourceTrigger.Add(TriggerInfo);

      SourceQuery.Next;
    end;

    CheckQuery.Connection := con2;
    CheckQuery.SQL.Text := TriggerQuery;
    CheckQuery.ParamByName('Database').AsString := CheckDB;
    CheckQuery.Open;
    while not CheckQuery.Eof do
    begin
      var TriggerInfo: string := Format('%s|%s|%s', [CheckQuery.FieldByName('ACTION_TIMING').AsString, CheckQuery.FieldByName('EVENT_MANIPULATION').AsString, CheckQuery.FieldByName('EVENT_OBJECT_TABLE').AsString]);
      CheckTrigger.Add(TriggerInfo);

      CheckQuery.Next;
    end;

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
        SourceQuery.SQL.Text := 'SELECT TRIGGER_NAME, ACTION_STATEMENT FROM information_schema.TRIGGERS WHERE ' + 'TRIGGER_SCHEMA = :Database AND EVENT_OBJECT_TABLE = :Table AND ACTION_TIMING = :Time AND EVENT_MANIPULATION = :Event';
        SourceQuery.ParamByName('Database').AsString := SourceDB;
        SourceQuery.ParamByName('Table').AsString := SourceTriggerInfo.Split(['|'])[2];
        SourceQuery.ParamByName('Time').AsString := SourceTriggerInfo.Split(['|'])[0];
        SourceQuery.ParamByName('Event').AsString := SourceTriggerInfo.Split(['|'])[1];
        SourceQuery.Open;
        tempNonTables := SourceQuery.Fields[0].AsString;

        SourceQuery.SQL.Text := 'USE ' + SourceDB + '; SHOW CREATE TRIGGER ' + SourceQuery.Fields[0].AsString + ';';
        SourceQuery.Open;

        sMemo2.Lines.Add('/* New Trigger */');
        sMemo2.Lines.Add('DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`' + delimiterNonTables);
        QRunning := 'DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`';
        AutoPatching;

//        TempTrigger := '';
//        TempTrigger := 'CREATE TRIGGER ' + SourceQuery.Fields[0].AsString + ' ' + SourceTriggerInfo.Split(['|'])[0] + ' ' + SourceTriggerInfo.Split(['|'])[1] + ' ON ' + SourceTriggerInfo.Split(['|'])[2] + ' FOR EACH ROW ';
//        sMemo2.Lines.Add(TempTrigger + SourceQuery.Fields[1].AsString + delimiterNonTables);
//        QRunning := TempTrigger + SourceQuery.Fields[1].AsString;

        if Pos('`' + SourceDB + '`.', SourceQuery.Fields[2].AsString) > 0 then
        begin
          TempTrigger := '';
          TempTrigger := StringReplace(SourceQuery.Fields[2].AsString, '`' + SourceDB + '`.', '', [rfReplaceAll]);
          sMemo2.Lines.Add(TempTrigger + delimiterNonTables);
          QRunning := TempTrigger;
          TempTrigger := '';
        end
        else
        begin
          sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
          QRunning := SourceQuery.Fields[2].AsString;
        end;

        AutoPatching;
      end
      else
      begin
        // Edit Trigger
        PatchFlag := False;
        nameTriggerSame := True;

        TriggerQuery := 'SELECT TRIGGER_NAME, ACTION_STATEMENT FROM information_schema.TRIGGERS WHERE ' + 'TRIGGER_SCHEMA = :Database AND EVENT_OBJECT_TABLE = :Table AND ACTION_TIMING = :Time AND EVENT_MANIPULATION = :Event';

        SourceQuery.SQL.Text := TriggerQuery;
        SourceQuery.ParamByName('Database').AsString := SourceDB;
        SourceQuery.ParamByName('Table').AsString := SourceTriggerInfo.Split(['|'])[2];
        SourceQuery.ParamByName('Time').AsString := SourceTriggerInfo.Split(['|'])[0];
        SourceQuery.ParamByName('Event').AsString := SourceTriggerInfo.Split(['|'])[1];
        SourceQuery.Open;
        tempNonTables := SourceQuery.Fields[0].AsString;

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
//          SourceQuery.SQL.Text := 'SHOW CREATE TRIGGER `' + SourceDB + '`.`' + SourceQuery.Fields[0].AsString + '`';
          SourceQuery.SQL.Text := 'USE ' + SourceDB + '; SHOW CREATE TRIGGER ' + SourceQuery.Fields[0].AsString + ';';
          SourceQuery.Open;

          sMemo2.Lines.Add('/* Updated Trigger */');
          if not nameTriggerSame then
          begin
            sMemo2.Lines.Add('DROP TRIGGER IF EXISTS `' + CheckQuery.Fields[0].AsString + '`' + delimiterNonTables);
            QRunning := 'DROP TRIGGER IF EXISTS `' + CheckQuery.Fields[0].AsString + '`';
            AutoPatching;
          end;

          sMemo2.Lines.Add('DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`' + delimiterNonTables);
          QRunning := 'DROP TRIGGER IF EXISTS `' + SourceQuery.Fields[0].AsString + '`';
          AutoPatching;

//          TempTrigger := '';
//          TempTrigger := 'CREATE TRIGGER ' + SourceQuery.Fields[0].AsString + ' ' + SourceTriggerInfo.Split(['|'])[0] + ' ' + SourceTriggerInfo.Split(['|'])[1] + ' ON ' + SourceTriggerInfo.Split(['|'])[2] + ' FOR EACH ROW ';
//          sMemo2.Lines.Add(TempTrigger + SourceQuery.Fields[1].AsString + delimiterNonTables);
//          QRunning := TempTrigger + SourceQuery.Fields[1].AsString;

          if Pos('`' + SourceDB + '`.', SourceQuery.Fields[2].AsString) > 0 then
          begin
            TempTrigger := '';
            TempTrigger := StringReplace(SourceQuery.Fields[2].AsString, '`' + SourceDB + '`.', '', [rfReplaceAll]);
            sMemo2.Lines.Add(TempTrigger + delimiterNonTables);
            QRunning := TempTrigger;
            TempTrigger := '';
          end
          else
          begin
            sMemo2.Lines.Add(SourceQuery.Fields[2].AsString + delimiterNonTables);
            QRunning := SourceQuery.Fields[2].AsString;
          end;
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
begin
  if autoPatch then
  begin
    QueryText := QRunning;
    con2.Database := cDBcheck.Text;

    try
      if QueryText <> '' then
      begin
        sql1.SQL.Clear;
        sql1.SQL.Text := QueryText;
        sql1.Execute;
      end;
    except
      on E: Exception do
      begin
        con2.Rollback;
//        sMemo1.Cursor := crDefault;
        if tempError = '' then
          tempError := E.Message + ' - (' + tempNonTables + ')'
        else
          tempError := tempError + #13 + E.Message  + ' - (' + tempNonTables + ')';
//        ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
//        exit;
      end;
    end;
  end;
end;

procedure TFPATCH.CreatePatchField;
var
  SourceQuery, CheckQuery: TMyQuery;
  SourceDB, CheckDB, TableName, SourcePri, CheckPri: string;
  PatchFlag, hasChanges: boolean;
  QueryText, CurrentQuery: string;
  StartPos, EndPos: Integer;
begin
  SourceDB := cDBsource.Text;
  CheckDB := cDBcheck.Text;

  SourceQuery := TMyQuery.Create(nil);
  CheckQuery := TMyQuery.Create(nil);

  try
    sMemo2.Text := '';

    SourceQuery.Connection := con1;
    CheckQuery.Connection := con2;

    var TablesToCheck: TArray<string> := ['erp_table', 'erp_menu', 'erp_lookup_set', 'erp_lookup_value', 'coa_setup'];

    for TableName in TablesToCheck do
    begin
      // pengecekan diganti berdasarkan primary key bukan TableName_ID
      SourceQuery.SQL.Text := 'SELECT column_name FROM information_schema.key_column_usage WHERE constraint_name = "PRIMARY" AND table_schema = ' + QuotedStr(SourceDB) + ' AND table_name = ' + QuotedStr(TableName);
      CheckQuery.SQL.Text := 'SELECT column_name FROM information_schema.key_column_usage WHERE constraint_name = "PRIMARY" AND table_schema = ' + QuotedStr(CheckDB) + ' AND table_name = ' + QuotedStr(TableName);
      SourceQuery.Open;
      CheckQuery.Open;

      SourcePri := SourceQuery.FieldByName('column_name').AsString;
      CheckPri := CheckQuery.FieldByName('column_name').AsString;

      if (SourcePri = '') or (CheckPri = '') then
      begin
        SourceQuery.SQL.Text := 'SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = ' + QuotedStr(SourceDB) + ' AND TABLE_NAME = ' + QuotedStr(TableName) + ' AND ORDINAL_POSITION = 1';
        SourceQuery.Open;

        SourcePri := SourceQuery.FieldByName('column_name').AsString;
        CheckPri := SourceQuery.FieldByName('column_name').AsString;
      end;

      if TableName = 'erp_lookup_value' then
      begin
        SourceQuery.SQL.Text := 'SELECT * FROM `' + SourceDB + '`.`' + TableName + '` WHERE ERP_LOOKUP_SET_ID NOT IN (48, 49, 52, 53, 54, 55)';
        CheckQuery.SQL.Text := 'SELECT * FROM `' + CheckDB + '`.`' + TableName + '` WHERE ERP_LOOKUP_SET_ID NOT IN (48, 49, 52, 53, 54, 55)';
      end
      else
      begin
        SourceQuery.SQL.Text := 'SELECT * FROM `' + SourceDB + '`.`' + TableName + '`';
        CheckQuery.SQL.Text := 'SELECT * FROM `' + CheckDB + '`.`' + TableName + '`';
      end;
      SourceQuery.Open;
      CheckQuery.Open;

      if SourcePri = CheckPri then
      begin
        while not SourceQuery.Eof do
        begin
          var nama_table_idValue := SourceQuery.FieldByName(SourcePri).AsString;

          if not CheckQuery.Locate(CheckPri, nama_table_idValue, []) then
          begin
            // INSERT
            sMemo1.Lines.Add('DELETE FROM `' + TableName + '` WHERE `' + CheckPri + '`=' + QuotedStr(nama_table_idValue) + ';');

            sMemo2.Text := '';
            sMemo2.Lines.Add('DELETE FROM `' + TableName + '` WHERE `' + CheckPri + '`=' + QuotedStr(nama_table_idValue) + ';');

            var InsertStatement: string := 'INSERT INTO `' + TableName + '` (';
            var ValuesStatement: string := 'VALUES (';

            for var j := 0 to SourceQuery.FieldCount - 1 do
            begin
              var vfieldName := SourceQuery.Fields[j].FieldName;
              var vfieldValue := SourceQuery.FieldByName(vfieldName).Value;

              InsertStatement := InsertStatement + '`' + vfieldName + '`,';

              if (SourceQuery.Fields[j].DataType in [ftDate, ftDateTime]) and (SourceQuery.FieldByName(vfieldName).AsDateTime = 0) then
                ValuesStatement := ValuesStatement + QuotedStr('0000-00-00 00:00:00') + ','
              else
              if SourceQuery.Fields[j].DataType in [ftDate, ftDateTime] then
                ValuesStatement := ValuesStatement + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', SourceQuery.FieldByName(vfieldName).AsDateTime)) + ','
              else
              if (vfieldValue = Null) then
                ValuesStatement := ValuesStatement + 'NULL,'
              else
                ValuesStatement := ValuesStatement + QuotedStr(SourceQuery.FieldByName(vfieldName).AsString) + ',';
            end;

            // Hapus koma terakhir
            Delete(InsertStatement, Length(InsertStatement), 1);
            Delete(ValuesStatement, Length(ValuesStatement), 1);

            InsertStatement := InsertStatement + ') ' + ValuesStatement + ');';
            sMemo1.Lines.Add(InsertStatement);

            sMemo2.Text := '';
            sMemo2.Lines.Add(InsertStatement);
          end
          else
          begin
            // UPDATE
            if not ((TableName = 'erp_menu') or (TableName = 'coa_setup')) then
            begin
              hasChanges := False;
              var updateStatement := 'UPDATE `' + TableName + '` SET ';

              for var j := 0 to SourceQuery.FieldCount - 1 do
              begin
                var vfieldName := SourceQuery.Fields[j].FieldName;

                if CheckQuery.FieldByName(vfieldName) <> nil then
                begin
                  var vsourceValue := SourceQuery.FieldByName(vfieldName).Value;
                  var vcheckValue := CheckQuery.FieldByName(vfieldName).Value;

                  if VarIsNull(vsourceValue) then
                  begin
                    if not VarIsNull(vcheckValue) then
                      hasChanges := True;
                  end
                  else
                  begin
                    if (VarToStrDef(vsourceValue, '') <> VarToStrDef(vcheckValue, '')) and (vfieldName <> 'SEQ_ID') then
                      hasChanges := True;
                  end;

                  if hasChanges and (vfieldName <> 'SEQ_ID') then
                  begin
                    // Tambahkan kolom ke pernyataan UPDATE
                    if (SourceQuery.Fields[j].DataType in [ftDate, ftDateTime]) and (SourceQuery.FieldByName(vfieldName).AsDateTime = 0) then
                      updateStatement := updateStatement + '`' + vfieldName + '` = ' + QuotedStr('0000-00-00 00:00:00') + ','
                    else
                    if SourceQuery.Fields[j].DataType in [ftDate, ftDateTime] then
                      updateStatement := updateStatement + '`' + vfieldName + '` = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', SourceQuery.FieldByName(vfieldName).AsDateTime)) + ','
                    else
                    if VarIsNull(vsourceValue) then
                      updateStatement := updateStatement + '`' + vfieldName + '` = NULL,'
                    else
                      updateStatement := updateStatement + '`' + vfieldName + '` = ' + QuotedStr(SourceQuery.FieldByName(vfieldName).AsString) + ',';
                  end;
                end
                else
                  updateStatement := updateStatement + '`' + vfieldName + '` = ' + QuotedStr(SourceQuery.FieldByName(vfieldName).AsString) + ',';
              end;

              if hasChanges then
              begin
                // Hapus koma terakhir
                updateStatement := Copy(updateStatement, 1, Length(updateStatement) - 1);

                updateStatement := updateStatement + ' WHERE `' + CheckPri + '` = ' + nama_table_idValue + ';';
                sMemo1.Lines.Add(updateStatement);

                sMemo2.Text := '';
                sMemo2.Lines.Add(updateStatement);
              end;
            end;
          end;

          if autoPatch and (sMemo2.Text <> '') then
          begin
            QueryText := sMemo2.Text;
            con2.Database := CheckDB;
            if not con2.InTransaction then
              con2.StartTransaction;
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
                  sql1.SQL.Clear;
                  sql1.SQL.Text := CurrentQuery;
                  sql1.Execute;
                end;
              end;
            except
              on E: Exception do
              begin
                con2.Rollback;
//                sMemo1.Cursor := crDefault;
                if tempError = '' then
                  tempError := E.Message + ' - (' + CurrentQuery + ')'
                else
                  tempError := tempError + #13 + E.Message + ' - (' + CurrentQuery + ')';
//                ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
//                exit;
              end;
            end;
          end;

          SourceQuery.Next;
        end;
      end;
    end;

//    sMemo1.lines.Add(sMemo2.Text);
//    Sleep(1000);

    // untuk auto-patch
{    if autoPatch and (sMemo2.Text <> '') then
    begin
      QueryText := sMemo2.Text;
      con2.Database := CheckDB;
      if not con2.InTransaction then
        con2.StartTransaction;
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
            sql1.SQL.Clear;
            sql1.SQL.Text := CurrentQuery;
            sql1.Execute;
          end;
        end;
      except
        on E: Exception do
        begin
          con2.Rollback;
          sMemo1.Cursor := crDefault;
          ShowMessage('Error during Auto-Patch : ' + #13 + E.Message);
          exit;
        end;
      end;
    end;  }

    sMemo2.Text := '';
  finally
    SourceQuery.Free;
    CheckQuery.Free;
  end;
end;

end.

