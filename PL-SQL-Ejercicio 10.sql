DECLARE
BEGIN

    UPDATE alumno a SET promedio= ( 
    SELECT AVG (c.notaexamenfinal)
    FROM alumno a1, cursado c
    WHERE a1.legajo=c.fkLegajoAlumno AND a.legajo=a1.legajo
    GROUP BY a1.legajo);
    COMMIT;
 
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Division Por Cero'); 
     WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);    
END;

