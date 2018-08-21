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

> [Success] Response 200 (application/json)

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

# Wallet [Auth]


## Get Balances

`/v1/wallet/balances [GET]`

    Get currencies, amounts, types, status of balances.




### Query Parameters
  + `currency`: Currency ID (optional, default to all currencies)
    + string
  + `type`: ledger type
    + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]




### Response

> [Success] Response 200 (application/json)

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
    + `type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `usd_value`: Market value in USDT
      + string


## Get All Generic Deposits

`/v1/wallet/generic_deposits [GET]`

    Get informations for generic deposits.
This endnpoint is equipped with <a href="#custom-query-amp-pagination">custom-query</a>.









### Response

> [Success] Response 200 (application/json)

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



  + `generic_deposits`: array
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `fee`: fee of this generic deposit
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `id`: unique id of generic deposit
      + string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + integer
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic deposit type
      + enum [`deposit_type_blockchain`, `deposit_type_epay`, `deposit_type_iota`, `deposit_type_internal_transfer`, `deposit_type_internal_deposit`, `deposit_type_manual_deposit`]
    + `additional_info`: If memo is `null`, this field will be omitted.
      + object
      + `memo`: string


## Get Generic Deposit

`/v1/wallet/generic_deposits/:generic_deposit_id [GET]`

    Get information for a single generic deposit.



### Path Parameters
  + `generic_deposit_id`: generic deposit ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `generic_deposit`: object
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `fee`: fee of this generic deposit
      + string
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `created_at`: created time of this generic deposit
      + integer
    + `id`: unique id of generic deposit
      + string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + integer
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `is_cancelled`: cancelled or not
      + boolean
    + `type`: generic deposit type
      + enum [`deposit_type_blockchain`, `deposit_type_epay`, `deposit_type_iota`, `deposit_type_internal_transfer`, `deposit_type_internal_deposit`, `deposit_type_manual_deposit`]
    + `additional_info`: If memo is `null`, this field will be omitted.
      + object
      + `memo`: string


## Get All Generic Withdrawals

`/v1/wallet/generic_withdrawals [GET]`

    Get informations for generic withdrawals.
This endnpoint is equipped with <a href="#custom-query-amp-pagination">custom-query</a>.









### Response

> [Success] Response 200 (application/json)

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



  + `generic_withdrawals`: array
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `is_cancelled`: cancelled or not
      + boolean
    + `created_at`: created time of this generic deposit
      + integer
    + `id`: unique id of generic deposit
      + string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + integer
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `approval_motion_id`: approve motion id
      + ['string', 'null']
    + `type`: generic withdrawal type
      + enum [`withdrawal_type_blockchain`, `withdrawal_type_epay`, `withdrawal_type_iota`, `withdrawal_type_internal_transfer`, `withdrawal_type_internal_withdrawal`, `withdrawal_type_manual_withdrawal`]
    + `additional_info`: additional info
      + object
      + `memo`: If memo is `null`, this field will be omitted.
        + string
      + `iota_transaction`: object
        + `tx_hash`: string
        + `bundle_hash`: string
        + `current_index`: integer
        + `value`: integer
        + `address`: string
      + `iota_withdrawal`: object
        + `status`: 
        + `user_id`: string
        + `address`: string


## Get Generic Withdrawal

`/v1/wallet/generic_withdrawals/:generic_withdrawal_id [GET]`

    Get infomation for a single generic withdrawal.



### Path Parameters
  + `generic_withdrawal_id`: generic withdrawal ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `generic_withdrawal`: object
    + `status`: tx status
      + enum [`tx_pending_two_factor_auth`, `tx_pending_email_auth`, `tx_pending_approval`, `tx_approved`, `tx_processing`, `tx_sent`, `tx_pending`, `tx_confirmed`, `tx_timeout`, `tx_invalid`, `tx_cancelled`, `tx_rejected`, `tx_unexpected`]
    + `user_id`: user id of this generic deposit
      + string
    + `description`: human readable description
      + string
    + `is_cancelled`: cancelled or not
      + boolean
    + `created_at`: created time of this generic deposit
      + integer
    + `id`: unique id of generic deposit
      + string
    + `currency_id`: currency id
      + string
    + `completed_at`: updated time of this generic deposit
      + integer
    + `amount`: amount of this generic deposit
      + string
    + `ledger_type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `approval_motion_id`: approve motion id
      + ['string', 'null']
    + `type`: generic withdrawal type
      + enum [`withdrawal_type_blockchain`, `withdrawal_type_epay`, `withdrawal_type_iota`, `withdrawal_type_internal_transfer`, `withdrawal_type_internal_withdrawal`, `withdrawal_type_manual_withdrawal`]
    + `additional_info`: additional info
      + object
      + `memo`: If memo is `null`, this field will be omitted.
        + string
      + `iota_transaction`: object
        + `tx_hash`: string
        + `bundle_hash`: string
        + `current_index`: integer
        + `value`: integer
        + `address`: string
      + `iota_withdrawal`: object
        + `status`: 
        + `user_id`: string
        + `address`: string


