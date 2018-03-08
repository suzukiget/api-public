---
title: COBINHOOD Exchange - API Reference

language_tabs:
- http

toc_footers:
- <a href='https://cobinhood.com'>COBINHOOD</a>
- <a href='https://github.com/cobinhood/api-public/issues'>Report Issues</a>
---

<aside class="notice">
** NOTE: COBINHOOD IS CURRENTLY UNDER HEAVY DEVELOPMENT, APIs ARE SUBJECT TO CHANGE WITHOUT PRIOR NOTICE **
</aside>

# Overview
COBINHOOD RESTful API URL: `https://api.cobinhood.com`

COBINHOOD WebSocket API URL: `wss://feed.cobinhood.com/ws` [Will deprecate in June, 2018]
COBINHOOD WebSocket V2 API URL: `wss://ws.cobinhood.com/v2/ws`

## HTTP Request Headers
`nonce` for 'POST' 'UPDATE' 'DELETE'. Accept nonce in millisecond unix time format. ex: `1518166662197`
`authorization`  for APIs that require authentication, value should be the API key token you obtain from the API key page in COBINHOOD exchange.

## Timestamps
All timestamps exchanged between client and server are based on server Unix UTC timestamp. Please refer to System Module for retrieving server timestamp.

## Floating Point Values
All floating point values in responses are encoded in `string` type to avoid loss of precision.

## Authentication
COBINHOOD uses token for APIs that require authentication. Token header field name is `authorization`. The JWT can be generated and revoked on COBINHOOD exchange API console page.

## Successful API Response

```json
{
    "success": true,
    "result": {
        "<object name>": {
            ...
        }
    }
}
```

All responses from API contain a JSON object field named `result`:

A successful response should have HTTP status codes ranging from 100 to 399, and a boolean `success` field with value `true`. Clients should find the response as a JSON object within the `result` object, containing the name of the requested object as the key:

## Unsuccessful Response

```json
{
    "success": false,
    "error": {
        "error_code": "error_code_string"
    }
}
```

An unsuccessful response would result in HTTP status codes ranging from 400 to 599, and a boolean `success` field with value `false`. If `success` is `false`, an `error` object member containing information that describes the error can be found in the root object:

## Rate-limiting
All API requests are rate-limited.

## Pagination

> Request URL:

```
https://api.cobinhood.com/v1/trading/trades?limit=30&page=7
```

# System

## Get System Time

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "time": 1505204498376
    }
}
```

`/v1/system/time [GET]`

    Get the reference system time as Unix timestamp

+ **Response**
    + `time`: Server Unix timestamp in milliseconds
        + int

## Get System Information

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "info": {
            "phase": "production",
            "revision": "480bbd"
        }
    }
}
```
`/v1/system/info [GET]`

    Get system information

+ **Response**
    + `phase`: System Phase
        + enum[`production`]
    + `revision`: Revision number of the system deployment
        + string

# Market

## Get All Currencies

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "currencies": [
            {
                "currency": "BTC",
                "name": "Bitcoin",
                "min_unit": "0.00000001",
                "deposit_fee": "0",
                "withdrawal_fee": "22.6",
                "type": "native",
                "is_active": true,
                "funding_frozen": false
            },
            ...
        ]
    }
}
```

`/v1/market/currencies [GET]`

    Returns info for all currencies available for trade

+ **Response**
    + `currency`: Currency ID
        + (enum[`BTC`, `ETH`, ...])
    + `min_unit`: Minimum size unit, all order sizes must be an integer multiple of this number
        + string
    + `name`: The currency name
        + string
    + `deposit_fee`: The currency deposit fee
        + string
    + `withdrawal_fee`: The currency withdrawal fee
        + string
    + `type`: The type of the currency, could be `native`, `erc20` ...
        + string
    + `is_active`: Whether or not the currency is active
        + bool
    + `funding_frozen`: Whether the funding service for the currency is frozen or not
        + bool

## Get All Trading Pairs
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trading_pairs": [
            {
                "id": "BTC-USDT",
                "base_currency_id": "BTC",
                "quote_currency_id": "USDT",
                "base_min_size": "0.004",
                "base_max_size": "10000",
                "quote_increment": "0.1"
            },
            ...
        ]
    }
}
```

`/v1/market/trading_pairs [GET]`

    Get info for all trading pairs

+ **Response**
    + `id`: Trading pair ID
        + enum[`BTC-USDT`, `ETH-USDT`, ...] (Base-Quote)
    + `base_min_size`: Minimum amount of base
        + string
    + `base_max_size`: Maximum amount of base
        + string
    + `quote_increment`: Minimum quote currency increment
        + string

## Get Order Book
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "orderbook": {
            "sequence": 1938572,
            "bids": [
                [ price, count, size ],
                ...
            ],
            "asks": [
                [ price, count, size ],
                ...
            ]
        }
    }
}
```
`/v1/market/orderbooks/<trading_pair_id> [GET]`

    Get order book for the trading pair containing all asks/bids

+ **Path Parameters**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
        + required

+ **Query parameters**
    + `limit`: Limits number of entries of asks/bids list, beginning from the best price for both sides
        + int
        + optional
        + Defaults to 50 if not specified, if limit is `0`, it means to fetch the whole order book.

+ **Response**
    + `sequence`: A sequence number that is updated on each orderbook state change
        + int
    + `price`: Order price
        + string
    + `size`: The aggregated total amount in the price group
        + string
    + `count`: The number of orders within current price range
        + string
        + e.g. when `precision=2`,  4137.181 and 4137.1837 would both fall into price group 4137.18

## Get Order Book Precisions
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": []
}
```
`/v1/market/orderbook/precisions/<trading_pair_id> [GET]`

    Get order book available precisions for the trading pair

