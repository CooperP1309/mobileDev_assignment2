Mobile Application Development - Assignment 2

By Cooper Peek; Stu ID: 22093312

 ---- Architecture ----
 
 - Database access:
 
    Database access is the same for both dish and order databases. But we will refer to
    just the dish DB to explain.
    
    Extremely low level/basic database access will be done through class DishDbManager.
    Such functions are limited to essential CRUD implementation.
    
    The DishDAO class will use the DBManager functions at a higher level, e.g. for deleting
    many orders in one go, checking if an ID already exists and so on...
    
    