## Get Ledger Entries

`/v1/wallet/ledger [GET]`

    Get balance change logs. Pagination is supported.




### Query Parameters
  + `currency`: Currency ID (optional, default to all currencies)
    + string




### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "limit": 50,
        "page": 1,
        "total_page": 1,
        "total_count": 100,
        "ledger": [
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



  + `total_count`: pagingnation total count of data
    + integer
  + `limit`: pagingnation limit number
    + integer
  + `page`: pagingnation page number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `ledger`: array
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
    + `amount`: Amount of the balance change
      + string
    + `fiat_withdrawal_id`: Fiat currency withdrawal ID. This field will be removed.
      + ['string', 'null']
    + `currency`: Currency ID
      + string
    + `trade_id`: Trade ID
      + ['string', 'null']
    + `deposit_id`: Deposit ID. This field will be removed.
      + ['string', 'null']
    + `withdrawal_id`: Withdrawal ID. This field will be removed.
      + ['string', 'null']
    + `balance`: Balance after the change
      + string
    + `type`: ledger type
      + enum [`funding`, `margin`, `tradable`, `exchange`, `coblet`, `cob_point`]
    + `action`: Ledger action
      + enum [`trade`, `deposit`, `deposit_fee`, `revoke_deposit`, `revoke_deposit_fee`, `withdraw`, `withdrawal_fee`, `cancel_withdrawal`, `cancel_withdrawal_fee`, `funding_tax`, `funding_tax_fee`, `fixup`]


## Transfer Balance Between Wallets

`/v1/wallet/transfer [POST]`

    Transfer balance between different types of wallets.





### Request

> Payload

```json
{
    "from": "exchange",
    "to": "margin",
    "currency": "COB",
    "amount": "0.1"
}

```



  + `to`: To wallet type
    + string
  + `amount`: Transfer amount
    + string
  + `from`: From wallet type
    + string
  + `currency`: Currency ID
    + string


### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


# Trading [Auth]


## Check Order

`/v1/trading/check_order [POST]`

    Check conditional order will be executed immediately.





### Request

> Payload

```json
{
    "trading_pair_id": "BTC-USDT",
    "side": "bid",
    "type": "limit_stop",
    "stop_price": "5000.01000000"
}

```



  + `trading_pair_id`: trading pair ID
    + string
  + `stop_price`: order stop price
    + string
  + `side`: order side
    + enum [`bid`, `ask`]
  + `type`: order type
    + enum [`market_stop`, `limit_stop`]


### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "may_execute_immediately": true
    }
}

```



  + `may_execute_immediately`: boolean


## Get Order History

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

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
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



  + `orders`: array
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + string
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `id`: order ID
      + string
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + string
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string


## Place Order

`/v1/trading/orders [POST]`

    Place an order.





### Request

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



  + `trading_pair_id`: trading pair ID
    + string
  + `stop_price`: optional, type should be `limit_stop` or `market_stop`
    + string
  + `source`: optional, order source, default is `exchange`
    + enum [`exchange`, `margin`]
  + `price`: optional, `market` type will ignore
    + string
  + `type`: order type
    + enum [`market`, `limit`, `market_stop`, `limit_stop`]
  + `side`: order side
    + enum [`bid`, `ask`]
  + `size`: base amount
    + string


### Response

> [Success] Response 200 (application/json)

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



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + string
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `id`: order ID
      + string
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + string
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string


## Get Open Orders

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

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
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



  + `orders`: array
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + string
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `id`: order ID
      + string
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + string
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string


## Modify Order

`/v1/trading/orders/:order_id [PUT]`

    Modify an order.



### Path Parameters
  + `order_id`: order ID
    + string


### Request

> Payload

```json
{
    "price": "5000.01000000",
    "size": "1.0100"
}

