package vector;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class IntSwizzles {
    #if macro
    public static macro function buildSwizzles2():Array<Field> {
        var fields = Context.getBuildFields();

        // Generate 2-component swizzles
        var components2 = ["x", "y"];
        for (a in components2) {
            for (b in components2) {
                addSwizzle2(fields, a, b);
            }
        }
        
        // Generate 3-component swizzles
        for (a in components2) {
            for (b in components2) {
                for (c in components2) {
                    addSwizzle3(fields, a, b, c);
                }
            }
        }
        
        // Generate 4-component swizzles
        for (a in components2) {
            for (b in components2) {
                for (c in components2) {
                    for (d in components2) {
                        addSwizzle4(fields, a, b, c, d);
                    }
                }
            }
        }
        
        return fields;
    }

    public static macro function buildSwizzles3():Array<Field> {
        var fields = Context.getBuildFields();

        // Generate 2-component swizzles
        var components2 = ["x", "y"];
        for (a in components2) {
            for (b in components2) {
                addSwizzle2(fields, a, b);
            }
        }
        
        // Generate 3-component swizzles
        var components3 = ["x", "y", "z"];
        for (a in components3) {
            for (b in components3) {
                for (c in components3) {
                    addSwizzle3(fields, a, b, c);
                }
            }
        }
        
        // Generate 4-component swizzles
        for (a in components3) {
            for (b in components3) {
                for (c in components3) {
                    for (d in components3) {
                        addSwizzle4(fields, a, b, c, d);
                    }
                }
            }
        }
        
        return fields;
    }

    public static macro function buildSwizzles4():Array<Field> {
        var fields = Context.getBuildFields();

        // Generate 2-component swizzles
        var components2 = ["x", "y"];
        for (a in components2) {
            for (b in components2) {
                addSwizzle2(fields, a, b);
            }
        }
        
        // Generate 3-component swizzles
        var components3 = ["x", "y", "z"];
        for (a in components3) {
            for (b in components3) {
                for (c in components3) {
                    addSwizzle3(fields, a, b, c);
                }
            }
        }
        
        // Generate 4-component swizzles
        var components4 = ["x", "y", "z", "w"];
        for (a in components4) {
            for (b in components4) {
                for (c in components4) {
                    for (d in components4) {
                        addSwizzle4(fields, a, b, c, d);
                    }
                }
            }
        }
        
        return fields;
    }
    
    static function addSwizzle2(fields:Array<Field>, a:String, b:String):Void {
        var name = a + b;
        var canSet = !hasDuplicates([a, b]);
        
        // Property declaration
        fields.push({
            name: name,
            access: [APublic],
            kind: FProp("get", canSet ? "set" : "never", macro :Float2),
            pos: Context.currentPos()
        });
        
        // Getter
        var aIdent = Context.parse("this." + a, Context.currentPos());
        var bIdent = Context.parse("this." + b, Context.currentPos());
        
        fields.push({
            name: "get_" + name,
            access: [AInline],
            kind: FFun({
                args: [],
                ret: macro :Float2,
                expr: macro return new Float2($aIdent, $bIdent)
            }),
            pos: Context.currentPos()
        });
        
        // Setter (only if no duplicate components)
        if (canSet) {
            var aSet = Context.parse("this." + a + " = v.x", Context.currentPos());
            var bSet = Context.parse("this." + b + " = v.y", Context.currentPos());
            
            fields.push({
                name: "set_" + name,
                access: [AInline],
                kind: FFun({
                    args: [{name: "v", type: macro :Float2}],
                    ret: macro :Float2,
                    expr: macro {
                        $aSet;
                        $bSet;
                        return v;
                    }
                }),
                pos: Context.currentPos()
            });
        }
    }
    
    static function addSwizzle3(fields:Array<Field>, a:String, b:String, c:String):Void {
        var name = a + b + c;
        var canSet = !hasDuplicates([a, b, c]);
        
        // Property declaration
        fields.push({
            name: name,
            access: [APublic],
            kind: FProp("get", canSet ? "set" : "never", macro :Float3),
            pos: Context.currentPos()
        });
        
        // Getter
        var aIdent = Context.parse("this." + a, Context.currentPos());
        var bIdent = Context.parse("this." + b, Context.currentPos());
        var cIdent = Context.parse("this." + c, Context.currentPos());
        
        fields.push({
            name: "get_" + name,
            access: [AInline],
            kind: FFun({
                args: [],
                ret: macro :Float3,
                expr: macro return new Float3($aIdent, $bIdent, $cIdent)
            }),
            pos: Context.currentPos()
        });
        
        // Setter (only if no duplicate components)
        if (canSet) {
            var aSet = Context.parse("this." + a + " = v.x", Context.currentPos());
            var bSet = Context.parse("this." + b + " = v.y", Context.currentPos());
            var cSet = Context.parse("this." + c + " = v.z", Context.currentPos());
            
            fields.push({
                name: "set_" + name,
                access: [AInline],
                kind: FFun({
                    args: [{name: "v", type: macro :Float3}],
                    ret: macro :Float3,
                    expr: macro {
                        $aSet;
                        $bSet;
                        $cSet;
                        return v;
                    }
                }),
                pos: Context.currentPos()
            });
        }
    }
    
    static function addSwizzle4(fields:Array<Field>, a:String, b:String, c:String, d:String):Void {
        var name = a + b + c + d;
        var canSet = !hasDuplicates([a, b, c, d]);
        
        // Property declaration
        fields.push({
            name: name,
            access: [APublic],
            kind: FProp("get", canSet ? "set" : "never", macro :Float4),
            pos: Context.currentPos()
        });
        
        // Getter
        var aIdent = Context.parse("this." + a, Context.currentPos());
        var bIdent = Context.parse("this." + b, Context.currentPos());
        var cIdent = Context.parse("this." + c, Context.currentPos());
        var dIdent = Context.parse("this." + d, Context.currentPos());
        
        fields.push({
            name: "get_" + name,
            access: [AInline],
            kind: FFun({
                args: [],
                ret: macro :Float4,
                expr: macro return new Float4($aIdent, $bIdent, $cIdent, $dIdent)
            }),
            pos: Context.currentPos()
        });
        
        // Setter (only if no duplicate components)
        if (canSet) {
            var aSet = Context.parse("this." + a + " = v.x", Context.currentPos());
            var bSet = Context.parse("this." + b + " = v.y", Context.currentPos());
            var cSet = Context.parse("this." + c + " = v.z", Context.currentPos());
            var dSet = Context.parse("this." + d + " = v.w", Context.currentPos());
            
            fields.push({
                name: "set_" + name,
                access: [AInline],
                kind: FFun({
                    args: [{name: "v", type: macro :Float4}],
                    ret: macro :Float4,
                    expr: macro {
                        $aSet;
                        $bSet;
                        $cSet;
                        $dSet;
                        return v;
                    }
                }),
                pos: Context.currentPos()
            });
        }
    }
    
    static function hasDuplicates(components:Array<String>):Bool {
        var seen = new Map<String, Bool>();
        for (c in components) {
            if (seen.exists(c)) return true;
            seen.set(c, true);
        }
        return false;
    }
    #end
}