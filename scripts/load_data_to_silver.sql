SET SEARCH_PATH TO silver;


CREATE OR REPLACE PROCEDURE load_silver()
LANGUAGE plpgsql
AS
$$
BEGIN
    RAISE NOTICE 'Start the load silver proc';
--     Load the client details
    BEGIN
        TRUNCATE TABLE silver.clients;
        INSERT INTO silver.clients
            (
                client_id,
                client_name,
                client_type,
                state,
                created_at
            )

        SELECT
            client_id,
            client_name,
                CASE
                    WHEN trim(client_type) = 'Retail' OR trim(client_type) = 'retail' THEN 'Retail'
                    WHEN trim(client_type) = 'Institutional' OR trim(client_type) = 'INST' THEN 'Institutional'
                ELSE 'N/A'
                END AS New_client_type,
                CASE
                    WHEN state = '' THEN 'N/A'
                    ELSE state
                END AS New_state,
                created_at

        FROM (
            SELECT
                client_id,
                client_name,
                client_type,
                state,
                created_at,
                ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY created_at DESC) AS New_client_id
            FROM bronze.clients
        ) AS temp
        WHERE New_client_id = 1;
        EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Error running proc for client, %', SQLERRM;
    END;

--     Load the accounts details
    BEGIN
        TRUNCATE TABLE silver.accounts;
        INSERT INTO silver.accounts
            (
             account_id,
             client_id,
             account_type,
             broker_code,
             opened_at
            )

        SELECT
            account_id,
            client_id,
            CASE
                WHEN trim(account_type) = 'Margin' THEN 'Margin'
                WHEN trim(account_type) = 'Cash' THEN 'Cash'
                WHEN account_type = '' THEN 'Cash'
            ELSE 'N/A'
            END,
            broker_code,
            opened_at
        FROM bronze.accounts
        WHERE client_id IN (SELECT client_id FROM clients);
    EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error running proc for accounts, %', SQLERRM;
    END;

--     Load the Orders details
    BEGIN
        TRUNCATE TABLE silver.orders;
        INSERT INTO silver.orders

            (
                order_id,
                account_id,
                symbol,
                side,
                quantity,
                price,
                status,
                order_time
            )

        SELECT
            order_id,
            account_id,
            trim(symbol) AS Symbol,
            CASE
                WHEN trim(upper(side)) = 'SELL' THEN 'Sell'
                WHEN trim(upper(side)) = 'BUY' THEN 'Buy'
                WHEN side IS NULL  THEN 'Buy'
                WHEN side = ''  THEN 'Buy'
                ELSE 'Unknown'
            END AS Side,
            CASE
                WHEN quantity IS NULL THEN 0
                ELSE quantity
            END AS Quantity,
            price,
            CASE
                WHEN trim(status) = 'Submitted' THEN 'Submitted'
                WHEN trim(status) = 'Filled' THEN 'Filled'
                WHEN trim(status) = 'Cancelled' THEN 'Cancelled'
                WHEN status IS NULL  THEN 'Part-Fill'
                ELSE 'Unknown'
            END AS status,
            order_time
        FROM
            (
                SELECT order_id,
                        account_id,
                        symbol,
                        side,
                        quantity,
                        price,
                        status,
                        order_time,
                        row_number() OVER (PARTITION BY order_id ORDER BY order_time DESC ) as filter
                 FROM bronze.orders
             ) AS temp
        WHERE filter  = 1;
    EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error running proc for orders, %', SQLERRM;
    END;

--     Load the trades details
     BEGIN
        TRUNCATE TABLE silver.trades;
        INSERT INTO  silver.trades
            (
             trade_id,
             order_id,
             trade_value,
             trade_date
            )

        SELECT
            trade_id,
            order_id,
            trade_value,
            to_date(trade_date, 'YYYY-MM-DD') AS Trade_date
        FROM bronze.trades
        WHERE trade_date ~ '^\d{4}-(0[1-9]|1[0-2])-\d{2}$';
    EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error running proc for trades, %', SQLERRM;
    END;

--     Load the executions details
    BEGIN
        TRUNCATE TABLE silver.executions;
        INSERT INTO  silver.executions
            (
             execution_id,
             order_id,
             exec_price,
             exec_qty,
             exec_time)

        SELECT
            execution_id,
            order_id,
            CASE
                WHEN exec_price IS NULL THEN 0
                ELSE exec_price
            END AS exec_price,
            exec_qty,
            exec_time
        FROM bronze.executions;
    EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error running proc for executions, %', SQLERRM;
    END;

--     Load the Price details
    BEGIN
    TRUNCATE TABLE silver.price;
        INSERT INTO silver.price
            (
                symbol,
                price_date,
                open,
                close,
                low,
                high,
                volume
            )

        SELECT
            CASE
                WHEN symbol IS NULL THEN 'Unknow'
                WHEN symbol = '' THEN 'Unknow'
                ELSE symbol
            END AS Symbol,
            price_date,
            CASE
                WHEN open IS NULL  THEN 0
                ELSE open
            END AS open,
            close,
            low,
            high,
            volume

        FROM bronze.price;
    EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error running proc for price, %', SQLERRM;
    END;

    RAISE NOTICE 'End of the  successful load!';

END;
$$;


CALL load_silver();