```



  + `price`: order price
    + string
  + `size`: base amount
    + string


### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Get Order

`/v1/trading/orders/:order_id [GET]`

    Get information for a single order.



### Path Parameters
  + `order_id`: order ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + string
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `id`: order ID
      + string
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + string
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string


## Cancel Order

`/v1/trading/orders/:order_id [DELETE]`

    Cancel an order.



### Path Parameters
  + `order_id`: order ID
    + string





### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Get Trades of Order

`/v1/trading/orders/:order_id/trades [GET]`

    Get trades which fill the specific order.



### Path Parameters
  + `order_id`: order ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `trades`: array
    + `maker_side`: order side
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

`/v1/trading/positions [GET]`

    List all open positions for a user.








### Response

> [Success] Response 200 (application/json)

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
    + `id`: position ID
      + string
    + `interest`: amount of interest has paid for the position
      + string
    + `base_on_order`: amount of base currency on order
      + string


## Close Position

`/v1/trading/positions/:trading_pair_id [DELETE]`

    Close a position.



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `order`: object
    + `eq_price`: the equivalance(average) price
      + string
    + `trading_pair_id`: trading pair ID
      + string
    + `stop_price`: order stop price
      + string
    + `completed_at`: order filled time
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `price`: quote price
      + string
    + `id`: order ID
      + string
    + `source`: order source
      + string
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `trailing_distance`: order trailing distance
      + string
    + `type`: order type
      + enum [`market`, `limit`, `market_stop`, `limit_stop`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: amount filled in current order
      + string
    + `size`: base amount
      + string


## Get Position

`/v1/trading/positions/:trading_pair_id [GET]`

    Get information for a single position.



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string





### Response

> [Success] Response 200 (application/json)

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
    + `id`: position ID
      + string
    + `interest`: amount of interest has paid for the position
      + string
    + `base_on_order`: amount of base currency on order
      + string


## Claim Position

`/v1/trading/positions/:trading_pair_id [PATCH]`

    Claim a position



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string


### Request

> Payload

```json
{
    "size": "1.0100"
}

```



  + `size`: claim size, should be a positive number
    + string


### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Get Claimable Size

`/v1/trading/positions/:trading_pair_id/claimable_size [GET]`

    Get claimable size depend on user's balance



### Path Parameters
  + `trading_pair_id`: trading pair ID
    + string





### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "size": "1"
    }
}

```



  + `size`: claimable size
    + string


## Get Trade History

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

> [Success] Response 200 (application/json)

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



  + `total_count`: pagingnation total count of data
    + integer
  + `trades`: array
    + `maker_side`: order side
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

`/v1/trading/trades/:trade_id [GET]`

    Get information for a single trade.



### Path Parameters
  + `trade_id`: trade ID
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `trade`: object
    + `maker_side`: order side
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

> [Success] Response 200 (application/json)

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



  + `volume`: object
    + `currency_id`: currency ID
      + string
    + `sum`: trading volume
      + string

# Funding [Auth]


## Setup Auto Offering

`/v1/funding/auto_offerings [POST]`

    Setup an auto offering.





### Request

> Payload

```json
{
    "currency": "USDT",
    "period": 2,
    "interest_rate": "0.01",
    "size": "1"
}

```



  + `currency`: currency ID
    + string
  + `interest_rate`: interest rate of this auto offering will set
    + string
  + `period`: how many days this auto offering will set
    + integer
  + `size`: maximum offering size, 0 is unlimited
    + string


### Response

> [Success] Response 200 (application/json)

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

`/v1/funding/auto_offerings [GET]`

    List all active auto offerings.








### Response

> [Success] Response 200 (application/json)

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


## Get Auto Offering

`/v1/funding/auto_offerings/:currency_id [GET]`

    Get information for an auto offering.



