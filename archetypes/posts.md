---
title: "{{ .TranslationBaseName | replaceRE "^[0-9]{14}-" "" | replaceRE "-" " " | title }}"
slug: {{ .TranslationBaseName | replaceRE "^[0-9]{14}-" ""  }}
date: {{ .Date }}
draft: true
tags:
description:
ogType: "article"
---

First Paragraph

<!--more-->

Rest