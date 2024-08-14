use hrmanagement;
-- lab 9
-- 1. Check constraint to value of gender in “Nam” or “Nu”. 
alter table employees
add constraint check_gender
check (gender in ('Nam', 'Nu'));
-- 2. Check constraint to value of salary > 0. 
alter table employees
add constraint check_salary
check (salary > 0);
-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con 
-- gai”, “Me ruot”, “Cha ruot”. 
alter table relative
add constraint check_relationship
check(relationship in ('Vo chong', 'Con trai', 'Con gai', 'Me ruot', 'Cha ruot'));
-- III>
-- 1.Look for employees with salaries above 25,000 in room 4 or employees with salaries above 
-- 30,000 in room 5. 
with A as (select * from employees
where salary > 25000 and departmentID = 4),
B as (
select * from employees
where salary > 30000 and departmentID = 5)
select * from A
union all
select * from B;
-- 2. Provide full names of employees in HCM city. 
select concat(lastName, ' ',middleName,' ',firstName) as fullname
from employees
where address like '%TPHCM%';
-- 3. Indicate the date of birth of Dinh Ba Tien staff. 
select dateOfBirth from employees
where lastName = 'Dinh' and middleName = 'Ba' and firstName = 'Tien';
-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this 
-- employee is directly managed by "Nguyen Thanh Tung". 
select e.lastName,e.middleName,e.firstName from 
employees e join projects p on e.departmentID = p.departmentID
join employees e2 on e.managerID = e2.employeeID
where p.departmentID = 5 and p.projectName = 'San pham X' 
						and e2.lastName='Nguyen' and e2.middleName = 'Thanh' and e2.firstName='Tung';
-- 5. Find the names of department heads of each department. 
select e.lastName,e.middleName,e.firstName from department d join employees e
on d.managerID = e.managerID;
-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName, 
-- departmentID, date0fEmployment.
select p.projectID,p.projectName,p.projectAddress,d.departmentID,
		d.departmentName,d.managerID,d.dateOfEmployment 
from projects p join department d
on p.departmentID = d.departmentID;
-- 7. Find the names of female employees and their relatives.
select e.lastName,e.middleName,e.firstName,r.relativeName from employees e join relative r
on e.employeeID = r.employeeID
where e.gender = 'Nu';
 
