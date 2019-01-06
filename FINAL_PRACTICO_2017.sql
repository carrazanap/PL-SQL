CREATE OR REPLACE
PROCEDURE DATOS_EMPLEADO(
    NRO_LEGAJO employees.employee_id%TYPE)
IS
  CURSOR cEmpleado
  IS
    SELECT e.employee_id,
      e.first_name,
      e.last_name,
      e.email,
      e.phone_number,
      e.hire_date,
      j.job_title,
      e.salary,
      e.commission_pct,
      e.manager_id,
      d.department_name,
      e.totsal
    FROM employees e,
      departments d,
      jobs j
    WHERE employee_id  =NRO_LEGAJO
    AND e.department_id= d.department_id
    AND e.job_id       =j.job_id;
BEGIN
  FOR emp IN cEMpleado
  LOOP
    dbms_output.put_line('Legajo:' || emp.EMPLOYEE_ID || ', Nombre: ' || emp.first_name || ', Apellido: ' || emp.last_name || ', Email: ' || emp.email || ', Celular: ' || emp.phone_number || ', Fecha Ingreso: ' || emp.hire_date || ', Trabajo: ' || emp.job_title || ', Salario: ' || emp.salary || ' , Comision: ' || emp.commission_pct || ', Legajo Jefe: ' || emp.manager_id || ', Depto: ' || emp.department_name);
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Legajo ingresado incorrecto');
END;
CREATE OR REPLACE
PROCEDURE DATOS_DEPARTAMENTO(
    NRO_DEPTO departments.department_id%TYPE)
IS
  CURSOR cDepto
  IS
    SELECT d.department_id,
      d.department_name,
      d.manager_id,
      l.city
    FROM departments d,
      locations l
    WHERE department_id=NRO_DEPTO
    AND d.location_id  =l.location_id;
BEGIN
  FOR depto IN cDepto
  LOOP
    dbms_output.put_line('Nro Depto:' || depto.department_id || ', Nombre: ' || depto.department_name || ', Legajo Jefe: ' || depto.manager_id || ', Localidad: ' || depto.city);
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Legajo ingresado incorrecto');
END;
CREATE OR REPLACE
PROCEDURE DATOS_EMPLEADOS_POR_DEPTO(
    NRO_DEPTO employees.department_id%TYPE)
IS
  CURSOR cEmpleado
  IS
    SELECT e.employee_id,
      e.first_name,
      e.last_name,
      e.email,
      e.phone_number,
      e.hire_date,
      j.job_title,
      e.salary,
      e.commission_pct,
      e.manager_id,
      d.department_name,
      e.totsal
    FROM employees e,
      departments d,
      jobs j
    WHERE e.department_id=NRO_DEPTO
    AND e.department_id  = d.department_id
    AND e.job_id         =j.job_id;
BEGIN
  FOR emp IN cEMpleado
  LOOP
    dbms_output.put_line('Legajo:' || emp.EMPLOYEE_ID || ', Nombre: ' || emp.first_name || ', Apellido: ' || emp.last_name || ', Email: ' || emp.email || ', Celular: ' || emp.phone_number || ', Fecha Ingreso: ' || emp.hire_date || ', Trabajo: ' || emp.job_title || ', Salario: ' || emp.salary || ' , Comision: ' || emp.commission_pct || ', Legajo Jefe: ' || emp.manager_id || ', Depto: ' || emp.department_name);
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Legajo ingresado incorrecto');
END;
CREATE OR REPLACE
  FUNCTION VALIDAR_EMPLEADO(
      LEGAJO IN NUMBER)
    RETURN BOOLEAN
  IS
    EMP NUMBER;
  BEGIN
    SELECT COUNT(employee_id) INTO emp FROM employees WHERE employee_id=legajo;
    IF emp = 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('Empleado no existe');
  END;
CREATE OR REPLACE
FUNCTION VALIDAR_EMPLEADO_A_DEPTO(
    NRO_DEPTO IN NUMBER)
  RETURN BOOLEAN
IS
  EMP NUMBER;
BEGIN
  SELECT COUNT(employee_id)
  INTO emp
  FROM employees
  WHERE department_id=NRO_DEPTO;
  IF emp             = 0 THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  dbms_output.put_line('Empleado no existe en el Departamento ' || NRO_DEPTO);
