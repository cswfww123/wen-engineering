# When To Mock

Mock at system boundaries only:

- external APIs
- databases, when a test database is impractical
- time and randomness
- file systems, when real files are impractical

Do not mock:

- your own classes or modules
- internal collaborators
- anything you control

## Designing For Mockability

At system boundaries, design interfaces that are easy to mock.

Use dependency injection:

```typescript
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}
```

Prefer SDK-style interfaces over generic fetchers:

```typescript
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch("/orders", { method: "POST", body: data }),
};
```

This keeps mocks specific, simple, and type-safe.
