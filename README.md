Initial port of https://github.com/ProwlEngine/Prowl.Vector to Haxe.

Currently ported:
- Float2, Float3, Float4.
- clamp, saturate, lerp (Maths)

Haxe has a Single type and a Float type. Float is a 64 bit float, and Single is a 32 bit float. Single is only supported on C#, C++, C. I've decided to not implement Single for now.

```haxe
var v2 = new Float2(1, 2);
trace('v2: ${v2.toString()}'); // v2: (1, 2)

var v3 = new Float3(1, 2, 3);
trace('v3: ${v3.toString()}'); // v3: (1, 2, 3)

var v4 = new Float4(1, 2, 3, 4);
trace('v4: ${v4.toString()}'); // v4: (1, 2, 3, 4)

trace('Swizzle v2.xx: ${v2.xx.toString()}');     // (1, 1)
trace('Swizzle v2.yx: ${v2.yx.toString()}');     // (2, 1)
trace('Swizzle v3.zyx: ${v3.zyx.toString()}');   // (3, 2, 1)
trace('Swizzle v4.wzyx: ${v4.wzyx.toString()}'); // (4, 3, 2, 1)
```