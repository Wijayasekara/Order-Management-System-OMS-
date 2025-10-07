-- Procedure: load_bronze_data
-- Description: Loads raw CSV files into bronze layer tables from the local file system.
-- Each table is truncated before loading. Handles errors per table and logs execution time.


SET SEARCH_PATH TO bronze;

CREATE OR REPLACE PROCEDURE bronze.load_bronze_data()
LANGUAGE plpgsql
AS
    $$
    DECLARE
        Start_time timestamp;
        end_time timestamp;
        Exe_time interval;
    BEGIN

        Start_time = now();

        BEGIN
            TRUNCATE TABLE bronze.accounts;
            COPY bronze.accounts
            FROM '/private/tmp/Row_Data/accounts.csv'
            DELIMITER ','
            CSV HEADER
            NULL 'NULL';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading accounts: %', SQLERRM;
        END;

         BEGIN
            TRUNCATE TABLE bronze.clients;
            COPY bronze.clients
            FROM '/private/tmp/Row_Data/clients.csv'
            DELIMITER ','
            CSV HEADER
            NULL 'NULL';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading clients: %', SQLERRM;
        END;

         BEGIN
            TRUNCATE TABLE bronze.executions;
            COPY bronze.executions
            FROM '/private/tmp/Row_Data/executions.csv'
            DELIMITER ','
            CSV HEADER
            NULL 'NULL';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading executions: %', SQLERRM;
        END;

         BEGIN
            TRUNCATE TABLE bronze.trades;
            COPY bronze.trades
            FROM '/private/tmp/Row_Data/trades.csv'
            DELIMITER ','
            CSV HEADER
            NULL 'NULL';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading trades: %', SQLERRM;
        END;

         BEGIN
            TRUNCATE TABLE bronze.orders;
            COPY bronze.orders
            FROM '/private/tmp/Row_Data/orders.csv'
            DELIMITER ','
            CSV HEADER
            NULL '';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading orders: %', SQLERRM;
        END;

         BEGIN
            TRUNCATE TABLE bronze.price;
            COPY bronze.price
            FROM '/private/tmp/Row_Data/price_feed.csv'
            DELIMITER ','
            CSV HEADER
            NULL 'NULL';

            EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Error loading price: %', SQLERRM;
        END;

        end_time = now();
        Exe_time = end_time - Start_time;
        RAISE NOTICE 'Time taken by the Proc is %', Exe_time;
    END;
    $$;


CALL load_bronze_data()


