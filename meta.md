# content

um tag order
um tag science

1343.complexity.md
1343.causality.md
1350.science.md
1352.math.md
1355.science.md
1356.science.md

um tag sot 1455.chemistry.md through 1491.measurement.md

um tag healing

1268.thoreau.md

1502.pascal.md

um tag movies

1331.word.md

1358.nachlass.md

phantom limb chapter

1101.ai_therapy.md

1081.loneliness.md
1318.alone.md

surveil

truth
human nature

---

med/

025.whatismed.md

030.whatisbreath.md

115.intelligent_limitation.md

050.genealogy_of.md

---

journal/

1052.wenzi.md

1036.criticality.md

1084.feminine

1034.sacks

0926.groundhog_day

0816.strength_weakness

1087.health

---

Bartholomy channel:
https://music.youtube.com/channel/UCK90dspXUc-OQHjWUWretsQ

---

## glyphs

#psychosomatism
身

#psychedelia
熏
玄

#proprioception
身

#consciousness
心

#meditation
坐

#neuromorphism
道

#criticality
卯

#psychoanalysis
明

#freedom
自

#epistemology
章
象

#nietzsche
#history
史

#animism
麗
舞

#anthropology
屰

#exclusion
北

#morality
皿
风

#intelligence
里

日

始

乡

父

幸


文

---

# dev

## hugo scss

I've moved to Dart Sass:

https://gohugo.io/host-and-deploy/host-on-netlify/#procedure
https://gohugo.io/functions/css/sass/#dart-sass
https://discourse.gohugo.io/t/netlify-and-dart-sass/51077

Which requires an awkward build command on Netlify. Doesn't look like it will be included in the Hugo binary. Perhaps a reason to move to Render with Docker.

To check:

```
hugo env
```

## native CSS

I'd rather just use native CSS, which now has hierarchical nesting. Reasons for SCSS remain:

* every CSS @import asks for another network call. No big compiled file. This is reason enough for a build step.
* no @mixin yet, but soon.
* no scoped variables, but this is not so serious.