END;
CREATE OR REPLACE
PROCEDURE REGISTRAR_EMPLEADO(
    EMPLOYEE_ID employees.EMPLOYEE_ID%TYPE,
    FIRST_NAME employees.first_name%TYPE,
    LAST_NAME employees.last_name%TYPE,
    EMAIL employees.email%TYPE,
    PHONE_NUMBER employees.phone_number%TYPE,
    JOB_ID employees.JOB_ID%TYPE,
    SALARY employees.SALARY%TYPE,
    COMMISSION_PCT employees.COMMISSION_PCT%TYPE,
    MANAGER_ID employees.MANAGER_ID%TYPE,
    DEPARTMENT_ID employees.DEPARTMENT_ID%TYPE,
    TOTSAL employees.TOTSAL%TYPE)
IS
BEGIN
  IF (VALIDAR_EMPLEADO(EMPLOYEE_ID) =FALSE) THEN
    INSERT
    INTO EMPLOYEES VALUES
      (
        EMPLOYEE_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE_NUMBER,
        TRUNC(SYSDATE),
        JOB_ID,
        SALARY,
        COMMISSION_PCT,
        MANAGER_ID,
        DEPARTMENT_ID,
        TOTSAL
      );
  ELSE
    dbms_output.put_line('Empleado que quiere registrar ya existe');
  END IF;
EXCEPTION
WHEN OTHERS THEN
  dbms_output.put_line('Error al insertar los datos');
END;
CREATE OR REPLACE
PROCEDURE MODIFICAR_EMPLEADO
  (
    EMPLOYEE_ID IN NUMBER,
    CAMPO       IN employees%rowtype,
    NUEVO_VALOR IN CAMPO%type
  )
IS
BEGIN
  IF (VALIDAR_EMPLEADO(EMPLOYEE_ID2) =TRUE) THEN
    UPDATE EMPLOYEES SET CAMPO=NUEVO_VALOR WHERE EMPLOYEE_ID=EMPLOYEE_ID2;
    COMMIT;
  ELSE
    dbms_output.put_line('Empleado que quiere modificar no existe');
  END IF;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line('Error al modificar');
END;
CREATE OR REPLACE
PROCEDURE ELIMINAR_DEPARTAMENTO(
    NRO_DEPTO IN NUMBER )
IS
BEGIN
  IF (VALIDAR_EMPLEADO_A_DEPTO(NRO_DEPTO) =TRUE) THEN
    DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID=NRO_DEPTO;
    UPDATE EMPLOYEES SET DEPARTMENT_ID=NULL WHERE DEPARTMENT_ID=NRO_DEPTO;
    COMMIT;
  ELSE
    ROLLBACK;
    dbms_output.put_line('Departamente que quiere eliminar no existe');
  END IF;
END;
CREATE OR REPLACE TRIGGER MODIFICACIONES_HORARIO BEFORE
  UPDATE ON EMPLOYEES DECLARE hora PLS_INTEGER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
  BEGIN
    IF (hora BETWEEN 15 AND 7) THEN
      RAISE_APPLICATION_ERROR(-20150, 'Solo puede realizarse modificaciones en los horarios de 8 a 14. Saludos');
    END IF;
  END;
CREATE OR REPLACE TRIGGER MODIFICACIONES_EMPLEADO AFTER
  UPDATE ON EMPLOYESS DECLARE hora PLS_INTEGER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
  BEGIN
    INSERT INTO LOG_EMPLEADO VALUES
      (sysdate, old.employee_id, new.employee_id
      );
  END;
CREATE OR REPLACE TRIGGER MODIFICACIONES_DEPTO AFTER
  UPDATE ON DEPARTMENTS DECLARE hora PLS_INTEGER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
  BEGIN
    INSERT
    INTO LOG_DEPARTAMENTO VALUES
      (
        sysdate,
        old.department_id,
        new.department_id
      );
  END;
CREATE OR REPLACE
PROCEDURE DEPENDENCIAS
  (
    USUARIO char
  )
IS
  CURSOR cLista
  IS
    SELECT * FROM all_objects WHERE owner = UPPER(USUARIO);
BEGIN
  FOR obj IN cLista
  LOOP
    dbms_output.put_line('Objeto:' || obj.object_name|| ', Tipo: ' || obj.object_type || ', Estado: ' || obj.status || ', Creado: ' || obj.created);
  END LOOP;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('No existe el usuario');
END;

