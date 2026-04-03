# Ruby & Rails Upgrade Plan: cacklist

## Current State
- **Ruby:** 2.1.0 (EOL since Dec 2015)
- **Rails:** 3.0.20 (EOL since 2013)
- **Bundler:** 1.14.4
- **Database:** PostgreSQL
- **Test framework:** RSpec 2.12, factory_girl_rails 1.0, Capybara 2.12
- **Key gems:** will_paginate 3.0.pre2, gravatar_image_tag 0.1.0, rubocop 0.47.1

## Upgrade Strategy

Rails upgrades should be done **one major version at a time** to catch deprecation warnings at each step. The plan follows this path:

> Rails 3.0 → 3.1 → 3.2 → 4.0 → 4.1 → 4.2 → 5.0 → 5.1 → 5.2 → 6.0 → 6.1 → 7.0 → 7.1 → 7.2

Ruby will be upgraded in tandem as required by each Rails version.

---

## Phase 1: Preparation (on current Ruby 2.1 / Rails 3.0)

### 1.1 Set up a reliable test baseline
- Run existing RSpec specs and record which pass/fail
- Fix any broken tests so we have a green baseline to verify each upgrade step
- Add missing test coverage for critical paths (auth, microposts, relationships)

### 1.2 Pin all gem versions explicitly
- Update Gemfile to pin every gem to its current version from Gemfile.lock
- This prevents unintended upgrades during the process

### 1.3 Set up a database seed/fixture strategy
- Ensure `db:migrate` runs cleanly from scratch
- Verify `db:schema:load` works

---

## Phase 2: Rails 3.0 → 3.1 → 3.2

### 2.1 Upgrade to Rails 3.1
- Update `gem 'rails'` to `'~> 3.1.0'`
- Run `bundle update rails`
- Add asset pipeline support (`config/application.rb`: `config.assets.enabled = true`)
- Move static assets from `public/` to `app/assets/`
- Add `gem 'sass-rails'`, `gem 'coffee-rails'`, `gem 'uglifier'`
- Run tests, fix deprecation warnings

### 2.2 Upgrade to Rails 3.2
- Update `gem 'rails'` to `'~> 3.2.0'`
- Run `bundle update rails`
- Address deprecation warnings (these become errors in Rails 4)
- Ensure `config.active_record.whitelist_attributes = true` is set
- Run tests, fix any failures

---

## Phase 3: Rails 3.2 → 4.0 → 4.1 → 4.2 (Ruby upgrade required)

### 3.0 Upgrade Ruby to 2.3+
- Rails 4.0 requires Ruby 1.9.3+ (but 2.3+ recommended)
- Update `.ruby-version` to `2.3.8`
- Run `bundle install`, fix gem compatibility issues

### 3.1 Pre-Rails-4 code changes (critical)
These changes are **required** before upgrading to Rails 4:

- **Replace `attr_accessible` with Strong Parameters**
  - Remove `attr_accessible` from all models (`User`, `Micropost`, `Relationship`)
  - Add `gem 'strong_parameters'` (or wait for Rails 4)
  - Move attribute whitelisting to controllers using `params.permit`
  
- **Replace `match` routes with explicit HTTP verbs**
  - `match '/signup'` → `get '/signup'`
  - `match '/signin'` → `get '/signin'`
  - etc.

- **Replace deprecated finders**
  - `find_by_email(email)` → `find_by(email: email)`
  - `find_by_remember_token(token)` → `find_by(remember_token: token)`

- **Replace `before_filter` with `before_action`**

- **Replace `update_attributes` with `update`**

### 3.2 Upgrade to Rails 4.0
- Update `gem 'rails'` to `'~> 4.0.0'`
- Remove `activeresource` (no longer part of Rails)
- Remove `attr_accessible` usage completely (strong_parameters is built-in)
- Update `secret_token.rb` → `secrets.yml`
- Remove `whiny_nils` config (removed in Rails 4)
- Run tests, fix failures

### 3.3 Upgrade to Rails 4.1
- Update to `'~> 4.1.0'`
- Add `config/secrets.yml`
- Replace `MultiJSON` usage if any
- Run tests

### 3.4 Upgrade to Rails 4.2
- Update to `'~> 4.2.0'`
- Add `gem 'web-console'` to development group
- Review `respond_to` / `respond_with` patterns
- Run tests

---

## Phase 4: Rails 4.2 → 5.0 → 5.1 → 5.2 (Ruby upgrade required)

### 4.0 Upgrade Ruby to 2.5+
- Update `.ruby-version` to `2.5.9`
- Run `bundle install`, fix compatibility

### 4.1 Upgrade to Rails 5.0
- Update to `'~> 5.0.0'`
- **Major changes:**
  - `ApplicationRecord` base class — add `app/models/application_record.rb`, update all models to inherit from it
  - `ApplicationController` already exists
  - `belongs_to` associations are now required by default — add `optional: true` where needed
  - Replace `before_filter` → `before_action` (if not done already)
  - Update `rake` commands → `rails` commands