+ **Path Parameters**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
        + required


+ **Response**
    + `result`: available precisions in scientific notation format.

## Get Trading Statistics
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "BTC-USDT": {
            "id": "BTC-USDT",
            "last_price": "10005",
            "lowest_ask": "10005",
            "highest_bid": "15200.1",
            "base_volume": "0.36255776",
            "quote_volume": "4197.431917146",
            "is_frozen": false,
            "high_24hr": "16999.9",
            "low_24hr": "10000",
            "percent_changed_24hr": "-0.3417806461799593"
        }
    }
}
```

`/v1/market/stats [GET]`

## Get Ticker

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "ticker": {
            "trading_pair_id": "COB-BTC",
            "timestamp": 1504459805123,
            "24h_high": "23.456",
            "24h_low": "10.123",
            "24h_open": "15.764",
            "24h_volume": "7842.11542563",
            "last_trade_price":"244.82",
            "highest_bid":"244.75",
            "lowest_ask":"244.76"
        }
    }
}
```

`/v1/market/tickers/<trading_pair_id> [GET]`

    Returns ticker for specified trading pair.

+ **Path Parameters**
    + `trading_pair_id`
        + enum[`BTC-USDT`, ...]
        + optional
        + If not specified, return tickers for all pairs.

+ **Response**
    + `trading_pair_id`: Ticker trading pair id
        + string
    + `last_trade_price`: Latest trade price
        + string
    + `highest_bid`: Best bid price in current order book
        + string
    + `lowest_ask`: Best ask price in current order book
        + string
    + `24h_volume`: Trading volume of the last 24 hours
        + string
    + `24h_low`: Lowest trade price of the last 24 hours
        + string
    + `24h_high`: Highest trade price of the last 24 hours
        + string
    + `timestamp`: Ticker timestamp in milliseconds
        + int

## Get Recent Trades

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trades": [
            {
                "id": "09619448e48a3bd73d493a4194f9020b",
                "price": "10.00000000",
                "size": "0.01000000",
                "maker_side": "buy",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```

`/v1/market/trades/<trading_pair_id> [GET]`

    Returns most recent trades for the specified trading pair

+ **Path Parameters**
    + `trading_pair_id`
        + enum[`BTC-USDT`, ...]
        + required

+ **Query parameters**
    + `limit`: Limits number of trades beginning from the most recent
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `id`: Trade ID
        + string
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `maker_side`: Side of the taker
        + enum[`bid`, `ask`]
    + `timestamp`: Closed timestamp in milliseconds
        + int

# Chart

## Get Candles

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "candles": [
            {
                "timestamp": 1507366756,
                "open": "4378.6",
                "close": "4379.0",
                "high": "4379.0",
                "low": "4378.3",
                "volume": "23.91460172"
            },
            ...
        ]
    }
}
```

`/v1/chart/candles/<trading_pair_id>`

    Get charting candles

+ **Path Parameters**
    + `trading_pair_id`
        + enum[`BTC-USDT`, ...]
        + required

+ **Query parameter**
    + `start_time`: Unix timestamp in milliseconds
        + int
        + optional
        + Defaults to 0 if not specified
    + `end_time`: Unix timestamp in milliseconds
        + int
        + optional
        + Defaults to current server time if not specified
    + `timeframe`: Time span of data aggregation
        + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]
        + required
        + `timeframe` is limited to the range specified by the `start_time` and `end_time` fields, e.g. if range has a span of 3 hours, `timeframe` should only be one of `1m`, `5m`, `15m`, or `1h`

+ **Response**
    + `timestamp`: Time of candlestick, Unix time in milliseconds, rounded up to zero point of each timeframe intervals
        + int
    + `open`: The open price during the interval (the last trade price before the interval)
        + string
    + `close`: The close price during the interval
        + string
    + `high`: The highest price during the interval
        + string
    + `low`: The lowest  price during the interval
        + string
    + `volume`: The volume of trading during the interval
        + string

# Trading *[Auth]*

