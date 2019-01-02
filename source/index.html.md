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

COBINHOOD WebSocket API URL: `wss://feed.cobinhood.com/ws` [Will be removed in June, 2018]
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

## Custom Query & Pagination
APIs equipped with custom query functionality enable users to query with different `filter`, `order`, `limit` and `page`.

### Query Parameters

  + `filter`: object
    + `and`: array
    + `or`: array
    + `not_equal`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `like`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `ilike`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `smaller_than`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `greater_than_or_equal`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `in`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `equal`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `between`: object
      + `column`: column to filter on
        + string
      + `value`: array of values with length 2
    + `greater_than`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
    + `smaller_than_or_equal`: object
      + `column`: column to filter on
        + string
      + `value`: the value to fitler with
        + ['string', 'number']
  + `limit`: limit
    + integer
  + `page`: page number
    + integer
  + `order`: object
    + `column`: column name
      + string
    + `keyword`: [`asc`, `desc`]
      + string

### Filter
> Ex. 1: `Where column_a = 'A'`

```json
{
	"equal": {
		"column": "column_a",
		"value": "A"
	}
}
```

> Ex. 2: `Where ((column_a = 'A') AND (column_b != 'B'))`

```json
{
	"and": [
		{
			"equal": {
				"column": "column_a",
				"value": "A"
			}
		},{
			"not_equal": {
				"column": "column_b",
				"value": "A"
			}
		}
	]
}
```

Pass the JSON stringified object as the `filter` query parameter in url to filter the queried data.
Filter object is a nested JSON object that will be evaluated to `Where` arguments in a SQL query. Each layer is a single-key map, with operator as the key and parameters as the value. There are two kinds of filters (operators), comparison filters and logic filters. Comparison filter is the atomic element of a filter and logic filter is to combine multiple filters into one single filter.

The allowed column, values and operators can differ in APIs according to different use cases.

### Comparison Operators:
- `equal`
- `not_equal`
- `greater_than`
- `greater_than_or_equal`
- `smaller_than`
- `smaller_than_or_equal`
- `in`
- `like`
- `ilike`
- `between`

### Logic Operators:

- `and`
- `or`

### Order

Pass the JSON stringified JSON array as the `order` query parameter in url to order the queried data.
Order array will be evaluated to `ORDER BY` arguments in a SQL query. Each element is a order object with column to order by and the order keyword(`asc`|`desc`).

The allowed column, values and operators can differ in APIs according to different use cases.

> Ex. `ORDER BY column_a ASC`

```json
[
	{
		"column":"column_a",
		"keyword":"asc"
	}
]
```

### Pagination

Pass `limit` and `page` query parameter to specify the pagination. Page starts from `1` and the maximum `limit` is `100`


# Chart


## Get Candle





> Sample Response

```json
{
    "success": true,
    "result": {
        "candles": [
            {
                "timeframe": "1h",
                "trading_pair_id": "COB-BTC",
                "timestamp": 1521280800000,
                "volume": "59775.03494641",
                "open": "0.00001138",
                "close": "0.00001143",
                "high": "0.00001151",
                "low": "0.00001118"
            }
        ]
    }
}

```

`/v1/chart/candles/:trading_pair_id [GET]`

returns candle of given trading pair, timeframe, time range.



### Path Parameters
  + `order_id`: trading pair ID
    + string

### Query Parameters
  + `start_time`: unix timestamp in milliseconds
    + integer
  + `end_time`: unix timestamp in milliseconds
    + integer
  + `timeframe`: timeframe type
    + enum [`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]



### Response



  + `candles`: array
    + `trading_pair_id`: trading pair symbol/id
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `volume`: summation volume of this candle
      + string
    + `high`: highest price of this candle
      + string
    + `low`: lowest price of this candle
      + string
    + `timeframe`: timeframe type
      + enum [`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]
    + `close`: last price of this candle
      + string
    + `open`: first price of this candle
      + string


# Funding [Auth]


## Setup Auto Offering


> Sample Request

```json
{
    "currency": "USDT",
    "period": 2,
    "interest_rate": "0.01",
    "size": "1"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "auto_offering": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "currency": "USDT",
            "size": "1",
            "interest_rate": "0.01",
            "period": 2,
            "active": true
        }
    }
}

```

`/v1/funding/auto_offerings [POST]`

Setup an auto offering.





### Request



  + `currency`: currency ID
    + string
  + `interest_rate`: interest rate of this auto offering will set
    + string
  + `period`: how many days this auto offering will set
    + integer
  + `size`: maximum offering size, 0 is unlimited
    + string

### Response



  + `auto_offering`: object
    + `currency`: currency ID
      + string
    + `active`: if this auto offering is active
      + boolean
    + `interest_rate`: interest rate of this auto offering will set
      + string
    + `size`: maximum offering size, 0 is unlimited
      + string
    + `period`: how many days this auto offering will set
      + integer
    + `id`: auto offering ID
      + string



## Get All Active Auto Offerings





> Sample Response

```json
{
    "success": true,
    "result": {
        "auto_offerings": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "currency": "USDT",
                "size": "1",
                "interest_rate": "0.01",
                "period": 2,
                "active": true
            }
        ]
    }
}

```

`/v1/funding/auto_offerings [GET]`

List all active auto offerings.







### Response



  + `auto_offerings`: array
    + `currency`: currency ID
      + string
    + `active`: if this auto offering is active
      + boolean
    + `interest_rate`: interest rate of this auto offering will set
      + string
    + `size`: maximum offering size, 0 is unlimited
      + string
    + `period`: how many days this auto offering will set
      + integer
    + `id`: auto offering ID
      + string



## Disable Auto Offering





> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/funding/auto_offerings/:currency_id [DELETE]`

Disable an auto offering.



### Path Parameters
  + `currency_id`: currency ID
    + string




### Response



  + null



## Get Auto Offering





> Sample Response

```json
{
    "success": true,
    "result": {
        "auto_offering": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "currency": "USDT",
            "size": "1",
            "interest_rate": "0.01",
            "period": 2,
            "active": true
        }
    }
}

```

`/v1/funding/auto_offerings/:currency_id [GET]`

Get information for an auto offering.



### Path Parameters
  + `currency_id`: currency ID
    + string




### Response



  + `auto_offering`: object
    + `currency`: currency ID
      + string
    + `active`: if this auto offering is active
      + boolean
    + `interest_rate`: interest rate of this auto offering will set
      + string
    + `size`: maximum offering size, 0 is unlimited
      + string
    + `period`: how many days this auto offering will set
      + integer
    + `id`: auto offering ID
      + string



## Get Funding Orders History





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "fundings": [
          {
              "id": "8850805e-d783-46ec-9af5-30712035e760",
              "period": 49,
              "type": "limit",
              "interest_rate": "0.05",
              "size": "1000.3002",
              "filled": "0",
              "currency": "COB",
              "side": "bid",
              "state": "filled",
              "completed_at": "2018-05-07T01:10:02.999169Z",
              "auto_refund": false,
              "position_id": null,
              "timestamp": 1529401868804
          }
        ]
    }
}

```

`/v1/funding/funding_history [GET]`

List historical funding orders.




### Query Parameters
  + `currency`: currency ID
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `fundings`: array
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `side`: funding side
      + enum [`bid`, `ask`]
    + `currency`: which currency of this fund
      + string
    + `state`: funding state
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: funding type
      + enum [`market`, `limit`]
    + `id`: funding ID
      + string
    + `filled`: how many money dealt
      + string
    + `size`: how many money provide/request
      + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer



## Place Funding Order


> Sample Request

```json
{
    "side": "bid",
    "type": "limit",
    "interest_rate": "0.05",
    "size": "1000.3002",
    "period": 49,
    "currency": "COB"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
      "funding": {
        "id": "8850805e-d783-46ec-9af5-30712035e760",
        "period": 49,
        "type": "limit",
        "interest_rate": "0.05",
        "size": "1000.3002",
        "filled": "0",
        "currency": "COB",
        "side": "bid",
        "state": "filled",
        "completed_at": "2018-05-07T01:10:02.999169Z",
        "auto_refund": false,
        "position_id": null,
        "timestamp": 1529401868804
      }
    }
}

```

`/v1/funding/fundings [POST]`

Place a funding order.





### Request



  + `currency`: Currency ID
    + string
  + `interest_rate`: Interest rate of this funding per day
    + string
  + `size`: How many money provide/request
    + string
  + `type`: funding type
    + enum [`market`, `limit`, `market_stop`, `limit_stop`]
  + `period`: How many days this funding request/offer
    + integer
  + `side`: funding side
    + enum [`bid`, `ask`]

### Response



  + `funding`: object
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `side`: funding side
      + enum [`bid`, `ask`]
    + `currency`: which currency of this fund
      + string
    + `state`: funding state
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: funding type
      + enum [`market`, `limit`]
    + `id`: funding ID
      + string
    + `filled`: how many money dealt
      + string
    + `size`: how many money provide/request
      + string



## Get Open Funding Orders





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "fundings": [
          {
              "id": "8850805e-d783-46ec-9af5-30712035e760",
              "period": 49,
              "type": "limit",
              "interest_rate": "0.05",
              "size": "1000.3002",
              "filled": "0",
              "currency": "COB",
              "side": "bid",
              "state": "filled",
              "completed_at": "2018-05-07T01:10:02.999169Z",
              "auto_refund": false,
              "position_id": null,
              "timestamp": 1529401868804
          }
        ]
    }
}

```

`/v1/funding/fundings [GET]`

List all open funding orders for a user.




### Query Parameters
  + `currency`: currency ID
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `fundings`: array
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `side`: funding side
      + enum [`bid`, `ask`]
    + `currency`: which currency of this fund
      + string
    + `state`: funding state
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: funding type
      + enum [`market`, `limit`]
    + `id`: funding ID
      + string
    + `filled`: how many money dealt
      + string
    + `size`: how many money provide/request
      + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer



## Modify Funding Order


> Sample Request

```json
{
    "interest_rate": "0.08",
    "size": "100000.300"
}

```




> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/funding/fundings/:funding_id [PUT]`

Modify a funding order.



### Path Parameters
  + `funding_id`: funding ID
    + string


### Request



  + `interest_rate`: interest rate per day
    + string
  + `size`: amount
    + string

### Response



  + null



## Cancel Funding Order





> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/funding/fundings/:funding_id [DELETE]`

Cancel an funding order.



### Path Parameters
  + `funding_id`: funding ID
    + string




### Response



  + null



## Get All Loans





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "loans": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "timestamp": 1529020800,
                "currency": "USDT",
                "size": "1",
                "interest_rate": "0.01",
                "period": 2,
                "state": "active",
                "will_close_at": "2018-05-23T04:20:50.304063Z",
                "completed_at": null,
                "auto_refund": false,
                "side": "ask",
                "maker_side": "ask"
            }
        ]
    }
}

```

`/v1/funding/loans [GET]`

List all loans for a user.




### Query Parameters
  + `currency_id`: currency ID
    + string
  + `state`: state filter of loan, possible values are `in_use` and `active`.
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `side`: side filter of loan, possible values are `ask` and `bid`.
    + string



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `loans`: array
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `will_close_at`: the expected close time of the loan
      + string
    + `auto_refund`: if the loan will be auto close
      + boolean
    + `completed_at`: the complete time of the loan
      + ['string', 'null']
    + `timestamp`: created timestamp in unix timestamp
      + integer
    + `interest_rate`: interest rate of the loan
      + string
    + `period`: valid period of the loan
      + integer
    + `side`: loan side
      + enum [`bid`, `ask`]
    + `currency`: currency ID
      + string
    + `state`: 
      + enum [`in_use`, `active`, `closed`]
    + `id`: loan ID
      + string
    + `size`: loan amount
      + string
  + `limit`: pagingnation limit number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `page`: pagingnation page number
    + integer



## Close Loan





> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/funding/loans/:loan_id [DELETE]`

Close a loan manually.



### Path Parameters
  + `loan_id`: loan ID
    + string




### Response



  + null



## Get Loan





> Sample Response

```json
{
    "success": true,
    "result": {
        "loan": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "timestamp": 1529020800,
            "currency": "USDT",
            "size": "1",
            "interest_rate": "0.01",
            "period": 2,
            "state": "active",
            "will_close_at": "2018-05-23T04:20:50.304063Z",
            "completed_at": null,
            "auto_refund": false,
            "side": "ask",
            "maker_side": "ask"
        }
    }
}

```

`/v1/funding/loans/:loan_id [GET]`

Get information for a single loan.



### Path Parameters
  + `loan_id`: loan ID
    + string




### Response



  + `loan`: object
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `will_close_at`: the expected close time of the loan
      + string
    + `auto_refund`: if the loan will be auto close
      + boolean
    + `completed_at`: the complete time of the loan
      + ['string', 'null']
    + `timestamp`: created timestamp in unix timestamp
      + integer
    + `interest_rate`: interest rate of the loan
      + string
    + `period`: valid period of the loan
      + integer
    + `side`: loan side
      + enum [`bid`, `ask`]
    + `currency`: currency ID
      + string
    + `state`: 
      + enum [`in_use`, `active`, `closed`]
    + `id`: loan ID
      + string
    + `size`: loan amount
      + string


# Market


## Get Currencies





> Sample Response

```json
{
    "success": true,
    "result": {
        "currencies": [
            {
                "cob_withdrawal_fee": "18.16970378",
                "currency": "REP",
                "deposit_fee" : "0",
                "deposit_frozen": false,
                "funding_enabled" : true,
                "funding_min_size" : "968.853",
                "interest_increment": "0.001",
                "min_unit": "0.00000001",
                "min_withdrawal": "0.20387",
                "name": "Augur",
                "optional_field_text": null,
                "quotation_enabled" : false,
                "required_kyc_level" : 1,
                "type": "erc20",
                "withdrawal_fee": "0.06",
                "withdrawal_frozen": false
            }
        ]
    }
}

```

`/v1/market/currencies [GET]`

This endpoint returns all supported currencies and related information.







### Response



  + `currencies`: array
    + `currency`: the currency id
      + string
    + `interest_increment`: the interest increment rate while margining
      + string
    + `withdrawal_fee`: withdrawal fee with same currency
      + string
    + `deposit_fee`: deposit fee with same currency
      + string
    + `quotation_enabled`: available for quotation
      + boolean
    + `required_kyc_level`: the required kyc level to deposit and withdrawal currency
      + integer
    + `deposit_frozen`: available for deposit
      + boolean
    + `optional_field_text`: displaying field name of remarks for specific currency. e.g. `memo` for EOS, `payment_id` for Monero.
      + ['string', 'null']
    + `name`: the currency name
      + string
    + `funding_enabled`: available for funding
      + boolean
    + `min_withdrawal`: minimal available withdrawal size
      + string
    + `cob_withdrawal_fee`: withdrawal fee with COB
      + string
    + `withdrawal_frozen`: available for withdrawal
      + boolean
    + `min_unit`: the currency minimum unit
      + string
    + `type`: currency type
      + enum [`erc20`, `native`, `qrc20`, `atp10`, `fiat`, `vrc20`, `eosio`]
    + `funding_min_size`: minimal funding size
      + string



## Get Fundingbook Precisions





> Sample Response

```json
{
    "success": true,
    "result": {
        "precisions": [
            "1E-7",
            "5E-7",
            "1E-6",
            "5E-6",
            "1E-5",
            "5E-5",
            "1E-4",
            "5E-4",
            "1E-3",
            "5E-3",
            "1E-2",
            "5E-2"
          ]
    }
}

```

`/v1/market/fundingbook/precisions/:currency_id [GET]`

Returns available precisions in scientific notation of funndingbook by given currency.



### Path Parameters
  + `trading_pair_id`: currency symbol/id
    + string




### Response



  + `precisions`: array
    + string



## Get Fundingbook





> Sample Response

```json
{
    "success": true,
    "result": {
        "fundingbook": {
            "sequence": 0,
            "bids": [
                [
                    "0.0830804",
                    "1",
                    "3.7387",
                    "1",
                    "3"
                ]
            ],
            "asks": [
                [
                    "0.0834349",
                    "1",
                    "5.3396",
                    "2",
                    "2"
                ]
            ]
        }
    }
}

```

`/v1/market/fundingbooks/:currency_id [GET]`

Return fundingbook of given currency.



### Path Parameters
  + `trading_pair_id`: currency symbol/id
    + string

### Query Parameters
  + `limit`: limits number of price point. Optional. If limit is 0, the whole fundingbook is returned. Default and max as 50, min 1
    + integer
  + `precision`: precision of fundingbook aggregation. Optional. Default the most precise level
    + string



### Response



  + `fundingbook`: object
    + `bids`: rate, count, volume, min_period, max_period
      + array
      + string
    + `asks`: rate, count, volume, min_period, max_period
      + array
      + string
    + `sequence`: legacy attribute
      + integer



## Get Orderbook Precisions





> Sample Response

```json
{
    "success": true,
    "result": [
      "1E-7",
      "5E-7",
      "1E-6",
      "5E-6",
      "1E-5",
      "5E-5",
      "1E-4",
      "5E-4",
      "1E-3",
      "5E-3",
      "1E-2",
      "5E-2"
    ]
}

```

`/v1/market/orderbook/precisions/:trading_pair_id [GET]`

Returns available precisions in scientific notation of orderbook by given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string




### Response



  + string



## Get Orderbook





> Sample Response

```json
{
    "success": true,
    "result": {
        "orderbook": {
            "sequence": 0,
            "bids": [
                [
                    "0.0830804",
                    "1",
                    "3.7387"
                ]
            ],
            "asks": [
                [
                    "0.0834349",
                    "1",
                    "5.3396"
                ]
            ]
        }
    }
}

```

`/v1/market/orderbooks/:trading_pair_id [GET]`

Return orderbook of given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string

### Query Parameters
  + `limit`: limits number of price point. Optional. If limit is 0, the whole orderbook is returned. Default and max as 50, min 1
    + integer
  + `precision`: precision of orderbook aggregation. Optional. Default the most precise level
    + string



### Response



  + `orderbook`: object
    + `bids`: price, count, volume
      + array
      + string
    + `asks`: price, count, volume
      + array
      + string
    + `sequence`: legacy attribute
      + integer



## Get Quote Currencies





> Sample Response

```json
{
    "success": true,
    "result": {
        "quote_currencies": [
            {
                "cob_withdrawal_fee": "18.16970378",
                "currency": "REP",
                "deposit_fee" : "0",
                "deposit_frozen": false,
                "funding_enabled" : true,
                "funding_min_size" : "968.853",
                "interest_increment": "0.001",
                "min_unit": "0.00000001",
                "min_withdrawal": "0.20387",
                "name": "Augur",
                "optional_field_text": null,
                "quotation_enabled": false,
                "required_kyc_level" : 1,
                "type": "erc20",
                "withdrawal_fee": "0.06",
                "withdrawal_frozen": false
            }
        ]
    }
}

```

`/v1/market/quote_currencies [GET]`

This endpoint returns all supported quote currencies and related information.







### Response



  + `quote_currencies`: array
    + `currency`: the currency id
      + string
    + `interest_increment`: the interest increment rate while margining
      + string
    + `withdrawal_fee`: withdrawal fee with same currency
      + string
    + `deposit_fee`: deposit fee with same currency
      + string
    + `quotation_enabled`: available for quotation
      + boolean
    + `required_kyc_level`: the required kyc level to deposit and withdrawal currency
      + integer
    + `deposit_frozen`: available for deposit
      + boolean
    + `optional_field_text`: displaying field name of remarks for specific currency. e.g. `memo` for EOS, `payment_id` for Monero.
      + ['string', 'null']
    + `name`: the currency name
      + string
    + `funding_enabled`: available for funding
      + boolean
    + `min_withdrawal`: minimal available withdrawal size
      + string
    + `cob_withdrawal_fee`: withdrawal fee with COB
      + string
    + `withdrawal_frozen`: available for withdrawal
      + boolean
    + `min_unit`: the currency minimum unit
      + string
    + `type`: currency type
      + enum [`erc20`, `native`, `qrc20`, `atp10`, `fiat`, `vrc20`, `eosio`]
    + `funding_min_size`: minimal funding size
      + string



## Show Exchange statistics





> Sample Response

```json
{
    "success": true,
    "result": {
        "ETH-BTC": {
            "id": "ETH-BTC",
            "last_price": "0.0836",
            "lowest_ask": "0.0837158",
            "highest_bid": "0.083461",
            "base_volume": "302.09964207",
            "quote_volume": "25.347837637256305",
            "is_frozen": false,
            "high_24hr": "0.08519",
            "low_24hr": "0.0825143",
            "percent_changed_24hr": "0.0023980815347722"
        }
    }
}

