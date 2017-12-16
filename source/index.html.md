---
title: COBINHOOD Exchange - API Reference

language_tabs:
- http

toc_footers:
- <a href='https://cobinhood.com'>COBINHOOD</a>
---

<aside class="notice">
** NOTE: COBINHOOD IS CURRENTLY UNDER HEAVY DEVELOPMENT, APIs ARE SUBJECT TO CHANGE WITHOUT PRIOR NOTICE **
</aside>

# Overview
COBINHOOD RESTful API URL: `https://api.cobinhood.com`

COBINHOOD WebSocket API URL: `wss://feed.cobinhood.com`

RESTful API SandBox: `https://sandbox-api.cobinhood.com`

WebSocket API SandBox: `wss://sandbox-feed.cobinhood.com`

## HTTP Request Headers
`device_id`
`nonce` for 'POST' 'UPDATE' 'DELETE'

## Timestamps
All timestamps exchanged between client and server are based on server Unix UTC timestamp. Please refer to System Module for retrieving server timestamp.

## Floating Point Values
All floating point values in responses are encoded in `string` type to avoid loss of precision.

## UUID String
+ String
+ e.g. "09619448-e48a-3bd7-3d49-3a4194f9020b"

## Authentication
COBINHOOD uses JWT for APIs that require authentication. JWT header field name is `authorization`. The JWT can be generated and revoked on COBINHOOD exchange API console page.

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
All API requests are rate-limited at 10 requests/sec per user, and 50 requests/sec per IP address.

## Pagination

> Request URL:

```
https://api.cobinhood.com/v1/trading/trades?limit=30&page=7
```

> Response headers:

```
Link: <https://api.cobinhood.com/v1/trading/trades?limit=30&page=1>; rel="first",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=6&before=cGFnZTZkdWRlaXRzanVzdGFuZXhhbXBsZXdoeXNvc2VyaW91c2NoaWxsCg==>; rel="prev",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=8&before=cGFnZThkdWRlaXRzanVzdGFuZXhhbXBsZXdoeXNvc2VyaW91c2NoaWxsCg==>; rel="next",<https://api.cobinhood.com/v1/trading/trades?limit=30&page=15>; rel="last"
X-Total-Count: 431
```

For APIs that return large amounts of data, the response may need to be paginated, e.g. retrieving the trade history. When pagination is required, a `Link` field can be found in the headers. Take the trade history request as an example:

The `Link` header contains a list of links that direct to the first, previous, next, and last pages of the paginated data. APIs that support pagination take a `limit` query parameter to indicate the page size. Clients should use `limit` to specify the number of entries per page, and use links provided in the response header to navigate through the paginated data. The header `X-Total-Count` indicates the total number of existing entries, in our case, 431 trades.

# Account

## Locale Enum
+ String
+ enum [`en_us`, `zh_cn`, `zh_tw`]

## Generate Device ID

> `/v1/account/device [POST]`

```json
{
    "platform": "web", // web, ios, android
    "optional": "" // optional information
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "device_id": "<uuid>"
    }
}
```


+ [Error]

## Register

> Payload

```json
{
    "email": "bojie@cobinhood.com",
    "password": "12345678",
    "g_recaptcha_token": "<reCAPTCHA token>",
    "device_id": "<device ID>",
    "platform": "<web / ios / android>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for checkEmailVerification API>"
    }
}
```

> [Register JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

`/v1/account/register [POST]`

+ [Error]

## Resend Email Verification

> Payload

```json
{
	"token": "<JWT from register API>"
}
```

> [Register JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for checkEmailVerification API>"
    }
}
```

> [Register JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

`/v1/account/resendEmailVerification [POST]`
+ [Error]

## Confirm Email Verification

> Payload

```json
{
	"token": "<JWT from email verification>"
}
```

> [Register JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "email_verified_success"
    }
}
```

`/v1/account/confirmEmailVerification [POST]`

+ [Error]

## Check Email Verification

> Payload

```json
{
    "token": "<JWT from register API>"
}
```

