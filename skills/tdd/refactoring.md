# Refactor Candidates

After the TDD cycle is green, look for:

- duplication -> extract a function or class
- long methods -> break into helpers while keeping tests on the public interface
- shallow modules -> combine or deepen
- feature envy -> move logic to where data lives
- primitive obsession -> introduce value objects
- existing code the new code reveals as problematic