```

`/v1/market/stats [GET]`

Returns exchange statistics in past 24 hours by trading pair.







### Response



  + `[A-Z]{2,6}-[A-Z]{2,6}`: object
    + `percent_changed_24hr`: the precent changed in previous 24hr
      + string
    + `lowest_ask`: the lowest ask on orderbook when querying
      + string
    + `base_volume`: the volume of base currency
      + string
    + `last_price`: latest price in previous 24hr
      + string
    + `high_24hr`: the highest price in previous 24hr
      + string
    + `highest_bid`: the highest bid on orderbook when querying
      + string
    + `low_24hr`: the lowest price in previous 24hr
      + string
    + `quote_volume`: the volume of quote currency
      + string
    + `is_frozen`: trading pair available or not
      + boolean
    + `id`: trading pair id
      + string



## Get Tickers





> Sample Response

```json
{
    "success": true,
    "result": {
        "tickers": [
            {
                "trading_pair_id": "ETH-BTC",
                "timestamp": 1526442600000,
                "24h_high": "0.08519",
                "24h_low": "0.0825143",
                "24h_open": "0.0832193",
                "24h_volume": "297.48782148000026",
                "last_trade_price": "0.0839425",
                "highest_bid": "0.083694",
                "lowest_ask": "0.0839903"
            }
        ]
    }
}

```

`/v1/market/tickers [GET]`

Returns all trading pair tickers.







### Response



  + `tickers`: array
    + `trading_pair_id`: trading pair symbol
      + string
    + `lowest_ask`: lowest ask on orderbook while querying
      + string
    + `24h_volume`: summation of volume in previous 24hr
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `highest_bid`: highest bid on orderbook while querying
      + string
    + `24h_low`: lowest price in previous 24hr
      + string
    + `24h_high`: highest price in previous 24hr
      + string
    + `last_trade_price`: last price in previous 24hr
      + string
    + `24h_open`: first price in previous 24hr
      + string



## Get Ticker





> Sample Response

```json
{
    "success": true,
    "result": {
        "ticker": {
          "trading_pair_id": "ETH-BTC",
          "timestamp": 1526442660000,
          "24h_high": "0.08519",
          "24h_low": "0.0825143",
          "24h_open": "0.083655",
          "24h_volume": "296.60529380000025",
          "last_trade_price": "0.0839425",
          "highest_bid": "0.0836897",
          "lowest_ask": "0.0839091"
        }
    }
}

```

`/v1/market/tickers/:trading_pair_id [GET]`

Return trading pair of given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string




### Response



  + `ticker`: object
    + `trading_pair_id`: trading pair symbol
      + string
    + `lowest_ask`: lowest ask on orderbook while querying
      + string
    + `24h_volume`: summation of volume in previous 24hr
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `highest_bid`: highest bid on orderbook while querying
      + string
    + `24h_low`: lowest price in previous 24hr
      + string
    + `24h_high`: highest price in previous 24hr
      + string
    + `last_trade_price`: last price in previous 24hr
      + string
    + `24h_open`: first price in previous 24hr
      + string



## Get Trades





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "trades": [
            {
                "id": "c0008469-1dd0-45d7-bbcc-97879ded8232",
                "trading_pair_id": "BTC-USDT",
                "maker_side": "bid",
                "timestamp": 1526441812535,
                "price": "0.0837002",
                "size": "0.06135"
            }
        ]
    }
}

```

`/v1/market/trades/:trading_pair_id [GET]`

Returns recently 50 periodly updated, cached trades of given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string




### Response



  + `trades`: array
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `trading_pair_id`: trading pair ID
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `price`: the trade price
      + string
    + `id`: unique id of trade
      + string
    + `size`: the trade size
      + string



## Get Trades with pagination





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "trades": [
            {
                "id": "c0008469-1dd0-45d7-bbcc-97879ded8232",
                "trading_pair_id": "BTC-USDT",
                "maker_side": "bid",
                "timestamp": 1526441812535,
                "price": "0.0837002",
                "size": "0.06135"
            }
        ]
    }
}

```

`/v1/market/trades_history/:trading_pair_id [GET]`

Returns trades of given trading pair, pagination supported, order by timestamp, descending.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string

### Query Parameters
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `end_time`: optional, end timestamp unix timestamp in milliseconds, default is now
    + integer



### Response



  + `trades`: array
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `trading_pair_id`: trading pair ID
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `price`: the trade price
      + string
    + `id`: unique id of trade
      + string
    + `size`: the trade size
      + string



## Get Trading Pairs





> Sample Response

```json
{
    "success": true,
    "result": {
        "trading_pairs": [
            {
                "id": "ETH-BTC",
                "base_currency_id": "ETH",
                "quote_currency_id": "BTC",
                "base_max_size": "1361.889",
                "base_min_size": "0.027",
                "quote_increment": "0.0000001",
                "margin_enabled": false,
                "maker_fee": "0",
                "taker_fee": "0"
            }
        ]
    }
}

```

`/v1/market/trading_pairs [GET]`

Returns all supported trading pairs and related information.







### Response



  + `trading_pairs`: array
    + `base_currency_id`: the base currency symbol
      + string
    + `margin_enabled`: available for margin
      + boolean
    + `maker_fee`: maker fee
      + string
    + `quote_increment`: the quote incremental step
      + string
    + `base_max_size`: max base volume size
      + string
    + `taker_fee`: taker fee
      + string
    + `quote_currency_id`: the quote currency symbol
      + string
    + `id`: the trading pair symbol
      + string
    + `base_min_size`: min base volume size
      + string


# System


## Get System Time





> Sample Response

```json
{
    "success": true,
    "result": {
        "time": 1505204498376
    }
}

```

`/v1/system/time [GET]`

Get the reference system time as Unix timestamp.







### Response



  + `time`: server Unix timestamp in milliseconds
    + integer


# Trading [Auth]


## Check Order


> Sample Request

```json
{
    "trading_pair_id": "BTC-USDT",
    "side": "bid",
    "type": "limit_stop",
    "stop_price": "5000.01000000"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "may_execute_immediately": true
    }
}

```

`/v1/trading/check_order [POST]`

Check conditional order will be executed immediately.





### Request



  + `trading_pair_id`: trading pair ID
    + string
  + `stop_price`: order stop price
    + string
  + `side`: order side
    + enum [`bid`, `ask`]
  + `type`: order type
    + enum [`market_stop`, `limit_stop`]

### Response



  + `may_execute_immediately`: boolean



## Get Order History





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "orders": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "trading_pair_id": "COB-ETH",
                "side": "bid",
                "type": "limit",
                "price": "0.0001195",
                "size": "212",
                "filled": "212",
                "state": "filled",
                "timestamp": 1526018972869,
                "eq_price": "0.0001194999996323",
                "completed_at": "2018-05-11T06:09:38.946678Z",
                "source": "exchange"
            }
        ]
    }
}

```

`/v1/trading/order_history [GET]`

Get historical orders.




### Query Parameters
  + `trading_pair_id`: trading pair ID
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `orders`: array
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + ['string', 'null']
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `side`: order side
      + enum [`bid`, `ask`]
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + ['string', 'null']
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `id`: order ID
      + string
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string



## Place Order


> Sample Request

```json
{
    "trading_pair_id": "BTC-USDT",
    "side": "bid",
    "type": "limit",
    "price": "5000.01000000",
    "size": "1.0100",
    "stop_price": null,
    "trailing_distance": null
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "order": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "trading_pair_id": "COB-ETH",
            "side": "bid",
            "type": "limit",
            "price": "0.0001195",
            "size": "212",
            "filled": "212",
            "state": "filled",
            "timestamp": 1526018972869,
            "eq_price": "0.0001194999996323",
            "completed_at": "2018-05-11T06:09:38.946678Z",
            "source": "exchange"
        }
    }
}

```

`/v1/trading/orders [POST]`

Place an order.





### Request



  + `trading_pair_id`: trading pair ID
    + string
  + `stop_price`: optional, type should be `limit_stop` or `market_stop`
    + ['string', 'null']
  + `price`: optional, `market` type will ignore
    + string
  + `source`: optional, order source, default is `exchange`
    + enum [`exchange`, `margin`]
  + `trailing_distance`: order trailing distance
    + ['string', 'null']
  + `type`: order type
    + enum [`market`, `limit`, `market_stop`, `limit_stop`]
  + `side`: order side
    + enum [`bid`, `ask`]
  + `size`: base amount
    + string

### Response



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + ['string', 'null']
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `side`: order side
      + enum [`bid`, `ask`]
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + ['string', 'null']
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `id`: order ID
      + string
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string



## Get Open Orders





> Sample Response

```json
{
    "success": true,
    "result": {
        "limit": 50,
        "page": 1,
        "total_count": 1,
        "total_page": 1,
        "orders": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "trading_pair_id": "COB-ETH",
                "side": "bid",
                "type": "limit",
                "price": "0.0001195",
                "size": "212",
                "filled": "212",
                "state": "filled",
                "timestamp": 1526018972869,
                "eq_price": "0.0001194999996323",
                "completed_at": "2018-05-11T06:09:38.946678Z",
                "source": "exchange"
            }
        ]
    }
}

```

`/v1/trading/orders [GET]`

List all open orders for a user.




### Query Parameters
  + `trading_pair_id`: trading pair ID
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `orders`: array
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + ['string', 'null']
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `side`: order side
      + enum [`bid`, `ask`]
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + ['string', 'null']
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `id`: order ID
      + string
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string



## Modify Order


> Sample Request

```json
{
    "price": "5000.01000000",
    "size": "1.0100"
}

```




> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/trading/orders/:order_id [PUT]`

Modify an order.



### Path Parameters
  + `order_id`: order ID
    + string


### Request



  + `price`: order price. No need if `market_stop`.
    + string
  + `stop_price`: order stop price. Must have if `market_stop` or `limit_stop`
    + ['string', 'null']
  + `size`: base amount
    + string

### Response



  + null



## Cancel Order





> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/trading/orders/:order_id [DELETE]`

Cancel an order.



### Path Parameters
  + `order_id`: order ID
    + string




### Response



  + null



## Get Order





> Sample Response

```json
{
    "success": true,
    "result": {
        "order": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "trading_pair_id": "COB-ETH",
            "side": "bid",
            "type": "limit",
            "price": "0.0001195",
            "size": "212",
            "filled": "212",
            "state": "filled",
            "timestamp": 1526018972869,
            "eq_price": "0.0001194999996323",
            "completed_at": "2018-05-11T06:09:38.946678Z",
            "source": "exchange"
        }
    }
}

```

`/v1/trading/orders/:order_id [GET]`

Get information for a single order.



### Path Parameters
  + `order_id`: order ID
    + string




### Response



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + ['string', 'null']
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `side`: order side
      + enum [`bid`, `ask`]
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + ['string', 'null']
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `id`: order ID
      + string
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string



