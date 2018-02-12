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

COBINHOOD WebSocket API URL: `wss://feed.cobinhood.com`

## HTTP Request Headers
`nonce` for 'POST' 'UPDATE' 'DELETE'  
`authorization`

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
        "error_code": <string>,
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
                "name": "Bitcoin"
                "min_unit": "0.00000001"
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

## Get All Trading Pairs
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trading_pairs": [
            {
                "id": "BTC-USD",
                "base_currency_id": "BTC",
                "quote_currency_id": "USD",
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
                [ price, size, count ],
                ...
            ],
            "asks": [
                [ price, size, count ],
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

## Get Trading Statistics
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "BTC-USD": {
            "id": "BTC-USD",
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
            "last_trade_id": "e015d51ae494f3edc3d921a091adab27",
            "price":"244.82",
            "highest_bid":"244.75",
            "lowest_ask":"244.76",
            "24h_volume": "7842.11542563",
            "24h_high": "23.456",
            "24h_low": "10.123",
            "24h_open": "15.764",
            "timestamp": 1504459805123,
        },
    }
}
```

`/v1/market/tickers/<trading_pair_id> [GET]`

    Returns ticker for specified trading pair

+ **Path Parameters**
    + `trading_pair_id`
        + enum[`BTC-USDT`, ...]
        + required
        
+ **Response**
    + `last_trade_id`: Latest trade ID
        + string
    + `price`: Latest trade price
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
            "trading_pair": "BTC-USD",
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
        + enum[`BTC-USD`, ...]
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
                "maker_side": "bid"
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
                "trading_pair": "BTC-USD",
                "state": "open",
                "side": "bid",
                "type": "limit",
                "price": "5000.01",
                "size": "1.0100",
                "filled": "0.59",
                "timestamp": 1504459805123
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
        + enum[`BTC-USD`, ...]
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

## Place Order 
> Payload

```json
{
    "trading_pair_id": "BTC-USD",
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
            "trading_pair": "BTC-USD",
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
+ **Response**
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USD`, ...]
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
        + enum[`BTC-USD`, ...]
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
                "trading_pair": "BTC-USD",
                "state": "filled",
                "side": "bid",
                "type": "limit",
                "price": "5000.01",
                "size": "1.0100",
                "filled": "0.59",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```

+ **Response**
    + `trading_pair`: Trading pair ID
        + enum[`BTC-USD`, ...]
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

## Get Trade 
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "trade": {
            "id": "09619448-e48a-3bd7-3d49-3a4194f9020b",
            "price": "10.00000000",
            "size": "0.01000000",
            "maker_side": "bid",
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
    + `id`: Trade ID
        + [UUID String](#uuid-string)
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `maker_side`: Side of the maker
        + enum[`ask`, `bid`]
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
                "trade_id": "09619448e48a3bd73d493a4194f9020b",
                "maker_order_id": "54c692b3c0ad514bcc527fbcc4d29e6f",
                "taker_order_id": "c7d4b777d9034fdcacf955d940284177",
                "price": "10.00000000",
                "size": "0.01000000",
                "side": "buy"
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
    + `trade_id`: Trade ID
        + string
    + `maker_order_id`: ID of maker order
        + string
    + `taker_order_id`: ID of taker order
        + string
    + `price`: Quote price
        + string
    + `size`: Base amount
        + string
    + `side`: Side of the taker
        + enum[`bid`, `ask`]
    + `timestamp`: Closed timestamp in milliseconds
        + int

# Wallet *[Auth]*

    This module contains APIs for querying user account balances and history, generate deposit addresses, and deposit/withdraw funds.

## Get Ledger Entries
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "ledger": [
            {
                "type": "trade",
                "trade_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "+635.77",
                "balance": "2930.33",
                "timestamp": 1504685599302,
            },
            {
                "type": "deposit",
                "deposit_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "+635.77",
                "balance": "2930.33",
                "timestamp": 1504685599302,
            },
            {
                "type": "withdrawal",
                "withdrawal_id": "09619448e48a3bd73d493a4194f9020b",
                "currency": "BTC",
                "amount": "-121.01",
                "balance": "2194.87",
                "timestamp": 1504685599302,
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
    + `type`: Type of balance change
        + enum[`trade`, `deposit`, `withdrawal`]
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
        +

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
                "created_at": 1504459805123
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

## Get Withdrawal Addresses

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "withdrawal_addresses": [
            {
                "currency": "BTC",
		        "name": "Kihon's Bitcoin Wallet Address",
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
    + `currency`: Currency ID
        + enum[`BTC`, ...]
    + `name`: A name to describe this withdrawal wallet address
        + string
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
            "status": "pending",
            "created_at": 1504459805123,
            "completed_at": 1504459914233,
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
    + `status`: Status of the withdrawal request
        + enum[`pending`, `completed`]
    + `created_at`: Timestamp of withdrawal creation in milliseconds
        + int
    + `completed_at`: Timestamp of withdrawal completion in milliseconds
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
                "status": "pending",
                "created_at": 1504459805123,
                "completed_at": 1504459914233,
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
        + enum[`pending`, `completed`]
        + optional
        + Returns all status if not specified
    + `limit`: Limits number of withdrawals per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ **Response**
    + `withdrawal_id`: Withdrawal ID
        + string
    + `status`: Status of the withdrawal request
        + enum[`pending`, `completed`]
    + `created_at`: Timestamp of withdrawal creation in milliseconds
        + int
    + `completed_at`: Timestamp of withdrawal completion in milliseconds
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

# WebSocket

## Order *[Auth]*

> **Request**

```json
{
  "action": 'subscribe',
  "type": 'order',
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "order",
  "channel_id": CHANNEL_ID,
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
  "action": 'subscribe',
  "type": 'trade',
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
  "action": 'subscribe',
  "type": 'order-book',
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
  "action": 'subscribe',
  "type": 'ticker',
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
          TIME_STAMP,
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
          TIME_STAMP,
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
  "action": 'subscribe',
  "type": 'candle',
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
  "action": 'ping',
}
```

> **Response**

```json
{
  "event": "pong",
}
```

Send `ping` to test connection

## Unsubscribe

> **Request**

```json
{
  "action": 'unsubscribe',
  "channel_id": CHANNEL_ID
}
```

> **Response**

```json
{
  "event": 'unsubscribed',
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
  "message": "undefined_action"
  "type": "ticker",
  "trading_pair_id": "BTC-USD"
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

