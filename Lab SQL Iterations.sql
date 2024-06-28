-- Write queries to answer the following questions:

-- Write a query to find what is the total business done by each store.


SELECT s.store_id, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;



-- Convert the previous query into a stored procedure.

DELIMITER //

CREATE PROCEDURE TotalBusinessByStore()
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    GROUP BY s.store_id;
END //

DELIMITER ;

-- Convert the previous query into a stored procedure that takes the input for store_id
-- and displays the total sales for that store.

DELIMITER //

CREATE PROCEDURE TotalSalesByStore(IN storeId INT)
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = storeId
    GROUP BY s.store_id;
END //

DELIMITER ;

CALL TotalSalesByStore(1);


-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result
-- (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //

CREATE PROCEDURE TotalSalesByStoreWithVariable(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;

    SELECT SUM(p.amount) INTO total_sales_value
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = storeId;

    SELECT total_sales_value AS total_sales;
END //

DELIMITER ;

CALL TotalSalesByStoreWithVariable(2);

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag
-- otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER //

CREATE PROCEDURE TotalSalesByStoreWithFlag(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10);

    SELECT SUM(p.amount) INTO total_sales_value
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = storeId;

    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;

    SELECT total_sales_value AS total_sales, flag AS sales_flag;
END //

DELIMITER ;

CALL TotalSalesByStoreWithFlag(2);
