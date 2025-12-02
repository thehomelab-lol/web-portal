---
title: "Using Callouts in Hugo"
date: 2025-12-01
draft: false
summary: "A comprehensive guide to using GitHub-style alerts and callouts in your markdown content."
cover:
    image: "callouts_cover.png"
    alt: "Callouts Guide"
    caption: "Enhance your documentation with rich alerts"
    relative: true
tags: ["hugo", "markdown", "guide", "callouts"]
---

Callouts (also known as Admonitions or Alerts) are a great way to highlight important information, warnings, or tips in your documentation. This site supports **GitHub-flavored alerts** with some extra superpowers.

## Installation

To enable callouts, we use the `hugo-admonitions` theme component.

### 1. Clone the Repository

Clone the theme into your `themes` directory:

```bash
git clone https://github.com/KKKZOZ/hugo-admonitions themes/hugo-admonitions
```

### 2. Configure Hugo

Add `hugo-admonitions` to your `hugo.toml` file.

> [!IMPORTANT]
> **Theme Order Matters**: You must list `hugo-admonitions` **before** your main theme (e.g., `PaperMod`) in the configuration. This ensures the CSS is loaded correctly.

```toml
theme = ["hugo-admonitions", "PaperMod"]
```

## Basic Syntax

To create a callout, use the standard blockquote syntax `>` followed by `[!TYPE]`.

```markdown
> [!NOTE]
> This is a note.
```

**Renders as:**

> [!NOTE]
> This is a note.

## Foldable Callouts

You can make callouts collapsible by adding a `+` (open by default) or `-` (closed by default) after the type.

**Open by default:**

```markdown
> [!FAQ]+ How do I use this?
> Just like this!
```

> [!FAQ]+ How do I use this?
> Just like this!

**Closed by default:**

```markdown
> [!SPOILER]- Click to see the secret
> The butler did it!
```

> [!SPOILER]- Click to see the secret
> The butler did it!

## Supported Types

We support a wide range of callout types, each with its own icon and color.

### Standard GitHub Types

> [!NOTE]
> **Note**: Useful for general information.

> [!TIP]
> **Tip**: Helpful advice or shortcuts.

> [!IMPORTANT]
> **Important**: Key information users should not miss.

> [!WARNING]
> **Warning**: Advisory information about potential problems.

> [!CAUTION]
> **Caution**: Negative consequences of an action.

### Extended Types

> [!ABSTRACT]
> **Abstract**: Summary or overview.

> [!SUCCESS]
> **Success**: Completion of a task.

> [!QUESTION]
> **Question**: Something to ask or answer.

> [!FAILURE]
> **Failure**: Something went wrong (alias for Error).

> [!DANGER]
> **Danger**: Critical issue.

> [!BUG]
> **Bug**: Report a software issue.

> [!EXAMPLE]
> **Example**: Show how it's done.

> [!QUOTE]
> **Quote**: A citation or reference.

## Nested Callouts

You can nest callouts inside each other for complex information structures.

```markdown
> [!QUESTION] Can I nest them?
> > [!SUCCESS] Yes!
> > It works perfectly.
```

> [!QUESTION] Can I nest them?
> > [!SUCCESS] Yes!
> > It works perfectly.

## Custom Titles

You can add a custom title after the type.

```markdown
> [!WARNING] Do Not Touch!
> This is very hot.
```

> [!WARNING] Do Not Touch!
> This is very hot.

## References

- **Project Repository**: [hugo-admonitions](https://github.com/KKKZOZ/hugo-admonitions) by [@KKKZOZ](https://github.com/KKKZOZ)
- **Hugo Discourse**: [Hugo Admonitions: A simple way to add beautiful callouts](https://discourse.gohugo.io/t/hugo-admonitions-a-simple-way-to-add-beautiful-callouts-to-hugo-site/52576)
- **Reddit Discussion**: [r/gohugo Post](https://www.reddit.com/r/gohugo/comments/1h1vx86/hugoadmonitions_a_simple_way_to_add_beautiful/)
