DECLARE
promedio1 FLOAT:=0;
suma INT:= 0;
contador INT:=0;
CURSOR cAlumno IS
SELECT legajo 
FROM Alumno;
CURSOR cCursado IS
SELECT * 
FROM Cursado;
BEGIN
FOR rAlumno IN Calumno LOOP
    
    FOR rCursado IN cCursado LOOP
        IF(RALUMNO.LEGAJO = RCURSADO.FKLEGAJOALUMNO ) THEN
        suma:=suma+RCURSADO.NOTAEXAMENFINAL;
        contador:=contador+1;
        END IF;
     
    END LOOP;

 promedio1:=suma/contador;
 UPDATE Alumno SET promedio=promedio1
 WHERE legajo = rAlumno.Legajo;
 suma:=0;
 contador:=0;
 promedio1:=0;
 END LOOP;
 COMMIT;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Division Por Cero'); 
     WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);    
END;