> [Register JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for access auth APIs>"
    }
}
```

> [AccessToken JWT Payload]

```json
{
    "user_id": "<user ID>",
    "access_token_id": "<access token ID>",
    "scope": {
        "exchange": true,
        "customer_support": true,
        "kyc": true,
        "operation": true
    },
    "exp": "<expire time>"
}
```

`/v1/account/checkEmailVerification [POST]`

+ [Error]

## Login

> Payload

```json
{
	"email": "bojie@cobinhood.com",
	"password": "12345678",
	"g_recaptcha_token": "<reCAPTCHA token>",
	"device_id": "<device ID>",
    "platform": "<web / ios / android>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "type": "none", // none, sms, totp, new_device, email_not_verified
        "token": "<none -> JWT for access auth APIs," +
        "sms/totp -> JWT for 2FALogin API," +
        "new_device -> JWT for checkDeviceVerification API" +
        "email_not_verified -> JWT for resendEmailVerification API>"
    }
}
```

> [Two FA Login JWT Payload]

```json
{
    "login_id": "<login ID>",
    "exp": "<expire time>"
}
```

> [Resend Email Verification JWT Payload]

```json
{
    "registration_id": "<registration ID>",
    "exp": "<expire time>"
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

> [AccessToken JWT Payload]

```json
{
    "user_id": "<user ID>",
    "access_token_id": "<access token ID>",
    "scope": {
        "exchange": true,
        "customer_support": true,
        "kyc": true,
        "operation": true
    },
    "exp": "<expire time>"
}
```

`/v1/account/login [POST]`

+ [Error]

##  2FA Login

> Payload

```json
{
    "token": "<JWT from login API>",
    "code": "1234",
    "device_id": ""
}
```

> [Two FA Login JWT Payload]

```json
{
    "login_id": "<login ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "type": "new_device", // none, new_device
        "token": "<new_device -> JWT for checkDeviceVerification API, none -> JWT for access APIs>"
    }
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

> [AccessToken JWT Payload]

```json
{
    "user_id": "<user ID>",
    "access_token_id": "<access token ID>",
    "scope": ["exchange", "customer_support", "kyc", "operation"],
    "exp": "<expire time>"
}
```

`/v1/account/2FALogin [POST]`
+ [Error]

## Confirm Device Verification

> Payload

```json
{
    "token": "<JWT from device verification>"
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "device_verified_success"
    }
}
```

`/v1/account/confirmDeviceVerification [POST]`
+ [Error]

## Check Device Verification

> Payload

```json
{
    "token": "<JWT from login / 2FALogin / resendDeviceVerification API>"
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for access auth APIs>"
    }
}
```

> [AccessToken JWT Payload]

```json
{
    "user_id": "<user ID>",
    "access_token_id": "<access token ID>",
    "scope": {
        "exchange": true,
        "customer_support": true,
        "kyc": true,
        "operation": true
    },
    "exp": "<expire time>"
}
```

`/v1/account/checkDeviceVerification [POST]`
+ [Error]

## Resend Device Verification

> Payload

```json
{
    "token": "<JWT from login / 2FALogin API / resendDeviceVerification API>"
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for checkDeviceVerification API>"
    }
}
```

> [New Device JWT Payload]

```json
{
    "login_id": "<login ID>",
    "device_authorization_id": "<device authorization ID>",
    "exp": "<expire time>"
}
```

`/v1/account/resendDeviceVerification [POST]`
+ [Error]

## Forgot Password

> Payload

```json
{
    "email": "bojie@cobinhood.com"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "reset_password_email_send"
    }
}
```

`/v1/account/forgotPassword [POST]`
+ [Error]

## Reset Password

> Payload

```json
{
	"token": "<JWT from email verification>",
	"password": "123456"
}
```

> [Reset Password Email JWT Payload]

```json
{
    "reset_password_id": "<reset password ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "2fa": "none", // none, sms, totp
        "token": "<none -> empty, sms/totp -> for confirmResetPasswordWith2FA>"
    }
}
```

`/v1/account/resetPassword [POST]`
+ [Error]

## Confirm Reset Password With 2FA

> Payload

```json
{
	"token": "<JWT from resetPassword API>",
	"code": "123456"
}
```

> [Reset Password JWT Payload]

```json
{
    "reset_password_id": "<reset password ID>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "reset_password_success"
    }
}
```

`/v1/account/confirmResetPasswordWith2FA [POST]`
+ [Error]

## Change Password

> Payload

```json
{
	"old_password": "123456",
	"new_password": "123456"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "2fa": "none",  // none, sms, totp
        "token": "<Change Password JWT Payload>"  // empty if none
    }
}
```

> [Change Password JWT Payload]

```json
{
    "change_password_id": "<reset password ID>",
    "exp": "<expire time>"
}
```

`/v1/account/changePassword [POST]`
+ [Error]

## Confirm Change Password

> Payload

```json
{
    "token": "<Change Password JWT>",
    "code": "123456"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "messsage": "password_changed"
    }
}
```

`/v1/account/confirmChangePassword [POST]`
+ [Error]

## Enable 2FA

> Payload

```json
{
    "2fa": "sms", //none, sms, totp
    "country_code": "+886", // if 2fa == sms
    "phone_num": "999999999" // if 2fa == sms
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "token": "<JWT for confirm2FA API>"
    }
}
```

> [Auth JWT payload] `if 2fa == sms || 2fa == totp`

```json
{
    "auth_id": "<2FA auth ID>",
    "totp_url": "<TOTP url>",
    "exp": "<expire time>"
}
```

`/v1/account/enable2FA [POST]` [Authentication Required]
+ [Error]

## Verify 2FA

> Payload

```json
{
	"token": "<JWT from enable2FA API>",
	"code": "1234"
}
```

> [Auth JWT payload]

```json
{
    "auth_id": "<2FA auth ID>",
    "totp_url": "<TOTP url>",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "two_fa_verified"
    }
}
```

+ [Error]

## Confirm Enable 2FA
`/v1/account/confirmEnable2FA [POST]`

> Payload

```json
{
	"token": "<JWT from email link which is sent after 2FA verified>",
}
```

> [Auth JWT payload]

```json
{
    "auth_id": "<2FA auth ID>",
    "type": "sms|totp",
    "exp": "<expire time>"
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "two_fa_enabled"
    }
}
```

`/v1/account/verify2FA [POST]` [Authentication Required]
+ [Error]

# User

## Get User Info

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "id": "<user ID>",
        "email": "<user email>",
        "profile_picture": "<base64 encoded string>",
        "account_type": "<individual / corporation>",
        "corporation": "<corporation>",
        "first_name": "<first name>",
        "last_name": "<last name>",
        "passport_cover_picture": "<base64 encoded string>",
        "passport_inner_picture": "<base64 encoded string>",
        "selfie_picture": "<base64 encoded string>",
        "kyc_status": "<rejected / completed / pending_verification / not_submitted>",
        "kyc_updated_at": "<time>",
        "timezone": "<int>",
        "locale": "<en_us / zh_cn / zh_tw>",
        "email_notification": "<bool>",
        "is_freezed": "<bool>"
    }
}
```

