# README

* Ruby version 2.4.1

* Rails version 5.2.3

## Setup

* Run bundle

* Run rake db:{drop,create,migrate}

* Run rake import to load CSV data

* Run rails s

* Run rspec

* Run spec harness

## Endpoints

We have six record types: Merchants, Items, Invoices, Invoice Items, Transactions, and Customers.

Below are examples of several endpoints, see routes.rb for complete list.

### Record Endpoints

* Index: GET "/api/v1/merchants"

* Show: GET "GET /api/v1/merchants/id"

* Single record finder: GET "/api/v1/merchants/find?parameters"

* Multi record finder: GET "/api/v1/merchants/find_all?parameters"

* Random record: GET "api/v1/merchants/random"

### Relationship endpoints

* Merchant Items: GET "/api/v1/merchants/:id/items"

* Merchant Invoices: GET "/api/v1/merchants/:id/invoices"

### Business Intelligence

* Customers with pending Invoices: GET "/api/v1/merchants/:id/customers_with_pending_invoices"
