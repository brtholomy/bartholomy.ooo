---
title: "{{ replace .Name "_" " " | replaceRE `\d*\.` "" | title }}"
summary: ""
slug: "{{ replace .Name "_" "-" | replaceRE `\d*\.` "" }}"
draft: true
date: {{ .Date }}
thumbnail: "thumbnails/0152.witch_hunt.png"
images: ["covers/0152.witch_hunt.jpg"]
tags: ["psychoanalysis"]
---
