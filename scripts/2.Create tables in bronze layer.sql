SET SEARCH_PATH TO bronze;

/*
 1️**Bronze Layer (Raw Layer)**
   - This is the *landing zone* for raw data.
   - Data from the source files (CSV, APIs, etc.) is loaded here *as-is*, without any transformation.
   - Each source file maps directly to a table (one table per file).
   - Column names and structures match the original source exactly.
   - Purpose: To preserve the original data for traceability and audit
 */


-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- Customer's trading a/c table
    -- The accounts table contains brokerage account details for each client.
    -- A single client can have multiple accounts (e.g., individual, joint, or corporate).
    -- Each account is linked to a client and used to place and manage orders.

DROP TABLE IF EXISTS bronze.clients;
CREATE TABLE bronze.clients (
    client_id int,
    client_name varchar(100),
    client_type varchar(50),
    state varchar(10),
    created_at date
);
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


-- client list
    -- The clients table stores master information about all brokerage clients.
    -- It includes both retail and institutional investors with basic identifying details.
    -- Acts as the parent entity for all client-related data (accounts, orders, and trades).

DROP TABLE IF EXISTS bronze.accounts;
CREATE TABLE bronze.accounts(
    account_id int,
    client_id int,
    account_type varchar(50),
    broker_code varchar(15),
    opened_at date
);
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


-- Execution list
    -- The executions table records partial or full_fills of client orders.
    -- Each record represents an execution event with details such as quantity, price, and time.
    -- Multiple executions can belong to a single order (1-to-many relationship).

DROP TABLE IF EXISTS bronze.executions;
CREATE TABLE bronze.executions(
    execution_id int,
    order_id int,
    exec_price float4,
    exec_qty int,
    exec_time timestamp
);
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- Order list
    -- The orders table stores all client order instructions (buy/sell requests).
    -- Each order is linked to an account and may have multiple execution records.
    -- Represents the intent to trade before actual execution occurs.

DROP TABLE IF EXISTS bronze.orders;
CREATE TABLE bronze.orders(
    order_id int,
    account_id int,
    symbol varchar(15),
    side varchar(10),
    quantity int,
    price float4,
    status varchar(10),
    order_time timestamp
);
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- Trade list
    -- The trades table contains finalized trades aggregated from executions.
    -- Each trade represents the completed transaction resulting from one or more executions.
    -- Used for settlement, reporting, and business analytics.

DROP TABLE IF EXISTS bronze.trades;
CREATE TABLE bronze.trades(
    trade_id int,
    order_id int,
    trade_value float4,
    trade_date date
);
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- Price table
    -- The price_feed table stores daily market price data for listed securities.
    -- It includes open, high, low, close prices, and trading volume (OHLCV).
    -- This data is used for market analysis, trade valuation, and performance reporting.

DROP TABLE IF EXISTS bronze.price;
CREATE TABLE bronze.price(
    symbol varchar(15),
    price_date date,
    open float4,
    close float4,
    low float4,
    high float4,
    volume float4
)
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
