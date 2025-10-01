---
layout: blog
title: Blog
---

<div class="container">
  <main class="blog-posts" style="padding-top: 100px;">
    {% for post in site.posts %}
    <article class="post">
      {% if post.thumbnail %}
      <div class="post-thumbnail" style="background-image: url('{{ post.thumbnail }}')"></div>
      {% endif %}
      <div class="post-content">
        <h2 class="post-title">
          <a href=".{{ post.url }}">{{ post.title }}</a>
        </h2>
        <div class="post-meta">
          <span>{{ post.date | date: "%B %d, %Y" }}</span>
          {% if post.category %}
          <span class="post-tag">{{ post.category }}</span>
          {% endif %}
        </div>
        <p class="post-excerpt">
          {{ post.excerpt | strip_html | truncatewords: 30 }}
        </p>
      </div>
    </article>
    {% endfor %}
  </main>

  <a href="{{ site.baseurl }}" class="back-home">
    <span class="back-arrow">←</span>
    Back to Home
  </a>
</div>