### Path Parameters
  + `currency_id`: currency ID
    + string





### Response

> [Success] Response 200 (application/json)

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


## Disable Auto Offering

`/v1/funding/auto_offerings/:currency_id [DELETE]`

    Disable an auto offering.



### Path Parameters
  + `currency_id`: currency ID
    + string





### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Get Funding Orders History

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

> [Success] Response 200 (application/json)

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



  + `total_count`: pagingnation total count of data
    + integer
  + `fundings`: array
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `currency`: which currency of this fund
      + string
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `id`: funding ID
      + string
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: 
      + enum [`market`, `limit`]
    + `side`: order side
      + enum [`bid`, `ask`]
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

`/v1/funding/fundings [POST]`

    Place a funding order.





### Request

> Payload

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



  + `currency`: Currency ID
    + string
  + `interest_rate`: Interest rate of this funding per day
    + string
  + `size`: How many money provide/request
    + string
  + `type`: order type
    + enum [`market`, `limit`, `market_stop`, `limit_stop`]
  + `period`: How many days this funding request/offer
    + integer
  + `side`: order side
    + enum [`bid`, `ask`]


### Response

> [Success] Response 200 (application/json)

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



  + `funding`: object
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `currency`: which currency of this fund
      + string
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `id`: funding ID
      + string
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: 
      + enum [`market`, `limit`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `filled`: how many money dealt
      + string
    + `size`: how many money provide/request
      + string


## Get Open Funding Orders

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

> [Success] Response 200 (application/json)

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



  + `total_count`: pagingnation total count of data
    + integer
  + `fundings`: array
    + `auto_refund`: if this fund should be auto refund
      + boolean
    + `currency`: which currency of this fund
      + string
    + `position_id`: this funding is requested by system for position_id
      + ['string', 'null']
    + `timestamp`: order timestamp in milliseconds
      + integer
    + `interest_rate`: interest rate of this fund per day
      + string
    + `period`: how many days this funding request/offer
      + integer
    + `id`: funding ID
      + string
    + `completed_at`: funding filled time
      + ['string', 'null']
    + `state`: order status
      + enum [`queued`, `open`, `partially_filled`, `filled`, `cancelled`, `rejected`, `pending_cancellation`, `pending_modifications`, `triggered`]
    + `type`: 
      + enum [`market`, `limit`]
    + `side`: order side
      + enum [`bid`, `ask`]
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

`/v1/funding/fundings/:funding_id [PUT]`

    Modify a funding order.



### Path Parameters
  + `funding_id`: funding ID
    + string


### Request

> Payload

```json
{
    "interest_rate": "0.08",
    "size": "100000.300"
}

```



  + `interest_rate`: interest rate per day
    + string
  + `size`: amount
    + string


### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Cancel Funding Order

`/v1/funding/fundings/:funding_id [DELETE]`

    Cancel an funding order.



### Path Parameters
  + `funding_id`: funding ID
    + string





### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null


## Get All Loans

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




### Response

> [Success] Response 200 (application/json)

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
                "side": "ask"
            }
        ]
    }
}

```



  + `total_count`: pagingnation total count of data
    + integer
  + `loans`: array
    + `will_close_at`: the expected close time of the loan
      + string
    + `auto_refund`: if the loan will be auto close
      + boolean
    + `currency`: currency ID
      + string
    + `timestamp`: created timestamp in unix timestamp
      + integer
    + `interest_rate`: interest rate of the loan
      + string
    + `period`: valid period of the loan
      + integer
    + `id`: loan ID
      + string
    + `completed_at`: the complete time of the loan
      + ['string', 'null']
    + `state`: 
      + enum [`in_use`, `active`, `closed`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `size`: loan amount
      + string
  + `limit`: pagingnation limit number
    + integer
  + `total_page`: pagingnation total page number
    + integer
  + `page`: pagingnation page number
    + integer


## Get Loan

`/v1/funding/loans/:loan_id [GET]`

    Get information for a single loan.



### Path Parameters
  + `loan_id`: loan ID
    + string





### Response

> [Success] Response 200 (application/json)

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
            "side": "ask"
        }
    }
}

```



  + `loan`: object
    + `will_close_at`: the expected close time of the loan
      + string
    + `auto_refund`: if the loan will be auto close
      + boolean
    + `currency`: currency ID
      + string
    + `timestamp`: created timestamp in unix timestamp
      + integer
    + `interest_rate`: interest rate of the loan
      + string
    + `period`: valid period of the loan
      + integer
    + `id`: loan ID
      + string
    + `completed_at`: the complete time of the loan
      + ['string', 'null']
    + `state`: 
      + enum [`in_use`, `active`, `closed`]
    + `side`: order side
      + enum [`bid`, `ask`]
    + `size`: loan amount
      + string


