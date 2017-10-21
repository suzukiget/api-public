** NOTE: COBINHOOD IS CURRENTLY UNDER HEAVY DEVELOPMENT, APIs ARE SUBJECT TO CHANGE WITHOUT PRIOR NOTICE **

# General
COBINHOOD RESTful API URL: `https://api.cobinhood.com`

COBINHOOD WebSocket API URL: `wss://feed.cobinhood.com`

RESTful API SandBox: `https://sandbox-api.cobinhood.com`

WebSocket API SandBox: `wss://sandbox-feed.cobinhood.com`

### Timestamps
All timestamps exchanged between client and server are based on server Unix UTC timestamp. Please refer to System Module for retrieving server timestamp.

### Floating Point Values
All floating point values in responses are encoded in `string` type to avoid loss of precision.

### Authentication
COBINHOOD uses JWT for APIs that require authentication. JWT header field name is `authorization`. The JWT can be generated and revoked on COBINHOOD exchange API console page.

### API Responses
All responses from API contain a JSON object field named `result`:

A successful response should have HTTP status codes ranging from 100 to 399, and a boolean `success` field with value `true`. Clients should find the response as a JSON object within the `result` object:
```javascript
{
    "success": true,
    "result": {
        ...
    }
}
```

An unsuccessful response would result in HTTP status codes ranging from 400 to 599, and a boolean `success` field with value `false`. If `success` is `false`, an `error` object member containing information that describes the error can be found in the root object:
```javascript
{
    "success": false,
    "error": {
        "type": <string>,
        "code": <int>,
        "message": <string>,
        ...
    }
}
```

### Rate-limiting
All API requests are rate-limited at 10 requests/sec per user, and 50 requests/sec per IP address.

### Pagination
For APIs that return large amounts of data, the response may need to be paginated, e.g. retrieving the trade history. When pagination is required, a `Link` field can be found in the headers. Take the trade history request as an example:

Request URL: `https://api.cobinhood.com/v1/trading/trades?limit=30&page=7`

Response headers:
```
Link: <https://api.cobinhood.com/v1/trading/trades?limit=30&page=1>; rel="first",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=6&before=cGFnZTZkdWRlaXRzanVzdGFuZXhhbXBsZXdoeXNvc2VyaW91c2NoaWxsCg==>; rel="prev",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=8&before=cGFnZThkdWRlaXRzanVzdGFuZXhhbXBsZXdoeXNvc2VyaW91c2NoaWxsCg==>; rel="next",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=15>; rel="last"
X-Total-Count: 431
```
The `Link` header contains a list of links that direct to the first, previous, next, and last pages of the paginated data. APIs that support pagination take a `limit` query parameter to indicate the page size. Clients should use `limit` to specify the number of entries per page, and use links provided in the response header to navigate through the paginated data. The header `X-Total-Count` indicates the total number of existing entries, in our case, 431 trades.

# System Module - Authentication Not Required

### Get System Time
`/v1/system/time [GET]`

    Get the reference system time as Unix timestamp

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "time": 1505204498376
    }
}
```
+ `time`: Server Unix timestamp in milliseconds
    + int

### Get System Phase
`/v1/system/phase [GET]`

    Get system phase

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "phase": "production_online"
    }
}
```
+ `phase`: System Phase
    + enum[`open_beta`, `production_online`]

# Market Module - Authentication Not Required

### Get All Currencies
`/v1/market/currencies [GET]`

    Returns info for all currencies available for trade

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "currencies": [
            {
                "currency": "BTC",
                "min_unit": "0.00000001"
            },
            ...
        ]
    }
}
```
+ `currency`: Currency ID
    + (enum[`BTC`, `ETH`, ...])
+ `min_unit`: Minimum size unit, all order sizes must be an integer multiple of this number
    + string

### Get Available Trading Pairs
`/v1/market/trading_pairs [GET]`

    Get info for all currency trading pairs

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "trading_pairs": [
            {
                "trading_pair_id": "BTC-USDT",
                "base_min_size": "0.01",
                "base_max_size": "10000.00",
                "base_min_unit": "0.00000001",
                "quote_min_unit": "0.01"
            },
            ...
        ]
    }
}
```
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...] (Base-Quote)
+ `base_min_size`: Minimum amount of base
    + string
