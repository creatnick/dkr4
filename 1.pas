program dkr4;
uses crt, GraphABC;

var
  choice: integer;
  a, b, area, error: real;
  n: integer;

function F(x: real): real;
begin
  F := 1*x*x*x + 2*x*x + (-4)*x + 6;
end;

function find(a, b: real; n: integer): real;
var
  h, x, sum: real;
  i: integer;
begin
  if a > b then
    begin
      swap(a, b);
    end;
    
  h := (b - a) / n;
  sum := 0;
  
  for i := 1 to n do
  begin
    x := a + i * h;
      sum := sum + F(x) * h;
  end;
  
  find := sum;
end;

function ferror(a, b: real; n: integer): real;
var
  i1, i2: real;
begin
  i1 := find(a, b, n);
  i2 := find(a, b, 2*n);
  ferror := abs(i1 - i2);
end;


procedure draw(xmin, xmax, ymin, ymax, sx, sy: real);
var
  i: integer;
  stepX, stepY: real;
  posX, posY: integer;
  labelX, labelY: real;
begin

  setfontcolor(clBlack);
  setfontsize(10);
  

  stepX := (xmax - xmin) / 10;
  for i := 0 to 10 do
  begin
    labelX := xmin + i * stepX;
    posX := Round(i * stepX * sx);
    
    if (posX > 20) and (posX < Window.Width - 20) then
    begin
      var strX := '';
      if abs(labelX) < 0.05 then strX := '0'
      else if abs(labelX - Round(labelX)) < 0.001 then 
        strX := Round(labelX).ToString
      else 
        strX := labelX.ToString('0.0');
      
      TextOut(posX - 15, Window.Height - 25, strX);
      
      Line(posX, Window.Height - 5, posX, Window.Height + 5);
    end;
  end;
  
  SetFontSize(12);
  TextOut(Window.Width - 20, Window.Height - 20, 'X');
  
  stepY := (ymax - ymin) / 10;
  for i := 0 to 10 do
  begin
    labelY := ymin + i * stepY;
    posY := Round(Window.Height - i * stepY * sy);
    
    if (posY > 20) and (posY < Window.Height - 20) then
    begin
      var strY := '';
      if abs(labelY) < 0.05 then strY := '0'
      else if abs(labelY - Round(labelY)) < 0.001 then 
        strY := Round(labelY).ToString
      else 
        strY := labelY.ToString('0.0');
      
      TextOut(5, posY - 8, strY);
      
      Line(0, posY, 5, posY);
    end;
  end;
  
  TextOut(10, 5, 'Y');
end;

procedure drect(x1, y1, x2, y2: integer);
var
  i: integer;
begin

  Brush.Color := RGB(255, 255, 200);
  FillRectangle(x1, y1, x2, y2);
  
 
  Pen.Color := RGB(180, 180, 100);
  var stepSize := 5;
  
  for i := 0 to (x2 - x1 + y2 - y1) div stepSize do
  begin
    var offset := i * stepSize;
    

    var startX1 := x1;
    var startY1 := y1 + offset;
    var endX1 := x1 + offset;
    var endY1 := y1;
    
    if startY1 <= y2 then
      Line(startX1, startY1, endX1, endY1);
       
    var startX2 := x1 + offset;
    var startY2 := y2;
    var endX2 := x2;
    var endY2 := y2 - offset;
    
    if startX2 <= x2 then
      Line(startX2, startY2, endX2, endY2);
  end;
end;

procedure graph(a, b: real; n: integer);
var
    x, y: real;
    xmin, xmax, ymin, ymax: real;
    sx, sy: real;
    px, py, px1, px2: integer;
    i: integer;
    h: real;
    scale: real;
    key: char;
    showHatch: boolean;