## Close Loan

`/v1/funding/loans/:loan_id [DELETE]`

    Close a loan manually.



### Path Parameters
  + `loan_id`: loan ID
    + string





### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": null
}

```



  + null

# Market


## Get Currencies

`/v1/market/currencies [GET]`

    This endpoint returns all supported currencies and related information.








### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "currencies": [
            {
                "currency": "REP",
                "name": "Augur",
                "type": "erc20",
                "min_unit": "0.00000001",
                "deposit_fee": "0",
                "withdrawal_fee": "0.06",
                "min_withdrawal": "0.20387",
                "funding_min_size": "0.611",
                "interest_increment": "0.001",
                "margin_enabled": false,
                "deposit_frozen": false,
                "withdrawal_frozen": false,
                "cob_withdrawal_fee": "18.16970378"
            }
        ]
    }
}

```



  + `currencies`: array
    + `deposit_frozen`: available for deposit
      + boolean
    + `name`: the currency name
      + string
    + `margin_enabled`: available for margin
      + boolean
    + `min_withdrawal`: minimal available withdrawal size
      + string
    + `currency`: the currency id
      + string
    + `funding_min_size`: minimal funding size
      + string
    + `withdrawal_fee`: withdrawal fee with same currency
      + string
    + `withdrawal_frozen`: available for withdrawal
      + boolean
    + `deposit_fee`: deposite fee with same currency
      + string
    + `min_unit`: the currency mininum unit
      + string
    + `type`: currency type
      + enum [`erc20`, `native`, `qrc20`, `atp10`]
    + `interest_increment`: the interest increment rate while margining
      + string
    + `cob_withdrawal_fee`: withdrawal fee with COB
      + string


## Get Fundingbook Precisions

`/v1/market/fundingbook/precisions/:currency_id [GET]`

    Returns available precisions in scientific notation of funndingbook by given currency.



### Path Parameters
  + `trading_pair_id`: currency symbol/id
    + string





### Response

> [Success] Response 200 (application/json)

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



  + `precisions`: array
    + string


## Get Fundingbook

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

> [Success] Response 200 (application/json)

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

`/v1/market/orderbook/precisions/:trading_pair_id [GET]`

    Returns available precisions in scientific notation of orderbook by given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string





### Response

> [Success] Response 200 (application/json)

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



  + string


## Get Orderbook

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

> [Success] Response 200 (application/json)

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

`/v1/market/quote_currencies [GET]`

    This endpoint returns all supported quote currencies and related information.








### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "quote_currencies": [
            {
                "currency": "BTC",
                "name": "Bitcoin",
                "type": "native",
                "min_unit": "0.00000001",
                "deposit_fee": "0",
                "withdrawal_fee": "0.001",
                "min_withdrawal": "0.00109",
                "funding_min_size": "0.003",
                "interest_increment": "0.001",
                "margin_enabled": false,
                "deposit_frozen": false,
                "withdrawal_frozen": false,
                "cob_withdrawal_fee": "51.02040816"
            }
        ]
    }
}