+ `base_max_size`: Maximum amount of base
    + string
+ `base_min_unit`: Minimum base currency unit, amount must be an integer multiple of this number
    + string
+ `quote_min_unit`: Minimum quote currency unit
    + string

### Get Order Book
`/v1/market/orderbooks/<trading_pair_id> [GET]`

    Get order book for the trading pair containing all asks/bids

+ Path Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required

+ Query parameters
    + `precision`: Price aggregation level, denoted as number of digits after decimal
        + int (digits [0..2], -1 shows result with no precision limit)
        + optional
        + Defaults to 2 (0.01) if not specified
    + `limit`: Limits number of entries of asks/bids list, beginning from the best price for both sides
        + int
        + optional
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
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
+ `sequence`: A sequence number that is updated on each orderbook state change
    + int
+ `price`: Order price
    + string
+ `size`: The aggregated total amount in the price group
    + string
+ `count`: The number of orders within current price range
    + string
    + e.g. when `precision=2`,  4137.181 and 4137.1837 would both fall into price group 4137.18


### Get Ticker
`/v1/market/tickers/<trading_pair_id> [GET]`

    Returns ticker for specified trading pair

+ Path Parameters
    + `trading_pair_id`
        + enum[`BTC-USDT`, `...`]
        + required

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "ticker": {
            "last_trade_id": "e015d51ae494f3edc3d921a091adab27",
            "price":"244.82",
            "bid":"244.75",
            "ask":"244.76",
            "low": "244.2",
            "high": "248.19",
            "volume": "7842.11542563",
            "timestamp": 1504459805123
        }
    }
}
```
+ `last_trade_id`: Latest trade ID
    + string
+ `price`: Latest trade price
    + string
+ `bid`: Best bid price in current order book
    + string
+ `ask`: Best ask price in current order book
    + string
+ `low`: Lowest trade price of the last 24 hours
    + string
+ `high`: Highest trade price of the last 24 hours
    + string
+ `volume`: Trading volume of the last 24 hours
    + string
+ `timestamp`: Ticker timestamp in milliseconds
    + int

### Get Recent Trades
`/v1/market/trades/<trading_pair_id> [GET]`

    Returns most recent trades for the specified trading pair

+ Path Parameters
    + `trading_pair_id`
        + enum[`BTC-USDT`, `...`]
        + required

+ Query parameters
    + `limit`: Limits number of trades beginning from the most recent
        + int
        + optional
        + Defaults to 50 if not specified
        + Maximum: 50

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "trades": [
            {
                "trading_pair_id": "BTC-USDT",
                "trade_id": "09619448e48a3bd73d493a4194f9020b",
                "bid_order_id": "54c692b3c0ad514bcc527fbcc4d29e6f",
                "ask_order_id": "c7d4b777d9034fdcacf955d940284177",
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
+ `trading_pair_id`: Trading pair ID
    + string
+ `trade_id`: Trade ID
    + string
+ `bid_order_id`: ID of maker order
    + string
+ `ask_order_id`: ID of taker order
    + string
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `maker_side`: Side of the taker
    + enum[`buy`, `sell`]
+ `timestamp`: Closed timestamp in milliseconds
    + int

# Chart Module - Authentication Not Required

### Get Candles
`/v1/chart/candles/<trading_pair_id>`

    Get charting candles

+ Path Parameters
    + `trading_pair_id`
        + enum[`BTC-USDT`, `...`]
        + required

+ Query parameter
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

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "candles": [
            {
                "timestamp": 1504459805123,
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
+ `timestamp`: Time of candlestick, Unix time in milliseconds
    + int
+ `open`: The open (first trade) price during the interval
    + string
+ `close`: Closing (last trade) price during the interval
    + string
+ `high`: The highest price during the interval
    + string
+ `low`: The lowest  price during the interval
    + string
+ `volume`: Volume of trading activity during the interval
    + string

# Trading Module - Authentication Required

### Get Order
`/v1/trading/orders/<order_id> [GET]`

    Get information for a single order

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "order": {
            "order_id": "37f550a202aa6a3fe120f420637c894c",
            "trading_pair_id": "BTC-USDT",
            "status": "open",
            "side": "buy",
            "type": "limit",
            "price": "5000.01",
            "size": "1.0100",
            "filled_size": "0.59",
            "timestamp": 1504459805123
        }
    }
}
```
+ `order_id`: Order ID
    + string
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `status`: Order status
    + enum[`received`, `open`, `canceled`, `partially-filled`, `filled`]