`/v1/user/info [GET]`
+ [Error]

## Update User Info

> Payload

```json
{
	"profile_picture": "<base64 encoded string>",
    "account_type": "<individual / corporation>",
    "corporation": "<corporation>",
    "first_name": "<first name>",
    "last_name": "<last name>",
    "locale": "<en_us / zh_cn / zh_tw>",
    "email_notification": "<bool>",
}
```

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message": "update_success"
    }
}
```

`/v1/user/info [PATCH]`
+ [Error]

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
+ `time`: Server Unix timestamp in milliseconds
    + int

## Get System Information
`/v1/system/info [GET]`

    Get system information

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
    	"info": {
            "phase": "production_online",
            "revision": "480bbd"
	}
    }
}
```
`/v1/system/time [GET]`

    Get the reference system time as Unix timestamp

+ `phase`: System Phase
    + enum[`open_beta`, `production_online`]
+ `revision`: Revision number of the system deployment
    + string


## System Message Priority Enum
> String
> enum [`normal`, `warning`, `critical`]

## Get System Message IDs
> Query parameters
    + `limit`: Limit the number of list.
        + Optional
        + Int
        + The default value is 50 if not specified. Max limit is 200.

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "messages": [
            {
                "id": "09619448-e48a-3bd7-3d49-3a4194f9020b",
                "announce_time": 1504459805123,
                "priority": "normal",
                "subject": "..."
            },
            ...
        ]
    }
}
```

`/v1/system/messages [GET]`

    Get the list of latest system message IDs. This API only can get messages which have been announced.

+ `id`: Message ID
    + [UUID String](#uuid-string)
+ `announce_time`: The time of announcement
    + Int
    + Milliseconds
+ `priority`: The priority of this message
    + [Priority Enum](#system-message-priority-enum)
+ `subject`: The default subject of this message
    + String

## Get System Message

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "<message_id>": {
            "<locale_enum>": {
                "subject": "...",
                "content": "..."
            },
            "en_us": {
                "subject": "Hello",
                "content": "..."
            },
            "zh_tw": {
                "subject": "安安",
                "content": "..."
            },
            ...
        }
    }
}
```

