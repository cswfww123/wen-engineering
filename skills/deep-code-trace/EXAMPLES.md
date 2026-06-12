# Deep Code Trace Examples

## Java/Spring

User: "Walk me through the logic in UserService.createUser()."

```text
Round 1: read UserService.createUser()
`-- found internal calls: validateUser(dto), userManager.save(user), publishEvent(userId)

Round 2: read queued calls in parallel
|-- UserService#validateUser(dto)
|   `-- found: checkDuplicate(phone), validateFields(dto)
|       |-- UserService#checkDuplicate -> userMapper.selectByPhone [stops: mapper query read]
|       `-- UserService#validateFields -> checkEmailFormat, roleMapper.selectById [stops: project calls read]
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
