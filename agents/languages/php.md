## PHP

### Version and Runtime

- Target PHP 8.3+. Use features introduced in 8.0+: named arguments, match expressions, union
  types, fibers, readonly properties, enums.
- Manage dependencies with Composer. Always commit `composer.lock`.
- Use `symfony/var-dumper` only in dev dependencies — never in production code paths.

### Type System

PHP 8 has a rich type system — use it fully:

```php
// Always declare strict types
declare(strict_types=1);

// Typed properties
class Order {
    public function __construct(
        private readonly OrderId $id,
        private Money $total,
        private OrderStatus $status,
    ) {}
}

// Return types and nullable
function findUser(UserId $id): ?User { ... }

// Union types
function process(string|int $input): void { ... }

// Enums (PHP 8.1+)
enum OrderStatus: string {
    case Pending   = 'pending';
    case Confirmed = 'confirmed';
    case Shipped   = 'shipped';
}
```

Always declare `strict_types=1` at the top of every file.

### PSR Standards

Follow applicable PSRs:
- **PSR-1**: Basic coding standard (namespace, class names, method names)
- **PSR-12**: Extended coding style
- **PSR-3**: Logger interface
- **PSR-4**: Autoloading (configure in `composer.json` under `autoload`)
- **PSR-7/15**: HTTP message interfaces and middleware
- **PSR-11**: Container interface

### Naming Conventions

| Construct | Convention |
|---|---|
| Classes, interfaces, enums | `PascalCase` |
| Methods, variables | `camelCase` |
| Constants | `SCREAMING_SNAKE_CASE` |
| Files | One class per file, filename = class name |
| Test files | `*Test.php` (PHPUnit convention) |
| Namespaces | `Company\Package\SubNamespace` (mirrors directory structure) |

### Project Structure (Hexagonal)

```
src/
├── Domain/          # Entities, value objects, domain exceptions, repository interfaces
├── Application/     # Command/query handlers, DTOs, use case services
├── Infrastructure/  # Doctrine repos, HTTP clients, adapters
└── Ports/           # Symfony controllers, console commands, message handlers
tests/
├── Unit/
├── Integration/
└── bootstrap.php
composer.json
```

### Error Handling

- Use custom exception classes extending `\DomainException` or `\RuntimeException`.
- Never catch `\Throwable` or `\Exception` without re-throwing or logging.
- Use typed exceptions in catch blocks — avoid bare `catch (\Exception $e)`.
- Validate DTOs at the boundary (controller/handler) before they enter the domain.

### Code Style

- Format with PHP-CS-Fixer (`.php-cs-fixer.php` in repo root).
- Lint with PHPStan at level 8 (`phpstan.neon`). Fix all warnings.
- Use `readonly` for value objects and DTOs where mutation is never intended.
- Prefer constructor property promotion for concise DTOs.
- Avoid `static` methods in domain logic — they hinder testability.
