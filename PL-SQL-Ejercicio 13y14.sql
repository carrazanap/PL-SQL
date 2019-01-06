CREATE OR REPLACE PACKAGE PkgLogger IS

    PROCEDURE registerError(NombreProceso IN VARCHAR2,p_appcod IN NUMBER ,  p_sqlcode IN NUMBER, p_sql_error IN VARCHAR2);
    PROCEDURE summarize_errors(p_tipo_informe IN NUMBER, p_fecha_desde IN DATE) ;
    
END PkgLogger;
----------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY PkgLogger IS

    PROCEDURE registerError(nombreProceso IN VARCHAR2,p_appcod IN NUMBER ,  p_sqlcode IN NUMBER, p_sql_error IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO logger_transaction VALUES
        (nombreProceso, p_appcod, p_sqlcode, p_sql_error, SYSDATE);
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || SQLCODE || ', Mensaje: ' || SQLERRM );   
END;


    PROCEDURE summarize_errors(p_tipo_informe IN NUMBER, p_fecha_desde IN DATE)
    IS
        ERROR_TIPO_INFORME EXCEPTION;
        CURSOR cLoggerT IS
            SELECT nombreproceso,count(*) as contador
            FROM logger_transaction
            WHERE add_date >= p_fecha_desde
            GROUP BY nombreproceso;
        CURSOR cLoggerT2 IS
            SELECT nombreproceso,count(DISTINCT p_sql_error) as contador
            FROM logger_transaction
            WHERE add_date >= p_fecha_desde
            GROUP BY nombreproceso;
    BEGIN
         CASE
            WHEN p_tipo_informe = 1 THEN
                FOR rLoggerT IN cLoggerT LOOP
                    DBMS_OUTPUT.PUT_LINE('Proceso: ' || rLoggerT.NOMBREPROCESO || ', Cantidad Total errores: ' ||rLoggerT.CONTADOR  );
                END LOOP;

            WHEN p_tipo_informe = 2 THEN
               FOR rLoggerT2 IN cLoggerT2 LOOP
                   DBMS_OUTPUT.PUT_LINE('Proceso: ' || rLoggerT2.NOMBREPROCESO || ', Cantidad Total errores distintos: ' ||rLoggerT2.CONTADOR  );
                END LOOP;
            ELSE
                RAISE ERROR_TIPO_INFORME;
         END CASE;
    COMMIT;
    EXCEPTION
        WHEN ERROR_TIPO_INFORME THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR: Tipo de informe no existe' ); 
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Nro. Error: ' || SQLCODE || ', Mensaje: ' || SQLERRM );      
    END;
    
END PkgLogger;
-----------------------------------------------------
CREATE TABLE logger_transaction(
nombreProceso VARCHAR(100),
p_appcod NUMBER,
p_sqlcode NUMBER,
p_sql_error VARCHAR2(500),
add_date DATE);
