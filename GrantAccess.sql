---SQL Learning how to grant access and privilege to users or specific roles on tables/database

---Dropping auto user insert triggers
Drop Trigger AutoInsert_User_Branch;
Drop Trigger AutoInsert_User_Customers;
Drop Trigger AutoInsert_User_FinancialProducts;
Drop Trigger AutoInsert_User_Transactions;
Drop Trigger AutoInsert_User_BranchManagers;

---Creating auto user insert triggers
CREATE or REPLACE Trigger AutoInsert_User_Branch
BEFORE INSERT OR UPDATE ON Branch
FOR EACH ROW
BEGIN
:new.CTL_SEC_USER:= user;
END;
/
CREATE or REPLACE Trigger AutoInsert_User_Customers
BEFORE INSERT OR UPDATE ON Customers
FOR EACH ROW
BEGIN
:new.CTL_SEC_USER:= user;
END;
/
CREATE or REPLACE Trigger AutoInsert_User_BranchManagers
BEFORE INSERT OR UPDATE ON Branch_Managers
FOR EACH ROW
BEGIN
:new.CTL_SEC_USER:= user;
END;
/
CREATE or REPLACE Trigger AutoInsert_User_FinancialProducts
BEFORE INSERT OR UPDATE ON Financial_Products
FOR EACH ROW
BEGIN
:new.CTL_SEC_USER:= user;
END;
/
CREATE or REPLACE Trigger AutoInsert_User_Transactions
BEFORE INSERT OR UPDATE ON Transactions
FOR EACH ROW
BEGIN
:new.CTL_SEC_USER:= user;
END;
/
show error;

---Creating Security Function for each table

Create or Replace Function Security_Function_TCP (P_schema_name IN varchar2, P_object_name IN varchar2) 
Return Varchar2 IS V_where Varchar2(300);
Begin 
IF User = 'DBA643' Then
V_where:= '';
Else 
V_where:= 'CTL_SEC_USER = USER';
END IF;
Return V_where;
END;
/

--- Drop and create security function policy on Tables
EXEC DBMS_RLS.DROP_POLICY ('DBA643','Branch','Row_Owner_Sec');
EXEC DBMS_RLS.DROP_POLICY ('DBA643','Customers','Row_Owner_Sec');
EXEC DBMS_RLS.DROP_POLICY ('DBA643','Financial_Products','Row_Owner_Sec');
EXEC DBMS_RLS.DROP_POLICY ('DBA643','Transactions','Row_Owner_Sec');
EXEC DBMS_RLS.DROP_POLICY ('DBA643','Branch_Managers','Row_Owner_Sec');

EXEC DBMS_RLS.ADD_POLICY ('DBA643','Branch','Row_Owner_Sec','DBA643','Security_Function_TCP','SELECT, UPDATE, DELETE, INSERT',TRUE);
EXEC DBMS_RLS.ADD_POLICY ('DBA643','Customers','Row_Owner_Sec','DBA643','Security_Function_TCP','SELECT, UPDATE, DELETE, INSERT',TRUE);
EXEC DBMS_RLS.ADD_POLICY ('DBA643','Financial_Products','Row_Owner_Sec','DBA643','Security_Function_TCP','SELECT, UPDATE, DELETE, INSERT',TRUE);
EXEC DBMS_RLS.ADD_POLICY ('DBA643','Transactions','Row_Owner_Sec','DBA643','Security_Function_TCP','SELECT, UPDATE, DELETE, INSERT',TRUE);
EXEC DBMS_RLS.ADD_POLICY ('DBA643','Branch_Managers','Row_Owner_Sec','DBA643','Security_Function_TCP','SELECT, UPDATE, DELETE, INSERT',TRUE);

---Creating users BAdmin, CAdmin, PAdmin, KAdmin

Drop Tablespace IA643_TBS
Including Contents AND Datafiles;

Create Tablespace IA643_TBS
Datafile 'IA643_dat' Size 500K
AUTOEXTEND ON NEXT 300k MAXSIZE 50M;

Drop User BAdmin;
Drop User CAdmin;
Drop User PAdmin;
Drop User KAdmin;

Create User BAdmin Identified by BAdmin
Default Tablespace IA643_TBS
Temporary Tablespace TEMP
Account Unlock;
Grant Connect, Resource to BAdmin;

Create User CAdmin Identified by CAdmin
Default Tablespace IA643_TBS
Temporary Tablespace TEMP
Account Unlock;
Grant Connect, Resource to CAdmin;

Create User PAdmin Identified by PAdmin
Default Tablespace IA643_TBS
Temporary Tablespace TEMP
Account Unlock;
Grant Connect, Resource to PAdmin;

Create User KAdmin Identified by KAdmin
Default Tablespace IA643_TBS
Temporary Tablespace TEMP
Account Unlock;
Grant Connect, Resource to KAdmin;

---Creating public synonym
DROP PUBLIC SYNONYM Branch;
DROP PUBLIC SYNONYM Customers;
DROP PUBLIC SYNONYM FinancialProducts;
DROP PUBLIC SYNONYM Transactions;

CREATE PUBLIC SYNONYM Branch for dba643.Branch;
CREATE PUBLIC SYNONYM Customers for dba643.Customers;
CREATE PUBLIC SYNONYM FinancialProducts for dba643.Financial_Products;
CREATE PUBLIC SYNONYM Transactions for dba643.Transactions;

---Creating Role and granting role to users
Drop Role Mgr_R;
CREATE ROLE Mgr_R;
Grant Select, Update, Delete, Insert on Branch to Mgr_R;
Grant Select, Update, Delete, Insert on Customers to Mgr_R;
Grant Select, Update, Delete, Insert on FinancialProducts to Mgr_R;
Grant Select, Update, Delete, Insert on Transactions to Mgr_R;
Grant Mgr_R to BAdmin, CAdmin, PAdmin, KAdmin;