+ `side`: Order side
    + enum[`buy`, `sell`]
+ `type`: Order type
    + enum[`market`, `limit`, `stop`, `stop-limit`]
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `filled_size`: Amount filled in current order
    + string
+ `timestamp`: Order timestamp in milliseconds
    + int

### Get Trades of An Order
`/v1/trading/orders/<order_id>/trades [GET]`

    Get all trades originating from the specific order

+ Path Parameters
    + `order_id`: Order ID
        + string
        + required

+ [Success] Response 200 (application/json)
```javascript
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
    + enum[`buy`, `sell`]
+ `timestamp`: Closed timestamp in milliseconds
    + int

### Get All Orders
`/v1/trading/orders [GET]`

    List all current orders for user

+ Query parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required
    + `limit`: Limits number of orders per page
        + int
        + optional
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "orders": [
            {
                "trading_pair_id": "BTC-USDT",
                "order_id": "37f550a202aa6a3fe120f420637c894c",
                "status": "open",
                "side": "buy",
                "type": "limit",
                "price": "5000.01000000",
                "size": "1.0100",
                "filled_size": "0.59",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `order_id`: Order ID
    + string
+ `status`: Order status
    + enum[`open`]
+ `side`: Order side
    + enum[`buy`, `sell`]
+ `type`: Order type
    + enum[`market`, `limit`, `stop`, `stop-limit`]
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `filled_size`: Amount filled in current order
    + string
+ `timestamp`: Order timestamp in milliseconds
    + int

### Place Order
`/v1/trading/orders [POST]`

    Place orders to ask or bid

+ Payload
```javascript
{
    "trading_pair_id": "BTC-USDT",
    "side": "buy",
    "type": "limit",
    "price": "5000.01000000",
    "size": "1.0100"
}
```
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `side`: Order side
    + enum[`buy`, `sell`]
+ `type`: Order type
    + enum[`market`, `limit`, `stop`, `stop-limit`]
+ `price`: Quote price
    + string
    + optional
    + `market` type will ignore
+ `size`: Base amount
    + string

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "order": {
            "trading_pair_id": "BTC-USDT",
            "order_id": "37f550a202aa6a3fe120f420637c894c",
            "status": "open",
            "side": "buy",
            "type": "limit",
            "price": "5000.01000000",
            "size": "1.0100",
            "timestamp": 1504459805123
        }
    }
}
```
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `order_id`: Order ID
    + string
+ `status`: Order status
    + enum[`open`]
+ `side`: Order side
    + enum[`buy`, `sell`]
+ `type`: Order type
    + enum[`market`, `limit`, `stop`, `stop-limit`]
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `filled_size`: Amount filled in current order
    + string
+ `timestamp`: Order timestamp in milliseconds
    + int

### Cancel Order
`/v1/trading/orders/<order_id> [DELETE]`

    Cancel a single order

+ Path parameter
    + `order_id`: Order ID
        + string
        + required

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true
}
```

### Get Order History
`/v1/trading/order_history [GET]`

    Returns order history for the current user

+ Query Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required
    + `limit`: Limits number of orders per page
        + int
        + optional
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "order_history": [
            {
                "trading_pair_id": "BTC-USDT",
                "order_id": "37f550a202aa6a3fe120f420637c894c",
                "side": "buy",
                "type": "limit",
                "price": "5000.01000000",
                "size": "1.0100",
                "filled_size": "0.59",
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```
+ `trading_pair_id`: Trading pair ID
    + enum[`BTC-USDT`, ...]