```



  + `quote_currencies`: array
    + `deposit_frozen`: available for deposit
      + boolean
    + `name`: the currency name
      + string
    + `margin_enabled`: available for margin
      + boolean
    + `min_withdrawal`: minimal available withdrawal size
      + string
    + `currency`: the currency id
      + string
    + `funding_min_size`: minimal funding size
      + string
    + `withdrawal_fee`: withdrawal fee with same currency
      + string
    + `withdrawal_frozen`: available for withdrawal
      + boolean
    + `deposit_fee`: deposite fee with same currency
      + string
    + `min_unit`: the currency mininum unit
      + string
    + `type`: currency type
      + enum [`erc20`, `native`, `qrc20`, `atp10`]
    + `interest_increment`: the interest increment rate while margining
      + string
    + `cob_withdrawal_fee`: withdrawal fee with COB
      + string


## Show Exchange statistics

`/v1/market/stats [GET]`

    Returns exchange statistics in past 24 hours by trading pair.








### Response

> [Success] Response 200 (application/json)

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

`/v1/market/tickers [GET]`

    Returns all trading pair tickers.








### Response

> [Success] Response 200 (application/json)

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

`/v1/market/tickers/:trading_pair_id [GET]`

    Return trading pair of given trading pair.



### Path Parameters
  + `trading_pair_id`: trading pair symbol/id
    + string





### Response

> [Success] Response 200 (application/json)

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

`/v1/market/trades/:trading_pair_id [GET]`

    Returns recently trades of given trading pair.



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

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
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



  + `trades`: array
    + `maker_side`: order side
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

`/v1/market/trading_pairs [GET]`

    Returns all supported trading pairs and related information.








### Response

> [Success] Response 200 (application/json)

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
                "margin_enabled": false
            }
        ]
    }
}

```



  + `trading_pairs`: array
    + `base_currency_id`: the base currency symbol
      + string
    + `margin_enabled`: available for margin
      + boolean
    + `base_max_size`: max base volume size
      + string
    + `quote_increment`: the quote incremental step
      + string
    + `quote_currency_id`: the quote currency symbol
      + string
    + `id`: the trading pair symbol
      + string
    + `base_min_size`: min base volume size
      + string

# System


## Get System Time

`/v1/system/time [GET]`

    Get the reference system time as Unix timestamp.








### Response

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "time": 1505204498376
    }
}

```



  + `time`: server Unix timestamp in milliseconds
    + integer



# WebSocket [Deprecated]

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

**WARN**: v1 order update won't support complete conditional order and will deprecate. Please check v2 order update.


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
    "trading_pair_id": TRADING_PAIR_ID,
    "precision": PRECISION
}
```

> **Response**

