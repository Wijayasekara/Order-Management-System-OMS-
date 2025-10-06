# Order-Management-System-OMS-
OMS — Order Management System Data Engineering Practice Project

# 🟦 OMS — Order Management System Data Engineering Practice Project

## 📘 Overview

This project simulates a U.S. brokerage **Order Management System (OMS)** — a core platform used by brokers and financial institutions to handle client accounts, trades, and market data.

The goal of this repo is to let **data analysts and engineers** practice advanced **PostgreSQL** and **data modeling** techniques using a realistic, messy dataset that mirrors production scenarios.

---

## 🧩 What Is an OMS?

An **Order Management System (OMS)** is the heart of a trading platform.  
It handles the full lifecycle of a financial order — from a client placing an order, to its execution, trade settlement, and reporting.

### Typical OMS responsibilities:

- Manage client & account information  
- Track orders, executions, and trades  
- Record cash movements and balances  
- Integrate market price feeds  
- Support compliance, audit, and risk management  

---

## 🧱 Dataset Overview

The dataset used here is **synthetic but realistic**, generated using **Python** (`pandas`, `faker`, `numpy`).

It contains **6 interrelated tables** that represent the core OMS workflow:

| Table | Description |
|--------|--------------|
| `clients` | Client master data (retail & institutional investors) |
| `accounts` | Brokerage accounts belonging to clients |
| `orders` | Orders placed by clients (buy/sell of securities) |
| `executions` | Individual fills (partial or full executions of orders) |
| `trades` | Completed trades aggregated from executions |
| `price_feed` | Market price data (daily OHLCV for listed securities) |

---

> 💡 This project provides a hands-on environment to explore **data pipelines, SQL analytics, data quality checks**, and **financial data modeling**.