+ `order_id`: Order ID
    + string
+ `status`: Order status
    + enum[`canceled`, `closed`]
+ `side`: Order side
    + enum[`buy`, `sell`]
+ `type`: Order type
    + enum[`market`, `limit`, `stop`, `stop-limit`]
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `filled_size`: Amount filled in current order
    + string
+ `timestamp`: Order timestamp milliseconds
    + int

### Get Trade
`/v1/trading/trades/<trade_id> [GET]`

    Get trade information

+ Path Parameters
    + `trade_id`: Trading ID
        + string
        + required

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "trade_id": "09619448-e48a-3bd7-3d49-3a4194f9020b",
        "price": "10.00000000",
        "size": "0.01000000",
        "maker_side": "bid",
        "timestamp": 1504459805123
    }
}
```
+ `trade_id`: Trade ID
    + string
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `maker_side`: Side of the taker
    + enum[`ask`, `bid`]
+ `timestamp`: Closed timestamp in milliseconds
    + int

### Get Trade History
`/v1/trading/trades [GET]`

    Returns trade history for the current user

+ Path Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required
    + `limit`: Limits number of trades per page
        + int
        + optional
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
{
    "result": {
        "success": true,
        "trades": [
            {
                "trading_pair_id": "BTC-USDT",
                "trade_id": "09619448e48a3bd73d493a4194f9020b",
                "bid_order_id": "54c692b3c0ad514bcc527fbcc4d29e6f",
                "ask_order_id": "c7d4b777d9034fdcacf955d940284177",
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
+ `trading_pair_id`: Trading pair ID
    + string
+ `trade_id`: Trade ID
    + string
+ `bid_order_id`: ID of ask order
    + string
+ `ask_order_id`: ID of bid order
    + string
+ `price`: Quote price
    + string
+ `size`: Base amount
    + string
+ `maker_side`: Side of the taker
    + enum[`buy`, `sell`]
+ `timestamp`: Closed timestamp in milliseconds
    + int

# Wallet Module - Authentication Required

    This module contains APIs for querying user account balances and history, generate deposit addresses, and deposit/withdraw funds.

### Get Wallet Balances
`/v1/wallet/balances [GET]`

    Get Wallet Balances

+ Query Parameter
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + returns all currencies if not specified

+ [Success] Response 200 (application/json)
```javascript
{
    "result": {
        "success": true,
        "balances": [
            {
                "currency": "BTC",
                "total": "5.00000001",
                "available": "4.00000001",
                "on_order": "1.00000000"
            },
            ...
        ]
    }
]
```
+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `total`: Total amount in wallet
    + string
+ `available`: Available amount in wallet
    + string
+ `on_order`: The amount in order book
    + string

### Get Balance History
`/v1/wallet/history [GET]`

    Get balance history for the current user

+ Query Parameter
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + returns history of all currencies if not given
    + `limit`: Limits the number of balance changes per page
        + int
        + optional
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
{
    "result":
        "success": true,
        "history": [
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
    + string

### Generate New Deposit Address
`/v1/wallet/deposit_addresses [POST]`

    Generate a New Deposit Address
    PLEASE NOTE: COBINHOOD KEEPS A LIST OF MOST RECENT 10 DEPOSIT ADDRESSES PER CURRENCY
    OLDER ADDRESSES WILL NOT BE TRACKED

+ Payload
```javascript
{
    "currency": "BTC"
}
```
+ `currency`: Currency ID
    + enum[`BTC`, `ETH`, ...]

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "deposit_address": {
            "currency": "BTC",
            "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
            "created_at": 1504459805123
        }
    }
}
```
+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: Newly generated address
    + string
+ `created_at`: Address creation time in milliseconds
    + int

