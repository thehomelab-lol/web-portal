---
title: "Adding Giscus Comments to Hugo"
date: 2025-12-01
draft: false
summary: "A step-by-step guide to integrating GitHub Discussions-based comments into your Hugo site using Giscus."
cover:
    image: "giscus_cover.png"
    alt: "Giscus Comments"
    caption: "Open Source Comments for Static Sites"
    relative: true
tags: ["hugo", "giscus", "comments", "guide"]
---

Adding a comment section to a static site can be tricky. You want something that is low maintenance, spam-free, and doesn't track your users. [Giscus](https://giscus.app) checks all these boxes by leveraging **GitHub Discussions** to store comments.

In this guide, we'll walk through how to integrate Giscus into a Hugo site (specifically using the PaperMod theme, but the concepts apply generally).

## Why Giscus?

- **Open Source**: No proprietary lock-in.
- **No Ads / No Tracking**: Respects user privacy.
- **GitHub Integration**: Comments are just GitHub Discussions.
- **Free**: Hosted on GitHub.

## Prerequisites

1. A **public** GitHub repository for your site (or a separate repo just for comments).
2. **GitHub Discussions** enabled on that repository.
3. The [Giscus App](https://github.com/apps/giscus) installed on that repository.

## Step 1: Configure Giscus

Head over to [giscus.app](https://giscus.app) and fill out the configuration form:

1. Enter your **Repository** (e.g., `username/repo`).
2. Select the **Category** where new discussions will be created (e.g., "Announcements" or "General").
3. Choose your **features** (reactions, lazy loading, etc.).

The app will generate a `<script>` tag for you. **Keep this tab open**, we'll need the values from it shortly.

## Step 2: Create the Partial

Instead of hardcoding the script into every page, we'll create a reusable partial. This allows us to control where it appears and configure it dynamically.

Create a new file at `layouts/partials/comments.html`:

```html
{{- /* layouts/partials/comments.html */ -}}
{{- if .Site.Params.comments.enabled }}
<script src="https://giscus.app/client.js"
        data-repo="{{ .Site.Params.comments.repo }}"
        data-repo-id="{{ .Site.Params.comments.repoId }}"
        data-category="{{ .Site.Params.comments.category }}"
        data-category-id="{{ .Site.Params.comments.categoryId }}"
        data-mapping="{{ .Site.Params.comments.mapping | default "pathname" }}"
        data-strict="{{ .Site.Params.comments.strict | default "0" }}"
        data-reactions-enabled="{{ .Site.Params.comments.reactionsEnabled | default "1" }}"
        data-emit-metadata="{{ .Site.Params.comments.emitMetadata | default "0" }}"
        data-input-position="{{ .Site.Params.comments.inputPosition | default "bottom" }}"
        data-theme="{{ .Site.Params.comments.theme | default "preferred_color_scheme" }}"
        data-lang="{{ .Site.Params.comments.lang | default "en" }}"
        data-loading="lazy"
        crossorigin="anonymous"
        async>
</script>
{{- end }}
```

### Dynamic Theme Switching (Optional)

If your site supports Dark Mode (like PaperMod), you'll want Giscus to switch themes automatically. Add this script below the Giscus script in `comments.html`:

```html
<script>
    // Dynamic theme switching for Giscus
    function setGiscusTheme(theme) {
        const iframe = document.querySelector('iframe.giscus-frame');
        if (!iframe) return;
        const message = {
            setConfig: {
                theme: theme
            }
        };
        iframe.contentWindow.postMessage({ giscus: message }, 'https://giscus.app');
    }

    // Listen for theme toggle events (Example for PaperMod)
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                const isDark = document.body.classList.contains('dark');
                // Map your site's theme to Giscus themes
                const giscusTheme = isDark ? 'catppuccin_frappe' : 'catppuccin_latte';
                setGiscusTheme(giscusTheme);
            }
        });
    });

    observer.observe(document.body, { attributes: true });
</script>
```

## Step 3: Configure Hugo

Now, add your Giscus configuration to your `hugo.toml` (or `config.toml`). This keeps your secrets and settings separate from the code.

```toml
[params.comments]
  enabled = true
  repo = "your-username/your-repo"
  repoId = "R_kgD..."          # From giscus.app
  category = "Announcements"
  categoryId = "DIC_kwD..."    # From giscus.app
  mapping = "pathname"
  strict = "0"
  reactionsEnabled = "1"
  emitMetadata = "0"
  inputPosition = "top"
  theme = "catppuccin_frappe"  # Default theme
  lang = "en"
```

## Step 4: Add to Layout (If needed)

If you are using **PaperMod**, it automatically includes `layouts/partials/comments.html` if `params.comments` is set.

For other themes, you might need to add this line to your `single.html` template, usually near the footer:

```go
{{ partial "comments.html" . }}
```

## Conclusion

That's it! You now have a fully functional, privacy-friendly comment system on your static site.

> [!TIP]
> **Testing**: Giscus only works on the domain you configured in the GitHub App settings. If it doesn't show up on `localhost`, check your "Discussion Mapping" settings or ensure `giscus.app` is allowed in your CSP.

## References

- **Official Website**: [giscus.app](https://giscus.app/) - Documentation and configuration tool.
- **GitHub Repository**: [giscus/giscus](https://github.com/giscus/giscus) - Source code and advanced usage.
