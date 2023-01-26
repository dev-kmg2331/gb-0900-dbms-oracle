/*JOBS 테이블에서 JOB_ID로 직원들의 JOB_TITLE, EMAIL, 성, 이름 검색*/
SELECT j.JOB_ID, FIRST_NAME, LAST_NAME, JOB_TITLE, EMAIL
FROM JOBS j JOIN EMPLOYEES e
ON j.JOB_ID = e.JOB_ID;

/*EMP 테이블의 SAL을 SALGRADE 테이블의 등급으로 나누기*/
SELECT  E.ENAME, E.SAL, S.GRADE, S.LOSAL, S.HISAL
FROM SALGRADE S JOIN EMP E
ON SAL BETWEEN S.LOSAL AND S.HISAL
ORDER BY E.SAL DESC;

/*EMPLOYEES 테이블에서 HIREDATE가 2003~2005년까지인 사원의 정보와 부서명 검색*/
SELECT D.DEPARTMENT_ID, E.*
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.HIRE_DATE BETWEEN TO_DATE('2003', 'YYYY') AND TO_DATE('2005', 'YYYY')  /* <-- 문자열 DATE 타입으로 자동형변환 */
/*TO_DATE('2003-01-01', 'YYYY-MM-DD') AND TO_DATE('2005-12-31', 'YYYY-MM-DD')*/
ORDER BY D.DEPARTMENT_ID;

-- 시스템 날짜 형식 변경(왠만하면 쓰지 말자)
/*SELECT SYS_CONTEXT('USERNV', 'NLS_DATE_FORMAT') FROM DUAL; 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY';*/

/*JOB_TITLE 중 'Manager'라는 문자열이 포함된 직업들의 평균 연봉을 JOB_TITLE별로 검색*/
SELECT j.JOB_TITLE , AVG(SALARY) AS AVG_SALARY
FROM JOBS j JOIN EMPLOYEES e 
ON j.JOB_ID = e.JOB_ID AND j.JOB_TITLE LIKE '%Manager%'
GROUP BY j.JOB_TITLE;

/*EMP 테이블에서 ENAME에 L이 있는 사원들의 DNAME과 LOC 검색*/
SELECT E.ENAME , D.DNAME , D.LOC
FROM DEPT d JOIN EMP e
ON E.DEPTNO = D.DEPTNO AND E.ENAME LIKE '%L%';

/*축구 선수들 중에서 각 팀별로 키가 가장 큰 선수들 전체 정보 검색*/
FROM PLAYER p JOIN
	(
	SELECT TEAM_ID, MAX(HEIGHT) AS MAX_HEIGHT
	FROM PLAYER
	GROUP BY TEAM_ID
	) d1 ON p.TEAM_ID = d1.TEAM_ID
WHERE p.TEAM_ID = d1.TEAM_ID AND p.HEIGHT = d1.MAX_HEIGHT
ORDER BY p.TEAM_ID;

/* (A, B) IN (C, D) -> A = C AND B = D */
SELECT * 
FROM PLAYER p 
WHERE (TEAM_ID, HEIGHT)
IN (SELECT TEAM_ID, MAX(HEIGHT) FROM PLAYER GROUP BY TEAM_ID)
ORDER BY TEAM_ID;

/*EMP 테이블에서 사원의 이름과 매니저 이름을 검색*/
SELECT d1.EMPLOYEE_ID, d1.DEPARTMENT_ID ,d1.FIRST_NAME || ' ' || d1.LAST_NAME AS EMPLOYEE_NAME, d2."MANAGER ID" , d2.MANAGER_NAME 
FROM EMPLOYEES d1 JOIN
	(
	SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS MANAGER_NAME, e.EMPLOYEE_ID AS "MANAGER ID", dp.DEPARTMENT_ID 
	FROM EMPLOYEES e JOIN DEPARTMENTS dp  
	ON e.DEPARTMENT_ID = dp.DEPARTMENT_ID AND e.EMPLOYEE_ID = dp.MANAGER_ID
	) d2 
ON d1.DEPARTMENT_ID = d2.DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/* ------- 실습 ------- */

/*[브론즈]*/
/*PLAYER 테이블에서 키가 NULL인 선수들은 키를 170으로 변경하여 평균 구하기(NULL 포함)*/
SELECT AVG(NVL(HEIGHT, 170)) AS AVG_PLAYER_HEIGHT
FROM PLAYER;

/*[실버]*/
/*PLAYER 테이블에서 팀 별 최대 몸무게*/
SELECT TEAM_ID, MAX(WEIGHT) AS MAX_WEIGHT
FROM PLAYER
GROUP BY TEAM_ID
ORDER BY TEAM_ID;

