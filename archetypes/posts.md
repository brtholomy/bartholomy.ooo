---
title: "{{ replace .Name "_" " " | replaceRE `\d*\.` "" | title }}"
summary: ""
slug: {{ replace .Name "_" "-" | replaceRE `\d*\.` "" }}
draft: true
date: {{ .Date }}
thumbnail: "thumbnails/0153.camera.png"
images: ["covers/0153.camera.png"]
tags: [psychoanalysis]
---
