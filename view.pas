unit view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, DateUtils, System.Diagnostics;

type
 TThreadFifo = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;
  TThreadLifo = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;
  TThreadRR = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;
  TTask = record
    ti: Integer;
    t: Integer;
    tf: Integer;
  end;
  TResults = record
    T: Integer;
    E: Integer;
    I: Extended;
  end;
  TAvg = record
    T, E, I: Extended;
  end;
  TForm1 = class(TForm)
    gridData: TStringGrid;
    Button1: TButton;
    title: TLabel;
    calculator: TButton;
    gridResult: TStringGrid;
    Label1: TLabel;
    delRow: TButton;
    procedure selectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure create(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure calculatorClick(Sender: TObject);
    procedure delRowClick(Sender: TObject);
  private
    const
      maxVisibleRows = 10;
    procedure AdjustGridHeight;
    function isNumeric (const Value: String): Boolean;
    function fillTaskFromGridData: TArray<TTask>;
    procedure CalculateTF(var Matrix : array of TTask; Algorithm : string; quantum : Integer = 0);
    function CalculateTEI(Matrix: array of TTask): TArray<TResults>;
    function CalculateAvg(Matrix: array of TResults): TAvg;
    function CalculatePerformace(Avg: TAvg): Extended;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

constructor TThreadFifo.Create;
begin
  inherited Create(False);
  FreeOnTerminate := True;
end;
procedure TThreadFifo.Execute;
var
  taskFifo : TArray<TTask>;
  resultFifo: TArray<TResults>;
  avgFifo: TAvg;
  performanceFifo: Extended;
  stopWatchFifo:TStopwatch;
  exeTimeFifo: Int64;
begin
  taskFifo := Form1.fillTaskFromGridData;

  stopWatchFifo := TStopWatch.Create;
  stopWatchFifo.Start;

  Form1.CalculateTF(taskFifo, 'FIFO');
  resultFifo := Form1.CalculateTEI(taskFifo);
  avgFifo := Form1.CalculateAvg(resultFifo);
  performanceFifo := Form1.CalculatePerformace(avgFifo);

  stopWatchFifo.Stop;

  exeTimeFifo := stopWatchFifo.ElapsedMilliseconds;
  Form1.gridResult.Cells[1,1] := IntToStr(exeTimeFifo);
  Form1.gridResult.Cells[1,2] := FloatToStr(performanceFifo)+'%';

end;

constructor TThreadLifo.Create;
begin
  inherited Create(False);
  FreeOnTerminate := True;
end;
procedure TThreadLifo.Execute;
var
  i: Integer;
  taskLifo : TArray<TTask>;
  resultLifo: TArray<TResults>;
  avgLifo: TAvg;
  performanceLifo: Extended;
  stopWatchLifo:TStopwatch;
  exeTimeLifo: Int64;
begin
  taskLifo := Form1.fillTaskFromGridData;

  stopWatchLifo := TStopWatch.Create;
  stopWatchLifo.Start;

  Form1.CalculateTF(taskLifo, 'LIFO');
  resultLifo := Form1.CalculateTEI(taskLifo);

  avgLifo := Form1.CalculateAvg(resultLifo);
  performanceLifo := Form1.CalculatePerformace(avgLifo);

  stopWatchLifo.Stop;

  exeTimeLifo := stopWatchLifo.ElapsedMilliseconds;
  Form1.gridResult.Cells[2,1] := IntToStr(exeTimeLifo);
  Form1.gridResult.Cells[2,2] := FloatToStr(performanceLifo)+'%';
end;

constructor TThreadRR.Create;
begin
  inherited Create(False);
  FreeOnTerminate := True;
end;
procedure TThreadRR.Execute;
var
  i: Integer;
  taskRR : TArray<TTask>;
  resultRR: TArray<TResults>;
  avgRR: TAvg;
  performanceRR: Extended;
  stopWatchRR:TStopwatch;
  exeTimeRR: Int64;
begin
  taskRR := Form1.fillTaskFromGridData;

  stopWatchRR := TStopWatch.Create;
  stopWatchRR.Start;

  Form1.CalculateTF(taskRR, 'RR', 4);
  resultRR := Form1.CalculateTEI(taskRR);

  for i := 0 to High(taskRR) do
    ShowMessage('tf = '+IntToStr(taskRR[i].tf));


  avgRR := Form1.CalculateAvg(resultRR);
  performanceRR := Form1.CalculatePerformace(avgRR);

  stopWatchRR.Stop;

  exeTimeRR := stopWatchRR.ElapsedMilliseconds;
  Form1.gridResult.Cells[2,1] := IntToStr(exeTimeRR);
  Form1.gridResult.Cells[2,2] := FloatToStr(performanceRR)+'%';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, totalHeight: Integer;
begin
  gridData.RowCount := gridData.RowCount + 1;
  AdjustGridHeight;
end;


procedure TForm1.calculatorClick(Sender: TObject);
var
  i, j: Integer;
  isValid: Boolean;
  ThreadFifo : TThreadFifo;
  ThreadLifo : TThreadLifo;
  ThreadRR: TThreadRR;
  stopWatch : TStopwatch;
begin

  isValid := True;

  for i := 1 to gridData.RowCount - 1 do
  begin
    for j := 0 to gridData.ColCount - 1 do
    begin
      if not IsNumeric(gridData.Cells[j, i]) then
      begin
        isValid := False;
        Break;
      end;
    end;
    if not isValid then
      Break;
  end;
  if not isValid then
  begin
    ShowMessage('Todos los datos ingresados deben ser n�meros v�lidos y positivos.');
    Exit;
  end;

    ThreadFifo := TThreadFifo.Create;
    ThreadLifo := TThreadLifo.Create;
//      ThreadRR := TThreadRR.Create;



end;

procedure TForm1.create(Sender: TObject);
begin
  gridData.ColCount := 2;
  gridData.RowCount := 2;

  gridResult.ColCount := 4;
  gridResult.RowCount := 3;

  //Columna de Encabezado (Grid de Resultados)
  gridResult.Cells[0,0] := 'Rendimiento';
  gridResult.Cells[1,0] := 'FIFO';
  gridResult.Cells[2,0] := 'LIFO';
  gridResult.Cells[3,0] := 'Round Robin';

  gridResult.Cells[0,1] := 'Tiempo (ms)';
  gridResult.Cells[0,2] := 'Porcentaje (%)';

  gridData.Cells[0,0] := 'Tiempo inicial (ti)';
  gridData.Cells[1,0] := 'Tiempo de servicio (t)';

  gridData.OnSelectCell := selectCell;

  AdjustGridHeight;
end;

procedure TForm1.delRowClick(Sender: TObject);
begin
  gridData.RowCount := gridData.RowCount - 1;
  AdjustGridHeight;
end;

procedure TForm1.selectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := ARow <> 0;
end;

function TForm1.isNumeric(const Value: string): Boolean;
var
  num: Integer;
begin
  Result := TryStrToInt(Value, num) and (num >= 0);
end;


procedure TForm1.AdjustGridHeight;
var
  i, totalHeight : Integer;
begin
  if gridData.RowCount > MaxVisibleRows then
    begin
      totalHeight := MaxVisibleRows * gridData.DefaultRowHeight;
      if gridData.ScrollBars = ssNone then
        gridData.Width := gridData.Width + 20;
      gridData.ScrollBars := ssVertical;
    end
  else
    begin
      totalHeight := gridData.RowCount * gridData.DefaultRowHeight;
      gridData.ScrollBars := ssNone;
    end;
  gridData.Height := TotalHeight + gridData.GridLineWidth * (gridData.RowCount + 1) + 2;
end;

function TForm1.fillTaskFromGridData: TArray<TTask>;
var
  i : Integer;
  Task: TArray<TTask>;
begin
  SetLength(Task, gridData.RowCount - 1);

  for i := 1 to gridData.RowCount - 1 do
    begin
      Task[i - 1].ti := StrToInt(gridData.Cells[0, i]);
      Task[i - 1].t := StrToInt(gridData.Cells[1,i]);
      Task[i - 1].tf := 0;
    end;

  Result := Task;
end;

procedure TForm1.CalculateTF(var Matrix : array of TTask; Algorithm : string; quantum : Integer = 0);
var
  clock: Integer;
  found : Boolean;
procedure FIFO;
  var
    i, j, processedCount :Integer;
  begin
    clock := 0;
    processedCount := 0;
    repeat
      found := False;
      for i := 0 to High(Matrix) do
        begin
          if (Matrix[i].tf = 0) and (Matrix[i].ti <= clock) then
          begin
            clock := clock + Matrix[i].t;
            Matrix[i].tf := clock;
            found := True;
            Inc(processedCount);
            Break;
          end;
        end;
      if not found then
        begin
          Inc(clock);
        end;

    until (processedCount = Length(Matrix));
  end;

  procedure LIFO;
  var
    i, j, processedCount :Integer;
  begin
    clock := 0;
    processedCount := 0;
    repeat
      found := False;
      for i := High(Matrix) downto 0 do
        begin
          if (Matrix[i].tf = 0) and (Matrix[i].ti <= clock) then
          begin
            clock := clock + Matrix[i].t;
            Matrix[i].tf := clock;
            found := True;
            Inc(processedCount);
            Break;
          end;
        end;
      if not found then
        begin
          Inc(clock);
        end;

    until (processedCount = Length(Matrix)) or (clock > 1000);
  end;

procedure RoundRobin;
  var
    clock, processedCount, i: Integer;
    found: Boolean;
  begin
    clock := 0;
    processedCount := 0;
    repeat
      found := False;
      for i := 0 to High(Matrix) do
      begin
        if (Matrix[i].tf = 0) and (Matrix[i].ti <= clock)  then
        begin
          found := True;
          ShowMessage('Encontro un valor');
          if Matrix[i].t < Quantum then
          begin
            clock := clock + Quantum;
            Matrix[i].t := Matrix[i].t - Quantum;
          end
          else
          begin
            clock := clock + Matrix[i].t;
            Matrix[i].tf := clock;
            Inc(processedCount);
          end;
        end;
      end;
      if not found  then
        begin
          ShowMessage('Se suma el clock -> '+IntToStr(quantum));
          clock := clock + Quantum;
        end;

    until processedCount = Length(Matrix);
  end;

begin
  if Algorithm = 'FIFO' then
    FIFO
  else if Algorithm = 'LIFO' then
    LIFO
  else if Algorithm  = 'RR' then
    RoundRobin
  else
    ShowMessage('El tipo de algoritmo no existe');
end;

function TForm1.CalculateTEI(Matrix: array of TTask): TArray<TResults>;
var
  i: Integer;
  results: TArray<TResults>;
  currentResult: TResults;
begin
  SetLength(results, Length(Matrix));
  for i := 0 to High(Matrix) do
  begin
    currentResult.T := Matrix[i].tf - Matrix[i].ti;
    currentResult.E := currentResult.T - Matrix[i].t;
    if currentResult.T <> 0 then
      currentResult.I := Matrix[i].t / currentResult.T
    else
      currentResult.I := 0;
    results[i] := currentResult;
  end;
  Result := results;
end;

function TForm1.CalculateAvg(Matrix: array of TResults): TAvg;
var
  i: Integer;
  sumT, sumE, sumI: Extended;
  avgResult: TAvg;
begin
  sumT := 0;
  sumE := 0;
  sumI := 0;
  for i := 0 to High(Matrix) do
  begin
    sumT := sumT + Matrix[i].T;
    sumE := sumE + Matrix[i].E;
    sumI := sumI + Matrix[i].I;
  end;
  avgResult.T := sumT / Length(Matrix);
  avgResult.E := sumE / Length(Matrix);
  avgResult.I := sumI / Length(Matrix);
  Result := avgResult;
end;

function TForm1.CalculatePerformace(Avg: TAvg): Extended;
begin
  Result := (Avg.T + Avg.E + Avg.I) / 3;
end;

end.