begin
    scale := 1.0;
    showHatch := true;
    
    repeat
      window.clear;
      window.width := 900;
      window.height := 600;
  
      xmin := a;
      xmax := b;
      ymin := f(a);
      ymax := f(a);
  
      x := a;
      while x <= b do
      begin
          if f(x) < ymin then ymin := f(x);
          if f(x) > ymax then ymax := f(x);
          x += (b-a)/500;
      end;
  
   
      ymin := ymin - 0.1 * abs(ymax - ymin) - 1;
      ymax := ymax + 0.1 * abs(ymax - ymin) + 1;
  
      sx := window.width / (xmax - xmin) * scale;
      sy := window.height / (ymax - ymin) * scale;
      
      Pen.Color := clGray;
      Pen.Width := 1;
      
 
      if (ymin <= 0) and (ymax >= 0) then
      begin
        var y0 := round(window.height - (0 - ymin) * sy);
        Line(0, y0, window.width, y0);
      end;
      
   
      if (xmin <= 0) and (xmax >= 0) then
      begin
        var x0 := round((0 - xmin) * sx);
        Line(x0, 0, x0, window.height);
      end;
      
      draw(xmin, xmax, ymin, ymax, sx, sy);
   
      SetFontColor(clRed);
      SetFontSize(12);
      textout(10, 10, 'График функции f(x) = x³ + 2x² - 4x + 6');
      textout(10, 30, 'a = ' + a.ToString + '  b = ' + b.ToString);
      textout(10, 50, 'Правые прямоугольники, n=' + n.ToString);
      

      area := find(a, b, n);
      textout(10, 70, 'Площадь = ' + area.ToString('0.0000'));
      
      pen.color := clGreen;
      pen.width := 3;
      x := xmin;
      while x <= xmax do
      begin
          y := f(x);
          px := Round((x - xmin)*sx);
          py := Round(Window.Height - (y - ymin)*sy);
  
          if x = xmin then
              MoveTo(px, py)
          else
              LineTo(px, py);
  
          x += (b - a)/500;
      end;
      
      pen.color := clBlue;
      pen.width := 1;
      h := (b - a) / n;
      x := a;
      for i := 1 to n do
      begin
          px := round((x - xmin)*sx);
          py := round(window.height - (f(x) - ymin)*sy);
          line(px, window.height, px, py);
          x += h;
      end;
      
      if showHatch then
      begin
        x := a;
        for i := 1 to n do
        begin
            px1 := round((x - xmin)*sx);
            px2 := round((x + h - xmin)*sx);
            py := round(window.height - (f(x) - ymin)*sy);
            
            drect(px1, window.height, px2, py);
            x += h;
        end;
      end;
      
      pen.color := clRed;
      pen.width := 2;
      x := a;
      for i := 1 to n do
      begin
          px1 := round((x - xmin)*sx);
          px2 := round((x + h - xmin)*sx);
          py := round(window.height - (f(x) - ymin)*sy);
          
          Brush.Color := clWhite;
          Rectangle(px1, window.height, px2, py);
          x += h;
      end;
      
      key := ReadKey;
      
      case key of
        '+': scale := scale * 2;
        '-': scale := scale / 2;
      end;
      
    until key = #27;
end;

begin
  a := 0;
  b := 1;
  n := 50;
  
  repeat
    clrscr;
    writeln('1. Ввести пределы интегрирования');
    writeln('2. Ввести количество разбиений');
    writeln('3. Вычислить площадь на отрезке [', a:0:2, ', ', b:0:2, ']');
    writeln('4. Оценить погрешность');
    writeln('5. Вывести график');
    writeln('6. Выход');
    readln(choice);
    
    case choice of
      1: begin
        write('Введите a: ');
        readln(a);
        write('Введите b: ');
        readln(b);
      end;
      
      2: begin
        write('Введите n: ');
        readln(n);
      end;
      
      3: begin
        area := find(a, b, n);
        writeln('Площадь на отрезке [', a:0:2, ', ', b:0:2, '] = ', area:0:6);
        writeln('Нажмите Enter для продолжения...');
        readln;
      end;
      
      4: begin
        error := ferror(a, b, n);
        writeln('Оценка погрешности: ', error:0:6);
        writeln('Нажмите Enter для продолжения...');
        readln;
      end;
      
      5: begin
        graph(a, b, n);
      end;
      
      6: begin
        writeln('Выход из программы');
      end;
    end;
  until choice = 6;
end.