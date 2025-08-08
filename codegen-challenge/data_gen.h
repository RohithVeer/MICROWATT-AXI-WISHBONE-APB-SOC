// Auto-generated from input.yaml
#ifndef DATA_GEN_H
#define DATA_GEN_H

#include <stdint.h>

// Package markdown-it_markdown-it
#define PKG_0_NAME "markdown-it_markdown-it"
#define PKG_0_VERSION "13.0.1"
#define PKG_0_COMMIT "e843acc9edad115cbf8cf85e676443f01658be08"
#define PKG_0_DATE "May 3, 2022"
#define PKG_0_NOTE_0 "Rename variables that use python built-in names, e.g. - `max` -> `maximum` - `len` -> `length` - `str` -> `string`"
#define PKG_0_NOTE_1 "Convert JS `for` loops to `while` loops\nthis is generally the main difference between the codes,\nbecause in python you can't do e.g. `for {i=1;i<x;i++} {}`\n"
#define PKG_0_NOTE_2 "`env` is a common Python dictionary, and so does not have attribute access to keys,\nas with JavaScript dictionaries.\n`options` have attribute access only to core markdownit configuration options\n"
#define PKG_0_NOTE_3 "`Token.attrs` is a dictionary, instead of a list of lists.\nUpstream the list format is only used to guarantee order: https://github.com/markdown-it/markdown-it/issues/142,\nbut in Python 3.7+ order of dictionaries is guaranteed.\nOne should anyhow use the `attrGet`, `attrSet`, `attrPush` and `attrJoin` methods\nto manipulate `Token.attrs`, which have an identical signature to those upstream.\n"
#define PKG_0_NOTE_4 "Use python version of `charCodeAt`"
#define PKG_0_NOTE_5 "Use `str` units instead of `int`s to represent Unicode codepoints.\nThis provides a significant performance boost\n"
#define PKG_0_NOTE_6 "In markdown_it/rules_block/reference.py,\nrecord line range in state.env[\"references\"] and add state.env[\"duplicate_refs\"]\nThis is to allow renderers to report on issues regarding references\n"
#define PKG_0_NOTE_7 "The `MarkdownIt.__init__` signature is slightly different for updating options,\nsince you must always specify the config first, e.g.\nuse `MarkdownIt(\"commonmark\", {\"html\": False})` instead of `MarkdownIt({\"html\": False})`\n"
#define PKG_0_NOTE_8 "The default configuration preset for `MarkdownIt` is \"commonmark\" not \"default\""
#define PKG_0_NOTE_9 "Allow custom renderer to be passed to `MarkdownIt`"
#define PKG_0_NOTE_10 "change render method signatures\n`func(tokens, idx, options, env, slf)` to\n`func(self, tokens, idx, options, env)`\n"
#define PKG_0_NOTE_11 "Extensions add render methods by format\n`MarkdownIt.add_render_rule(name, function, fmt=\"html\")`,\nrather than `MarkdownIt.renderer.rules[name] = function`\nand renderers should declare a class property `__output__ = \"html\"`.\nThis allows for extensibility to more than just HTML renderers\n"
#define PKG_0_NOTE_12 "inline tokens in tables are assigned a map (this is helpful for propagation to children)"

#endif // DATA_GEN_H
