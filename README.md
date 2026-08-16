# dedup

Finds byte-identical duplicate assets in a Rails `app/assets` tree and reports wasted disk space. Exits nonzero so it can block CI.

## Install

```
git clone https://github.com/jordanmoore753/dedup
cd dedup
bundle install
```

## Usage

```
bin/dedup                  # scans app/assets in the current directory
bin/dedup path/to/assets   # scans a custom path
```

Clean output (exit 0):

```
No duplicate assets found.
```

Duplicates found (exit 1, printed to stderr):

```
Duplicates:
  app/assets/images/team_a/icon.png
  app/assets/images/team_b/icon.png

Wasted: 0.4 MB
```

## CI (GitHub Actions)

```yaml
- name: Check for duplicate assets
  run: bin/dedup
```

The step fails the job automatically on exit 1.

## Run tests

```
bundle exec rake
```
