1. Use Ink. http://zurb.com/ink/
2. Understand their grid system- http://zurb.com/ink/docs.php
3. Take Template and customize it.
4. Write %%NAME for any variables we need to put in.
5. Convert the email to Inline CSS. (Some mail clients strip out the <style> tag). You can use Ink’s inline converter: http://zurb.com/ink/inliner.php
6. NOTE: Fonts- to add custom font, use the <link> tag in the head. @import gets deleted when run through the inline converter.