## Get Order
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "order": {
            "id": "37f550a202aa6a3fe120f420637c894c",
            "trading_pair": "BTC-USDT",
            "state": "open",
            "side": "bid",
            "type": "limit",
            "price": "5000.01",
            "size": "1.0100",
            "filled": "0.59",
            "timestamp": 1504459805123
        }
    }
}
```
`/v1/trading/orders/<order_id> [GET]`

    Get information for a single order

+ **Response**
    + `id`: Order ID
        + string
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USDT`, ...]
    + `state`: Order status
        + enum[`new`, `queued`, `open`, `partially_filled`, `filled`, `cancelled`]
    + `side`: Order side
        + enum[`bid`, `ask`]
    + `type`: Order type
        + enum[`market`, `limit`, `stop`, `stop_limit`, `trailing_stop`,`fill_or_kill`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `filled`: Amount filled in current order
        + string
    + `timestamp`: Order timestamp in milliseconds
        + int
    + `eq_price`: The equivalance price
        + string
    + `completed_at`: The order filled time
        + string

## Get Trades of An Order

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trades": [
            {
                "id": "09619448e48a3bd73d493a4194f9020b",
                "price": "10.00000000",
                "size": "0.01000000",
                "maker_side": "bid",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```

`/v1/trading/orders/<order_id>/trades [GET]`

    Get all trades originating from the specific order

+ **Path Parameters**
    + `order_id`: Order ID
        + string
        + required

+ **Response**
    + `id`: Trade ID
        + string
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `maker_side`: Side of the taker
        + enum[`bid`, `ask`]
    + `timestamp`: Closed timestamp in milliseconds
        + int

## Get All Orders

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "orders": [
            {
                "id": "37f550a202aa6a3fe120f420637c894c",
                "trading_pair": "BTC-USDT",
                "state": "open",
                "side": "bid",
                "type": "limit",
                "price": "5000.01",
                "size": "1.0100",
                "filled": "0.59",
                "timestamp": 1504459805123,
                "eq_price": "5000.01"
            },
            ...
        ]
    }
}
```

`/v1/trading/orders [GET]`

    List all current orders for user

+ **Query parameters**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
        + optional
        + Returns orders of all trading pairs if not specified
    + `limit`: Limits number of orders per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USDT`, ...]
    + `id`: Order ID
        + string
    + `state`: Order status
        + enum[`new`, `queued`, `open`, `partially_filled`]
    + `side`: Order side
        + enum[`bid`, `ask`]
    + `type`: Order type
        + enum[`market`, `limit`, `stop`, `stop_limit`, `trailing_stop`,`fill_or_kill`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `filled`: Amount filled in current order
        + string
    + `timestamp`: Order timestamp in milliseconds
        + int
    + `eq_price`: The equivalance price
        + string
    + `completed_at`: The order filled time
        + string

## Place Order
> Payload

```json
{
    "trading_pair_id": "BTC-USDT",
    "side": "bid",
    "type": "limit",
    "price": "5000.01000000",
    "size": "1.0100"
}
```

`/v1/trading/orders [POST]`

    Place orders to ask or bid

+ **Request**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
    + `side`: Order side
        + enum[`bid`, `ask`]
    + `type`: Order type
        + enum[`market`, `limit`, `stop`, `stop_limit`]
    + `price`: Quote price
        + string
        + optional
        + `market` type will ignore
    + `size`: Base amount
        + string

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "order": {
            "id": "37f550a202aa6a3fe120f420637c894c",
            "trading_pair": "BTC-USDT",
            "state": "open",
            "side": "bid",
            "type": "limit",
            "price": "5000.01",
            "size": "1.0100",
            "filled": "0.59",
            "timestamp": 1504459805123,
            "eq_price": "5000.01"
        }
    }
}
```
+ **Response**
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USDT`, ...]
    + `id`: Order ID
        + string
    + `state`: Order status
        + enum[`open`]
    + `side`: Order side
        + enum[`bid`, `ask`]
    + `type`: Order type
        + enum[`market`, `limit`, `stop`, `stop_limit`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `filled`: Amount filled in current order
        + string
    + `timestamp`: Order timestamp in milliseconds
        + int
    + `eq_price`: The equivalance price
        + string
    + `completed_at`: The order filled time
        + string


## Modify Order
> [Success] Response 200 (application/json)

```json
{
    "success": true
}
```

`/v1/trading/orders/<order_id> [PUT]`

    Modify a single order

+ **Path Parameter**
    + `order_id`: Order ID
        + string
        + required

+ **Query Parameters**
    + `price`:
        + string
        + required
    + `size`:
        + string
        + required

## Cancel Order
> [Success] Response 200 (application/json)

```json
{
    "success": true
}
```

`/v1/trading/orders/<order_id> [DELETE]`

    Cancel a single order

+ **Path parameter**
    + `order_id`: Order ID
        + string
        + required

## Get Order History
`/v1/trading/order_history [GET]`

    Returns order history for the current user

+ **Query Parameters**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
        + optional
    + `limit`: Limits number of orders per page
        + int
        + optional
        + Defaults to 50 if not specified

### Success

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "order_history": [
            {
                "id": "37f550a202aa6a3fe120f420637c894c",
                "trading_pair": "BTC-USDT",
                "state": "filled",
                "side": "bid",
                "type": "limit",
                "price": "5000.01",
                "size": "1.0100",
                "filled": "0.59",
                "timestamp": 1504459805123,
                "eq_price": "5000.01"
            }
            ...
        ]
    }
}
```

+ **Response**
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USDT`, ...]
    + `id`: Order ID
        + string
    + `status`: Order status
        + enum[`cancelled`, `filled`]
    + `side`: Order side
        + enum[`bid`, `ask`]
    + `type`: Order type
        + enum[`market`, `limit`, `stop`, `stop_limit`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `filled`: Amount filled in current order
        + string
    + `timestamp`: Order timestamp milliseconds
        + int
    + `eq_price`: The equivalance price
        + string
    + `completed_at`: The order filled time
        + string

## Get Trade
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trade": {
            "trading_pair_id": "BTC-USDT",
            "id": "09619448-e48a-3bd7-3d49-3a4194f9020b",
            "maker_side": "bid",
            "price": "10.00000000",
            "size": "0.01000000",
            "timestamp": 1504459805123
        }
    }
}
```

`/v1/trading/trades/<trade_id> [GET]`

    Get trade information. A user only can get their own trade.

+ **Path Parameters**
    + `trade_id`: Trading ID
        + Required
        + [UUID String](#uuid-string)

+ **Response**
    + `trading_pair_id`: Trading pair ID
        + string
    + `id`: Trade ID
        + [UUID String](#uuid-string)
    + `maker_side`: Side of the maker
        + enum[`ask`, `bid`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `timestamp`: Closed timestamp in milliseconds
        + int

## Get Trade History
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trades": [
            {
                "trading_pair_id": "BTC-USDT",
                "id": "09619448e48a3bd73d493a4194f9020b",
                "maker_side": "ask",
                "price": "10.00000000",
                "size": "0.01000000",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```

`/v1/trading/trades [GET]`

    Returns trade history for the current user

+ **Path Parameters**
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, ...]
        + required
    + `limit`: Limits number of trades per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `trading_pair_id`: Trading pair ID
        + string
    + `id`: Trade ID
        + [UUID String](#uuid-string)
    + `maker_side`: Side of the maker
        + enum[`ask`, `bid`]
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `timestamp`: Closed timestamp in milliseconds
        + int

# Wallet *[Auth]*

    This module contains APIs for querying user account balances and history, generate deposit addresses, and deposit/withdraw funds.

## Get Wallet Balances
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "balances": [
            {
                "currency": "BTC",
                "type": "exchange",
                "total": "1",
                "on_order": "0.4",
                "locked": false,
                "usd_value": "10000.0",
                "btc_value": "1.0"
            },
            {
                "currency": "ETH",
                "type": "exchange",
                "total": "0.0855175219863032",
                "on_order": "0.04",
                "locked": false,
                "usd_value": "10000.0",
                "btc_value": "0.008"
            },
            {
                "currency": "COB",
                "type":" exchange",
                "total": "100",
                "on_order": "20",
                "locked": false,
                "usd_value": "1000.0",
                "btc_value": "0.1"
            },
            ...
        ]
    }
}
```

`/v1/wallet/balances [GET]`

    Get balances of the current user

+ **Response**
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `type`: Type of balance
        + enum[`exchange`]
    + `total`: Total amount of balance
        + string
    + `on_order`: On order amount of balance
        + string
    + `locked`: If the balance is locked
        + bool
    + `usd_value`: market value in USDT
        + string
    + `btc_value`: market value in BTC
        + string

## Get Ledger Entries
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "ledger": [
            {
                "action": "trade",
                "type": "exchange",
                "trade_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "+635.77",
                "balance": "2930.33",
                "timestamp": 1504685599302
            },
            {
                "action": "deposit",
                "type": "exchange",
                "deposit_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "+635.77",
                "balance": "2930.33",
                "timestamp": 1504685599302
            },
            {
                "action": "withdraw",
                "type": "exchange",
                "withdrawal_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "-121.01",
                "balance": "2194.87",
                "timestamp": 1504685599302
            },
            ...
        ]
    }
}
```

`/v1/wallet/ledger [GET]`

    Get balance history for the current user

+ **Query Parameter**
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + returns balance history for all currencies if not given
    + `limit`: Limits the number of balance changes per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `type`: Type of ledger
        + enum[`funding`, `margin`, `exchange`]
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `amount`: Amount of change
        + string
    + `balance`: Total balance after amount change
        + string
    + `timestamp`: Unix timestamp in milliseconds
        + int
    + `trade_id`: Trade ID
        + string
    + `deposit_id`: Deposit ID
        + string
    + `withdrawal_id`: Withdrawal ID
        + string
    + `action`: The ledger action
        + enum[`deposit`, `fixup`, `withdrawal_fee`, `deposit_fee`, `trade`, `withdraw`]
    + `fiat_deposit_id`: The fiat deposit ID
        + string
    + `fiat_withdrawal_id`: The fiat withdrawal ID
        + string

## Get Deposit Addresses


> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "deposit_addresses": [
            {
                "currency": "BTC",
                "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
                "created_at": 1504459805123,
                "type": "exchange"
            },
            ...
        ]
    }
}
```

`/v1/wallet/deposit_addresses [GET]`

    Get Wallet Deposit Addresses

+ **Query Parameters**
    + `currency`: Currency ID
        + enum[`BTC`, ...]
        + optional

+ **Response**
    + `currency`: Currency ID
        + enum[`BTC`, ...]
    + `address`: Newly generated deposit address
        + string
    + `created_at`: Address creation time in milliseconds
        + int
    + `type`: Ledger type
        +enum[`exchange`, `margin`, `funding`]

## Get Withdrawal Addresses

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "withdrawal_addresses": [
            {
                "id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "name": "Kihon's Bitcoin Wallet Address",
                "type": "exchange",
                "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
                "created_at": 1504459805123
            },
            ...
        ]
    }
}
```

`/v1/wallet/withdrawal_addresses [GET]`

    Get Wallet Withdrawal Addresses

+ **Query Parameters**
    + `currency`: Currency ID
        + enum[`BTC`, ...]
        + optional

+ **Response**
    + `id`: Wallet ID
        + string
    + `currency`: Currency ID
        + enum[`BTC`, ...]
    + `name`: A name to describe this withdrawal wallet address
        + string
    + `type`: Ledger type
        + enum[`exchange`, `funding`, `margin`]
    + `address`: User withdrawal address
        + string
    + `created_at`: Address creation time in milliseconds
        + int

## Get Withdrawal

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "withdrawal": {
            "withdrawal_id": "62056df2d4cf8fb9b15c7238b89a1438",
            "user_id": "62056df2d4cf8fb9b15c7238b89a1438",
            "status": "pending",
            "confirmations": 25,
            "required_confirmations": 25,
            "created_at": 1504459805123,
            "sent_at": 1504459805123,
            "completed_at": 1504459914233,
            "updated_at": 1504459914233,
            "to_address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
            "txhash": "0xf6ca576fb446893432d55ec53e93b7dcfbbf75b548570b2eb8b1853de7aa7233",
            "currency": "BTC",
            "amount": "0.021",
            "fee": "0.0003"
        }
    }
}
```

`/v1/wallet/withdrawals/<withdrawal_id> [GET]`

    Get Withdrawal Information

+ **Path Parameters**
    + `withdrawal_id`: Withdrawal ID
        + string
        + required

+ **Response**
    + `withdrawal_id`: Withdrawal ID
        + string
    + `user_id`: Withdrawal user ID
        + string
    + `status`: Status of the withdrawal request
        + enum[`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`]
    + `confirmations`: Current confirmation count
        + int
    + `required_confirmations`: Required confirmation count
        + int
    + `created_at`: Timestamp of withdrawal creation in milliseconds
        + int
    + `sent_at`: Timestamp of issuing withdrawal in milliseconds
        + int
    + `completed_at`: Timestamp of withdrawal completion in milliseconds
        + int
    + `updated_at`: Timestamp of withdrawal update time in milliseconds
        + int
    + `to_address`: Target address of withdrawal
        + string
    + `txhash`: Transaction hash of withdrawal
        + string
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `amount`: Withdrawal amount
        + string
    + `fee`: Transfer fee of the withdrawal
        + string

## Get All Withdrawals

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "withdrawals": [
            {
                "withdrawal_id": "62056df2d4cf8fb9b15c7238b89a1438",
                "user_id": "62056df2d4cf8fb9b15c7238b89a1438",
                "status": "pending",
                "confirmations": 25,
                "required_confirmations": 25,
                "created_at": 1504459805123,
                "sent_at": 1504459805123,
                "completed_at": 1504459914233,
                "updated_at": 1504459914233,
                "to_address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
                "txhash": "0xf6ca576fb446893432d55ec53e93b7dcfbbf75b548570b2eb8b1853de7aa7233",
                "currency": "BTC",
                "amount": "0.021",
                "fee": "0.0003"
            },
            ...
        ]
    }
}
```

`/v1/wallet/withdrawals [GET]`

    Get All Withdrawals

+ **Query Parameters**
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + Returns all currencies if not specified
    + `status`: Status of withdrawal
        + enum[`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`]
        + optional
        + Returns all status if not specified
    + `limit`: Limits number of withdrawals per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `withdrawal_id`: Withdrawal ID
        + string
    + `user_id`: Withdrawal user ID
        + string
    + `status`: Status of the withdrawal request
        + enum[`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`]
    + `confirmations`: Current confirmation count
        + int
    + `required_confirmations`: Required confirmation count
        + int
    + `created_at`: Timestamp of withdrawal creation in milliseconds
        + int
    + `sent_at`: Timestamp of issuing withdrawal in milliseconds
        + int
    + `completed_at`: Timestamp of withdrawal completion in milliseconds
        + int
    + `updated_at`: Timestamp of withdrawal update time in milliseconds
        + int
    + `to_address`: Target address of withdrawal
        + string
    + `txhash`: Transaction hash of withdrawal
        + string
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `amount`: Withdrawal amount
        + string
    + `fee`: Transfer fee of the withdrawal
        + string

## Get Deposit

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "deposit": {
            "deposit_id": "62056df2d4cf8fb9b15c7238b89a1438",
            "user_id": "62056df2d4cf8fb9b15c7238b89a1438",
            "status": "pending",
            "confirmations": 25,
            "required_confirmations": 25,
            "created_at": 1504459805123,
            "completed_at": 1504459914233,
            "from_address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
            "txhash": "0xf6ca576fb446893432d55ec53e93b7dcfbbf75b548570b2eb8b1853de7aa7233",
            "currency": "BTC",
            "amount": "0.021",
            "fee": "0.0003"
        }
    }
}
```