-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead 
-- department (departmentID), the full name of the manager (lastName, middleName, 
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the 
-- Employees. 
select p.projectID,p.departmentID, concat(e.lastName, ' ', e.middleName, ' ',firstName)as fullname, 
address,dateOfBirth from projects p 
									join department d on p.departmentID = d.departmentID
                                    join employees e on d.managerID = e.employeeID
where p.projectAddress = 'HA NOI';
-- 9.For each employee, include the employee's full name and the employee's line manager. bỏ
select concat(e1.lastName,' ',e1.middleName,' ', e1.firstName) as emplloyee_name,
concat(e2.lastName,' ',e2.middleName,' ', e2.firstName) as manager_name
 from employees e1 join employees e2 on e1.managerID = e2.employeeID;
-- 10. For each employee, indicate the employee's full name and the full name of the head of the 
-- department in which the employee works. 
select concat(e1.lastName,' ',e1.middleName,' ', e1.firstName) as emplloyee_name , 
concat(e2.lastName,' ',e2.middleName,' ', e2.firstName) as manager_name
from employees e1 left join department d
left join employees e2 on d.managerID = e2.employeeID
on e1.departmentID = d.departmentID;

 -- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of 
-- the projects in which the employee participated, if any. 
select concat(e.lastName,' ',e.middleName,' ', e.firstName) as employee_fullname,p.projectName from employees e join department d 
on e.departmentID = d.departmentID 
join projects p on p.departmentID = d.departmentID;
-- 12.For each scheme, list the scheme name (projectName) and the total number of hours 
-- worked per week of all employees attending that scheme.
select p.projectName, sum(a.workingHour) as total_hours 
from projects p join assignments a on p.projectID = a.projectID
group by p.projectID;
-- 12. For each department, list the name of the department (departmentName) and the average 
-- salary of the employees who work for that department. 
select d.departmentName, avg(salary) as AVG_SALARY 
from department d join employees e on d.departmentID = e.departmentID
group by d.departmentID;
-- 13. For departments with an average salary above 30,000, list the name of the department and 
-- the number of employees of that department. 
with A as (select d.departmentName, avg(salary) as AVG_SALARY , count(e.employeeID) as numOfEmployee
from department d join employees e on d.departmentID = e.departmentID
group by d.departmentID)
select departmentName,numOfEmployee from A where AVG_SALARY > 30000;
-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh' 
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
(select p.projectID from projects p join department d
on p.departmentID = d.departmentID 
join employees e1 on e1.departmentID = d.departmentID
where e1.lastName = 'Dinh')
union
(select p.projectID from projects p join department d 
on d.departmentID =p.departmentID
join employees e on d.managerID = e.employeeID
where e.lastName = 'Dinh'
);
-- 16.List of employees (lastName, middleName, firstName) with more than 2 relatives. 
 select e.lastName,e.middleName,e.firstName from employees e join relative r 
 on e.employeeID = r.employeeID
 group by r.employeeID
 having count(r.relativeName) > 2;
-- 17. List of employees (lastName, middleName, firstName) without any relatives. 
select lastName,middleName,firstName from employees
where employeeID not in (select e.employeeID from employees e join relative r 
 on e.employeeID = r.employeeID
 group by r.employeeID
 having count(r.relativeName) > 0);
-- 18. List of department heads (lastName, middleName, firstName) with at least one relative. 
 select e.lastName,e.middleName,e.firstName from employees e join relative r 
 on e.employeeID = r.employeeID
 group by r.employeeID
 having count(r.relativeName) >= 1;
-- 19. Find the surname (lastName) of unmarried department heads. 
select lastName from employees e
where employeeID not in (select distinct employeeID from relative r 
where relationship in ('Vo chong', 'Con trai', 'Con gai'));
-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary 
-- is above the average salary of the "Research" department. 
with A as (select avg(salary) from employees e join department d
on e.departmentID = d.departmentID
where d.departmentName = 'Nghien cuu')
select concat(e.lastName,' ',e.middleName,' ', e.firstName) as employee_fullname from employees e
where salary > (select * from A);
-- 21 Indicate the name of the department and the full name of the head of the department with 
-- the largest number of employees. 
with A as (select count(e1.employeeID) as numOfEmploy, d.departmentID,d.departmentName, d.managerID from department d join employees e1
on d.departmentID = e1.departmentID
group by d.departmentID
order by numOfEmploy desc
limit 1)
select A.departmentName,concat(e.lastName,' ',e.middleName,' ', e.firstName) as manager_fullnam from A join employees e
on A.managerID = e.employeeID;
-- 22 Find the full names (lastName, middleName, firstName) and addresses (Address) of 
-- employees who work on a project in 'HCMC' but the department they belong to is not 
-- located in 'HCMC'. 
select e.lastName,e.middleName,e.firstName,e.address from employees e join assignments a
on e.employeeID = a.employeeID
join projects p on p.projectID = a.projectID
join department d on d.departmentID= e.departmentID
join departmentaddress da on da.departmentID = d.departmentID
where p.projectAddress = 'TP HCM' and da.address != 'TP HCM';
-- 23 . Find the names and addresses of employees who work on a scheme in a city but the 
-- department to which they belong is not located in that city.
select distinct e.lastName,e.middleName,e.firstName,e.address from employees e join assignments a
on e.employeeID = a.employeeID
join projects p on p.projectID = a.projectID
join department d on d.departmentID= e.departmentID
join departmentaddress da on da.departmentID = d.departmentID
where p.projectAddress != da.address;
-- 24 . Create procedure List employee information by department with input data 
-- departmentName. 
delimiter $$
create procedure listEmployDepartment(IN nameInput varchar(50))
begin
select * from employees e join department d
on e.departmentID = d.departmentID
where d.departmentName = nameInput;
end$$
delimiter ;
call listEmployDepartment('Nghien cuu');
-- 25 . Create a procedure to Search for projects that an employee participates in based on the 
-- employee's last name (lastName).
delimiter $$
create procedure searchProject(IN nameInput varchar(50))
begin
select p.projectID,p.projectName from employees e join department d
on e.departmentID = d.departmentID
join projects p on p.departmentID
where e.lastName = nameInput;
end$$
delimiter ;
call searchProject('Dinh');
-- 26 Create a function to calculate the average salary of a department with input data 
-- departmentID. 
delimiter $$
create function cal_avg_salary(department_id int)
returns int
deterministic
begin
declare result int;
select avg(salary) into result from employees e join department d
on e.departmentID = d.departmentID
where d.departmentID = department_id
group by d.departmentID;
return result;
end$$
delimiter ;
select cal_avg_salary('4') as avg_result;
-- 27. Create a function to Check if an employee is involved in a particular project input data is 
-- employeeID, projectID.
delimiter $$
create function check_employ(employID int, projectID int)
returns varchar(10)
deterministic
begin
    declare checkR varchar(10);
    with A as (
        select count(employeeID) as countR
        from employees e 
        join department d on e.departmentID = d.departmentID
        join projects p on p.departmentID = d.departmentID
        where employeeID = employID and p.projectID = projectID
        group by p.projectID
    )
    select
        case
            when countR = 0 then 'false'
            else 'true'
        end
    into checkR
    from A;

    RETURN checkR;
end$$
delimiter ;
select check_employ(123, 2) as checkResult;