## Get Trades of Order





> Sample Response

```json
{
    "success": true,
    "result": {
        "trades": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "trading_pair_id": "COB-ETH",
                "maker_side": "bid",
                "price": "0.0001195",
                "size": "212",
                "timestamp": 1526540686123
            }
        ]
    }
}

```

`/v1/trading/orders/:order_id/trades [GET]`

Get trades which fill the specific order.



### Path Parameters
  + `order_id`: order ID
    + string




### Response



  + `trades`: array
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `trading_pair_id`: trading pair ID
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `price`: the trade price
      + string
    + `id`: unique id of trade
      + string
    + `size`: the trade size
      + string



## Get All Open Positions





> Sample Response

```json
{
    "success": true,
    "result": {
        "positions": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "trading_pair_id": "COB-ETH",
                "base_size": "0",
                "quote_size": "0",
                "base_on_order": "0",
                "quote_on_order": "0",
                "eq_price": "0",
                "interest": "0",
                "profit": "0",
                "liq_price": "0"
            }
        ]
    }
}

```

`/v1/trading/positions [GET]`

List all open positions for a user.







### Response



  + `positions`: array
    + `eq_price`: the equivalance price of the position
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `quote_on_order`: amount of quote currency on order
      + string
    + `profit`: position profit at current market price
      + string
    + `liq_price`: liquidation price of the position
      + string
    + `quote_size`: amount of quote currency of the position
      + string
    + `base_size`: amount of base currency of the position
      + string
    + `base_on_order`: amount of base currency on order
      + string
    + `interest`: amount of interest has paid for the position
      + string
    + `id`: position ID
      + string



## Claim Position


> Sample Request

```json
{
    "size": "1.0100"
}

```




> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/trading/positions/:trading_pair_id [PATCH]`

Claim a position



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string


### Request



  + `size`: claim size, should be a positive number
    + string

### Response



  + null



## Get Position





> Sample Response

```json
{
    "success": true,
    "result": {
        "position": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "trading_pair_id": "COB-ETH",
            "base_size": "0",
            "quote_size": "0",
            "base_on_order": "0",
            "quote_on_order": "0",
            "eq_price": "0",
            "interest": "0",
            "profit": "0",
            "liq_price": "0"
        }
    }
}

```

`/v1/trading/positions/:trading_pair_id [GET]`

Get information for a single position.



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string




### Response



  + `position`: object
    + `eq_price`: the equivalance price of the position
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `quote_on_order`: amount of quote currency on order
      + string
    + `profit`: position profit at current market price
      + string
    + `liq_price`: liquidation price of the position
      + string
    + `quote_size`: amount of quote currency of the position
      + string
    + `base_size`: amount of base currency of the position
      + string
    + `base_on_order`: amount of base currency on order
      + string
    + `interest`: amount of interest has paid for the position
      + string
    + `id`: position ID
      + string



## Close Position





> Sample Response

```json
{
    "success": true,
    "result": {
        "order": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "trading_pair_id": "COB-ETH",
            "side": "bid",
            "type": "market",
            "price": "0",
            "size": "212",
            "filled": "0",
            "state": "queued",
            "timestamp": 1526018972869,
            "eq_price": "0",
            "completed_at": null,
            "source": "margin"
        }
    }
}

```

`/v1/trading/positions/:trading_pair_id [DELETE]`

Close a position.



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string




### Response



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + ['string', 'null']
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `side`: order side
      + enum [`bid`, `ask`]
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + ['string', 'null']
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `id`: order ID
      + string
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string



## Get Claimable Size





> Sample Response

```json
{
    "success": true,
    "result": {
        "size": "1"
    }
}

```

`/v1/trading/positions/:trading_pair_id/claimable_size [GET]`

Get claimable size depend on user's balance



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string




### Response



  + `size`: claimable size
    + string



## Get Trade History





> Sample Response

```json
{
    "success": true,
    "result": {
        "total_page" : 1,
        "total_count" : 1,
        "page" : 1,
        "limit" : 50,
        "trades": [
            {
                "id": "8850805e-d783-46ec-9af5-30712035e760",
                "trading_pair_id": "COB-ETH",
                "maker_side": "bid",
                "price": "0.0001195",
                "size": "212",
                "timestamp": 1526540686123
            }
        ]
    }
}

```

`/v1/trading/trades [GET]`

Get historical trades.




### Query Parameters
  + `trading_pair_id`: trading pair ID
    + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `trades`: array
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `trading_pair_id`: trading pair ID
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `price`: the trade price
      + string
    + `id`: unique id of trade
      + string
    + `size`: the trade size
      + string
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer



## Get Trade





> Sample Response

```json
{
    "success": true,
    "result": {
        "trade": {
            "id": "8850805e-d783-46ec-9af5-30712035e760",
            "trading_pair_id": "COB-ETH",
            "maker_side": "bid",
            "price": "0.0001195",
            "size": "212",
            "timestamp": 1526540686123
        }
    }
}

```

`/v1/trading/trades/:trade_id [GET]`

Get information for a single trade.



### Path Parameters
  + `trade_id`: trade ID
    + string




### Response



  + `trade`: object
    + `maker_side`: maker side
      + enum [`bid`, `ask`]
    + `trading_pair_id`: trading pair ID
      + string
    + `timestamp`: unix timestamp in milliseconds
      + integer
    + `price`: the trade price
      + string
    + `id`: unique id of trade
      + string
    + `size`: the trade size
      + string



## Get Trading Volume





> Sample Response

```json
{
    "success": true,
    "result": {
        "volume": {
            "currency_id": "BTC",
            "sum": "0.1"
        }
    }
}

```

`/v1/trading/volume [GET]`

Get trading volume within a time.




### Query Parameters
  + `currency_id`: currency ID
    + string
  + `start_time`: optional, start timestamp unix timestamp in milliseconds, default is 1 month before now
    + integer
  + `end_time`: optional, end timestamp unix timestamp in milliseconds, default is now
    + integer



### Response



  + `volume`: object
    + `currency_id`: currency ID
      + string
    + `sum`: trading volume
      + string


# Wallet [Auth]


## Get Balances





> Sample Response

```json
{
    "success": true,
    "result": {
        "balances": [
            {
                "currency": "ETH",
                "type": "exchange",
                "total": "1.2",
                "on_order": "0",
                "locked": false,
                "usd_value": "866.0784",
                "btc_value": "0.06095616"
            }
        ]
    }
}

```

`/v1/wallet/balances [GET]`

Get currencies, amounts, types, status of balances.




### Query Parameters
  + `currency`: Currency ID (optional, default to all currencies)
    + string
  + `type`: type of ledger
    + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]



### Response



  + `balances`: array
    + `currency`: Currency ID
      + string
    + `btc_value`: Market value in BTC
      + string
    + `locked`: Whether the balance is locked
      + boolean
    + `on_order`: Amount of the balance on order
      + string
    + `total`: Total amount of the balance
      + string
    + `type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `usd_value`: Market value in USDT
      + string



## Get Ledger in CSV





> Sample Response

```json
{
    "success": true
}

```

`/v1/wallet/csv/ledgers [GET]`

Get CSV file in ledgers by the begin time.





### Query Parameters
  + `begin_time`: Unix timestamp in seconds.
    + string



### Response




  + `success`: boolean



## Create New Deposit Address


> Sample Request

```json
{
    "currency": "BTC",
    "ledger_type": "exchange"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "deposit_address": {
            "address": "0x5BDfdC2fC119C9Cc485B6d6d6ce55dc6E5CCCb13",
            "blockchain_id": "ethereum",
            "created_at": 1528251226750,
            "currency": "ETH",
            "id": "a14147d0-ef5a-41b8-8a00-5bfa14d4fd91",
            "type": "exchange"
        }
    }
}

```

`/v1/wallet/deposit_addresses [POST]`

desc





### Request



  + `currency`: currency
    + string
  + `ledger_type`: type of ledger
    + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]

### Response



  + `deposit_address`: object
    + `currency`: currency
      + string
    + `blockchain_id`: blockchain id, default for testing only.
      + enum [`achain`, `bitcoin`, `bitcoin-cash`, `default`, `eosio`, `ethereum`, `litecoin`, `monero`, `neo`, `omni`, `qtum`, `ripple`]
    + `address`: deposit address
      + string
    + `created_at`: unix timestamp in milliseconds
      + integer
    + `type`: type of usage
      + string
    + `id`: deposit wallet id
      + string
    + `memo`: If memo is `null`, this field will be omitted.
      + ['string', 'null']



## Create IOTA Deposit Address





> Sample Response

```json
{
    "success": true,
    "result": {
        "deposit_address": {
            "currency": "MIOTA",
            "type": "exchange",
            "address": "GRIUAMSEAKOGECZYTPXLECJPFUOS9URIJZOBHTDVQDOTVWJKNPLCAPXFMGTD9CNUFNP9EEVBIISRCVEIYMNVIPSTJX",
            "created_at": 1504459805123
        }
    }
}

```

`/v1/wallet/deposit_addresses/iota [POST]`

Create an IOTA address for deposit.







### Response



  + `deposit_address`: object
    + `currency`: currency
      + string
    + `blockchain_id`: blockchain id, default for testing only.
      + enum [`achain`, `bitcoin`, `bitcoin-cash`, `default`, `eosio`, `ethereum`, `litecoin`, `monero`, `neo`, `omni`, `qtum`, `ripple`]
    + `address`: deposit address
      + string
    + `created_at`: unix timestamp in milliseconds
      + integer
    + `type`: type of usage
      + string
    + `id`: deposit wallet id
      + string
    + `memo`: If memo is `null`, this field will be omitted.
      + ['string', 'null']



## Create IOTA Deposit Address





> Sample Response

```json
{
    "success": true,
    "result": {
        "deposit_address": {
            "currency": "MIOTA",
            "type": "exchange",
            "address": "GRIUAMSEAKOGECZYTPXLECJPFUOS9URIJZOBHTDVQDOTVWJKNPLCAPXFMGTD9CNUFNP9EEVBIISRCVEIYMNVIPSTJX",
            "created_at": 1504459805123
        }
    }
}

```

`/v1/wallet/deposit_addresses/iota [GET]`

Create an IOTA address for deposit.







### Response



  + `deposit_address`: object
    + `currency`: currency
      + string
    + `blockchain_id`: blockchain id, default for testing only.
      + enum [`achain`, `bitcoin`, `bitcoin-cash`, `default`, `eosio`, `ethereum`, `litecoin`, `monero`, `neo`, `omni`, `qtum`, `ripple`]
    + `address`: deposit address
      + string
    + `created_at`: unix timestamp in milliseconds
      + integer
    + `type`: type of usage
      + string
    + `id`: deposit wallet id
      + string
    + `memo`: If memo is `null`, this field will be omitted.
      + ['string', 'null']



