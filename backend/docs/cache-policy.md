# Cache Policy

## Scope

Phase 4 defines cache policy only. Production caching is not enabled yet.

## Candidates

| API | Suggested TTL | Cache Key |
| --- | --- | --- |
| `GET /api/v1/home` | 5 minutes | `home:v1` |
| `GET /api/v1/search/trending` | 1 minute | `search:trending:v1` |
| `GET /api/v1/search?q={q}&type={type}` | 2 minutes | `search:v1:{type}:{normalizedQuery}` |

`GET /api/v1/users/me/recent-searches` must not use a shared cache because it is user-scoped.

## Invalidation

- Invalidate `home:v1` when active ingredients or published recipes change.
- Invalidate relevant search keys when ingredient names, recipe titles, or publication status change.
- Trending search cache may expire by TTL without explicit invalidation.

## Safety

- Do not cache authenticated responses in shared keys.
- Normalize query whitespace and casing before building search keys.
- Redis failure must fall back to database-backed responses.
