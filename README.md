Initial port of https://github.com/ProwlEngine/Prowl.Vector to Haxe.

Currently ported:
- Float2, Float3, Float4.
- clamp, saturate, lerp (Maths)

Haxe does not have Double vs Float, they only have Doubles by default, but it can change depending on the limitations of the target platform. The result is that `Float` in haxe is usually a 64 bit double precision floating point number. Therefore... Double2, Double3, DOuble4, would all be pointless, and as such I have not ported them.