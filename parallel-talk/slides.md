% title: Parallel computing in R
% subtitle: Local and distributed
% author: Wesley Brooks
% author: somesquares.org
% thankyou: Thanks everyone!
% thankyou_details: And especially these people:
% contact: <span>website</span> <a href="http://somesquares.org/blog/">website</a>
% contact: <span>github</span> <a href="http://github.com/wesesque">wesesque</a>
% contact: <span>twitter</span> <a href="http://twitter.com/buckyphilia">@buckyphilia</a>
% favicon: http://www.stat.wisc.edu/sites/all/libraries/uw_madison_omega/favicon.ico

---
title: Intro slide
build_lists: true

Here is a list that should build:

- I like formulas, like this one $e=mc^2$
- It's rendered using MathJax. You can change the settings by editing base.html if you like
- pressing 'f' toggle fullscreen
- pressing 'w' toggles widescreen
- 'o' toggles overview mode

---
title: Slide with a figure
subtitle: Subtitles are cool too
class: img-top-center

<img height=150 src=figures/200px-6n-graf.svg.png />

- Some point to make about about this figure from wikipedia
- This slide has a class that was defined in theme/css/custom.css

<footer class="source"> Always cite your sources! </footer>


---
title: Segue slide
subtitle: I can haz subtitlz?
class: segue dark nobackground

---
title: Maybe some code?

press 'h' to highlight an important section (that is highlighted
with &lt;b&gt;...&lt;/b&gt; tags)

<pre class="prettyprint" data-lang="javascript">
function isSmall() {
  return window.matchMedia("(min-device-width: ???)").matches;
}

<b>function hasTouch() {
  return Modernizr.touch;
}</b>

function detectFormFactor() {
  var device = DESKTOP;
  if (hasTouch()) {
    device = isSmall() ? PHONE : TABLET;
  }
  return device;
}
</pre>

