# Deep Code Trace Examples

Each example shows the **trace shape** — entry, queue, one parallel round, visited ledger, stop boundaries, one-line conclusion. They are representative, not tied to a specific framework version; what matters is *how the call chain is bounded*, not the library API.

## Java / Spring

User: "Walk me through the logic in UserService.createUser()."

```text
Round 1: read UserService.createUser()
`-- found internal calls: validateUser(dto), userManager.save(user), publishEvent(userId)

Round 2: read queued calls in parallel
|-- UserService#validateUser(dto)
|   `-- found: checkDuplicate(phone), validateFields(dto)
|       |-- UserService#checkDuplicate -> userMapper.selectByPhone [stops: mapper query read]
|       `-- UserService#validateFields -> checkEmailFormat, roleMapper.selectById [stops: query read]
|
|-- UserManager#save(user)
|   `-- found: userMapper.insert(user), roleManager.assignDefaultRole(userId)
|       `-- RoleManager#assignDefaultRole
|           |-- roleMapper.selectDefaultRole [stops: mapper query read]
|           `-- userRoleMapper.insert [stops: mapper write read]
|
`-- EventPublisher#publish(userId)
    `-- buildUserCreatedEvent(userId) -> plain POJO construction, no internal call [stops: data-only boundary]

Visited: UserService#validateUser, UserService#checkDuplicate, UserService#validateFields,
         UserManager#save, RoleManager#assignDefaultRole, EventPublisher#publish,
         EventPublisher#buildUserCreatedEvent
```

Full understanding: validation (phone deduplication and field format) -> persistence -> default role assignment -> event publication.

## Next.js / TypeScript

User: "Walk me through the createUser server action."

```text
Round 1: read createUser (app/actions/user.ts)
`-- found internal calls: validateUser(dto), db.user.create(...), publishUserCreated(id)

Round 2: read queued calls in parallel
|-- validateUser(dto)                       [app/actions/user.ts]
|   `-- found: checkDuplicate(email)
|       `-- checkDuplicate -> db.user.findUnique({ where: { email } }) [stops: ORM query read]
|
|-- db.user.create(...)                     [stops: external ORM]
|
`-- publishUserCreated(id)                  [lib/events.ts]
    `-- found: buildUserCreatedEvent(id)
        `-- buildUserCreatedEvent -> plain object literal [stops: data-only boundary]

Visited: createUser, validateUser, checkDuplicate, publishUserCreated, buildUserCreatedEvent
```

Full understanding: email dedup -> DB insert -> user-created event.

## Rust

User: "Walk me through UserService::create_user."

```text
Round 1: read UserService::create_user (src/user/service.rs)
`-- found internal calls: validate(&dto), repo.insert(user), bus.publish(UserCreated)

Round 2: read queued calls in parallel
|-- validate(&dto)                          [src/user/validate.rs]
|   `-- found: check_duplicate(dto.email)
|       `-- check_duplicate -> repo.find_by_email(...) [stops: repository query read]
|
|-- repo.insert(user)                       [src/user/repo.rs]
|   `-- repo is a trait; pg impl runs SQL via sqlx [stops: external crate]
|
`-- bus.publish(UserCreated)                [src/events/bus.rs]
    `-- found: serialize(event)
        `-- serialize -> serde derive output [stops: external crate]

Visited: UserService::create_user, validate, check_duplicate, repo.insert, bus.publish, serialize
```

Full understanding: email dedup -> INSERT -> publish serialized event.

## Go

User: "Walk me through UserService.Create."

```text
Round 1: read UserService.Create (user/service.go)
`-- found internal calls: s.validate(ctx, dto), s.repo.Save(ctx, user), s.events.Publish(ctx, ev)

Round 2: read queued calls in parallel
|-- s.validate(ctx, dto)                    [user/validate.go]
|   `-- found: checkDuplicate(ctx, dto.Email)
|       `-- checkDuplicate -> s.repo.FindByEmail(ctx, email) [stops: query read]
|
|-- s.repo.Save(ctx, user)                  [user/repo.go]
|   `-- repo is an interface; pg impl calls db.QueryContext [stops: external database/sql]
|
`-- s.events.Publish(ctx, ev)               [events/publisher.go]
    `-- found: marshal(ev)
        `-- marshal -> json.Marshal [stops: stdlib]

Visited: UserService.Create, validate, checkDuplicate, repo.Save, events.Publish, marshal
```

Full understanding: email dedup -> Save -> publish JSON event.

## Python

User: "Walk me through create_user in users/service.py."

```text
Round 1: read create_user (users/service.py)
`-- found internal calls: validate_user(dto), repo.add(user), publish_user_created(user.id)

Round 2: read queued calls in parallel
|-- validate_user(dto)                      [users/validate.py]
|   `-- found: check_duplicate(dto.email)
|       `-- check_duplicate -> repo.get_by_email(email) [stops: query read]
|
|-- repo.add(user)                          [users/repo.py]
|   `-- found: session.execute(insert(...)) [stops: external SQLAlchemy]
|
`-- publish_user_created(user.id)           [users/events.py]
    `-- found: build_payload(user.id)
        `-- build_payload -> plain dict [stops: data-only boundary]

Visited: create_user, validate_user, check_duplicate, repo.add, publish_user_created, build_payload
```

Full understanding: email dedup -> DB insert -> publish event.
