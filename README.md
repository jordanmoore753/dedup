# dedup

Hello! I built this library to find byte-identical duplicate assets in a Rails `app/assets` tree and report wasted disk space. Exits nonzero so it can block CI.

## Why?

I have encountered the following problem frequently in engineering departments. Imagine there are two different teams: Team Squirtle and Team Charmander. One designer works with both teams. The designer shares an image asset with a member of Team Squirtle first, who needs to add the image asset to the codebase for their ticket. Two weeks later, the designer shares the same image asset with a member of Team Charmander. This can easily happen because the designer can forget that they already shared it and accidentally share it again. Also, it's not always obvious what the file name would be for the second developer on Team Charmander to find it in the codebase and reuse it. So, it's very easy for duplicate image assets to be added to a codebase.

Over time, it's easy for these duplicate assets to accumulate and grow into sizable chunks of space taken up on the server or in a CDN. However, the bigger problem is UI inconsistencies. Imagine that product asks for all download buttons to have an updated version of the `download.svg` file. However, that `download.svg` file is in two separate spots of the codebase. Whichever team picks up the ticket to update the download buttons won't realize that they have to replace two SVGs instead of one, which will leave an uncertain amount of the UI with inconsistent download styling. This is the larger of the two problems because image assets typically don't take up a ton of space for an application.

I wanted to solve this problem for the one-hour interview challenge because it is a real problem encountered by developers every day and causes production headaches. My goal for this was to build something that I could use immediately in my work's Rails codebase, or even someone at Corporate Tools could use it on one of their codebases and find some duplicated assets.

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