/*[골드]*/
/*AVG 함수를 쓰지 않고 PLAYER 테이블에서 선수들의 평균 키 구하기(NULL 포함)*/
SELECT SUM(NVL(HEIGHT, 0)) / COUNT(NVL(HEIGHT, 0))
FROM PLAYER;

SELECT SUM(HEIGHT) / COUNT(PLAYER_ID) AS AVG_PLAYER_HEIGHT
FROM PLAYER;

/*[플래티넘]*/
/*DEPT 테이블의 LOC별 평균 급여를 반올림한 값과 각 LOC별 SAL 총 합을 조회, 반올림 : ROUND()*/
SELECT d.LOC, ROUND(AVG(e.SAL), 2) AS AVG_LOC_SAL, SUM(e.SAL) AS SUM_LOC_SAL 
FROM DEPT d JOIN EMP e 
ON d.DEPTNO = e.DEPTNO
GROUP BY d.LOC;

/*[다이아]*/
/*PLAYER 테이블에서 팀별 최대 몸무게인 선수 검색*/
SELECT p.* 
FROM 
	(
	SELECT TEAM_ID, MAX(WEIGHT) AS MAX_WEIGHT
	FROM PLAYER
	GROUP BY TEAM_ID
	) d1 JOIN PLAYER p
ON d1.TEAM_ID = p.TEAM_ID AND d1.MAX_WEIGHT = p.WEIGHT 
ORDER BY p.TEAM_ID;

/*[마스터]*/
/*EMP 테이블에서 HIREDATE가 FORD의 입사년도와 같은 사원 전체 정보 조회*/
--SELECT e.* 
--FROM
--	(
--	SELECT HIREDATE AS H_DATE
--	FROM EMP 
--	WHERE ENAME = 'FORD'
--	) d1 JOIN EMP e
--ON TO_CHAR(d1.H_DATE, 'YYYY') = TO_CHAR(e.HIREDATE, 'YYYY');

SELECT * FROM EMP
WHERE TO_CHAR(HIREDATE, 'YYYY') = 
(SELECT TO_CHAR(HIREDATE, 'YYYY') FROM EMP WHERE ENAME = 'FORD');

/*SELECT EXTRACT(YEAR FROM HIREDATE)
	FROM EMP 
	WHERE ENAME = 'FORD';*/

/* ------------------------------------------------------------------ */

/* 외부 JOIN */
/* 내부 JOIN : 반드시 조건식에 맞는 데이터만 JOIN */
/* JOIN 할 때 선행 또는 후행 중 하나의 테이블 정보를 모두 확인하고 싶을 때 사용한다. */ 
/* 행이 더 많은 테이블의 정보를 가져올 수 있다. */
SELECT * 
FROM STADIUM s JOIN TEAM t 
ON s.HOMETEAM_ID = t.TEAM_ID;

SELECT * 
FROM TEAM t RIGHT OUTER JOIN STADIUM s 
ON s.HOMETEAM_ID = t.TEAM_ID;

/* DEPARTMENTS 테이블에서 매니저 이름 검색, 매니저가 없더라도 부서명 모두 검색 */
SELECT * FROM DEPARTMENTS d ;
SELECT * FROM EMPLOYEES e;

SELECT e.EMPLOYEE_ID, d.MANAGER_ID, e.FIRST_NAME || ' ' || e.LAST_NAME AS EMPLOYEE_NAME, d.DEPARTMENT_NAME 
FROM DEPARTMENTS d LEFT OUTER JOIN EMPLOYEES e 
ON d.MANAGER_ID = e.EMPLOYEE_ID;

SELECT * 
FROM 
	(
	SELECT e.EMPLOYEE_ID, e.FIRST_NAME || ' ' || e.LAST_NAME AS EMPLOYEE_NAME
	FROM DEPARTMENTS d JOIN EMPLOYEES e
	ON d.MANAGER_ID = e.EMPLOYEE_ID
	) d1 LEFT OUTER JOIN
	(
	SELECT JOB_ID, MANAGER_ID FROM EMPLOYEES
   GROUP BY JOB_ID, MANAGER_ID
	) d2
ON d1.EMPLOYEE_ID = d2.MANAGER_ID;

/* EMPLOYEES 테이블에서 사원의 매니저 이름, 사원의 이름 조회, 매니저가 없는 사원은 본인이 매니저임을 표시 */
SELECT e.EMPLOYEE_ID, e.FIRST_NAME || ' ' || e.LAST_NAME AS EMPLOYEE_NAME, 
NVL(d1.MANAGER_NAME, 'Chief Manager') AS MANAGER_NAME
FROM 
	(
	SELECT e2.FIRST_NAME || ' ' || e2.LAST_NAME AS MANAGER_NAME, e2.EMPLOYEE_ID AS MANAGER_ID 
	FROM EMPLOYEES e2
	) d1 RIGHT OUTER JOIN EMPLOYEES e 
