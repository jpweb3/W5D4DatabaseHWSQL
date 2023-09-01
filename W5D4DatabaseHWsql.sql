

CREATE OR REPLACE PROCEDURE platinum_member()
LANGUAGE plpgsql
AS $$
BEGIN
	ALTER TABLE customer
	ADD COLUMN IF NOT EXISTS platinum_member BOOLEAN;
		UPDATE customer
		SET platinum_member = '1'
		WHERE customer_id  IN (
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING SUM(amount)> 200);
			
	UPDATE customer
	SET platinum_member = '0'
		WHERE customer_id  IN (
			SELECT customer_id
			FROM payment
			GROUP BY customer_id
			HAVING SUM(amount)< 200);
COMMIT;
END;
$$

CALL platinum_member()

SELECT *
FROM customer