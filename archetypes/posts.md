---
title: "{{ replace .Name "_" " " | replaceRE `\d*\.` "" | title }}"
subTitle: ""
slug: "{{ replace .Name "_" "-" | replaceRE `\d*\.` "" }}"
draft: true
date: {{ .Date }}
place: "Fool's Bluff, Nevada"
thumbnail: 'thumbnails/0152.witch_hunt.png'
images: ['covers/0152.witch_hunt.jpg']
tags: ['psychoanalysis']
---