## Get All Generic Deposits





> Sample Response

```json
{
    "success": true,
    "result": {
        "generic_deposits": [
            {
               "id": "ac7a286d-8524-435c-9606-0453a620fe52",
               "is_cancelled": false,
               "type": "deposit_type_internal_transfer",
               "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
               "currency_id": "SHPING",
               "ledger_type": "exchange",
               "btc_value": "5.566",
               "description": "Internal transfer [0xd47ed407b54f4124f90f9e09bbd1f981ddfc7e4fd201e9fc6bea5008b2c3987e]. Slot machine reward SHPING.",
               "amount": "1",
               "fee": "0",
               "created_at": 1526355806190,
               "completed_at": 1526355806208,
               "status": "tx_confirmed",
               "additional_info": {
                   "tx_hash": "d47ed407b54f4124f90f9e09bbd1f981ddfc7e4fd201e9fc6bea5008b2c3987e"
               }
            },
            {
               "id": "ac7a286d-8524-435c-9606-0453a620fe53",
               "is_cancelled": false,
               "type": "deposit_type_blockchain",
               "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
               "currency_id": "BTC",
               "ledger_type": "coblet",
               "btc_value": "5.566",
               "description": "",
               "amount": "0.1",
               "fee": "0",
               "created_at": 1526355806190,
               "completed_at": 1526355806208,
               "status": "tx_confirmed",
               "additional_info": {
                   "tx_hash": "d47ed407b54f4124f90f9e09ddb1f981ddfc7e4fd201e9fc6bea5008b2c3987e"
               }
            }
        ]
    }
}

```

`/v1/wallet/generic_deposits [GET]`

Get informations for generic deposits.
This endnpoint is equipped with <a href="#custom-query-amp-pagination">custom-query</a>.








### Response



  + `generic_deposits`: array
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `btc_value`: Market value in BTC
      + string
    + `fee`: fee of this generic deposit
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `additional_info`: If memo is `null`, this field will be omitted.
      + object
      + `memo`: ['string', 'null']
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + ['integer', 'null']
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic deposit type
      + enum [`deposit_type_blockchain`, `deposit_type_epay`, `deposit_type_iota`, `deposit_type_internal_transfer`, `deposit_type_internal_deposit`, `deposit_type_manual_deposit`]
    + `id`: unique id of generic deposit
      + string



## Get Generic Deposit





> Sample Response

```json
{
    "success": true,
    "result": {
        "generic_deposit": {
            "id": "ac7a286d-8524-435c-9606-0453a620fe52",
            "is_cancelled": false,
            "type": "deposit_type_internal_transfer",
            "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
            "currency_id": "SHPING",
            "ledger_type": "exchange",
            "btc_value": "5.566",
            "description": "Internal transfer [0xd47ed407b54f4124f90f9e09bbd1f981ddfc7e4fd201e9fc6bea5008b2c3987e]. Slot machine reward SHPING.",
            "amount": "1",
            "fee": "0",
            "created_at": 1526355806190,
            "completed_at": 1526355806208,
            "status": "tx_confirmed",
            "additional_info": {
                "tx_hash": "d47ed407b54f4124f90f9e09bbd1f981ddfc7e4fd201e9fc6bea5008b2c3987e"
            }
        }
    }
}

```

`/v1/wallet/generic_deposits/:generic_deposit_id [GET]`

Get information for a single generic deposit.



### Path Parameters
  + `generic_deposit_id`: generic deposit ID
    + string




### Response



  + `generic_deposit`: object
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `btc_value`: Market value in BTC
      + string
    + `fee`: fee of this generic deposit
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `additional_info`: If memo is `null`, this field will be omitted.
      + object
      + `memo`: ['string', 'null']
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + ['integer', 'null']
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic deposit type
      + enum [`deposit_type_blockchain`, `deposit_type_epay`, `deposit_type_iota`, `deposit_type_internal_transfer`, `deposit_type_internal_deposit`, `deposit_type_manual_deposit`]
    + `id`: unique id of generic deposit
      + string



## Get All Generic Withdrawals





> Sample Response

```json
{
    "success": true,
    "result": {
        "generic_withdrawals": [
            {
                "id": "2560c791-f874-4abd-bb40-647b2d38ef71",
                "is_cancelled": false,
                "type": "withdrawal_type_internal_transfer",
                "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
                "currency_id": "COB",
                "ledger_type": "exchange",
                "btc_value": "5.566",
                "description": "Internal transfer [0x304a396347cdf858bd3ce7337f061b5de04788d16b19d105d77816301614c1ef]. Prize redemption of 10 COB",
                "amount": "10",
                "approval_motion_id": null,
                "created_at": 1526020394504,
                "completed_at": 1526020394523,
                "status": "tx_confirmed",
                "additional_info": {
                    "tx_hash": "304a396347cdf858bd3ce7337f061b5de04788d16b19d105d77816301614c1ef"
                }
            },
            {
                "id": "2560d791-f874-4abd-bb40-647b2d38ef71",
                "is_cancelled": false,
                "type": "withdrawal_type_blockchain",
                "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
                "currency_id": "ETH",
                "ledger_type": "coblet",
                "btc_value": "5.566",
                "description": "",
                "amount": "0.1",
                "approval_motion_id": null,
                "created_at": 1526020394504,
                "completed_at": 1526020394523,
                "status": "tx_confirmed",
                "additional_info": {
                    "tx_hash": "304a396347cdf858bd3ce7337f061c5be04788d16b19d105d77816301614c1ef"
                }
            }
        ]
    }
}

```

`/v1/wallet/generic_withdrawals [GET]`

Get informations for generic withdrawals.
This endnpoint is equipped with <a href="#custom-query-amp-pagination">custom-query</a>.








### Response



  + `generic_withdrawals`: array
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `btc_value`: Market value in BTC
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `additional_info`: additional info
      + object
      + `memo`: If memo is `null`, this field will be omitted.
        + ['string', 'null']
      + `iota_transaction`: object
        + `tx_hash`: string
        + `bundle_hash`: string
        + `current_index`: integer
        + `value`: integer
        + `address`: string
      + `iota_withdrawal`: object
        + `status`: iota withdrawal status
          + enum [`iota_withdrawal_new`, `iota_withdrawal_cancelled`, `iota_withdrawal_approved`, `iota_withdrawal_rejected`, `iota_withdrawal_spending`, `iota_withdrawal_spent`]
        + `user_id`: string
        + `address`: string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + ['integer', 'null']
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic withdrawal type
      + enum [`withdrawal_type_blockchain`, `withdrawal_type_epay`, `withdrawal_type_iota`, `withdrawal_type_internal_transfer`, `withdrawal_type_internal_withdrawal`, `withdrawal_type_manual_withdrawal`]
    + `id`: unique id of generic deposit
      + string
    + `approval_motion_id`: approve motion id
      + ['string', 'null']



## Cancel Generic Withdrawal





> Sample Response

```json
{
    "success": true,
    "result": {
        "message_code": "withdrawal_cancelled"
    }
}

```

`/v1/wallet/generic_withdrawals/:generic_withdrawal_id [DELETE]`

Cancel a pending generic withdrawal.



### Path Parameters
  + `generic_withdrawal_id`: Generic withdrawal ID
    + string




### Response



  + `message_code`: `withdrawal_cancelled` if the withdrawal is successfully cancelled.
    + string



## Get Generic Withdrawal





> Sample Response

```json
{
    "success": true,
    "result": {
        "generic_withdrawal": {
            "id": "2560c791-f874-4abd-bb40-647b2d38ef71",
            "is_cancelled": false,
            "type": "withdrawal_type_internal_transfer",
            "user_id": "e28cd9d9-3121-48f5-aec1-dc82161f2e5d",
            "currency_id": "COB",
            "ledger_type": "exchange",
            "btc_value": "5.566",
            "description": "Internal transfer [0x304a396347cdf858bd3ce7337f061b5de04788d16b19d105d77816301614c1ef]. Prize redemption of 10 COB",
            "amount": "10",
            "approval_motion_id": null,
            "created_at": 1526020394504,
            "completed_at": 1526020394523,
            "status": "tx_confirmed",
            "additional_info": {
                "tx_hash": "304a396347cdf858bd3ce7337f061b5de04788d16b19d105d77816301614c1ef"
            }
        }
    }
}

```

`/v1/wallet/generic_withdrawals/:generic_withdrawal_id [GET]`

Get infomation for a single generic withdrawal.



### Path Parameters
  + `generic_withdrawal_id`: generic withdrawal ID
    + string




### Response



  + `generic_withdrawal`: object
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `btc_value`: Market value in BTC
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `additional_info`: additional info
      + object
      + `memo`: If memo is `null`, this field will be omitted.
        + ['string', 'null']
      + `iota_transaction`: object
        + `tx_hash`: string
        + `bundle_hash`: string
        + `current_index`: integer
        + `value`: integer
        + `address`: string
      + `iota_withdrawal`: object
        + `status`: iota withdrawal status
          + enum [`iota_withdrawal_new`, `iota_withdrawal_cancelled`, `iota_withdrawal_approved`, `iota_withdrawal_rejected`, `iota_withdrawal_spending`, `iota_withdrawal_spent`]
        + `user_id`: string
        + `address`: string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + ['integer', 'null']
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic withdrawal type
      + enum [`withdrawal_type_blockchain`, `withdrawal_type_epay`, `withdrawal_type_iota`, `withdrawal_type_internal_transfer`, `withdrawal_type_internal_withdrawal`, `withdrawal_type_manual_withdrawal`]
    + `id`: unique id of generic deposit
      + string
    + `approval_motion_id`: approve motion id
      + ['string', 'null']



## Get Ledger Entries





> Sample Response

