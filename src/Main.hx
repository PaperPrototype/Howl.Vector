package;

// import drift.Drift;
import vector.Float4;
import vector.Float3;
import drift.UserList.UserList;
import js.Browser.document;
import vector.Float2;

function main() {
    var canvas = document.createCanvasElement();
    canvas.width = 800;
    canvas.height = 600;

    var app = document.getElementById("app");
    app.appendChild(canvas);

    var v2 = new Float2(1, 2);
    trace('v2: ${v2.toString()}'); // v2: (1, 2)

    var v3 = new Float3(1, 2, 3);
    trace('v3: ${v3.toString()}'); // v3: (1, 2, 3)

    var v4 = new Float4(1, 2, 3, 4);
    trace('v4: ${v4.toString()}'); // v4: (1, 2, 3, 4)

    trace('Swizzle v2.xx: ${v2.xx.toString()}');     // Swizzle v2.xx: (1, 1)
    trace('Swizzle v2.yx: ${v2.yx.toString()}');     // Swizzle v2.yx: (2, 1)
    trace('Swizzle v3.zyx: ${v3.zyx.toString()}');   // Swizzle v3.zyx: (3, 2, 1)
    trace('Swizzle v4.wzyx: ${v4.wzyx.toString()}'); // Swizzle v4.wzyx: (4, 3, 2, 1)

    var context = canvas.getContext('2d');
    context.fillStyle = "lightblue";
    context.fillRect(0, 0, canvas.width, canvas.height);

    var drifval = new UserList();
    trace("Drift value: " + drifval);
    
    trace("Canvas initialized with light blue background.");

    // Counter.setupCounter(cast(document.querySelector('#counter'), ButtonElement));
}

// class Counter {
// 	public static function setupCounter(element:ButtonElement) {
// 		var counter = 0;
// 		var setCounter = (count:Int) -> {
// 			counter = count;
// 			element.innerHTML = 'count is $counter';
// 		}
// 		element.addEventListener('click', () -> setCounter(counter + 1));
// 		setCounter(0);
// 	}
// }