`/v1/wallet/deposits/<deposit_id> [GET]`

    Get Deposit Information

+ **Path Parameters**
    + `deposit_id`: Deposit ID
        + string
        + required

+ **Response**
    + `deposit_id`: Deposit ID
        + string
    + `user_id`: Deposit user ID
        + string
    + `status`: Transation status
        + string
    + `confirmations`: Current confirmation count
        + int
    + `required_confirmations`: Required confirmation count
        + int
    + `created_at`: Timestamp of deposit creation in milliseconds
        + int
    + `completed_at`: Timestamp of deposit  completion in milliseconds
        + int
    + `from_address`: Source address of deposit
        + string
    + `txhash`: Transaction hash of deposit
        + string
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `amount`: Deposit amount
        + string
    + `fee`: Transfer fee of the deposit
        + string

## Get All Deposits

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "deposits": [
            {
                "deposit_id": "62056df2d4cf8fb9b15c7238b89a1438",
                "user_id": "62056df2d4cf8fb9b15c7238b89a1438",
                "status": "pending",
                "confirmations": 25,
                "required_confirmations": 25,
                "created_at": 1504459805123,
                "completed_at": 1504459914233,
                "from_address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
                "txhash": "0xf6ca576fb446893432d55ec53e93b7dcfbbf75b548570b2eb8b1853de7aa7233",
                "currency": "BTC",
                "amount": "0.021",
                "fee": "0.0003"
            },
            ...
        ]
    }
}
```

`/v1/wallet/deposits [GET]`


+ **Response**
    + `deposit_id`: Deposit ID
        + string
    + `user_id`: Deposit user ID
        + string
    + `status`: Transation status
        + string
    + `confirmations`: Current confirmation count
        + int
    + `required_confirmations`: Required confirmation count
        + int
    + `created_at`: Timestamp of deposit creation in milliseconds
        + int
    + `completed_at`: Timestamp of deposit  completion in milliseconds
        + int
    + `from_address`: Source address of deposit
        + string
    + `txhash`: Transaction hash of deposit
        + string
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
    + `amount`: Deposit amount
        + string
    + `fee`: Transfer fee of the deposit
        + string

# WebSocket [Will deprecate in June, 2018]

## Order *[Auth]*

> **Request**

```json
{
  "action": "subscribe",
  "type": "order"
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "order",
  "channel_id": CHANNEL_ID
}
```

> **Snapshot / Update**

```json
//update
{
    "channel_id": CHANNEL_ID,
    "update":
        [
            ORDER_ID,
            TRADING_PAIR_ID,
            STATUS,
            SIDE,
            TYPE,
            PRICE,
            SIZE,
            FILLED_SIZE,
            TIME_STAMP
         ]
}
```

+ `CHANNEL_ID`: The channel ID for event type
    + string
+ `ORDER_ID`: Order ID
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `STATUS`: Order status
    + enum[`received`, `open`, `canceled`, `closed`]
+ `SIDE`: Order side
    + enum[`bid`, `ask`]
+ `TYPE`: Order type
    + enum[`market`, `limit`, `stop`, `stop_limit`]
+ `PRICE`: Quote price
    + string
+ `SIZE`: Base amount
    + string
+ `FILLED_SIZE`: Amount filled in current order
    + string
+ `TIME_STAMP`: Order timestamp in milliseconds
    + string

## Trades

After receiving the response, you will start receiving recent trade,
followed by any trade that occurs at COBINHOOD.

> **Request**

```json
{
  "action": "subscribe",
  "type": "trade",
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "trade",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `CHANNEL_ID`: The channel ID for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]