- Run tests

### 4.2 Upgrade to Rails 5.1
- Update to `'~> 5.1.0'`
- Encrypted secrets support available
- jQuery no longer included by default
- Run tests

### 4.3 Upgrade to Rails 5.2
- Update to `'~> 5.2.0'`
- Active Storage available (optional)
- Credentials support (`rails credentials:edit`)
- Run tests

---

## Phase 5: Rails 5.2 → 6.0 → 6.1 (Ruby upgrade required)

### 5.0 Upgrade Ruby to 2.7+
- Update `.ruby-version` to `2.7.8`
- Fix keyword argument deprecation warnings (Ruby 2.7 warns, Ruby 3.0 breaks)

### 5.1 Upgrade to Rails 6.0
- Update to `'~> 6.0.0'`
- **Major changes:**
  - Webpacker becomes default (or keep Sprockets)
  - Action Mailbox, Action Text available (optional)
  - Zeitwerk autoloader — add `config.autoloader = :zeitwerk` or `:classic`
- Run tests

### 5.2 Upgrade to Rails 6.1
- Update to `'~> 6.1.0'`
- Switch to Zeitwerk autoloader fully
- Run tests

---

## Phase 6: Rails 6.1 → 7.0 → 7.1 → 7.2 (Ruby upgrade required)

### 6.0 Upgrade Ruby to 3.1+
- Update `.ruby-version` to `3.1.6` (or `3.2.x` / `3.3.x`)
- Fix all keyword argument issues (breaking in Ruby 3.0+)
- Update all gems for Ruby 3 compatibility

### 6.1 Upgrade to Rails 7.0
- Update to `'~> 7.0.0'`
- **Major changes:**
  - Import maps or jsbundling-rails replaces Webpacker
  - Turbo + Stimulus replace Turbolinks + UJS
  - `config.load_defaults 7.0`
  - Encrypted attributes available
- Run tests

### 6.2 Upgrade to Rails 7.1
- Update to `'~> 7.1.0'`
- Dockerfile generation, async queries
- Run tests

### 6.3 Upgrade to Rails 7.2
- Update to `'~> 7.2.0'`
- Run tests, final stabilization

---

## Phase 7: Gem & Dependency Modernization

These can be done incrementally during the upgrade, but are listed here for tracking:

| Old Gem | Replacement | When |
|---|---|---|
| `factory_girl_rails` 1.0 | `factory_bot_rails` 6.x | Phase 3 |
| `rspec-rails` 2.12 | `rspec-rails` 6.x | Phase 3+ |
| `rspec` 2.12 | `rspec` 3.x | Phase 3+ |
| `capybara` 2.12 | `capybara` 3.x | Phase 4+ |
| `will_paginate` 3.0.pre2 | `will_paginate` 4.x or `kaminari` | Phase 3 |
| `mysql` gem | Remove (using `pg` already) | Phase 2 |
| `faker` 0.3.1 | `faker` 3.x | Phase 3 |
| `rubocop` 0.47.1 | `rubocop` 1.x + `rubocop-rails` | Phase 5+ |
| `gravatar_image_tag` 0.1.0 | Inline helper or `gravatar_image_tag` latest | Phase 3 |
| `json` 1.7.7 | Remove (built into Ruby stdlib) | Phase 3 |

---

## Phase 8: Security Hardening

### 8.1 Replace homegrown authentication with bcrypt/devise
- Current app uses manual SHA2 password hashing with salt
- Replace with `has_secure_password` (built into Rails 4+) using bcrypt
- Or adopt Devise gem for full auth solution

### 8.2 CSRF & session security
- Verify CSRF protection is enabled
- Use secure cookies for session storage
- Replace plaintext remember token with secure digest

### 8.3 Update secret management
- Move from `secret_token.rb` → Rails credentials

---

## Recommended Order of Execution

1. **Phase 1** — Get tests green, pin gems
2. **Phase 2** — Rails 3.1, 3.2 (stay on Ruby 2.1)
3. **Phase 3** — Ruby 2.3+, strong params migration, Rails 4.0–4.2
4. **Phase 4** — Ruby 2.5+, Rails 5.0–5.2
5. **Phase 5** — Ruby 2.7+, Rails 6.0–6.1
6. **Phase 6** — Ruby 3.1+, Rails 7.0–7.2
7. **Phase 7** — Modernize remaining gems (ongoing)
8. **Phase 8** — Security hardening

**Commit after each minor version upgrade** so you can bisect if something breaks.

---

## Estimated Scope

- ~14 Rails version bumps
- ~4 Ruby version bumps  
- ~10 gem replacements/upgrades
- Significant code changes for strong parameters, autoloading, authentication
- Each phase should be verified with a full test run before proceeding
