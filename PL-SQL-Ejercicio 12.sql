CREATE OR REPLACE PACKAGE PkgUtilColegio IS

    PROCEDURE PRC_Ejercicio2(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;
    PROCEDURE PRC_Ejercicio3(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;
    PROCEDURE PRC_Ejercicio4(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;
    PROCEDURE PRC_Ejercicio5(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;
    PROCEDURE PRC_Ejercicio10(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;
    PROCEDURE PRC_Ejercicio11(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) ;

END PkgUtilColegio;
----------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PkgUtilColegio IS

    PROCEDURE PRC_Ejercicio2(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2)
    IS
        aux int;
    BEGIN
    p_appcod:=0;
    p_sqlcode:=SQLCODE;
    p_sql_error:=SQLERRM;
    aux:=10;
    FOR contador IN  1..10 LOOP
        INSERT INTO Profesor(idProfesor,nombre,apellido) VALUES(aux,'Nombre ' || aux,'Apellido_' || aux );
        aux:=aux+20;
        END LOOP;
    COMMIT;
   EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('ERROR: Indices Duplicados'); 
     WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error );   
END;

PROCEDURE PRC_Ejercicio3(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2) 
IS
auxMat int:=1;
CURSOR cProf IS
    SELECT idProfesor
    FROM Profesor;
BEGIN
    p_appcod:=0;
    p_sqlcode:=SQLCODE;
    p_sql_error:=SQLERRM;
FOR prof IN  cProf LOOP
      
        INSERT INTO Materia(idMateria,nombre,fkprofesorTitular) VALUES(auxMat,'Materia_' || auxMat, PROF.IDPROFESOR);
         auxMat:=auxMat+1;     
              END LOOP;
COMMIT;
EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('ERROR: Indices Duplicados'); 
     WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error ); 
END;      

PROCEDURE PRC_Ejercicio4(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2)
IS
auxLegajo int;
auxFecha date;
xCantidad int;
BEGIN
p_appcod:=0;
p_sqlcode:=SQLCODE;
p_sql_error:=SQLERRM;
auxLegajo:=10;
FOR contador IN  1..100 LOOP
        xCantidad:=auxLegajo*2;
        SELECT trunc(sysdate - numtoyminterval(xCantidad, 'YEAR')) 
        INTO auxFecha
        FROM dual;
        
        INSERT INTO Alumno(legajo,nombre,apellido,promedio,fechaNacimiento) VALUES(auxLegajo,'Nombre_' || auxLegajo,'Apellido_' || auxLegajo,0,auxFecha);
        auxLegajo:=auxLegajo+2;
        END LOOP;
COMMIT;
EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('ERROR: Indices Duplicados'); 
     WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error );   
END;

 PROCEDURE PRC_Ejercicio5(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2)
 IS
 auxNota int;
CURSOR cAlumno IS
SELECT legajo
FROM Alumno;
CURSOR cMateria IS
SELECT idMateria
FROM Materia;
BEGIN
p_appcod:=0;
p_sqlcode:=SQLCODE;
p_sql_error:=SQLERRM;
FOR rAlumno IN  cAlumno LOOP
        
        FOR rMateria IN  cMateria LOOP
                  
                SELECT (1+ABS(MOD(dbms_random.random,10)))
                INTO auxNota
                FROM dual;
                 
                 INSERT INTO Cursado(fkLegajoAlumno,fkMateria,aula,notaExamenFinal) VALUES(rAlumno.Legajo,rMateria.IdMateria,'A_' || rMAteria.IdMateria,auxNota);
        END LOOP;
        
        END LOOP;
COMMIT;
EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('ERROR: Indices Duplicados'); 
     WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error );      
END;

PROCEDURE PRC_Ejercicio10(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2)
IS
BEGIN
p_appcod:=0;
p_sqlcode:=SQLCODE;
p_sql_error:=SQLERRM;
    UPDATE alumno a SET promedio= ( 
    SELECT AVG (c.notaexamenfinal)
    FROM alumno a1, cursado c
    WHERE a1.legajo=c.fkLegajoAlumno AND a.legajo=a1.legajo
    GROUP BY a1.legajo);
COMMIT;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        ROLLBACK;
        p_appcod:=-1;
        DBMS_OUTPUT.PUT_LINE('ERROR: Division Por Cero'); 
     WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error );       
END;

PROCEDURE PRC_Ejercicio11(p_appcod OUT NUMBER, p_sqlcode OUT NUMBER, p_sql_error OUT VARCHAR2)
IS
nivel INT:=0;
PROMEDIO_INCORRECTO EXCEPTION;
CURSOR cAlumno IS
SELECT *
FROM Alumno;
BEGIN
p_appcod:=0;
p_sqlcode:=SQLCODE;
p_sql_error:=SQLERRM;
FOR rAlumno IN cAlumno LOOP
    CASE
        WHEN RALUMNO.PROMEDIO  >=1  AND RALUMNO.PROMEDIO <= 4 THEN nivel := 1;
        WHEN RALUMNO.PROMEDIO > 4 AND RALUMNO.PROMEDIO <= 8 THEN nivel := 2;
        WHEN RALUMNO.PROMEDIO >= 9 THEN nivel := 3;
        ELSE 
        RAISE PROMEDIO_INCORRECTO;
    END CASE;
DBMS_OUTPUT.PUT_LINE('Alumno: ' || RALUMNO.Legajo || ' Nivel: ' || nivel); 
END LOOP;
COMMIT;
EXCEPTION
    WHEN PROMEDIO_INCORRECTO THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('ERROR: Promedio fuera del rango ');
    WHEN OTHERS THEN
            ROLLBACK;
            p_appcod:=-1;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || p_sqlcode || ', Mensaje: ' || p_sql_error ); 
END;
    
END PkgUtilColegio;