### Get Deposit Addresses
`/v1/wallet/deposit_addresses [GET]`

    Get Wallet Deposit Addresses
    PLEASE NOTE: WE KEEP A LIST OF 10 MOST RECENT GENERATED ADDRESSES PER CURRENCY TYPE
    PLEASE MAKE SURE A DEPOSIT ADDRESS IS ON THE LIST BEFORE YOU TRANSFER ANY FUNDS

+ Query Parameters
    + `currency`: Currency ID
        + enum[`BTC`, ...]
        + optional

+ [Success] Response 200 (application/json)
```javascript
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
+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: Newly generated address
    + string
+ `created_at`: Address creation time in milliseconds
    + int

### Withdraw Funds
`/v1/wallet/withdrawals [POST]`

    Create a Withdrawal Request

+ Payload
```javascript
{
    "currency": "BTC",
    "amount": "1.00000001",
    "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20"
}
```
+ `currency`: Currency ID
    + string
    + required
+ `amount`: Withdrawal amount
    + string
    + required
+ `address`: The target address for withdrawal
    + string
    + required

+ [Success] Response 200 (application/json)
```javascript
{
    "success": true,
    "result": {
        "withdrawal": {
            "withdrawal_id": "393215d18749fa01987c43103712d61e",
            "timestamp": 1504459805123
        }
    }
}
```
+ `withdrawal_id`: Withdrawal ID
    + string
+ `timestamp`: Millisecond timestamp of withdrawal
    + int

### Get Withdrawal
`/v1/wallet/withdrawals/<withdrawal_id> [GET]`

    Get Withdrawal Information

+ Path Parameters
    + `withdrawal_id`: Withdrawal ID
        + string
        + required

+ [Success] Response 200 (application/json)
```javascript
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

### Get All Withdrawals
`/v1/wallet/withdrawals [GET]`

    Get All Withdrawals

+ Query Parameters
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
        + Defaults to 50 if not specified

+ [Success] Response 200 (application/json)
```javascript
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
        }
    }
}
```
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

### Get Deposit
`/v1/wallet/deposits/<deposit_id> [GET]`

    Get Deposit Information

+ Path Parameters
    + `deposit_id`: Deposit ID
        + string
        + required

+ [Success] Response 200 (application/json)
```javascript
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

### Get All Deposits
`/v1/wallet/deposits [GET]`

    Get All Deposits

+ Query Parameters
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + Returns all currencies if not specified
    + `limit`: Limits the number of withdrawals per page
        + int
        + optional
        + Returns most recent 50 deposits if not specified

+ [Success] Response 200 (application/json)
```javascript
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
        }
    }
}
```
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

# WebSocket Public Channels - Authentication Not Required

All parameter in the WebSocket api is string format.

### Trades

After receiving the response, you will start receiving recent trade,
followed by any trade that occurs at COBINHOOD.

**Request**
```javascript
{
  "action": 'subscribe',
  "type": 'trade',
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]

**Response**
```javascript
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

**Snapshot / Update**
```javascript
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TRADE_ID, TIME, PRICE, AMOUNT, SIDE],
          ...
        ]
}

//update
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          [TRADE_ID, TIME, PRICE, AMOUNT, SIDE],
          ...
        ]
}
```
+ `CHANNEL_ID`: Channel ID
    + string
+ `TRADE_ID`: Trade ID
    + string
+ `TIME`: Trade timestamp in milliseconds
    + string
+ `PRICE`: Trade quote price
    + string
+ `AMOUNT`: Trade base amount
    + string
+ `SIDE`: The order side
    + enum[`buy`, `sell`]

### Order book

After receiving the response, you will receive a snapshot of the book,
followed by updates upon any changes to the book.

**Request**
```javascript
{
  "action": 'subscribe',
  "type": 'book',
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]

**Response**
```javascript
{
  "event": "subscribed",
  "type": "book",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]

**Snapshot / Update**
```javascript
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [PRICE, COUNT, AMOUNT, SIDE],
          ...
        ]
}

