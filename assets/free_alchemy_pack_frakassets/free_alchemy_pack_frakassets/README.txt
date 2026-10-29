Animated pixel art by Frakassets - https://frakassets.itch.io/

9 free alchemy items, every one animated. Every frame is a square of the
sheet's size (16 x 16, 32 x 32, 48 x 48 or 64 x 64 pixels), transparent PNG.
Play them at 12 frames per second.

What is in it (each item has its own folder):
  round-flask-blue       a mana potion, the draught seen through the glass
  heart-bottle-red       a health potion in a heart-shaped bottle
  crystal-ball-violet    a crystal ball with a mist inside
  cauldron-green         a cauldron of green brew, bubbling
  crystal-cluster-pink   a crystal cluster, lit from within
  glow-mushrooms-orange  glowing mushrooms
  spellbook-red          a spellbook
  candle-holder-ivory    a candle in a brass holder, its flame flickering
  lantern                a lantern, its flame flickering

The full Alchemy Megapack has 149 items in the same style: 8 bottles x 8
draughts, 40 gems, candles, slimes, soul jars and more:
https://frakassets.itch.io/alchemy-megapack

File names: <item>_<size>_<angle>_<outline>_<layer>.png
  size     16px, 32px, 48px or 64px
  angle    scroller (facing the camera, seen a little from above) or
           top-down (seen from above at 45 degrees)
  outline  outline (dark outer border) or no-outline
  layer    lit     the item, lit and shaded, without its shine
           shine   the shine alone, to draw over lit: highlights, glints
                   and sparkles (only for shiny items: glass, gems, gold)
           glow    the glowing parts alone, to draw over lit with additive
                   blending or bloom: flames, magic, bubbles (only for
                   items that glow)
           unlit   flat colours, to light yourself
  Draw lit, then shine over it, for the finished look; leave shine out, or
  fade or tint it, for a duller or animated one.
  And for each size and angle:
  <item>_<size>_<angle>_normal.png  the normal map, for 2D lights
                                    (x right, y up, z towards the camera)
  <item>_<size>_<angle>_lines.png   the outline alone, to recolour or fade
  <item>_<size>_<angle>_shadow.png  a contact shadow (black ellipse) to
                                    draw under the item, at any opacity

Turning items (potions, crystal ball, crystal, mushrooms, book): one row, a full turn (24 frames),
  looping.
Animated items: one row per animation, one
  column per frame, all looping:
  Flicker (12 frames)   the candle holder and the lantern
  Bubble (12 frames)    the cauldron
  <item>_<size>_<angle>.json gives every frame's place, animation, side and
  pivot (Aseprite's JSON hash, with frame tags), for every variant of that
  size and angle.

How to use
----------
1. Unzip. Each item has its own folder.
2. Pick a sheet (see the file names above).
3. Import:
   Godot 4    Default texture filter Nearest. AnimatedSprite2D > SpriteFrames >
              Add frames from sprite sheet: Horizontal = the columns, Vertical =
              the rows, then pick the cells of one row per animation; 12 FPS,
              looping.
   Unity      Texture Type Sprite (2D and UI), Sprite Mode Multiple, Filter
              Point, Compression None, Pixels Per Unit = the sheet's size.
              Sprite Editor > Slice > Grid By Cell Size (16, 32, 48 or 64).
   GameMaker  Create Sprite > Import Strip Image, one row at a time, size =
              the sheet's size; 12 frames per second.
   Aseprite   Open the PNG with its .json beside it, or File > Import >
              Import Sprite Sheet, By Rows, width and height = the sheet's size.
   Normal maps line up frame for frame with the sheets (Godot CanvasTexture,
   Unity Secondary Textures > _NormalMap).

Made with Pixor, the tool that turns 3D models into animated pixel-art
sprite sheets: every side, frame by frame, the same pixels every time.
The see-through glass and the gems lit from within are Pixor 2.1's.
Pay once, every pixel drawn by shaders, offline. https://pixor.art/

Licence: CC BY 4.0 (LICENSE.txt): use and change them anywhere, commercial or
not, and credit "Frakassets".

If you use these, a rating or a comment on the itch page helps a lot. Thank you!
