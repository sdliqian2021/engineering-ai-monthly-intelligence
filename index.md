---
layout: default
title: Home
description: Monthly public-source intelligence on AI in engineering work, modeling, simulation, and Digital Twins.
nav: engineering_ai
---

{% assign monthly_reports = site.pages | where: "content_type", "monthly_report" | sort: "period_end" | reverse %}

<header class="blog-intro engineering-ai-intro">
  <p class="eyebrow">Monthly public-source intelligence</p>
  <h1>Engineering AI Intelligence</h1>
  <p class="intro-lede">A human-reviewed monthly record of how AI is entering engineering tools, models, simulations, validation workflows, and Digital Twin systems.</p>
  <div class="signal-strip" aria-label="Standing areas of attention">
    <span>Modeling &amp; simulation</span>
    <span>Digital Twins</span>
    <span>Engineering workflows</span>
    <span>Open discovery</span>
  </div>
  <div class="intro-notes">
    <p>The project collects broadly before imposing structure. It pays particular attention to engineering modeling and simulation, broad uses of Digital Twin language, evidence maturity, and signals that connect with physical-system engineering. These are attention lenses, not fixed categories. Read about the scope and evidence approach on the <a href="{{ site.engineering_ai_url }}/about.html">About page</a>.</p>
  </div>
</header>

<section class="post-section" aria-labelledby="monthly-title">
  <div class="section-heading-row">
    <div>
      <p class="eyebrow">Archive</p>
      <h2 id="monthly-title">Monthly intelligence</h2>
    </div>
    <p class="archive-note">Verified signals, context, and explicit evidence limits.</p>
  </div>
  <div class="post-list">
    {% for report in monthly_reports %}
      <article class="post-preview report-preview">
        <div class="report-date" aria-hidden="true">
          <span>{{ report.period_start | date: "%b" }}</span>
          <strong>{{ report.period_start | date: "%Y" }}</strong>
        </div>
        <div class="report-preview__content">
          <h3><a href="{{ report.url | relative_url }}">{{ report.title }}</a></h3>
          {% if report.summary %}<p>{{ report.summary }}</p>{% endif %}
          <p class="post-meta">
            {{ report.period_start | date: "%B %-d" }}–{{ report.period_end | date: "%B %-d, %Y" }}
            · {{ report.core_count }} core signals
            · {{ report.context_count }} context notes
          </p>
        </div>
      </article>
    {% endfor %}
  </div>
</section>