ON e.MANAGER_ID = d1.MANAGER_ID
ORDER BY e.EMPLOYEE_ID;

SELECT e1.FIRST_NAME "사원 이름", NVL(e2.FIRST_NAME, e1.FIRST_NAME) "매니저 이름"
FROM EMPLOYEES e1 LEFT OUTER JOIN EMPLOYEES e2
ON e1.MANAGER_ID = e2.EMPLOYEE_ID
ORDER BY e1.EMPLOYEE_ID; 

/* EMPLOYEES 테이블에서 사원들의 FIRST_NAME 모두 조회, 사원들 중 매니저는 JOB_ID 조회 */
/* 내가 작성한 코드 : Adam 문제 있음 */
SELECT e.FIRST_NAME, e.JOB_ID, d1.JOB_ID AS "POSITION"
FROM 
	(
	SELECT e2.EMPLOYEE_ID AS EMPLOYEE_ID, JOB_ID, e2.FIRST_NAME 
	FROM EMPLOYEES e2 JOIN DEPARTMENTS d 
	ON e2.EMPLOYEE_ID = d.MANAGER_ID 
	) d1 FULL OUTER JOIN EMPLOYEES e
ON e.EMPLOYEE_ID = d1.EMPLOYEE_ID
ORDER BY e.DEPARTMENT_ID, "POSITION" DESC;

/* 강사님 코드 */
SELECT E1.JOB_ID 관리부서, E2.JOB_ID 소속부서, E2.FIRST_NAME 이름
FROM
(
   SELECT JOB_ID, MANAGER_ID FROM EMPLOYEES
   GROUP BY JOB_ID, MANAGER_ID
) E1 
FULL OUTER JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.EMPLOYEE_ID
ORDER BY 소속부서 DESC;

/* VIEW */
/*
 * CREATE VIEW [이름] AS [쿼리문]
 * 
 * 기존의 테이블을 그대로 놔둔 채 필요한 컬럼들 및 새로운 컬럼을 만든 가상 테이블
 * 실제 데이터가 저장되는 것은 아니지만 VIEW를 통해서 데이터를 관리할 수 있다.
 * 
 * - 독립성 : 다른 곳에서 접근하지 못하도록 하는 성질
 * - 편리성 : 길고 복잡한 쿼리문을 매번 작성할 필요가 없다.
 * - 보안성 : 기존의 쿼립문이 보이지 않는다.
 * 
 * */

/* PLAYER 테이블에 나이 컬럼 추가한 뷰 만들기 */
CREATE VIEW VIEW_PLAYER AS
SELECT p.*, FLOOR((SYSDATE - BIRTH_DATE) / 365) AS PLAYER_AGE FROM PLAYER p;

SELECT PLAYER_ID , PLAYER_NAME , PLAYER_AGE  
FROM VIEW_PLAYER vp
WHERE PLAYER_AGE < 40
ORDER BY PLAYER_AGE;

/* EMPLOYEES 테이블에서 사원 이름과 그 사원의 매니저 이름이 있는 VIEW 만들기 */
CREATE VIEW VIEW_EMPLOYEES_MANAGER AS
SELECT e1.FIRST_NAME || ' ' || e1.LAST_NAME AS EMPLOYEE_NAME, 
NVL(e2.FIRST_NAME, e1.FIRST_NAME) || ' ' || NVL(e2.LAST_NAME, e1.LAST_NAME) MANAGER_NAME
FROM EMPLOYEES e1 LEFT OUTER JOIN EMPLOYEES e2
ON e1.MANAGER_ID = e2.EMPLOYEE_ID
ORDER BY e1.EMPLOYEE_ID;

DROP VIEW VIEW_EMPLOYEES_MANAGER ;

SELECT * FROM VIEW_EMPLOYEES_MANAGER;

/* PLAYER 테이블에서 TEAM_NAME 컬럼을 추가한 VIEW 만들기 */
CREATE VIEW VIEW_PLAYER_TEAM_NAME AS
SELECT t.TEAM_NAME, p.*  
FROM TEAM t JOIN PLAYER p 
ON p.TEAM_ID = t.TEAM_ID
ORDER BY p.PLAYER_ID;

SELECT * 
FROM VIEW_PLAYER_TEAM_NAME;

DROP VIEW VIEW_PLAYER_TEAM_NAME ;

SELECT *
FROM TBL_USER
WHERE USER_IDENTIFICATION =
	(
		SELECT USER_RECOMMENDER_ID 
		FROM TBL_USER u
		WHERE u.USER_ID = 4
	);




