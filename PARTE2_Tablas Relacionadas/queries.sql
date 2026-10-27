-- EduTrack Parte2 — Multi-tabla queries 

-- Q1 Listar todas las inscripciones mostrando el nombre 
-- completo del estudiante, el título del curso y su porcentaje de completado

SELECT s.name, c.title, e.completion_percentage
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses c  ON c.id = e.course_id
ORDER BY s.name;

-- Q2 Mostrar el nombre y email de los estudiantes que han 
-- aprobado al menos un curso, junto con el título del curso que aprobaron

SELECT s.name, s.email, c.title
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses c  ON c.id = e.course_id
WHERE e.passed = TRUE;


-- Q3 Calcular el porcentaje de completado medio 
-- por instructor, ordenado de mayor a menor

SELECT c.instructor_name, ROUND(AVG(e.completion_percentage), 1) AS avg_completion
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.instructor_name
ORDER BY avg_completion DESC;


-- Q4 Encontrar todos los estudiantes que no tienen ninguna 
-- inscripción – se registraron en la plataforma pero nunca se apuntaron a un curso

SELECT s.name, s.email
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.id
WHERE e.id IS NULL;

-- Q5 Encontrar todos los cursos que no tienen ninguna 
-- inscripción - existen en el catálogo pero nadie se ha apuntado

SELECT c.title, c.instructor_name
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
WHERE e.id IS NULL;

-- Q6 Contar cuántos cursos tiene inscrito cada estudiante; 
-- mostrar solo los estudiantes inscritos en más de un curso

SELECT s.name, COUNT(e.course_id) AS course_count
FROM enrollments e
JOIN students s ON s.id = e.student_id
GROUP BY s.name
HAVING COUNT(e.course_id) > 1
ORDER BY course_count DESC;

-- Q7 Calcular los ingresos totales por categoría usando el precio 
-- del curso de la tabla courses (monthly_fee ), no el pago histórico de enrollments

SELECT c.category, ROUND(SUM(c.monthly_fee), 2) AS total_revenue
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- Q8 — Mostrar cada instructor junto con 
-- el número de estudiantes inscritos actualmente en sus cursos

SELECT c.instructor_name, COUNT(e.id) AS student_count
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.instructor_name
ORDER BY student_count DESC;


-- Q9 Comprobar si hay inscripciones cuyo student_id 
-- no corresponde a ningún estudiante existente (registros huérfanos)

SELECT e.id, e.student_id
FROM enrollments e
LEFT JOIN students s ON s.id = e.student_id
WHERE s.id IS NULL;


-- Q10 Comprobar si hay inscripciones cuyo 
-- course_id no corresponde a ningún curso existente (registros huérfanos)

SELECT e.id, e.course_id
FROM enrollments e
LEFT JOIN courses c ON c.id = e.course_id
WHERE c.id IS NULL;