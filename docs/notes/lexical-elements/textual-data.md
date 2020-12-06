# Textual data

## Characters

As the source files will be written in Unicode, UTF-8 (no BOM), to be precise, it's necessary for string literals to be able to contain unicode codepoints.

There is no such thing as a character any more, only code points, and each "character" can be composed of multiple codepoints. But it is required to handle codepoints, but what should the data type be called? There are a few options:

* ```char``` or ```character```? As I said above, they no longer exist,
* ```code_point```? A bit longer than the above.
* ```rune```? This is what newer languages such as Go and Odin are using, it kind of fits the definition of a codepoint I suppose.

### Literals

```exp
'A'
'3'
'\0x32C8`  // Idiographic telegraph symbol for September, ㋈.
'16#A8F6#' // Devanagari sign candrabindu three, ꣶ.
```

## Strings

* Based on arrays in the language.
  * Enables slicing.
* UTF-8.
* Iterators on various Unicode boundaries.
  * Grapheme(??) cluster.
  * Word.
* Extrapolation
  * Embed expressions into strings which are evaluated.
  * ```"expression: ${var1 + var2}"```
  * ```"expression: $var1"```
  * ```"expression: '{var1 + var2}"```
  * ```"expression: '(var1 + var2)"```
  * ```"expression: `(var1 + var2)" // Like ParaSail.```
* C-like escaped sequences?

## References

* [unicode support what does that actually mean](https://boyter.org/posts/unicode-support-what-does-that-actually-mean)