```json
{
    "event": "subscribed",
    "type": "order-book",
    "channel_id": CHANNEL_ID,
    "trading_pair_id": TRADING_PAIR_ID,
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
            [ PRICE, COUNT, SIZE ],
            ...
        ],
        "asks": [
            [ PRICE, COUNT, SIZE ],
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

Send `ping` to test connection and extends disconnection timeout which is 64 seconds.

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

## WebSocket error code
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

### Error Code

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
+ `4011`: invalid_client_version. Wrong url endpoint for request/action.
+ `4012`: order_operation_rate_limit.


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

* NOTE: client could add a request id for identifying. The id would be appended to headers and returned as same value. For more details, please check example.

## Ping/Pong

Ping/pong extends disconnection timeout. If no ping/pong message recieved, connection will be dropped by server in 64 seconds after last seen ping/pong message.

> **Request**

```json
{
    "action": "ping",
    "id": "sample_id"
}
```

> **Response**

```json
{
    // [channel_id, version, type, request_id (optional)]
    "h": ["", "2", "pong", "sample_id"],
    "d": []
}
```

## Subscribe

Please check channels below. the optional parameters are different from channel to channel.

## Unsubscribe

Unsubscribe from given channel to reduce unused data stream.

**PARAMS**

+ `CHANNEL_ID`: recieved from subscribe request and response.

> **Request**

```json
{
    "action": "unsubscribe",
    "channel_id": CHANNEL_ID,
    "id": "sample_id2"
}
```
```json
{
    // Or same payload as subscribe, but with 'unsubscribe' in action.
    "action": "unsubscribe",
    "type": "ticker",
    "trading_pair_id": "ETH-BTC",
    "id": "sample_id2"
}
```

> **Response**

```json
{
    // [channel_id, version, type, request_id (optional)]
    "h": ["trade.ETH-BTC", "2", "unsubscribed", "sample_id2"],
    "d": []
}
```

## Error

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

> **Response**

```json
{
    // [channel_id, version, type, error_code, msg, request_id (optional)]
    "h": ["", "2", "error", "4002", "channel_not_found"],
    "d": []
}
```

## Channel Request/Response

## Order [Auth]

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
+ `SOURCE`: order source

> **Request**

```json
{
    "action": "subscribe",
    "type": "order"
}
```

```json
// order operation (place)
{
    "action": "place_order",
    "trading_pair_id": "COB-ETH",
    "type": "0",    // Type enum above
    "price": "123.4567",
    "size": "1000.000",
    "side": "bid"/"ask",
    "source": "exchange",
    "stop_price": "",        // mandatory for stop/stop-limit order
    "trailing_distance": "", // mandatory for trailing-stop order
    "id": "order_req_id1"
}
```

```json
// order operation (modify)
{
    "action": "modify_order",
    "type": "0",    // Type enum above
    "order_id": "xxxx-xxxx-xxxx-xxxx",
    "price": "123.4567",
    "size": "1000.000",
    "stop_price": "",        // mandatory for stop/stop-limit order
    "trailing_distance": "", // mandatory for trailing stop order
    "id": "order_req_id2"
}
```

```json
// order operation (cancel)
{
    "action": "cancel_order",
    "type": "0",    // Type enum above
    "order_id": "xxxx-xxxx-xxxx-xxxx"
}
```

> **Response**

##Limit Order

```json
{
    // [channel_id, version, message_type, order_type, request_id (optional)]
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
        PARTIAL_FILLED_SIZE,
        SOURCE
    ]
}
```

##Market Order

```json
{
    // [channel_id, version, message_type, order_type, request_id (optional)]
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
        PARTIAL_FILLED_SIZE,
        SOURCE
    ]
}
```

##Stop Order

```json
{
    // [channel_id, version, message_type, order_type, request_id (optional)]
    "h": ["order", "2", "u", "2"],
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
        STOP_PRICE,
        SOURCE
    ]
}
```

##Limit Stop Order

```json
{
    // [channel_id, version, message_type, order_type, request_id (optional)]
    "h": ["order", "2", "u", "3"],
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
        STOP_PRICE,
        SOURCE
    ]
}
```

## Orderbook

After receiving the response, you will receive a snapshot of the book, followed by updates upon any changes to the book.
The updates is published as **DIFF**.

**PARAMS**

+ `PRECISION`: available precisions could be acquired from REST, endpoint: `/v1/market/orderbook/precisions/<trading_pair_id>`
+ `PRICE`: order price
+ `SIZE`: order amount, diff may be minus value
+ `COUNT`: order count, diff may be minus value

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
            [ PRICE, COUNT, SIZE ],
            ...
        ],
        "asks": [
            [ PRICE, COUNT, SIZE ],
            ...
        ]
    }
}
```

## Trade

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
            [TRADE_ID, TIME_STAMP, MAKER_SIDE, PRICE, SIZE],
            ...
        ]
}
```

## Ticker

After receiving the response, you will start receiving ticker updates


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


## Candle

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
    "h": ["candle.ETH-BTC.1h", "2", "u"],
    "d":
        [
            [TIME_STAMP, VOL, HIGH, LOW, OPEN, CLOSE],
            ...
        ]
}
```

## Matched loans

After subscribing this topic, you will start receiving recent matched loans,
followed by any loan that occurs at COBINHOOD.

**State**

+ `loan_in_use`: loan is currently used
+ `loan_active`: loan created or available for funding
+ `loan_closed`: loan closed

**Event**

+ `0`: created
+ `1`: updated

**Side**

+ `ask`: mean ask loan
+ `bid`: mean bid loan


**PARAMS**

+ `LOAN_ID`: loan id
+ `TIME_STAMP`: timestamp in milliseconds
+ `WILL_CLOSE_AT`: the closing time of this loan
+ `COMPLETED_AT`: the loan completed time
+ `CURRENCY_ID`: currency id of this loan
+ `STATE`: loan event sate
+ `EVENT`: laon event type
+ `INTEREST_RATE`: loan interest rate
+ `SIZE`: loan size
+ `PERIOD`: the loan period
+ `AUTO_REFUND`: boolean to mark auto refund or not
+ `SIDE`: appears in authed loan for user to recognize created information.

> **Request**

```json
{
    "action": "subscribe",
    "type": "loan",
    "currency_id": CURRENCY_ID
}
```

> **Response**