> **Snapshot**

```json
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TRADE_ID, TIME_STAMP, PRICE, SIZE, MAKER_SIDE],
          ...
        ]
}
```

> **Update**

```json
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          [TRADE_ID, TIME_STAMP, PRICE, SIZE, MAKER_SIDE],
          ...
        ]
}
```

+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `CHANNEL_ID`: Channel ID
    + string
+ `TRADE_ID`: Trade ID
    + string
+ `TIME_STAMP`: Trade timestamp in milliseconds
    + string
+ `PRICE`: Trade quote price
    + string
+ `SIZE`: Trade base amount
    + string
+ `MAKER_SIDE`: The order side
    + enum[`bid`, `ask`]

## Order book

After receiving the response, you will receive a snapshot of the book,
followed by updates upon any changes to the book.

> **Request**

```json
{
  "action": "subscribe",
  "type": "order-book",
  "trading_pair_id": TRADING_PAIR_ID
  "precision": PRECISION
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "order-book",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
  "precision": PRECISION
}
```

> **Snapshot**

```json
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":  {
        "bids": [
            [ PRICE, SIZE, COUNT ],
            ...
        ],
        "asks": [
            [ PRICE, SIZE, COUNT ],
            ...
        ]
    }
}
```

> **Update**

```json
//update
{
    "channel_id": CHANNEL_ID,
    "update":  {
        "bids": [
            [ PRICE, SIZE, COUNT ],
            ...
        ],
        "asks": [
            [ PRICE, SIZE, COUNT ],
            ...
        ]
    }
}
```