```json
{
    "success": true,
    "result": {
        "limit": 50,
        "page": 1,
        "total_page": 1,
        "total_count": 100,
        "ledgers": [
            {
                "timestamp": "2018-04-26T03:43:43.051255Z",
                "currency": "COB",
                "type": "exchange",
                "action": "fixup",
                "amount": "22000",
                "balance": "22199.32393872",
                "description": "",
                "sequence": 0,
                "trade_id": null,
                "loan_id": null,
                "deposit_id": null,
                "withdrawal_id": null,
                "fiat_deposit_id": null,
                "fiat_withdrawal_id": null
            },
            {
                "timestamp": "2018-04-23T06:55:22.990024Z",
                "currency": "COB",
                "type": "exchange",
                "action": "withdrawal_fee",
                "amount": "-38.95",
                "balance": "199.32393872",
                "description": "",
                "sequence": 0,
                "trade_id": null,
                "loan_id": null,
                "deposit_id": null,
                "withdrawal_id": null,
                "fiat_deposit_id": null,
                "fiat_withdrawal_id": null
            },
            {
                "timestamp": "2018-04-23T06:55:22.975023Z",
                "currency": "COB",
                "type": "exchange",
                "action": "withdraw",
                "amount": "-639.05",
                "balance": "238.27393872",
                "description": "",
                "sequence": 0,
                "trade_id": null,
                "loan_id": null,
                "deposit_id": null,
                "withdrawal_id": null,
                "fiat_deposit_id": null,
                "fiat_withdrawal_id": null
            }
        ]
    }
}

```

`/v1/wallet/ledger [GET]`

Get balance change logs. Pagination is supported.




### Query Parameters
  + `currency`: Currency ID (optional, default to all currencies)
    + string



### Response



  + `total_count`: pagingnation total count of data
    + integer
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `ledgers`: array
    + `loan_id`: Load ID
      + ['string', 'null']
    + `fiat_deposit_id`: Fiat currency deposit ID. This field will be removed.
      + ['string', 'null']
    + `description`: Description of the change
      + string
    + `sequence`: Sequence number of trades processing
      + integer
    + `timestamp`: Timestamp
      + string
    + `trade_id`: Trade ID
      + ['string', 'null']
    + `fiat_withdrawal_id`: Fiat currency withdrawal ID. This field will be removed.
      + ['string', 'null']
    + `currency`: Currency ID
      + string
    + `amount`: Amount of the balance change
      + string
    + `deposit_id`: Deposit ID. This field will be removed.
      + ['string', 'null']
    + `withdrawal_id`: Withdrawal ID. This field will be removed.
      + ['string', 'null']
    + `balance`: Balance after the change
      + string
    + `type`: type of ledger
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `action`: Ledger action
      + enum [`trade`, `deposit`, `deposit_fee`, `revoke_deposit`, `revoke_deposit_fee`, `withdraw`, `withdrawal_fee`, `cancel_withdrawal`, `cancel_withdrawal_fee`, `funding_tax`, `funding_tax_fee`, `fixup`]



## Get Withdrawal Limit





> Sample Response

```json
{
    "success": true,
    "result": {
        "withdrawal_limit": {
            "daily_fiat_withdrawal_usd_limit": "0",
            "monthly_fiat_withdrawal_usd_limit": "0",
            "daily_crypto_withdrawal_usd_limit": "3",
            "monthly_crypto_withdrawal_usd_limit": "90",
            "daily_fiat_deposit_usd_limit": "0",
            "monthly_fiat_deposit_usd_limit": "0",
            "daily_crypto_deposit_usd_limit": "-1",
            "monthly_crypto_deposit_usd_limit": "-1",
            "daily_crypto_usd_withdrawn": "0",
            "monthly_crypto_usd_withdrawn": "0",
            "daily_crypto_btc_withdrawn": "0",
            "monthly_crypto_btc_withdrawn": "0",
            "daily_crypto_withdrawal_btc_limit": "3",
            "monthly_crypto_withdrawal_btc_limit": "90",
            "daily_crypto_deposit_btc_limit": "-1",
            "monthly_crypto_deposit_btc_limit": "-1"
        }
    }
}

```

`/v1/wallet/limits/withdrawal [GET]`

Get daily and monthly limit of withdrawal and deposit.







### Response



  + `withdrawal_limit`: object
    + `monthly_crypto_deposit_btc_limit`: string
    + `daily_crypto_usd_withdrawn`: string
    + `daily_fiat_withdrawal_usd_limit`: string
    + `daily_crypto_deposit_btc_limit`: string
    + `monthly_crypto_usd_withdrawn`: string
    + `monthly_crypto_withdrawal_btc_limit`: string
    + `monthly_fiat_deposit_usd_limit`: string
    + `monthly_crypto_deposit_usd_limit`: string
    + `daily_crypto_withdrawal_usd_limit`: string
    + `monthly_crypto_withdrawal_usd_limit`: string
    + `monthly_fiat_withdrawal_usd_limit`: string
    + `monthly_crypto_btc_withdrawn`: string
    + `daily_crypto_withdrawal_btc_limit`: string
    + `daily_crypto_deposit_usd_limit`: string
    + `daily_fiat_deposit_usd_limit`: string
    + `daily_crypto_btc_withdrawn`: string



## Transfer Balance Between Wallets


> Sample Request

```json
{
    "from": "exchange",
    "to": "margin",
    "currency": "COB",
    "amount": "0.1"
}

```




> Sample Response

```json
{
    "success": true,
    "result": null
}

```

`/v1/wallet/transfer [POST]`

Transfer balance between different types of wallets.





### Request



  + `to`: To wallet type
    + string
  + `amount`: Transfer amount
    + string
  + `from`: From wallet type
    + string
  + `currency`: Currency ID
    + string

### Response



  + null



## Add Withdrawal Wallet


> Sample Request

```json
{
    "currency": "BTC",
    "address": "0xA4412f28a2Eb1eA1B28A567dC0242Ece6ce4916f",
    "name": "Misora's little wallet"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "2fa": {
            "type": "totp",
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        }
    }
}

```

`/v1/wallet/withdrawal_addresses [POST]`

Add a withdrawal wallet





### Request



  + `currency`: currency
    + string
  + `name`: name of the withdrawal address
    + string
  + `address`: withdrawal address to be added
    + string

### Response



  + `2fa`: object
    + `token`: JWT for `/v1/account/confirm_two_factor_authentication [POST]`
      + string
    + `type`: 2FA type
      + enum [`totp`, `sms`, `none`]



## Delete Withdrawal Wallet





> Sample Response

```json
{
    "success": true,
    "result": {
        "withdrawal_address": {
            "message_code": "delete_withdrawal_wallet_success"
        }
    }
}

```

`/v1/wallet/withdrawal_addresses/:wallet_id [DELETE]`

delete an existing withdrawal address



### Path Parameters
  + `wallet_id`: ID of the withdrawal wallet to be deleted
    + string




### Response



  + `withdrawal_address`: object
    + `message_code`: string



## Get Withdrawal Frozen Status





> Sample Response

```json
{
    "success": true,
    "result": {
        "withdrawal_frozen": false,
        "withdrawal_frozen_2": {
            "frozen": true,
            "blockers": [
                {
                       "expire_at": "2018-05-23T04:20:50.304063Z",
                       "action": "activity_change_password"
                },
                {
                       "expire_at": "2018-05-23T04:20:22.27859Z",
                       "action": "activity_disable_two_fa"
                }
            ]
        }
    }
}

```

`/v1/wallet/withdrawal_frozen [GET]`

Check whether withdrawal is blocked because of recent suspicious account activities. Activities which can cause withdrawal to be temporarily blocked include changing password, resetting password, disabling two-factor authentication.







### Response



  + `withdrawal_frozen_2`: object
    + `frozen`: True if withdrawal is not alowed
      + boolean
    + `blockers`: array
      + `action`: Account activity blocking withdrawal
        + enum [`activity_change_password`, `activity_reset_password`, `activity_disable_two_fa`]
      + `expire_at`: When the blocker will expire
        + string
  + `withdrawal_frozen`: True if withdrawal is not alowed
    + boolean



## Create Withdrawal


> Sample Request

```json
{
    "address" : "GRIUAMSEAKOGECZYTPXLECJPFUOS9URIJZOBHTDVQDOTVWJKNPLCAPXFMGTD9CNUFNP9EEVBIISRCVEIYMNVIPSTJX",
    "currency": "ETH",
    "amount": "0.4",
    "ledger_type": "exchange",
    "use_cob_as_fee": true,
    "memo": "abc"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "2fa": {
            "type": "totp",
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        }
    }
}

```

`/v1/wallet/withdrawals [POST]`

Create a withdrawal. Users must have 2FA enabled to use it.





### Request



  + `use_cob_as_fee`: Whether to pay withdrawal fee with COB. Optional and default to false. This option is not available when withdrawing COB, and it is automatically turned off when you don't have enough COB balance or exchange rates are not available. Users have to read the confirmation email they receive to know the amount and the currency of withdrawal fee they are going to pay.
    + boolean
  + `currency`: Currency ID
    + string
  + `amount`: Withdrawal amount. No withdrawal fee is required if the destination address is a deposit wallet in COBINHOOD exchange. For all other addresses, Withdrawal fee is charged according to `/v1/market/currencies [GET]`. If `use_cob_as_fee` is false, this amount includes withdrawal fee, and the amount sent to the withdrawal wallet will be less than the amount specified here.
    + string
  + `ledger_type`: type of ledger
    + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
  + `address`: The withdrawal address for IOTA / blockchain withdrawal.
    + string
  + `memo`: Memo could be `null`.
    + ['string', 'null']
  + `withdrawal_wallet_id`: (Deprecated) Withdrawal wallet ID. This field can only be used in COBX as in Coblet we don't necessarily store address in our DB.
    + string

### Response



  + `2fa`: object
    + `token`: JWT for `/v1/account/confirm_two_factor_authentication [POST]`
      + string
    + `type`: 2FA type
      + enum [`totp`, `sms`, `none`]



## Get withdrawal fee


> Sample Request

```json
{
    "address" : "0x29aa9730b11950a311febe0a566afa2dbd804bdb",
    "currency": "ETH",
    "amount": "0.4",
    "ledger_type": "coblet"
}

```




> Sample Response

```json
{
    "success": true,
    "result": {
        "fee": {
            "fee": "1",
            "cob_fee": "0.1",
            "is_internal": false
        }
    }
}

```

`/v1/wallet/withdrawals/fee [POST]`

Get withdrawal fee for corresponding payload.





### Request



  + `currency`: Currency ID
    + string
  + `amount`: Withdrawal amount. No withdrawal fee is required if the destination address is a deposit wallet in COBINHOOD exchange. For all other addresses, Withdrawal fee is charged according to `/v1/market/currencies [GET]`. If `use_cob_as_fee` is false, this amount includes withdrawal fee, and the amount sent to the withdrawal wallet will be less than the amount specified here.
    + string
  + `ledger_type`: type of ledger
    + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
  + `memo`: withdrawal memo
    + string
  + `address`: The withdrawal address for IOTA / blockchain withdrawal.
    + string

