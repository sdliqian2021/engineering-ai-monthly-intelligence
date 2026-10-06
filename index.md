---
layout: default
title: Home
description: Monthly public-source literature review on AI in engineering work, modeling, simulation, and Digital Twins.
nav: engineering_ai
---

{% assign monthly_reports = site.pages | where: "content_type", "monthly_report" | sort: "period_end" | reverse %}

<header class="blog-intro">
  <h1>Engineering AI Intelligence</h1>
  <div class="intro-notes">
    <p>Monthly public-source literature review of AI in engineering software, modeling and simulation, Digital Twins, industrial applications, research, standards, and technical projects. The collection remains deliberately broad rather than imposing a fixed classification system, with particular attention to modeling, simulation, and work connected with physical-system engineering. Read more about the scope and source approach on the <a href="{{ site.engineering_ai_url }}/about.html">About page</a>.</p>
  </div>
</header>

<section class="post-section" aria-labelledby="monthly-title">
  <h2 id="monthly-title">Monthly intelligence</h2>
  <div class="post-list">
    {% for report in monthly_reports %}
      <article class="post-preview">
        {% assign start_month = report.period_start | date: "%B" %}
        {% assign end_month = report.period_end | date: "%B" %}
        {% assign start_year = report.period_start | date: "%Y" %}
        {% assign end_year = report.period_end | date: "%Y" %}
        <h3><a href="{{ report.url | relative_url }}">{{ report.title }}</a></h3>
        <p class="post-meta">
          {% if start_year != end_year %}
            {{ report.period_start | date: "%B %-d, %Y" }}–{{ report.period_end | date: "%B %-d, %Y" }}
          {% elsif start_month == end_month %}
            {{ report.period_start | date: "%B %-d" }}–{{ report.period_end | date: "%-d, %Y" }}
          {% else %}
            {{ report.period_start | date: "%B %-d" }}–{{ report.period_end | date: "%B %-d, %Y" }}
          {% endif %}
          · {{ report.story_count }} stories
        </p>
      </article>
    {% endfor %}
  </div>
</section>