//update
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          [PRICE, COUNT, AMOUNT, SIDE],
          ...
        ]
}
```
+ `CHANNEL_ID`: Channel ID
    + string
+ `PRICE`: Order price
    + string
+ `COUNT`: Order number
    + string
+ `AMOUNT`: Total amount
    + string
+ `SIDE`: The order side
    + enum[`buy`, `sell`]

### Ticker

After receiving the response, you will receive a snapshot of the ticker,
 followed by updates upon any changes to the tickers.

**Request**
```javascript
{
  "action": 'subscribe',
  "type": 'ticker',
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]


**Response**
```javascript
{
  "event": "subscribed",
  "type": "ticker",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
}
```
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]

**Snapshot / Update**
```javascript
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
            [
              BID,
              BID_SIZE,
              ASK,
              ASK_SIZE,
              DAILY_CHANGE,
              DAILY_CHANGE_PERC,
              LAST_PRICE,
              VOLUME,
              HIGH,
              LOW
            ],
          ...
        ]
}

//update
{
    "channel_id": CHANNEL_ID,
    "update":
        [
            [
              BID,
              BID_SIZE,
              ASK,
              ASK_SIZE,
              DAILY_CHANGE,
              DAILY_CHANGE_PERC,
              LAST_PRICE,
              VOLUME,
              HIGH,
              LOW
            ],
          ...
        ]
}
```
+ `CHANNEL_ID`: Channel ID
    + string
+ `BID`: Price of last highest bid
    + string
+ `BID_SIZE`: Size of the last highest bid
    + string
+ `ASK`: Price of last lowest ask
    + string
+ `ASK_SIZE`: Size of the last lowest ask
    + string
+ `DAILY_CHANGE`: Amount that the last price has changed since yesterday
    + string
+ `DAILY_CHANGE_PERC`: Amount that the price has changed expressed in percentage terms
    + string
+ `LAST_PRICE`: Price of the last trade
    + string
+ `VOLUME`: Daily volume
    + string
+ `HIGH`: Daily high
    + string
+ `LOW`: Daily low
    + string

### Candles

After receiving the response, you will receive a snapshot of the candles data,
followed by updates upon any changes to the candles. Updates to the most recent
timeframe interval are emitted.

**Request**
```javascript
{
  "action": 'subscribe',
  "type": 'candles',
  "trading_pair_id": TRADING_PAIR_ID,
  "timeframe": TIMEFRAME
}
```
+ `TRADING_PAIR_ID`: Subscribe trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `TIMEFRAME`: Timespan granularity
    + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]

**Response**
```javascript
{
  "event": "subscribed",
  "type": "candles",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID,
  "timeframe": TIMEFRAME
}
```
+ `CHANNEL_ID`: The channel id for event type
    + string
+ `TRADING_PAIR_ID`: Trading pair ID
    + enum[`BTC-USDT`, `ETH-USDT`, ...]
+ `TIMEFRAME`: Timespan granularity
    + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]

**Snapshot / Update**
```javascript
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TIME, OPEN, CLOSE, HIGH, LOW, VOL],
          ...
        ]
}

//update
{
    "channel_id": CHANNEL_ID,
    "update":
        [
          [TIME, OPEN, CLOSE, HIGH, LOW, VOL],
          ...
        ]
}
```
+ `CHANNEL_ID`: Channel ID
    + string
+ `TIME`: Timestamp in milliseconds
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

### Ping/Pong

Send `ping` to test connection

**Request**
```javascript
{
  "action": 'ping',
}
```

**Response**
```javascript
{
  "event": "pong",
}
```

### Unsubscribe

Send unsubscribe action to unsubscribe channel

**Request**
```javascript
{
  "action": 'unsubscribe',
  "channel_id": CHANNEL_ID
}
```
+ `CHANNEL_ID`: The channel id for event type
    + string

**Response**
```javascript
{
  "event": 'unsubscribed',
  "channel_id": CHANNEL_ID
}
```
+ `CHANNEL_ID`: The channel id for event type
    + string