### Response



  + `fee`: object
    + `is_internal`: Flag indicates if this is an internal withdrawal.
      + boolean
    + `fee`: Fee calculated based on payload's currency
      + string
    + `cob_fee`: Fee calculated using COB as unit. If payload's currency is COB, then this field's value will be negative.
      + string



# WebSocket Common


## Common Parameters





> Sample Response

```json
{
    "h": [],
    "d": [],
}

```


*NOTE: all fields are converted to string for correct precision*

**Subscribe**

Please check channels below. the optional parameters are different from channel to channel.

**Unsubscribe**

Unsubscribe from given channel to reduce unused data stream.

**Version**

+ `2`: first version after v2 payload announced.

**Type**

For control response (see sessions below)

+ `pong`
+ `subscribe`
+ `unsubscribe`
+ `error`

For data response (see sessions below)

+ `s`: snapshot
+ `u`: update








### Response




  + `h`: extendable payload header, format as [channel_id, version, type, request_id (optional)]
    + array
    + string
  + `d`: data, array most time, will be ordered by uniqueness
    + array
    + string



## Error





> Sample Response

```json
{
    "h": ["", "2", "error", "4002", "channel_not_found"],
    "d": []
}

```


Error code for the specified error event occured, server will respond an error message including error code.

**Error Code**

+ `4000`: undefined_error. Unknown error.
+ `4001`: undefined_action. Request action is not defined.
+ `4002`: channel_not_found. Cound't found a  channel according the request.
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
+ `4013`: order_operation_not_authorized.
+ `4014`: invalid_order_type.
+ `4015`: invalid_order.
+ `4016`: invalid_trading_pair.
+ `4017`: invalid_json
+ `4018`: exceed_unprocessed_order_limit
+ `4019`: orderbook_service_is_down
+ `4020`: insufficient_balance
+ `4021`: balance_locked
+ `4022`: invalid_order_size
+ `4023`: trading_pair_blacklisted. It is not allowed to use this trading pair from the current IP address.
+ `4024`: register_channel_full
+ `4025`: unregister_channel_full
+ `4026`: funding_not_enabled
+ `4027`: exceed_buffered_message_limit








### Response




  + `h`: channel_id, version, type, error_code, msg, request_id (optional)
    + array
    + string
  + `d`: array
    + string



## Ping/Pong


> Sample Request

```json
{
    "action": "ping",
    "id": "sample_id"
}

```




> Sample Response

```json
{
    "h": ["", "2", "pong", "sample_id"],
    "d": []
}

```


Ping/pong extends disconnection timeout.
If no ping/pong message recieved, connection will be dropped by server in 64 seconds after last seen ping/pong message.






### Request



  + `action`: action string
    + string
  + `id`: optional, for concurrent request identification
    + string

### Response




  + `h`: channel_id, version, type, request_id (optional)
    + array
    + string
  + `d`: array
    + string



## Subscribe


> Sample Request

```json
{
    "action": "subscribe",
    "type:": "trade",
    "trading_pair_id": "COB-ETH",
    "id": "sample_id"
}

```




> Sample Response

```json
{
    "h": ["trade.COB-ETH", "2", "subscribed", "sample_id"],
    "d": []
}

```


Subscribe topic with specific parameters.





### Request



  + `action`: action string
    + string
  + `id`: optional, for concurrent request identification
    + string

### Response




  + `h`: channel_id, version, type, request_id (optional)
    + array
    + string
  + `d`: array
    + string



## Unsubscribe


> Sample Request

```json
{
    "action": "unsubscribe",
    "channel_id": "trade.COB-ETH",
    "id": "sample_id"
}

```




> Sample Response

```json
{
    "h": ["COB-ETH.trade", "2", "unsubscribed", "sample_id"],
    "d": []
}

```


Unsubscribe topic with channel id or parameters same as subscription.





### Request



  + `action`: action string
    + string
  + `channel_id`: channel identifier from subscription response
    + string
  + `id`: optional, for concurrent request identification
    + string

### Response




  + `h`: channel_id, version, type, request_id (optional)
    + array
    + string
  + `d`: array
    + string


# WebSocket V2


## User's balance updates [Auth]


> Sample Request

```json
{
    "action": "subscribe",
    "type": "balance-update"
}

```




> Sample Response

```json
{
    "h": ["balance-update", "2", "u"],
    "d":
        [
            [
                "ed679c62-bd0e-40ea-bf04-40e3b046c944",
                "BTC"
                "exchange",
                "100.1",
                "0.5",
                "100.1",
                "451639.188",
            ]
        ]
}

```


After subscribing this topic, you will start receiving your balances' status updates.

**PARAMS**

+ `balance_id`: balance id
+ `currency_id`: currency of this balance
+ `ledger_type`: ledger type of this balance
+ `total`: total amount of this balance
+ `on_order`: amount of this balance that's on order
+ `price_btc`: Equivalent total BTC amount of this balance
+ `price_usd`: Equivalent total USD amount of this balance






### Request



  + `action`: action string
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: balance_id, currency_id, ledger_type, total, on_order, price_btc, price_usd
    + array
    + string



## Candle


> Sample Request

```json
{
    "action": "subscribe",
    "type": "candle",
    "trading_pair_id": "COB-ETH",
    "timeframe": "1m"
}

```




> Sample Response

```json
{
    "h": ["candle.COB-ETH.1h", "2", "u"],
    "d":
        [
            ["1513555200000", "100", "0.012", "0.01", "0.01", "0.012"]
        ]
}

```


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

+ `trading_pair_id`: subscribe trading pair ID
+ `timeframe`: timespan granularity, check enumeration above
+ `timestamp`: timestamp in milliseconds
+ `volume`:  trading volume of the time frame
+ `high`: highest price during the time frame
+ `low`: lowest price during the time frame
+ `open`: first price during the time frame
+ `close`: last price during the time frame






### Request



  + `action`: action string
    + string
  + `trading_pair_id`: target trading pair symbol
    + string
  + `type`: channel type
    + string
  + `timeframe`: timeframe enum
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: timestamp, volume, high, low, open, close
    + array
    + string



## Funding [Auth]


> Sample Request

```json
{
    "action": "subscribe",
    "type": "funding",
}

```




> Sample Response

```json
{
    "h": ["funding", "2", "u", "1"],
    "d": [
        "ed679c62-bd0e-40ea-bf04-40e3b046c944",
        "1535760000100",
        "0",
        "COB",
        "open",
        "opened",
        "ask",
        "0.01",
        "100",
        "0",
        "2",
        "true"
    ]
}

```


After subscribing this topic, you will get all funding updates at COBINHOOD.

**PARAMS**

+ `funding_id`: funding ID
+ `timestamp`: created timestamp
+ `completed_at`: the funding completed time
+ `currency_id`: currency of this funding
+ `state`: funding state
+ `interest_rate`: the intererest rate of this funding
+ `size`: total size
+ `filled`: filled size
+ `period`: funding period
+ `auto_refund`: boolean to indicate auto refund or not

**Type**

Same type enums as Order [Auth]

**Event**

Same event enums as Order [Auth]

**State**

Same state enums as Order [Auth]






### Request



  + `action`: action string
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type, funding_type
    + array
    + string
  + `d`: funding_id, timestamp, completed_at, currency_id, state, event, side, interest_rate, size, filled, period, auto_refund
    + array
    + string



## Matched loans


> Sample Request

```json
{
    "action": "subscribe",
    "type": "loan",
    "currency_id": "COB"
}

```




> Sample Response

```json
{
    "h": ["loan.COB", "2", "u"],
    "d":
        [
            [
                "ed679c62-bd0e-40ea-bf04-40e3b046c944",
                "1535760000100",
                "1535760000000",
                "",
                "COB",
                "active",
                "0",
                "0.01",
                "100",
                "2",
                "true",
                "ask",
            ]
        ]
}

```


After subscribing this topic, you will start receiving recent matched loans,
followed by any loan that occurs at COBINHOOD.

**State**

+ `in_use`: loan is currently used
+ `active`: loan created or available for funding
+ `closed`: loan closed

**Event**

+ `0`: created
+ `1`: updated

**PARAMS**

+ `loan_id`: loan id
+ `timestamp`: loan created timestamp
+ `will_close_at`: the closing time of this loan
+ `completed_at`: the loan completed time
+ `currency_id`: currency id of this loan
+ `state`: loan event sate
+ `event`: loan event type
+ `interest_rate`: loan interest rate
+ `size`: loan size
+ `period`: the loan period
+ `auto_refund`: boolean to mark auto refund or not
+ `maker_side`: the funding side






### Request



  + `action`: action string
    + string
  + `currency_id`: target currency symbol
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: loan_id, will_close_at, completed_at, currency_id, state, event, interest_rate, size, period, auto_refund, maker_side
    + array
    + string



## Loan Ticker


> Sample Request

```json
{
    "action": "subscribe",
    "type": "loan-ticker",
    "currency_id": "COB"
}

```




> Sample Response

```json
{
    "h": ["loan-ticker.COB", "2", "u"],
    "d": [
        [
          "1535760000000",
          "10",
          "0.012",
          "0.01",
          "0.01",
          "0.012"
        ]
    ]
}

```


After receiving the response, you will start receiving loan ticker updates.

+ `currency_id`: currency ID
+ `timestamp`: ticker timestamp in milliseconds
+ `24h_volume`: funding volume of the last 24 hours
+ `24h_low`: lowest loan price of the last 24 hours
+ `24h_high`: highest loan price of the last 24 hours
+ `24h_open`: first loan price of the last 24 hours
+ `24h_last`: last loan price of the last 24 hours






### Request



  + `action`: action string
    + string
  + `currency_id`: target currency symbol
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: timestamp, 24h_volume, 24h_high, 24h_low, 24h_open, 24h_last
    + array
    + string



## User's loan updates [Auth]


> Sample Request

```json
{
    "action": "subscribe",
    "type": "loan-update",
}

```




> Sample Response

```json
{
    "h": ["loan-update", "2", "u"],
    "d":
        [
            [
                "ed679c62-bd0e-40ea-bf04-40e3b046c944",
                "1535760000100",
                "1535760000000",
                "",
                "COB",
                "in_use",
                "1",
                "0.01",
                "100",
                "2",
                "true",
                "ask",
            ]
        ]
}

```


After subscribing this topic, you will start receiving your loans' status updates.
Response format is same as matched loan.

**State**

  Same state enums as Matched Loan.

**Event**

  Same event enums as Matched Loan.

**PARAMS**