```json
{
    "h": ["loan.COB", "2", "u"],
    "d":
        [
            [
                LOAN_ID,
                TIME_STAMP,
                WILL_CLOSE_AT,
                COMPLETED_AT,
                CURRENCY_ID,
                STATE,
                EVENT,
                INTEREST_RATE,
                SIZE,
                PERIOD,
                AUTO_REFUND
            ],
          ...
        ]
}
```

## User's loan updates [Auth]

After subscribing this topic, you will start receiving your loans' status update
Response format is same as matched loan.

> **Request**

```json
{
    "action": "subscribe",
    "type": "loan-update",
}
```

> **Response**

```json
{
    "h": ["loan-update", "2", "u"],
    "d":
        [
            [
                LOAN_ID,
                TIME_STAMP,
                WILL_CLOSE_AT,
                COMPLETED_AT,
                CURRENCY_ID,
                STATE,
                EVENT,
                INTEREST_RATE,
                SIZE,
                PERIOD,
                AUTO_REFUND
            ],
          ...
        ]
}
```

## Funding [Auth]

After subscribing this topic, you will get all funding updates at COBINHOOD.

**PARAMS**

+ `FUNDING_ID`: funding ID
+ `TIMESTAMP`: created timestamp
+ `COMPLETED_AT`: the funding completed time
+ `CURRENCY_ID`: currency of this funding
+ `STATE`: funding state
+ `INTEREST_RATE`: the intererest rate of this funding
+ `SIZE`: total size
+ `FILLED`: filled size
+ `PERIOD`: funding period
+ `AUTO_REFUND`: boolean to indicate auto refund or not

> **Request**

```json
{
    "action": "subscribe",
    "type": "funding",
}
```

> **Response**

```json
{
    // topic, version, type, funding type
    "h": ["funding", "2", "u", ],
    "d":
        [
            [
                FUNDING_ID,
                TIMESTAMP,
                COMPLETED_AT,
                CURRENCY_ID,
                STATE,
                INTEREST_RATE,
                SIZE,
                FILLED,
                PERIOD,
                AUTO_REFUND
            ],
          ...
        ]
}
```

## Fundingbook

After receiving the response, you will receive a snapshot of the book, followed by updates upon any changes to the book.
The updates is published as **DIFF**.

**PARAMS**

+ `PRECISION`: available precisions could be acquired from REST, endpoint: `/v1/market/fundingbook/precisions/<currency_id>`
+ `RATE`: funding rate
+ `SIZE`: funding amount, diff may be minus value
+ `COUNT`: funding count, diff may be minus value
+ `MIN_PERIOD`:  min period in this rate, diff may be minus value
+ `MAX_PERIOD`:  max period in this rate, diff may be minus value

> **Request**

```json
{
    "action": "subscribe",
    "type": "funding-book",
    "currency_id": CURRENCY_ID,
    "precision": PRECISION
}
```

> **Response**

```json
{
    // [channel_id, version, type]
    "h": ["funding-book.COB-ETH.1E-7", "2", "u"],
    "d": {
        "bids": [
            [ RATE, COUNT, SIZE, MIN_PERIOD, MAX_PERIOD ],
            ...
        ],
        "asks": [
            [ RATE, COUNT, SIZE, MIN_PERIOD, MAX_PERIOD ],
            ...
        ]
    }
}
```

## Loan Ticker

After receiving the response, you will start receiving loan ticker updates


+ `CURRENCY_ID`: Subscribe currency ID
+ `TIME_STAMP`: Ticker timestamp in milliseconds
+ `24H_VOLUME`: Funding volume of the last 24 hours
+ `24H_LOW`: Lowest loan price of the last 24 hours
+ `24H_HIGH`: Highest loan price of the last 24 hours
+ `24H_OPEN`: First loan price of the last 24 hours
+ `24H_CLOSE`: Last loan price of the last 24 hours

> **Request**

```json
{
    "action": "subscribe",
    "type": "loan-ticker",
    "currency_id": CURRENCY_ID
}
```

> **Response**

```json
{
    "h": ["ticker.COB", "2", "u"],
    "d": [
        [
          TIME_STAMP,
          24H_VOLUME,
          24H_HIGH,
          24H_LOW,
          24H_OPEN,
          24H_LAST
        ]
    ]
}
```