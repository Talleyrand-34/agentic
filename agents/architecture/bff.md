## BFF (Backend for Frontend)

A BFF is a **dedicated backend layer tailored to the needs of a specific frontend client**
(web app, mobile app, TV app). Instead of a single generic API consumed by all clients, each
client type gets its own BFF that aggregates, transforms, and optimizes data for that surface.

### Motivation

- A mobile app needs smaller payloads, fewer round trips, and offline-friendly responses.
- A web app needs richer data and may tolerate more round trips.
- A public API serves third-party developers and must be stable and versioned differently.
- A single "API for all clients" inevitably becomes a compromise that works poorly for everyone.

### BFF Responsibilities

- **Aggregation**: call multiple downstream microservices, combine results into a single response.
- **Transformation**: map internal domain models to client-specific view models.
- **Authentication/Session**: handle client-specific auth flows (e.g., mobile OAuth vs web cookies).
- **Caching**: cache downstream responses at a layer tuned for the client's usage patterns.
- **Versioning**: the BFF version is coupled to the client version — deprecate together.

### What the BFF Must NOT Do

- Contain business logic. The BFF is a presentation/aggregation layer, not a domain layer.
- Own a database. The BFF is stateless (or caches only); domain state lives in microservices.
- Be shared between fundamentally different clients (web vs mobile). That defeats the purpose.

### File Structure

```
bff-web/
├── src/
│   ├── routes/          # Express/Fastify/Next.js API routes
│   ├── aggregators/     # Functions that call multiple services and combine results
│   ├── view-models/     # Types mapping internal data to client-specific shapes
│   ├── clients/         # Typed HTTP/gRPC clients for downstream services
│   └── middleware/      # Auth, logging, error handling
├── tests/
│   ├── integration/     # Tests against real downstream service stubs (MSW, WireMock)
│   └── unit/            # Aggregator and view-model transformation tests
└── package.json
```

### Client Communication

- Use a single response envelope for all BFF responses:
  ```json
  { "data": { ... }, "meta": { "requestId": "...", "version": "1" } }
  ```
- Errors use a consistent error envelope:
  ```json
  { "error": { "code": "USER_NOT_FOUND", "message": "..." } }
  ```
- Optimize for the client: batch calls to downstream services in parallel; use `Promise.all` /
  goroutine fan-out / `asyncio.gather`.

### Versioning

- The BFF is versioned in lock-step with its client. When the mobile app releases v2, the BFF
  gets a `/v2` path or a new deployment.
- Old versions are kept alive until all clients using them are decommissioned.
- Never silently break a BFF contract — old mobile app versions may still be in use.

### Testing

- Unit test aggregators and view-model transformations.
- Integration test routes using service stubs (MSW for HTTP, local gRPC stubs).
- Contract tests against downstream services (Consumer-Driven Contract testing with Pact).