`/v1/system/messages/<message_id> [GET]`

    Get a system message. This API only can get messages which have been announced.

+ `locale_enum`: The locale of this message. `locale_enum` must be replaced with one of enum.
    + [Locale Enum](#locale-enum)
+ `subject`: The subject of this locale message
    + String
+ `content`: The content of this locale message
    + String

+ Path Parameters
    + `message_id`: Message ID
        + Required
        + [UUID String](#uuid-string)
+ Query parameters
    + `locale`: Specify the locale of this message.
        + Optional
        + [Locale Enum](#locale-enum)
        + Return all locales if not specified.

## Get System Message IDs [Admin]

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "messages": [
            {
                "id": "09619448-e48a-3bd7-3d49-3a4194f9020b",
                "announce_time": 1504459805123,
                "priority": "normal",
                "subject": "...",
                "has_forwarded": false
            },
            ...
        ]
    }
}
```

`/v1/admin/system/messages [GET]`

    Get the list of system message IDs from the latest announcement. This API can get messages which have
	not been announced yet. For example, now is 2017-10-24 18:00:00 and the time of latest announcement
	is 2017-10-25 09:00:00. If the query parameter, announce_time, is empty string, the list of system
	messages starts from 2017-10-25 09:00:00.

+ Query parameters
    + `announce_time`: Specify the time of announcement.
        + Optional
        + Int
        + Milliseconds
        + The default value is the latest announcement time if not specified.
    + `limit`: Limit the number of list.
        + Optional
        + Int
        + The default value is 50 if not specified. Max limit is 200.

+ `id`: Message ID
    + [UUID String](#uuid-string)
+ `announce_time`: The time of announcement
    + Int
    + Milliseconds
+ `priority`: The priority of this message
    + [Priority Enum](#system-message-priority-enum)
+ `subject`: The default subject of this message
    + String
+ `has_forwarded`: Have all locale messages been forwarded to the mail server?
    + Bool

## Get System Message [Admin]

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "<message_id>": {
            "<locale_enum>": {
                "subject": "Hello",
                "content": "...",
                "has_forwarded": false
            },
            "zh_tw": {
                "subject": "安安",
                "content": "...",
                "has_forwarded": false
            },
            ...
        }
    }
}
```

`/v1/admin/system/messages/<message_id> [GET]`

    Get the system Locale messages

+ Path Parameters
    + `message_id`: Message ID
        + Required
        + [UUID String](#uuid-string)
+ Query parameters
    + `locale`: Specify the locale of this message.
        + Optional
        + [Locale Enum](#locale-enum)
        + Return all locales if not specified.

+ `locale_enum`: The locale of this message. `locale_enum` will be replaced with one of enum.
    + [Locale Enum](#locale-enum)
+ `subject`: The subject of this locale message
    + String
+ `content`: The content of this locale message
    + String
+ `has_forwarded`: Has this locale message been forwarded to the mail server?
    + Bool


## Create System Message [Admin]
> Payload

```json
{
    "announce_time": 1504459805123,
    "priority": "normal",
    "subject": "Hello World",
    "locales": {
        "<locale_enum>": {
            "subject": "...",
            "content": "..."
        },
        "en_us": {
            "subject": "Hello",
            "content": "..."
        },
        "zh_tw": {
            "subject": "安安",
            "content": "..."
        },
        ...
    }
}
```

`/v1/admin/system/messages [POST]`

    Create a new system message. If now is 2017-10-24 18:00:00 and this API can't create messages which
	annouce_time is before 17:55:00.

+ `announce_time`: The time of announcement
    + Required
    + Int
    + Milliseconds
+ `priority`: The priority of this message
    + Required
    + [Priority Enum](#system-message-priority-enum)
+ `subject`: The default subject of this message
    + Required
    + String
+ `locale`: The locale of this message.
    + Required
+ `locale_enum`: The locale of this message. `locale_enum` must be replaced with one of enum.
    + Required
    + [Locale Enum](#locale-enum)
+ `locale_enum -> subject`: The subject of this locale message
    + Required
    + String
+ `content`: The content of this locale message
    + Required
    + String

### Success

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "message_id": "09619448-e48a-3bd7-3d49-3a4194f9020b"
    }
}
```

+ `message_id`: Message ID
    + [UUID String](#uuid-string)

## Update System Message [Admin]
> Payload

```json
{
    "announce_time": 1504459805123,
    "priority": "normal",
    "subject": "Hello World",
    "locales": {
        "<locale_enum>" : {
            "subject": "...",
            "content": "..."
        },
        "zh_tw": {
            "subject": "您好",
            "content": "..."
        }
    }
}
```

`/v1/admin/system/messages/<message_id> [PATCH]`

    Update system message. If now is 2017-10-24 18:00:00 and this API can't update messages which original annouce_time is before 18:05:00.

+ `id`: Message ID. It must be replaced with UUID.
    + Optional
    + [UUID String](#uuid-string)
+ `announce_time`: The time of announcement
    + Optional
    + Int
    + Milliseconds
+ `priority`: The priority of this message
    + Optional
    + [Priority Enum](#system-message-priority-enum)
+ `subject`: The default subject of this message
    + Optional
    + String
+ `locale`: The locale of this message.
    + Required
+ `locale_enum`: The locale of this message. `locale_enum` must be replaced with one of enum.
    + Optional
    + [Locale Enum](#locale-enum)
+ `locale_enum -> subject`: The subject of this locale message
    + Optional
    + String
+ `content`: The content of this locale message
    + Optional
    + String

### Success

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
    }
}
```

## Delete System Message [Admin]
> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
    }
}
```

`/v1/admin/system/messages/<message_id> [DELETE]`

    Delete a system message. If now is 2017-10-24 18:00:00 and this API can't delete messages which
	annouce_time is before 18:05:00.

+ Path Parameters
    + `message_id`: Message ID
        + Optional
        + [UUID String](#uuid-string)

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

+ Path Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required

+ Query parameters
    + `limit`: Limits number of entries of asks/bids list, beginning from the best price for both sides
        + int
        + optional
        + Defaults to 50 if not specified, if limit is `0`, it means to fetch the whole order book.

+ `sequence`: A sequence number that is updated on each orderbook state change
    + int
+ `price`: Order price
    + string
+ `size`: The aggregated total amount in the price group
    + string
+ `count`: The number of orders within current price range
    + string
    + e.g. when `precision=2`,  4137.181 and 4137.1837 would both fall into price group 4137.18


## Get Ticker

`/v1/market/tickers/<trading_pair_id> [GET]`

    Returns ticker for specified trading pair

+ Path Parameters
    + `trading_pair_id`
        + enum[`BTC-USDT`, `...`]
        + required

### Success
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
+ [Success] Response 200 (application/json)

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
        + Defaults to 20 if not specified, Maximun 50.

### Success
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
                "maker_side": "buy"
                "timestamp": 1504459805123
            },
            ...
        ]
    }
}
```

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
`/v1/chart/candles/<trading_pair_id>`

    Get charting candles

+ Path Parameters
    + `trading_pair_id`
        + enum[`BTC-USDT`, `...`]
        + required

+ Query parameter
    + `start_time`: Unix timestamp in seconds
        + int
        + optional
        + Defaults to 0 if not specified
    + `end_time`: Unix timestamp in seconds
        + int
        + optional
        + Defaults to current server time if not specified
    + `timeframe`: Time span of data aggregation
        + enum[`1m`, `5m`, `15m`, `30m`, `1h`, `3h`, `6h`, `12h`, `1D`, `7D`, `14D`, `1M`]
        + required
        + `timeframe` is limited to the range specified by the `start_time` and `end_time` fields, e.g. if range has a span of 3 hours, `timeframe` should only be one of `1m`, `5m`, `15m`, or `1h`

### Success
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
+ `timestamp`: Time of candlestick, Unix time in seconds, rounded up to zero point of each timeframe intervals
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

# Trading

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

+ Path Parameters
    + `order_id`: Order ID
        + string
        + required

+ [Success] Response 200 (application/json)

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

`/v1/trading/orders [GET]` [Authentication Required]

    List all current orders for user

+ Query parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + optional
        + Returns orders of all trading pairs if not specified
    + `limit`: Limits number of orders per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

+ [Success] Response 200 (application/json)

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

`/v1/trading/orders [POST]` [Authentication Required]

    Place orders to ask or bid

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

### Success

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

## Cancel Order
```json
{
    "success": true
}
```

`/v1/trading/orders/<order_id> [DELETE]` [Authentication Required]

    Cancel a single order

+ Path parameter
    + `order_id`: Order ID
        + string
        + required

+ [Success] Response 200 (application/json)


## Get Order History
`/v1/trading/order_history [GET]` [Authentication Required]

    Returns order history for the current user

> Query Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USD`, `...`]
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
`/v1/trading/trades/<trade_id> [GET]` [Authentication Required]

    Get trade information. A user only can get their own trade.

+ Path Parameters
    + `trade_id`: Trading ID
        + Required
        + [UUID String](#uuid-string)

+ [Success] Response 200 (application/json)

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

`/v1/trading/trades [GET]` [Authenication Required]

    Returns trade history for the current user

+ Path Parameters
    + `trading_pair_id`: Trading pair ID
        + enum[`BTC-USDT`, `...`]
        + required
    + `limit`: Limits number of trades per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

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

# Wallet

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
                "total": "5.00000001",
                "on_order": "1.00000000"
            },
            ...
        ]
    }
}
```

`/v1/wallet/balances [GET]` [Authentication Required]

    Get Wallet Balances

+ Query Parameter
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + returns all currencies if not specified

+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `total`: Total amount in wallet
    + string
+ `on_order`: The amount in order book
    + string

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

`/v1/wallet/ledger [GET]` [Authentication Required]

    Get balance history for the current user

+ Query Parameter
    + `currency`: Currency ID
        + enum[`BTC`, `ETH`, ...]
        + optional
        + returns balance history for all currencies if not given
    + `limit`: Limits the number of balance changes per page
        + int
        + optional
        + Defaults to 20 if not specified, Maximun 50.

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

## Generate New Deposit Address
> Payload

```json
{
    "currency": "BTC"
}
```
+ `currency`: Currency ID
    + enum[`BTC`, `ETH`, ...]

> [Success] Response 200 (application/json)

```json
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

`/v1/wallet/deposit_addresses [POST]` [Authentication Required]

    Generate a New Deposit Address

+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: Newly generated user deposit address
    + string
+ `created_at`: Address creation time in milliseconds
    + int

## Get Deposit Addresses

`/v1/wallet/deposit_addresses [GET]` [Authentication Required]

    Get Wallet Deposit Addresses

+ Query Parameters
    + `currency`: Currency ID
        + enum[`BTC`, ...]
        + optional

### Success

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

> [Success] Response 200 (application/json)

+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: Newly generated deposit address
    + string
+ `created_at`: Address creation time in milliseconds
    + int

## Add Withdrawal Address

> Payload

```json
{
    "currency": "BTC"
}
```

`/v1/wallet/withdrawal_addresses [POST]` [Authentication Required]

    Add a New Withdrawal Address
    NOTE: Requires 2FA and Email verification if configured by user
    TODO: Add 2FA + Email

+ `currency`: Currency ID
    + enum[`BTC`, `ETH`, ...]

### Success

> [Success] Response 200 (application/json)

```json
{
    "success": true,
    "result": {
        "withdrawal_address": {
            "currency": "BTC",
            "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
            "created_at": 1504459805123
        }
    }
}
```
+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: Newly added address
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
                "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20",
                "created_at": 1504459805123
            },
            ...
        ]
    }
}
```

`/v1/wallet/withdrawal_addresses [GET]` [Authentication Required]

    Get Wallet Withdrawal Addresses

+ Query Parameters
    + `currency`: Currency ID
        + enum[`BTC`, ...]
        + optional

+ `currency`: Currency ID
    + enum[`BTC`, ...]
+ `address`: User withdrawal address
    + string
+ `created_at`: Address creation time in milliseconds
    + int

## Withdraw Funds
> Payload

```json
{
    "currency": "BTC",
    "amount": "1.00000001",
    "address": "0xbcd7defe48a19f758a1c1a9706e808072391bc20"
}
```

`/v1/wallet/withdrawals [POST]` [Authentication Required]

    Create a Withdrawal Request

+ `currency`: Currency ID
    + string
    + required
+ `amount`: Withdrawal amount
    + string
    + required
+ `address`: The target address for withdrawal
    + string
    + required

> [Success] Response 200 (application/json)

```json
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

## Get Withdrawal

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

`/v1/wallet/withdrawals/<withdrawal_id> [GET]` [Authentication Required]

    Get Withdrawal Information

+ Path Parameters
    + `withdrawal_id`: Withdrawal ID
        + string
        + required

+ [Success] Response 200 (application/json)

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

`/v1/wallet/withdrawals [GET]` [Authentication Required]

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
        + Defaults to 20 if not specified, Maximun 50.

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
`/v1/wallet/deposits/<deposit_id> [GET]` [Authentication Required]

    Get Deposit Information

+ Path Parameters
    + `deposit_id`: Deposit ID
        + string
        + required

+ [Success] Response 200 (application/json)

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

`/v1/wallet/deposits [GET]` [Authentication Required]

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

# WebSocket Authenticated Channels

COBINHOOD uses JWT for APIs that require authentication. JWT header field name is `authorization`. The JWT can be generated and revoked on COBINHOOD exchange API console page.

## Order [Authentication Required]

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

# WebSocket Public Channels

All parameter in the WebSocket api is string format.

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

> **Snapshot / Update**

```json
//snapshot
{
    "channel_id": CHANNEL_ID,
    "snapshot":
        [
          [TRADE_ID, TIME_STAMP, PRICE, SIZE, MAKER_SIDE],
          ...
        ]
}

//update
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
  "type": 'book',
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Response**

```json
{
  "event": "subscribed",
  "type": "book",
  "channel_id": CHANNEL_ID,
  "trading_pair_id": TRADING_PAIR_ID
}
```

> **Snapshot / Update**

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

> **Snapshot / Update**

```json
//snapshot
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

//update
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

> **Snapshot / Update**

```json
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