+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `CHANNEL_ID`: Channel ID
    + string
+ `PRICE`: Order price
    + string
+ `COUNT`: Order number
    + string
+ `SIZE`: Total amount
    + string
+ `PRECISION`: The precision of the target orderbook.
    + string

## Ticker

```json
{
  "action": "subscribe",
  "type": "ticker",
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "ticker",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Snapshot**

```json
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          LAST_TRADE_ID,
          PRICE,
          HIGHEST_BID,
          LOWEST_ASK,
          24H_VOLUME,
          24H_HIGH,
          24H_LOW,
          24H_OPEN,
          TIME_STAMP
        ]
}
```

> **Update**

```json
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          LAST_TRADE_ID,
          PRICE,
          HIGHEST_BID,
          LOWEST_ASK,
          24H_VOLUME,
          24H_HIGH,
          24H_LOW,
          24H_OPEN,
          TIME_STAMP
        ]
}
```

After receiving the response, you will receive a snapshot of the ticker,
 followed by updates upon any changes to the tickers.

+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `CHANNEL_ID`: Channel ID
    + string
+ `LAST_TRADE_ID`: Latest trade ID
    + string
+ `PRICE`: Latest trade price
    + string
+ `HIGHEST_BID`: Best bid price in current order book
    + string
+ `LOWEST_ASK`: Best ask price in current order book
    + string
+ `24H_VOLUME`: Trading volume of the last 24 hours
    + string
+ `24H_LOW`: Lowest trade price of the last 24 hours
    + string
+ `24H_HIGH`: Highest trade price of the last 24 hours
    + string
+ `TIME_STAMP`: Ticker timestamp in milliseconds
    + string

## Candle

> **Request**

```json
{
  "action": "subscribe",
  "type": "candle",
  "trading_pair_id": TRADING_PAIR_ID,
  "timeframe": TIMEFRAME
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "candle",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID,
  "timeframe": TIMEFRAME
}
```

> **Snapshot**

```json
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TIME, OPEN, CLOSE, HIGH, LOW, VOL],
          ...
        ]
}
```

> **Update**

```json
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          [TIME, OPEN, CLOSE, HIGH, LOW, VOL],
          ...
        ]
}
```

After receiving the response, you will receive a snapshot of the candle data,
followed by updates upon any changes to the chart. Updates to the most recent
timeframe interval are emitted.

+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `TIMEFRAME`: Timespan granularity
    + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `TIMEFRAME`: Timespan granularity
    + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]
+ `CHANNEL_ID`: Channel ID
    + string
+ `TIME_STAMP`: Timestamp in milliseconds
    + string
+ `OPEN`: First price during the time frame
    + string
+ `CLOSE`: Last price during the time frame
    + string
+ `HIGH`: Highest price during the time frame
    + string
+ `LOW`: Lowest price during the time frame
    + string
+ `VOL`:  Trading volume of the time frame
    + string

## Ping/Pong

> **Request**

```json
{
  "action": "ping"
}
```

> **Response**

```json
{
  "event": "pong"
}
```

Send `ping` to test connection

## Unsubscribe

> **Request**

```json
{
  "action": "unsubscribe",
  "channel_id": CHANNEL_ID
}
```

> **Response**

```json
{
  "event": "unsubscribed",
  "channel_id": CHANNEL_ID
}
```

Send unsubscribe action to unsubscribe channel
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `CHANNEL_ID`: The channel id for event type
    + string

# WebSocket error code
Error code for the specified error event occured, server will reponse an error message including error code and request parameters. For example:

```json
{
  "event": "error",
  "code": 4001,
  "message": "undefined_action",
  "type": "ticker",
  "trading_pair_id": "BTC-USDT"
}
```

## Error Code

+ `4000`: undefined_error. Unknown error.
+ `4001`: undefined_action. Request action is not defined.
+ `4002`: cannel_not_found. Cound't found a  channel according the request.
+ `4003`: subscribe_failed. Failed to subscribe a channel for specified request.
+ `4004`: unsubsribe_failed. Failed to unsubscribe a channel for specified request.
+ `4005`: invalid_payload. request is not avliable.
+ `4006`: not_authenticated. Calling a authorization required chanel, but request without authorization.
+ `4007`: invalid_snapshot. Failed to get a snapshot.
+ `4008`: place_order_failed. Failed to place a order.
+ `4009`: cancel_order_failed. Failed to cancel a order.
+ `4010`: modify_order_failed. Failed to modify a order.


# Websocket V2

To reduce payload size, using abbreviation and supporting message compression (RFC 7692), and support extendable structure, using key-value pair, JSON payload would result in following schema:

```json
 {
 	"h": [],	// header: extendable payload header.
 				// Format: [channel_id, version, type]
 				//  * version for future iteration.
 				//  * type is defined according to resource.
 				//
 				// Generally, we have following types:
 				//  * "s" for snapshot
 				//  * "u" for update.
 				//
 				// For order response, we may have enum mapping to order type.

 	"d": [],	// data: array most time, will be ordered by uniqueness.
 				// For exmpale:
 				//	* data with uuid, uuid would be the first
 				//	* data without uuid, timestamp is more
 				//      distinguishable than other fields.

 }
