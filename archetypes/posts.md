---
title: "{{ replace .Name "_" " " | replaceRE `\d*\.` "" | title }}"
summary: ""
slug: {{ replace .Name "_" "-" | replaceRE `\d*\.` "" }}
{{- if (eq (getenv "HUGO_PUBLISH") "true") }}
draft: false
{{- else }}
draft: true
{{- end }}
date: {{ .Date }}
{{- if (getenv "HUGO_SKIPIMG") -}}
{{- else }}
thumbnail: "thumbnails/0153.camera.png"
images: ["covers/0153.camera.png"]
{{- end -}}
{{- if (getenv "HUGO_TAGS") }}
tags: [{{ getenv "HUGO_TAGS" }}]
{{- else }}
tags: [psychoanalysis]
{{- end }}
---
