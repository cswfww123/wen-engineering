# Good And Bad Tests

## Good Tests

Good tests verify observable behavior through real interfaces.

```typescript
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Characteristics:

- tests behavior users or callers care about
- uses public API only
- survives internal refactors
- describes what, not how
- keeps one logical assertion per test

## Bad Tests

Bad tests couple to internal structure.

```typescript
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Red flags:

- mocking internal collaborators
- testing private methods
- asserting on call counts or call order
- breaking after refactors when behavior did not change
- naming tests after implementation details
- verifying through external means instead of the interface

Prefer:

```typescript
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
