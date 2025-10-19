# My Jekyll Blog

This is a simple Jekyll blog project scaffolded for local development.

## Getting Started

### Container - build and run

```bash
podman build --no-cache -t localhost/my-jekyll-blog . && podman run --rm -p 4000:4000 localhost/my-jekyll-blog
```

### Local setup
1. Install Ruby and Bundler if not already installed.
2. Run `bundle install` to install dependencies.
3. Start the server with `bundle exec jekyll serve`.


## Project Structure
- `_config.yml`: Jekyll configuration
- `Gemfile`: Ruby dependencies
- `_posts/`: Blog posts
- `_layouts/`: HTML layouts
- `_includes/`: Reusable HTML snippets
- `assets/`: Static files (CSS, JS, images)
- `index.md`: Homepage


## Documentation
See [Jekyll documentation](https://jekyllrb.com/docs/) for more details.