+ `loan_id`: loan id
+ `timestamp`: loan created timestamp
+ `will_close_at`: the closing time of this loan
+ `completed_at`: the loan completed time
+ `currency_id`: currency id of this loan
+ `state`: loan event sate
+ `event`: loan event type
+ `interest_rate`: loan interest rate
+ `size`: loan size
+ `period`: the loan period
+ `auto_refund`: boolean to mark auto refund or not
+ `maker_side`: the funding side






### Request



  + `action`: action string
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: loan_id, will_close_at, completed_at, currency_id, state, event, interest_rate, size, period, auto_refund, side
    + array
    + string



## Order [Auth]


> Sample Request

```json
{
    // order operation (place)
    "action": "place_order",
    "trading_pair_id": "COB-ETH",
    "type": "0",
    "price": "123.4567",
    "size": "1000.000",
    "side": "bid",
    "source": "exchange",
    "stop_price": "",        // mandatory for stop/stop-limit order
    "trailing_distance": "", // mandatory for trailing-stop order
    "id": "order_req_id1"
}

```

> Sample Request

```json
{
    // order operation (modify)
    "action": "modify_order",
    "type": "0",
    "order_id": "ed679c62-bd0e-40ea-bf04-40e3b046c944",
    "price": "123.4567",
    "size": "1000.000",
    "stop_price": "",        // mandatory for stop/stop-limit order
    "trailing_distance": "", // mandatory for trailing stop order
    "id": "order_req_id2"
}

```

> Sample Request

```json
{
    // order operation (cancel)
    "action": "cancel_order",
    "type": "0",
    "order_id": "ed679c62-bd0e-40ea-bf04-40e3b046c944"
}

```





Order response provides extra information for recognition, the following sessions show all values of field enumerations.

**Action**

+ `place_order`: place new order
+ `modify_order`: modify existing and valid order
+ `cancel_order`: cancel existing and valid order

**Type**

+ `0`: limit
+ `1`: market
+ `2`: stop
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
+ `pending_modification`

**Side**

+ `ask`
+ `bid`

**Source**

+ `exchange`
+ `margin`                      (not valid yet)

**PARAMS**

+ `order_id`: order's ID.
+ `timestamp`: order's timestamp.
+ `completed_at`: order executed timestamp.
+ `trading_pair_id`: trading pairs ID
+ `state`: order state, the state saved in database.
+ `event`: order event, the state changing event.
+ `side`: place side
+ `price`: order price
+ `eq_price`: equal/average price
+ `size`: order size
+ `pariial_filled_size`: partially filled size
+ `stop_price`: conditional stop price
+ `source`: order source






### Request










## Limit Order [Auth]





> Sample Response

```json
{
    "h": ["order", "2", "u", "0"],
    "d": [
        "ed679c62-bd0e-40ea-bf04-40e3b046c944",
        "1513555200000",
        "1513555200000",
        "COB-ETH",
        "open",
        "opened",
        "ask",
        "0.01",
        "0.0",
        "1000",
        "0.0",
        "exchange"
    ]
}

```










### Response




  + `h`: channel_id, version, message_type, order_type, request_id (optional)
    + array
    + string
  + `d`: order_id, timestamp, completed_at, trading_pair_id, state, event, side, price, eq_price, size, partial_filled_size, source
    + array
    + string



## Limit Stop Order [Auth]





> Sample Response

```json
{
    // Limit Stop Order
    "h": ["order", "2", "u", "3"],
    "d": [
        "12345678-5678-90ab-1234-567890abcdec",
        "1513555200001",
        "1513555200010",
        "COB-ETH",
        "filled",
        "executed",
        "ask",
        "0.001",
        "0.0012",
        "1000",
        "",
        "0.001",
        "exchange"
    ]
}

```










### Response




  + `h`: channel_id, version, message_type, order_type, request_id (optional)
    + array
    + string
  + `d`: order_id, timestamp, completed_at, trading_pair_id, state, event, side, price, eq_price, size, partial_filled_size, stop_price, source
    + array
    + string



## Market Order [Auth]





> Sample Response

```json
{
    "h": ["order", "2", "u", "1"],
    "d": [
        "12345678-5678-90ab-1234-567890abcded",
        "1513555200001",
        "1513555200002",
        "COB-ETH",
        "filled",
        "executed",
        "ask",
        "0.0012",
        "1000",
        "0.0012",
        "exchange"
    ]
}

```










### Response




  + `h`: channel_id, version, message_type, order_type, request_id (optional)
    + array
    + string
  + `d`: order_id, timestamp, completed_at, trading_pair_id, state, event, side, eq_price, size, partial_filled_size, source
    + array
    + string



## Stop Order [Auth]





> Sample Response

```json
{
    "h": ["order", "2", "u", "2"],
    "d": [
        "12345678-5678-90ab-1234-567890abcdec",
        "1513555200001",
        "1513555200010",
        "COB-ETH",
        "filled",
        "executed",
        "ask",
        "0.0012",
        "1000",
        "",
        "0.001",
        "exchange"
    ]
}

```










### Response




  + `h`: channel_id, version, message_type, order_type, request_id (optional)
    + array
    + string
  + `d`: order_id, timestamp, completed_at, trading_pair_id, state, event, side, price, eq_price, size, partial_filled_size, source
    + array
    + string



## Orderbook


> Sample Request

```json
{
    "action": "subscribe",
    "type": "order-book",
    "trading_pair_id": "COB-ETH",
    "precision": "1E-6"
}

```




> Sample Response

```json
{
    "h": ["order-book.COB-ETH.1E-7", "2", "u"],
    "d": {
        "bids": [
            [ "0.01", "1", "1234.56" ]
        ],
        "asks": [
            [ "0.012", "3", "9487.87" ]
        ]
    }
}

```


After receiving the response, you will receive a snapshot of the book, followed by updates upon any changes to the book.
The updates is published as **DIFF**.

**PARAMS**

+ `precision`: available precisions could be acquired from REST, endpoint: `/v1/market/orderbook/precisions/<trading_pair_id>`
+ `price`: order price
+ `size`: order amount, diff may be minus value
+ `count`: order count, diff may be minus value






### Request



  + `action`: action string
    + string
  + `trading_pair_id`: target trading pair symbol
    + string
  + `type`: channel type
    + string
  + `precision`: precision of target orderbook
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: object
    + `bids`: price, count, size
      + array
      + string
    + `asks`: price, count, size
      + array
      + string



## User's position updates [Auth]


> Sample Request

```json
{
    "action": "subscribe",
    "type": "position-update"
}

```




> Sample Response

```json
{
    "h": ["position-update", "2", "u"],
    "d":
        [
            [
                "ed679c62-bd0e-40ea-bf04-40e3b046c944",
                "BTC-USDT",
                "0",
                "0",
                "0",
                "0",
                "0",
                "0",
                "0",
                "0"
            ]
        ]
}

```


After subscribing this topic, you will start receiving your positions' status updates.

**PARAMS**

+ `position_id`: position id
+ `trading_pair_id`: trading pair id of this position
+ `base_size`: amount of base currency of the position
+ `quote_size`: amount of quote currency of the position
+ `base_on_order`: amount of base currency on order
+ `quote_on_order`: amount of quote currency on order
+ `eq_price`: the equivalance price of the position
+ `intererest`: amount of interest has paid for the position
+ `profit`: position profit at current market price
+ `liq_price`: liquidation price of the position






### Request



  + `action`: action string
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: balance_id, trading_pair_id, base_size, quote_size, base_on_order, quote_on_order, eq_price, interest, profit, liq_price
    + array
    + string



## Orderbook


> Sample Request

```json
{
    "action": "subscribe",
    "type": "repl-order-book",
    "trading_pair_id": "TRADING_PAIR_ID",
    "precision": "PRECISION"
}

```




> Sample Response

```json
{
    // [channel_id, version, type]
    "h": ["repl-order-book.COB-ETH.1E-7", "2", "u"],
    "d": {
        "bids": [
            [ PRICE, COUNT, SIZE ]
    ],
    "asks": [
        [ PRICE, COUNT, SIZE ]
    ]
}

```


After receiving the response, you will receive a snapshot of the book, followed by updates upon any changes to the book. The updates is published as latest state of entry.
**PARAMS**
+ `PRECISION`: available precisions could be acquired from REST, endpoint: `/v1/market/orderbook/precisions/<trading_pair_id>` + `PRICE`: order price + `SIZE`: order amount + `COUNT`: order count






### Request




### Response





## Ticker


> Sample Request

```json
{
    "action": "subscribe",
    "type": "ticker",
    "trading_pair_id": "COB-ETH"
}

```




> Sample Response

```json
{
    "h": ["ticker.COB-ETH", "2", "u"],
    "d": [
        [
            "1513555200000",
            "0.01",
            "0.012",
            "100",
            "0.012",
            "0.01",
            "0.01",
            "0.012"
        ]
    ]
}

```


After receiving the response, you will start receiving ticker updates.

+ `trading_pair_id`: subscribe trading pair ID
+ `timestamp`: ticker timestamp in milliseconds
+ `highest_bid`: best bid price in current order book
+ `lowest_ask`: best ask price in current order book
+ `24h_volume`: trading volume of the last 24 hours
+ `24h_low`: lowest trade price of the last 24 hours
+ `24h_high`: highest trade price of the last 24 hours
+ `24h_open`: first trade price of the last 24 hours
+ `last_trade_price`: latest trade price






### Request



  + `action`: action string
    + string
  + `trading_pair_id`: target trading pair symbol
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: timestamp, higest_bid, lowest_ask, 24h_volume, 24h_high, 24h_low, 24h_open, last_trade_price
    + array
    + string



## Trade


> Sample Request

```json
{
    "action": "subscribe",
    "type": "trade",
    "trading_pair_id": "COB-ETH"
}

```




> Sample Response

```json
{
    "h": ["trade.COB-ETH", "2", "u"],
    "d":
        [
            ["ed679c62-bd0e-40ea-bf04-40e3b046c944", "1513555200000", "ask", "0.01", "100"]
        ]
}

```


After receiving the response, you will start receiving recent trade,
followed by any trade that occurs at COBINHOOD.

**PARAMS**

+ `trading_pair_id`: subscribe trading pair ID
+ `trade_id`: trade ID
+ `timestamp`: trade timestamp in milliseconds
+ `price`: trade quote price
+ `size`: trade base amount
+ `maker_side`: the order side






### Request



  + `action`: action string
    + string
  + `trading_pair_id`: target trading pair symbol
    + string
  + `type`: channel type
    + string

### Response




  + `h`: channel_id, version, type
    + array
    + string
  + `d`: trade_id, timestamp, maker_side, price, size
    + array
    + string

