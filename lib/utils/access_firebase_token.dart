import 'package:googleapis_auth/auth_io.dart';

class AccessTokenFirebase {
  static String firebaseMessagingScope = 'https://www.googleapis.com/auth/firebase.messaging';

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "let-s-chat-dd0da",
          "private_key_id": "aa77aac7aac182492f017a9ce1abd7ebb128a460",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCfsBHFH13xOW/P\np35aZlWRQyniIFOKC+R4GsMe8fGfmhK4NF1t+ksKAu6Aw8A2knMKq8qIv7ExS37J\nc8jXBMdZMUd6SLP/VZj/0xqS/O6a7S2YlIE0MIanxhc0ElJ7Ws5D53fQvWJqD23T\n4H+FVyNAnL90S42YIxO0OBswWqI96QMxSjJHxnBHSx8GhHF9Gdg4HAyadXJ6CdH3\nmZ4apnsn2xUUsbQJPEZQ9w/EGcaWYcwoFzNizq+P1U/EE24DrlknkrV6HRZz960v\n0XYRu0OmbTM0u88oEJYY1lM6Y1CZD7RZRTpRQ+crEu/ZkCkM+A1+H3HNurJOSP1p\nGtjo9YSpAgMBAAECggEADFmVHj4tSUUsaQ5mnr4wWvIrUJI4c8I0src7JO8IRVQo\no3dlTGahnA4a/PlmqbHM1OPxX38XyJyymwjp3PtBIZxGj2YFCbfIg+yDLyABohi6\nwISns24XU+1liQDrwR+GOUkzAoFLFbHIyCyiICFbmBknU2qucjgwQ21daPFxf8Eg\ntJoU4ji3PVSpDTKGH5NxRDGbWotGecY8egyb84kOmEJZEk8jfT53MPgpzLnN9LVU\ntPxzqXhe+P0n577oMxYLmn9HXn7ddD8BEDazZYyU1CrhMm+q7V0Rkbkh1PBxTenO\nt8xoarpT6ge/B/KrifoEZkZ5GuS9bY5Nacql1hdYMwKBgQDeO/GoJFxs8UBoojMA\netMBmlADvyl+SJOS6q+fLDDmsTyoNAk/CLjQ2fAZokG38/GJlkCuRB3Av2l4xvz1\nCxT6RNujzhvRldOJiKkZeIJz2ySZyV/w7+yCTHnweJnT81qkIBD2iXmoIJ4VV6FS\nuzNuT6X2/lCFXLf6imGXXPl6GwKBgQC380+gK3cSQkXjejwcYKxENkMN7NEELS7q\nj7NFNMQdBWhw1aL8sqHkqWQcJSWg2sp/Nr0bYp9vSdYJzf+e08QxH4hhj89Ewtf7\nls4SsVC7wUw3q5ymyP+JxTQtuE2NmZreSni3sITKX9uCDuQHdNFbKF6XGfjyD8I1\nJWGePgQoiwKBgQDORBz7zyPqCdGaTFHCND380tlJYPiGOZ6fUixHNKD+vaprBEFA\nvDutvVpYsH0G2+hnp4nJNXfYGtEuRKMsXWjPEXI7C2ZOlR2OHcW12mBaYCAMjRf7\nbPS7y3eydn1weAK9KvYTnW3JWtzfOkKFozMNQ+fq5Aigf3pTlHUYJDd52QKBgQCt\nHQHWjpEkUdJL3gEsA56bIyW/uRqLf6ojfNENVDcryKcdaTBV+BZ7hx57jkn3M3BW\ngEE/wHSi2y3fVEo4QrrkL/S9PAWnhGaWkrmkxdJgn+0Ghy6Jl6dFFJ2iWUxC8kfY\n4uTwmeKeQc/mefUHP1y3GSrLsNmjlEkEkwVnUp2/OQKBgCcxgZ4mnebMBvH/1t6Z\nwpYDNQe6zf2+4hpJy9gUBFwZ2vTpEmaArqjtBw0Q3T9sh5GQyCavbKGf0oWV5dGT\n4FzT0Zv/G7m3RsWinTBr0VTPC/QiLluGHvPJ0qU2ooHLE4ZtT8hPRo8tZzuUtybb\n5jZh/WegcIDzpthHFl1v3g+Z\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-iixga@let-s-chat-dd0da.iam.gserviceaccount.com",
          "client_id": "115898124265858511153",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-iixga%40let-s-chat-dd0da.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [firebaseMessagingScope]);

    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }
}