```

## Common Parameters

*NOTE: all fields are converted to string for correct precision*

**Version**

+ `2`: first version after v2 payload announced.

**Type**

For control response (see sessions below):

+ `pong`
+ `subscribe`
+ `unsubscribe`
+ `error`

For data response (seed sessions below):

+ `s`: snapshot
+ `u`: update


## Control Request/Response

### Ping/Pong

Ping/pong extends disconnection timeout. If no ping/pong message recieved, connection will be dropped by server in 64 seconds after last seen ping/pong message.

> **Request**

```json
{
  "action": "ping"
}
```

> **Response**

```json
{
    // [channel_id, version, type]
    "h": ["", "2", "pong"],
    "d": []
}
```

### Subscribe

Please check channels below. the optional parameters are different from channel to channel.

### Unsubscribe

Unsubscribe from given channel to reduce unused data stream.

**PARAMS**

+ `CHANNEL_ID`: recieved from subscribe request and response.

> **Request**

```json
{
  "action": "unsubscribe",
  "type": CHANNEL_ID

}
```

> **Response**

```json
{
    // [channel_id, version, type]
    "h": ["trade.ETH-BTC", "2", "unsubscribed"],
    "d": []
}
```

### Error

Error code for the specified error event occured, server will reponse an error message including error code. For example:

**Error Code**

+ `4000`: undefined_error. Unknown error.
+ `4001`: undefined_action. Request action is not defined.
+ `4002`: cannel_not_found. Cound't found a  channel according the request.
+ `4003`: subscribe_failed. Failed to subscribe a channel for specified request.
+ `4004`: unsubsribe_failed. Failed to unsubscribe a channel for specified request.
+ `4005`: invalid_payload. request is not avliable.
+ `4006`: not_authenticated. Calling a authorization required chanel, but request without authorization.
+ `4007`: invalid_snapshot. Failed to get a snapshot.
+ `4008`: place_order_failed. Failed to place a order.
+ `4009`: cancel_order_failed. Failed to cancel a order.
+ `4010`: modify_order_failed. Failed to modify a order.
+ `4011`: invalid_client_version. Not supported client.
+ `4012`: order_operation_rate_limit. Order operation (including place, modify, cancel) reaches rate limit. Note that limit counter are platform-wide, counting both REST and websocket.

> **Response**

```json
{
    // [channel_id, version, type, error_code, msg]
    "h": ["", "2", "error", "4002", "channel_not_found"],
    "d": []
}
```

## Channel Request/Response

### Order [Auth]

Order response provides extra information for recognition, the following sessions show all values of field enumerations.

**Type**

+ `0`: limit
+ `1`: market
+ `2`: market_stop
+ `3`: limit_stop
+ `4`: trailing_fiat_stop       (not valid yet)
+ `5`: fill_or_kill             (not valid yet)
+ `6`: trailing_percent_stop    (not valid yet)

**Event**

+ `opened`: order placed.
+ `modified`: order modified.
+ `executed`: order executed/matched.
+ `triggered`: conditional order been triggered.
+ `cancelled`: order cancelled.
+ `cancel_pending`: server is processing cancelation.
+ `cancel_rejected`: cancel request is rejected.
+ `modify_rejected`: modify request is rejected.
+ `execute_rejected`: rejected while executing.
+ `trigger_rejected`: rejected while triggering.

**State**

+ `queued`
+ `open`
+ `partially_filled`
+ `filled`
+ `cancelled`
+ `pending_cancellation`
+ `rejected`
+ `triggered`

**Side**

+ `ask`
+ `bid`

**PARAMS**

+ `ORDER_ID`: order's ID.
+ `TIMESTAMP`: order's timestamp.
+ `COMPLETED_AT`: order executed timestamp.
+ `TRADING_PAIR_ID`: trading pairs ID
+ `STATE`: order state, the state saved in database.
+ `EVENT`: order event, the state changing event.
+ `SIDE`: place side
+ `PRICE`: order price
+ `EQ_PRICE`: equal/average price
+ `SIZE`: order size
+ `PARIIAL_FILLED_SIZE`: partially filled size
+ `STOP_PRICE`: conditional stop price

> **Request**

```json
{
  "action": "subscribe",
  "type": "order"
}
```

> **Response**

*Limit Order*

```json
{
    // [channel_id, version, type]
    "h": ["order", "2", "u", "0"],
    "d": [
        ORDER_ID,
        TIMESTAMP,
        COMPLETED_AT,
        TRADING_PAIR_ID,
        STATE,
        EVENT,
        SIDE,
        PRICE,
        EQ_PRICE,
        SIZE,
        PARTIAL_FILLED_SIZE
    ]
}
```

*Market Order*

```json
{
    // [channel_id, version, type]
    "h": ["order", "2", "u", "1"],
    "d": [
        ORDER_ID,
        TIMESTAMP,
        COMPLETED_AT,
        TRADING_PAIR_ID,
        STATE,
        EVENT,
        SIDE,
        EQ_PRICE,
        SIZE,
        PARTIAL_FILLED_SIZE
    ]
}
```

*Market Stop Order*

```json
{
    // [channel_id, version, type]
    "h": ["order", "2", "u", "3"],
    "d": [
        ORDER_ID,
        TIMESTAMP,
        COMPLETED_AT,
        TRADING_PAIR_ID,
        STATE,
        EVENT,
        SIDE,
        EQ_PRICE,
        SIZE,
        PARTIAL_FILLED_SIZE,
        STOP_PRICE
    ]
}
```

*Limit Stop Order*

```json
{
    // [channel_id, version, type]
    "h": ["order", "2", "u", "4"],
    "d": [
        ORDER_ID,
        TIMESTAMP,
        COMPLETED_AT,
        TRADING_PAIR_ID,
        STATE,
        EVENT,
        SIDE,
        PRICE,
        EQ_PRICE,
        SIZE,
        PARTIAL_FILLED_SIZE,
        STOP_PRICE
    ]
}
```

### Orderbook

After receiving the response, you will receive a snapshot of the book, followed by updates upon any changes to the book.
The updates is published as **DIFF**.

**PARAMS**

+ `PRECISION`: available precisions could be acquired from REST, endpoint: `/v1/market/orderbook/precisions/<trading_pair_id>`
+ `PRICE`: order price
+ `SIZE`: order amount, diff maybe minus value
+ `COUNT`: order count, diff maybe minus value

> **Request**

```json
{
  "action": "subscribe",
  "type": "order-book",
  "trading_pair_id": TRADING_PAIR_ID
  "precision": PRECISION
}
```

> **Response**
```json
{
    // [channel_id, version, type]
    "h": ["order-book.COB-ETH.1E-7", "2", "u"],
    "d": {
        "bids": [
            [ PRICE, SIZE, COUNT ],
            ...
        ],
        "asks": [
            [ PRICE, SIZE, COUNT ],
            ...
    }
}
```

### Trade

After receiving the response, you will start receiving recent trade,
followed by any trade that occurs at COBINHOOD.

**PARAMS**

+ `TRADING_PAIR_ID`: Subscribe trading pair ID
+ `TRADE_ID`: Trade ID
+ `TIME_STAMP`: Trade timestamp in milliseconds
+ `PRICE`: Trade quote price
+ `SIZE`: Trade base amount
+ `MAKER_SIDE`: The order side

> **Request**

```json
{
  "action": "subscribe",
  "type": "trade",
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Response**

```json
{
    "h": ["trade.COB-ETH", "2", "u"],
    "d":
        [
          [TRADE_ID, TIME_STAMP, PRICE, SIZE, MAKER_SIDE],
          ...
        ]
}
```

### Ticker

+ `TRADING_PAIR_ID`: Subscribe trading pair ID
+ `TIME_STAMP`: Ticker timestamp in milliseconds
+ `HIGHEST_BID`: Best bid price in current order book
+ `LOWEST_ASK`: Best ask price in current order book
+ `24H_VOLUME`: Trading volume of the last 24 hours
+ `24H_LOW`: Lowest trade price of the last 24 hours
+ `24H_HIGH`: Highest trade price of the last 24 hours
+ `LAST_TRADE_PRICE`: Latest trade price

> **Request**

```json
{
  "action": "subscribe",
  "type": "ticker",
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Response**

```json
{
    "h": ["ticker.COB-ETH", "2", "u"],
    "d": [
        [
          TIME_STAMP,
          HIGHEST_BID,
          LOWEST_ASK,
          24H_VOLUME,
          24H_HIGH,
          24H_LOW,
          24H_OPEN,
          LAST_TRADE_PRICE
        ]
    ]
}
```


### Candle

After receiving the response, you will receive a snapshot of the candle data,
followed by updates upon any changes to the chart. Updates to the most recent
timeframe interval are emitted.

**Timeframe**

+ `1m`: 1 minute
+ `5m`: 5 minute
+ `15m`: 15 minute
+ `30m`: 30 minute
+ `1h`: 1 hour
+ `3h`: 3 hour
+ `6h`: 6 hour
+ `12h`: 12 hour
+ `1D`: 1 day
+ `7D`: 7 day
+ `14D`: 14 day
+ `1M`: 1 month

**PARAMS**
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
+ `TIMEFRAME`: Timespan granularity, check enumeration above
+ `TIME_STAMP`: Timestamp in milliseconds
+ `VOL`:  Trading volume of the time frame
+ `HIGH`: Highest price during the time frame
+ `LOW`: Lowest price during the time frame
+ `OPEN`: First price during the time frame
+ `CLOSE`: Last price during the time frame

> **Request**

```json
{
  "action": "subscribe",
  "type": "candle",
  "trading_pair_id": TRADING_PAIR_ID,
  "timeframe": TIMEFRAME
}
```

> **Response**

```json
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TIME_STAMP, VOL, HIGH, LOW,OPEN, CLOSE],
          ...
        ]
}
```
