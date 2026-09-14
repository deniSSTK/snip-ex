# ShipEx

ShipEx is a tiny URL shortener API I built for fun, mainly to satisfy my curiosity about how Elixir and Phoenix work in practice. It intentionally has only three endpoints: create a link, follow its short URL, and view its click count.

## Run with Docker Compose

1. Optionally create a `.env` file in the project root to override the defaults:

   ```dotenv
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_NAME=ship_ex_dev
   API_KEY=secret-token-123
   ```

2. Start the API and PostgreSQL:

   ```sh
   docker compose up --build
   ```

The API listens on `http://localhost:4000`. The application runs database migrations automatically when its container starts.

## How it works

`Link` is the only domain entity. It stores the original URL, a randomly generated short code, and a click counter. Creating a link requires an API key; redirecting through a short URL increments its counter; fetching statistics returns the original URL and current count.

| Endpoint | Purpose |
| --- | --- |
| `POST /api/links` | Creates a short link. Requires the `x-api-key` header. |
| `GET /r/:code` | Redirects to the original URL and increments `clicks`. |
| `GET /api/links/:code/stats` | Returns link details and its click count. Requires the `x-api-key` header. |

## Example

```sh
curl -X POST http://localhost:4000/api/links \
  -H 'content-type: application/json' \
  -H 'x-api-key: secret-token-123' \
  -d '{"url":"https://elixir-lang.org"}'

curl -i http://localhost:4000/r/SHORT_CODE

curl http://localhost:4000/api/links/SHORT_CODE/stats \
  -H 'x-api-key: secret-token-123'
```
